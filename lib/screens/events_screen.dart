import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
import '../widgets/event_card.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Fan Meet',
    'Charity',
    'Celebration',
  ];

  void _showEventDetail(BuildContext context, Event event, DatabaseService db) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    event.category,
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              event.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(event.date, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(event.time, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 18, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    event.location,
                    style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text(
              'About this Event',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 6),
            Text(
              event.description,
              style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: event.isRegistered ? Colors.green.shade600 : AppTheme.primaryColor,
                ),
                onPressed: () {
                  db.toggleEventRegistration(event.id);
                  Navigator.pop(ctx);
                },
                icon: Icon(event.isRegistered ? Icons.check : Icons.app_registration),
                label: Text(event.isRegistered ? 'Registered (Tap to Cancel)' : 'Register for Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();

    return ListenableBuilder(
      listenable: db,
      builder: (context, _) {
        final filteredEvents = db.events.where((e) {
          if (_selectedCategory == 'All') return true;
          return e.category.toLowerCase() == _selectedCategory.toLowerCase();
        }).toList();

        return Scaffold(
          backgroundColor: AppTheme.bgLight,
          appBar: AppBar(
            title: Row(
              children: const [
                Text('🗓️ ', style: TextStyle(fontSize: 20)),
                Text('Association Events'),
              ],
            ),
          ),
          body: Column(
            children: [
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(cat),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                        selectedColor: AppTheme.primaryColor,
                        backgroundColor: Colors.white,
                        checkmarkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
                          ),
                        ),
                        onSelected: (val) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Events List
              Expanded(
                child: filteredEvents.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.event_busy, size: 50, color: Colors.grey),
                            SizedBox(height: 12),
                            Text('No events in this category yet.', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          final event = filteredEvents[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: EventCard(
                              event: event,
                              onRegisterToggle: () {
                                db.toggleEventRegistration(event.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      event.isRegistered
                                          ? 'Registration cancelled for ${event.title}'
                                          : 'Registered for ${event.title}! 🎉',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              onTap: () => _showEventDetail(context, event, db),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
