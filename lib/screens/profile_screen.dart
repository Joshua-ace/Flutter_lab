import 'package:flutter/material.dart';
import '../models/member.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'events_screen.dart';
import 'admin/admin_dashboard.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditProfileDialog(BuildContext context, Member currentMember) {
    final nameCtrl = TextEditingController(text: currentMember.name);
    final phoneCtrl = TextEditingController(text: currentMember.phone);
    final cityCtrl = TextEditingController(text: currentMember.city);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Member Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cityCtrl,
                decoration: const InputDecoration(labelText: 'City'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              AuthService().updateMember(
                currentMember.copyWith(
                  name: nameCtrl.text.trim(),
                  phone: phoneCtrl.text.trim(),
                  city: cityCtrl.text.trim(),
                ),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final db = DatabaseService();
    final storage = StorageService();

    return ListenableBuilder(
      listenable: Listenable.merge([auth, db, storage]),
      builder: (context, _) {
        final member = auth.currentMember;
        final registeredEvents = db.events.where((e) => e.isRegistered).toList();

        return Scaffold(
          backgroundColor: AppTheme.bgLight,
          appBar: AppBar(
            title: Row(
              children: const [
                Text('👤 ', style: TextStyle(fontSize: 20)),
                Text('Member Profile'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit Profile',
                onPressed: () => _showEditProfileDialog(context, member),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Digital Membership Card (Hero Visual)
                _DigitalMembershipCard(member: member),

                const SizedBox(height: 24),

                // Member Info Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      _ProfileRow(
                        icon: Icons.person_outline,
                        label: 'Member Name',
                        value: member.name,
                      ),
                      const Divider(height: 18),
                      _ProfileRow(
                        icon: Icons.phone_outlined,
                        label: 'Contact',
                        value: member.phone,
                      ),
                      const Divider(height: 18),
                      _ProfileRow(
                        icon: Icons.location_on_outlined,
                        label: 'City / District',
                        value: member.city,
                      ),
                      const Divider(height: 18),
                      _ProfileRow(
                        icon: Icons.bloodtype_outlined,
                        label: 'Blood Group',
                        value: member.bloodGroup ?? 'O+',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Registered Events Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Registered Events',
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
                      child: const Text('Browse Events'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (registeredEvents.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: const [
                        Icon(Icons.event_busy, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'You haven\'t registered for any events yet.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                else
                  ...registeredEvents.map(
                    (event) => Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          child: const Icon(Icons.check, color: Colors.green),
                        ),
                        title: Text(
                          event.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${event.date} • ${event.location}'),
                        trailing: TextButton(
                          onPressed: () => db.toggleEventRegistration(event.id),
                          child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // Settings & Preferences
                const Text(
                  'Settings & Association Portal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1B2E),
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: const Icon(Icons.notifications_outlined, color: AppTheme.primaryColor),
                        title: const Text('Association Notifications'),
                        subtitle: const Text('Updates, events, and fan alerts'),
                        value: storage.notificationsEnabled,
                        onChanged: (_) => storage.toggleNotifications(),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.admin_panel_settings_outlined, color: Colors.orange),
                        title: const Text('Admin Dashboard'),
                        subtitle: const Text('Staff & leadership management access'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          if (auth.isAdminLoggedIn) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AdminDashboard()),
                            );
                          } else {
                            _showAdminPrompt(context);
                          }
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.info_outline, color: Colors.grey),
                        title: const Text('Association Version'),
                        subtitle: const Text('Srekar Fan Association v2.4 (2026 Edition)'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAdminPrompt(BuildContext context) {
    final userCtrl = TextEditingController(text: 'admin');
    final passCtrl = TextEditingController(text: 'admin123');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Admin Authentication'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: userCtrl, decoration: const InputDecoration(labelText: 'Username')),
            const SizedBox(height: 10),
            TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final ok = AuthService().loginAdmin(userCtrl.text, passCtrl.text);
              Navigator.pop(ctx);
              if (ok) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminDashboard()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid Admin credentials! Use admin / admin123')),
                );
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

class _DigitalMembershipCard extends StatelessWidget {
  final Member member;

  const _DigitalMembershipCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2E0854),
            Color(0xFF512DA8),
            Color(0xFF7E57C2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF512DA8).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Watermark / Geometric shapes
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),

          // Card Content
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Text('❤️ ', style: TextStyle(fontSize: 18)),
                        Text(
                          "Srekar's Association",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        member.tier.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),

                // Chip & Contactless Visual
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD54F),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFFFB300), width: 1.5),
                      ),
                      child: const Center(
                        child: Icon(Icons.memory, size: 20, color: Color(0xFF795548)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.contactless, color: Colors.white70, size: 22),
                  ],
                ),

                // Member Name & ID
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'ID: ${member.membershipId}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontFamily: 'monospace',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    // Barcode / QR Simulation Icon
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.qr_code_2,
                        size: 32,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF1E1B2E),
          ),
        ),
      ],
    );
  }
}
