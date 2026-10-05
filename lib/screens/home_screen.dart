import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/announcement_card.dart';
import '../widgets/event_card.dart';
import 'leadership_screen.dart';
import 'events_screen.dart';
import 'membership_screen.dart';
import 'admin/admin_dashboard.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToUpdates;
  final VoidCallback onNavigateToGallery;
  final VoidCallback onNavigateToFans;

  const HomeScreen({
    super.key,
    required this.onNavigateToUpdates,
    required this.onNavigateToGallery,
    required this.onNavigateToFans,
  });

  void _showAdminLoginDialog(BuildContext context) {
    final userController = TextEditingController(text: 'admin');
    final passController = TextEditingController(text: 'admin123');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.admin_panel_settings, color: AppTheme.primaryColor),
            SizedBox(width: 10),
            Text('Admin Portal Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Authorized association coordinators & admins only.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: userController,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final auth = AuthService();
              final success = auth.loginAdmin(userController.text, passController.text);
              Navigator.pop(ctx);
              if (success) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminDashboard()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Invalid Admin credentials! Use admin / admin123'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Login to Dashboard'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();

    return ListenableBuilder(
      listenable: db,
      builder: (context, _) {
        final latestAnnouncement = db.updates.firstWhere(
          (u) => u.category == 'Announcements' || u.isPinned,
          orElse: () => db.updates.first,
        );

        final upcomingEvent = db.events.first;

        return Scaffold(
          backgroundColor: AppTheme.bgLight,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Bar with Secret Admin Access
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.verified, size: 16, color: AppTheme.primaryColor),
                            SizedBox(width: 6),
                            Text(
                              'Official Fan Association',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Admin Portal',
                        icon: const Icon(Icons.shield_outlined, color: Colors.grey),
                        onPressed: () => _showAdminLoginDialog(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Wireframe Header:
                  // "Srekar's ❤️"
                  // "Association"
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Srekar's ",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1E1B2E),
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              '❤️',
                              style: TextStyle(fontSize: 28),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Association',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // [ Srekar / Association ] Wireframe Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.deepPurple.shade100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Text(
                            '[ Srekar / Association ]',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryDark,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Metrics Row matching wireframe:
                  // 2,450+ Members | 36 Events | 1,200+ Photos
                  StatCard(
                    stats: [
                      StatItemData(
                        value: '${db.memberCount}+',
                        label: 'Members',
                        icon: Icons.people_alt_rounded,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MembershipScreen()),
                          );
                        },
                      ),
                      StatItemData(
                        value: '${db.eventsCount}',
                        label: 'Events',
                        icon: Icons.event_available_rounded,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EventsScreen()),
                          );
                        },
                      ),
                      StatItemData(
                        value: '${db.photosCount}+',
                        label: 'Photos',
                        icon: Icons.photo_library_rounded,
                        onTap: onNavigateToGallery,
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // Quick Action Buttons Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _QuickActionChip(
                          icon: Icons.badge_outlined,
                          label: 'Leadership',
                          color: Colors.deepPurple,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LeadershipScreen()),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        _QuickActionChip(
                          icon: Icons.calendar_month,
                          label: 'All Events',
                          color: Colors.indigo,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const EventsScreen()),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        _QuickActionChip(
                          icon: Icons.card_membership,
                          label: 'Join / ID Card',
                          color: Colors.pink,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const MembershipScreen()),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        _QuickActionChip(
                          icon: Icons.forum_outlined,
                          label: 'Fan Wall',
                          color: Colors.orange.shade800,
                          onTap: onNavigateToFans,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Latest Announcement section (Wireframe)
                  AnnouncementCard(
                    update: latestAnnouncement,
                    onReadMore: onNavigateToUpdates,
                  ),

                  const SizedBox(height: 22),

                  // Upcoming Event section (Wireframe)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upcoming Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1B2E),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EventsScreen()),
                          );
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  EventCard(
                    event: upcomingEvent,
                    onRegisterToggle: () {
                      db.toggleEventRegistration(upcomingEvent.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            upcomingEvent.isRegistered
                                ? 'Cancelled registration for ${upcomingEvent.title}'
                                : 'Successfully registered for ${upcomingEvent.title}! 🎉',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EventsScreen()),
                      );
                    },
                  ),

                  const SizedBox(height: 26),

                  // Association Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryDark,
                          AppTheme.primaryColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text('🌟 ', style: TextStyle(fontSize: 20)),
                            Text(
                              'Together for Srekar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Empowering communities, organizing premier fan galas, and standing strong in unity.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primaryDark,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const MembershipScreen()),
                            );
                          },
                          icon: const Icon(Icons.star, size: 16, color: Colors.amber),
                          label: const Text('Get Digital Fan Pass'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
