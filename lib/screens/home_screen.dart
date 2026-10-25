import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/announcement_card.dart';
import '../widgets/event_card.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/tilt_3d_card.dart';
import '../widgets/rotating_3d_halo.dart';
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

        final isDesktop = ResponsiveLayout.isDesktop(context);
        final isTablet = ResponsiveLayout.isTablet(context);

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 48 : (isTablet ? 28 : 18),
                    vertical: 12,
                  ),
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
                      Row(
                        children: [
                          IconButton(
                            tooltip: 'Experiments Hub (Exp 2-10)',
                            icon: const Icon(Icons.science_outlined, color: AppTheme.primaryColor),
                            onPressed: () => Navigator.pushNamed(context, '/experiments'),
                          ),
                          IconButton(
                            tooltip: 'Toggle Theme (Exp 5 & 6)',
                            icon: Icon(
                              context.watch<ThemeProvider>().isDarkMode
                                  ? Icons.light_mode
                                  : Icons.dark_mode_outlined,
                              color: AppTheme.primaryColor,
                            ),
                            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
                          ),
                          IconButton(
                            tooltip: 'Admin Portal',
                            icon: const Icon(Icons.shield_outlined, color: Colors.grey),
                            onPressed: () => _showAdminLoginDialog(context),
                          ),
                        ],
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
                          children: [
                            Text(
                              "Sreekar's ",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).textTheme.headlineMedium?.color ?? const Color(0xFF1E1B2E),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const Text(
                              '❤️',
                              style: TextStyle(fontSize: 28),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Fans Association',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Sreekar's Circular Hero Picture with 3D Holographic Orbiting Halos
                        Rotating3DHalo(
                          size: 146,
                          primaryGlow: AppTheme.primaryColor,
                          secondaryGlow: const Color(0xFF00E5FF),
                          child: Container(
                            width: 146,
                            height: 146,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [AppTheme.primaryColor, AppTheme.accentHeart, AppTheme.primaryLight],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withValues(alpha: 0.35),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).cardTheme.color ?? Colors.white,
                              ),
                              padding: const EdgeInsets.all(3),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/sreekar.png',
                                  width: 132,
                                  height: 132,
                                  fit: BoxFit.cover,
                                  alignment: const Alignment(0, -0.2),
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: AppTheme.primaryLight.withValues(alpha: 0.2),
                                    child: const Icon(Icons.person, size: 70, color: AppTheme.primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // [ Srekar / Association ] Wireframe Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color ?? Colors.white,
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
                          Navigator.pushNamed(context, '/membership');
                        },
                      ),
                      StatItemData(
                        value: '${db.eventsCount}',
                        label: 'Events',
                        icon: Icons.event_available_rounded,
                        onTap: () {
                          Navigator.pushNamed(context, '/events');
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
                          icon: Icons.science_outlined,
                          label: '🧪 Lab Hub',
                          color: AppTheme.primaryColor,
                          onTap: () => Navigator.pushNamed(context, '/experiments'),
                        ),
                        const SizedBox(width: 8),
                        _QuickActionChip(
                          icon: Icons.cloud_outlined,
                          label: '🌐 REST API Feed',
                          color: Colors.teal,
                          onTap: () => Navigator.pushNamed(context, '/api-feed'),
                        ),
                        const SizedBox(width: 8),
                        _QuickActionChip(
                          icon: Icons.badge_outlined,
                          label: 'Leadership',
                          color: Colors.deepPurple,
                          onTap: () {
                            Navigator.pushNamed(context, '/leadership');
                          },
                        ),
                        const SizedBox(width: 8),
                        _QuickActionChip(
                          icon: Icons.calendar_month,
                          label: 'All Events',
                          color: Colors.indigo,
                          onTap: () {
                            Navigator.pushNamed(context, '/events');
                          },
                        ),
                        const SizedBox(width: 8),
                        _QuickActionChip(
                          icon: Icons.card_membership,
                          label: 'Join / ID Card',
                          color: Colors.pink,
                          onTap: () {
                            Navigator.pushNamed(context, '/membership');
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
                          Navigator.pushNamed(context, '/events');
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
                      Navigator.pushNamed(context, '/events');
                    },
                  ),

                  const SizedBox(height: 26),

                  // ============================================
                  // Club Leadership & Office Bearers (One by One)
                  // ============================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Text('👔 ', style: TextStyle(fontSize: 20)),
                          Text(
                            'Club Leadership',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/leadership'),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 1st Pic: Joshua - President of Club (112px, smaller than Sreekar's 146px and bigger than other leaders' 82px)
                  const _LeaderCard(
                    name: 'Joshua',
                    role: 'President of Club',
                    description: 'Founder and visionary President of the Club. Leads association operations, spearheads charitable activities, and coordinates fan chapters.',
                    imagePath: 'assets/images/joshua.png',
                    imageSize: 112,
                    isPresident: true,
                  ),

                  // 2nd Pic: Sri Ram - General Secretary (82px equal size)
                  const _LeaderCard(
                    name: 'Sri Ram',
                    role: 'General Secretary',
                    description: 'General Secretary of the Club. Handles official correspondence, member registrations, and administrative directives.',
                    imagePath: 'assets/images/sriram.png',
                    imageSize: 82,
                  ),

                  // 3rd Pic: Akhiila - Manager (82px equal size)
                  const _LeaderCard(
                    name: 'Akhiila',
                    role: 'Manager',
                    description: 'Manager of the Club. Oversees event execution, member logistics, welfare campaigns, and venue arrangements.',
                    imagePath: 'assets/images/akhiila.png',
                    imageSize: 82,
                  ),

                  // 4th Pic: Harshith - Treasurer (82px equal size)
                  const _LeaderCard(
                    name: 'Harshith',
                    role: 'Treasurer',
                    description: 'Treasurer of the Club. Manages club accounts, budget planning, audit reports, and transparent financial records.',
                    imagePath: 'assets/images/harshith.png',
                    imageSize: 82,
                  ),

                  // 5th Pic: Akhila - Coordinator (82px equal size)
                  const _LeaderCard(
                    name: 'Akhila',
                    role: 'Coordinator',
                    description: 'Coordinator of the Club. Leads field volunteers, manages fan meet setups, communications, and social engagement.',
                    imagePath: 'assets/images/akhila.png',
                    imageSize: 82,
                  ),

                  const SizedBox(height: 24),
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
                            Navigator.pushNamed(context, '/membership');
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
          color: Theme.of(context).cardTheme.color ?? Colors.white,
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

class _LeaderCard extends StatelessWidget {
  final String name;
  final String role;
  final String description;
  final String imagePath;
  final double imageSize;
  final bool isPresident;

  const _LeaderCard({
    required this.name,
    required this.role,
    required this.description,
    required this.imagePath,
    required this.imageSize,
    this.isPresident = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardTheme.color ?? Colors.white;

    if (isPresident) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Tilt3DCard(
          borderRadius: 22,
          elevation: 16,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withValues(alpha: isDark ? 0.2 : 0.08),
                  cardColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                // Joshua's 112px Circle with 3D Holographic Halo
                Rotating3DHalo(
                  size: imageSize,
                  enableLevitation: false,
                  primaryGlow: AppTheme.primaryColor,
                  secondaryGlow: Colors.amberAccent,
                  child: Container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppTheme.primaryColor, AppTheme.accentHeart, AppTheme.primaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(3.5),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cardColor,
                      ),
                      padding: const EdgeInsets.all(2),
                      child: ClipOval(
                        child: Image.asset(
                          imagePath,
                          width: imageSize - 11,
                          height: imageSize - 11,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AppTheme.primaryLight.withValues(alpha: 0.2),
                            child: const Icon(Icons.person, size: 50, color: AppTheme.primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    role,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Standard Leader Card (equal size 82px) with 3D perspective tilt
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Tilt3DCard(
        borderRadius: 18,
        elevation: 10,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? const Color(0xFF3B3550) : Colors.grey.shade200,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Image (82px)
              Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.4),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cardColor,
                  ),
                  padding: const EdgeInsets.all(1.5),
                  child: ClipOval(
                    child: Image.asset(
                      imagePath,
                      width: imageSize - 7,
                      height: imageSize - 7,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppTheme.primaryLight.withValues(alpha: 0.2),
                        child: const Icon(Icons.person, size: 36, color: AppTheme.primaryColor),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Details: Role badge, Name, Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        role,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
