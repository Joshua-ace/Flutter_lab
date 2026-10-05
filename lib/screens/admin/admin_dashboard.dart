import 'package:flutter/material.dart';
import '../../models/member.dart';
import '../../models/event.dart';
import '../../models/update.dart';
import '../../models/gallery_item.dart';
import '../../models/poll.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedTabIndex = 0;

  final List<String> _sections = [
    'Members',
    'Updates',
    'Gallery',
    'Events',
    'Fan Posts',
    'Polls',
    'Leadership',
    'Notifications',
  ];

  final List<IconData> _sectionIcons = [
    Icons.people_alt,
    Icons.newspaper,
    Icons.photo_library,
    Icons.calendar_month,
    Icons.favorite,
    Icons.how_to_vote,
    Icons.badge,
    Icons.notifications_active,
  ];

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    final auth = AuthService();

    return ListenableBuilder(
      listenable: db,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppTheme.bgLight,
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E1B2E),
            foregroundColor: Colors.white,
            title: Row(
              children: const [
                Icon(Icons.admin_panel_settings, color: Colors.amber),
                SizedBox(width: 8),
                Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout Admin',
                onPressed: () {
                  auth.logoutAdmin();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out from Admin Dashboard')),
                  );
                },
              ),
            ],
          ),
          body: Row(
            children: [
              // Dashboard Navigation Drawer / Rail (Image 4 structure)
              Container(
                width: 175,
                color: const Color(0xFF171524),
                child: ListView.builder(
                  itemCount: _sections.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedTabIndex == index;
                    return ListTile(
                      dense: true,
                      selected: isSelected,
                      selectedTileColor: AppTheme.primaryColor.withValues(alpha: 0.25),
                      leading: Icon(
                        _sectionIcons[index],
                        color: isSelected ? Colors.amber : Colors.white70,
                        size: 18,
                      ),
                      title: Text(
                        _sections[index],
                        style: TextStyle(
                          color: isSelected ? Colors.amber : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                    );
                  },
                ),
              ),

              // Main Section Content
              Expanded(
                child: Container(
                  color: AppTheme.bgLight,
                  child: _buildSectionContent(context, db),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionContent(BuildContext context, DatabaseService db) {
    switch (_selectedTabIndex) {
      case 0:
        return _buildMembersAdmin(context, db);
      case 1:
        return _buildUpdatesAdmin(context, db);
      case 2:
        return _buildGalleryAdmin(context, db);
      case 3:
        return _buildEventsAdmin(context, db);
      case 4:
        return _buildFanPostsAdmin(context, db);
      case 5:
        return _buildPollsAdmin(context, db);
      case 6:
        return _buildLeadershipAdmin(context, db);
      case 7:
        return _buildNotificationsAdmin(context, db);
      default:
        return const SizedBox.shrink();
    }
  }

  // 1. Members Module
  Widget _buildMembersAdmin(BuildContext context, DatabaseService db) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMemberDialog(context, db),
        icon: const Icon(Icons.person_add),
        label: const Text('Add Member'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAdminHeader('👥 Members Management', '${db.memberCount} total registered members'),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: db.members.length,
                itemBuilder: (context, index) {
                  final member = db.members[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(child: Text(member.name[0])),
                      title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${member.membershipId} • ${member.city} (${member.role})'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => db.deleteMember(member.id),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context, DatabaseService db) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final cityCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 8),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone')),
            const SizedBox(height: 8),
            TextField(controller: cityCtrl, decoration: const InputDecoration(labelText: 'City')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                db.registerNewMember(
                  Member(
                    id: 'mem_${DateTime.now().millisecondsSinceEpoch}',
                    name: nameCtrl.text.trim(),
                    phone: phoneCtrl.text.trim(),
                    city: cityCtrl.text.trim(),
                    membershipId: 'SKR-2026-${(DateTime.now().millisecondsSinceEpoch % 9000 + 1000)}',
                    joinedDate: DateTime.now(),
                  ),
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // 2. Updates Module
  Widget _buildUpdatesAdmin(BuildContext context, DatabaseService db) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddUpdateDialog(context, db),
        icon: const Icon(Icons.add),
        label: const Text('New Update'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAdminHeader('📰 Announcements & Updates', '${db.updates.length} posts published'),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: db.updates.length,
                itemBuilder: (context, index) {
                  final update = db.updates[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(update.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${update.category} • ${update.date}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => db.deleteUpdate(update.id),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddUpdateDialog(BuildContext context, DatabaseService db) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String category = 'Announcements';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Publish New Update'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: const [
                    DropdownMenuItem(value: 'Announcements', child: Text('Announcements')),
                    DropdownMenuItem(value: 'News', child: Text('News')),
                    DropdownMenuItem(value: 'Association activities', child: Text('Association activities')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDialogState(() => category = val);
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.isNotEmpty) {
                  db.addUpdate(
                    UpdateItem(
                      id: 'up_${DateTime.now().millisecondsSinceEpoch}',
                      title: titleCtrl.text.trim(),
                      description: descCtrl.text.trim(),
                      category: category,
                      date: 'Just now',
                    ),
                  );
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Publish'),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Gallery Module
  Widget _buildGalleryAdmin(BuildContext context, DatabaseService db) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddGalleryDialog(context, db),
        icon: const Icon(Icons.add_photo_alternate),
        label: const Text('Upload Photo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAdminHeader('📸 Gallery Control', '${db.gallery.length} photos in gallery'),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: db.gallery.length,
                itemBuilder: (context, index) {
                  final item = db.gallery[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(item.imageUrl, width: 45, height: 45, fit: BoxFit.cover),
                      ),
                      title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${item.category} • ${item.likes} likes'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => db.deleteGalleryItem(item.id),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGalleryDialog(BuildContext context, DatabaseService db) {
    final titleCtrl = TextEditingController();
    final urlCtrl = TextEditingController(text: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=800&q=80');
    String category = 'Photos';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Photo to Gallery'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Photo Title')),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: const [
                  DropdownMenuItem(value: 'Photos', child: Text('Photos')),
                  DropdownMenuItem(value: 'Events', child: Text('Events')),
                  DropdownMenuItem(value: 'Fan meets', child: Text('Fan meets')),
                ],
                onChanged: (val) {
                  if (val != null) setDialogState(() => category = val);
                },
              ),
              const SizedBox(height: 8),
              TextField(controller: urlCtrl, decoration: const InputDecoration(labelText: 'Image URL')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.isNotEmpty) {
                  db.addGalleryItem(
                    GalleryItem(
                      id: 'gal_${DateTime.now().millisecondsSinceEpoch}',
                      title: titleCtrl.text.trim(),
                      category: category,
                      imageUrl: urlCtrl.text.trim(),
                      date: 'Today',
                    ),
                  );
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add Photo'),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Events Module
  Widget _buildEventsAdmin(BuildContext context, DatabaseService db) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEventDialog(context, db),
        icon: const Icon(Icons.add_task),
        label: const Text('Create Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAdminHeader('🗓️ Events Organizer', '${db.events.length} active events scheduled'),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: db.events.length,
                itemBuilder: (context, index) {
                  final ev = db.events[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(ev.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${ev.date} • ${ev.location} (${ev.registeredCount} registered)'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => db.deleteEvent(ev.id),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEventDialog(BuildContext context, DatabaseService db) {
    final titleCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: 'December 25, 2026');
    final locCtrl = TextEditingController(text: 'Hyderabad');
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create New Event'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Event Title')),
              const SizedBox(height: 8),
              TextField(controller: dateCtrl, decoration: const InputDecoration(labelText: 'Date & Time')),
              const SizedBox(height: 8),
              TextField(controller: locCtrl, decoration: const InputDecoration(labelText: 'Venue / Location')),
              const SizedBox(height: 8),
              TextField(controller: descCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Description')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                db.addEvent(
                  Event(
                    id: 'ev_${DateTime.now().millisecondsSinceEpoch}',
                    title: titleCtrl.text.trim(),
                    date: dateCtrl.text.trim(),
                    time: '05:00 PM',
                    location: locCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    category: 'Fan Meet',
                    imageUrl: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=600&q=80',
                  ),
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Create Event'),
          ),
        ],
      ),
    );
  }

  // 5. Fan Posts Module
  Widget _buildFanPostsAdmin(BuildContext context, DatabaseService db) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdminHeader('❤️ Fan Posts Moderation', '${db.fanPosts.length} messages on wall'),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: db.fanPosts.length,
              itemBuilder: (context, index) {
                final post = db.fanPosts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text('${post.authorName} (${post.authorCity})', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(post.message),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => db.deleteFanPost(post.id),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 6. Polls Module
  Widget _buildPollsAdmin(BuildContext context, DatabaseService db) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPollDialog(context, db),
        icon: const Icon(Icons.add),
        label: const Text('Create Poll'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAdminHeader('🗳️ Polls Management', '${db.polls.length} polls active'),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: db.polls.length,
                itemBuilder: (context, index) {
                  final poll = db.polls[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(poll.question, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${poll.options.length} options • ${poll.totalVotes} total votes'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => db.deletePoll(poll.id),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPollDialog(BuildContext context, DatabaseService db) {
    final questionCtrl = TextEditingController();
    final opt1Ctrl = TextEditingController();
    final opt2Ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create New Poll'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: questionCtrl, decoration: const InputDecoration(labelText: 'Question')),
            const SizedBox(height: 8),
            TextField(controller: opt1Ctrl, decoration: const InputDecoration(labelText: 'Option 1')),
            const SizedBox(height: 8),
            TextField(controller: opt2Ctrl, decoration: const InputDecoration(labelText: 'Option 2')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (questionCtrl.text.isNotEmpty && opt1Ctrl.text.isNotEmpty && opt2Ctrl.text.isNotEmpty) {
                db.addPoll(
                  Poll(
                    id: 'poll_${DateTime.now().millisecondsSinceEpoch}',
                    question: questionCtrl.text.trim(),
                    options: [
                      PollOption(id: 'o1', text: opt1Ctrl.text.trim(), votes: 0),
                      PollOption(id: 'o2', text: opt2Ctrl.text.trim(), votes: 0),
                    ],
                  ),
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  // 7. Leadership Module
  Widget _buildLeadershipAdmin(BuildContext context, DatabaseService db) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdminHeader('👔 Leadership Roster', '${db.leadership.length} executive leaders'),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: db.leadership.length,
              itemBuilder: (context, index) {
                final ldr = db.leadership[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(ldr.imageUrl)),
                    title: Text(ldr.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${ldr.role} • ${ldr.phone}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 8. Notifications Module
  Widget _buildNotificationsAdmin(BuildContext context, DatabaseService db) {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdminHeader('🔔 Broadcast Push Notification', 'Send immediate alert to all ${db.memberCount} members'),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Notification Title')),
                  const SizedBox(height: 12),
                  TextField(controller: bodyCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Message Body')),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (titleCtrl.text.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Broadcast sent to all members: "${titleCtrl.text}"! 🔔'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          titleCtrl.clear();
                          bodyCtrl.clear();
                        }
                      },
                      icon: const Icon(Icons.send),
                      label: const Text('Send Broadcast Notification'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1B2E)),
        ),
        const SizedBox(height: 2),
        Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
      ],
    );
  }
}
