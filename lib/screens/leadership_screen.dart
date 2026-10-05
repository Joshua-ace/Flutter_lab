import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
import '../widgets/leadership_card.dart';

class LeadershipScreen extends StatelessWidget {
  const LeadershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();

    return ListenableBuilder(
      listenable: db,
      builder: (context, _) {
        final leaderList = db.leadership;
        final president = leaderList.firstWhere(
          (m) => m.role.toLowerCase().contains('president'),
          orElse: () => leaderList.first,
        );
        final otherLeaders = leaderList.where((m) => m.id != president.id).toList();

        return Scaffold(
          backgroundColor: AppTheme.bgLight,
          appBar: AppBar(
            title: Row(
              children: const [
                Text('👔 ', style: TextStyle(fontSize: 20)),
                Text('Association Leadership'),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Note
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppTheme.primaryColor,
                        radius: 20,
                        child: Icon(Icons.groups_rounded, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Executive Committee',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Guiding Srekar\'s Association across all districts with unity and integrity.',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'President & Founder',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1B2E),
                  ),
                ),
                const SizedBox(height: 10),

                // Featured President Card
                LeadershipCard(
                  member: president,
                  isFeatured: true,
                ),

                const SizedBox(height: 24),

                const Text(
                  'Office Bearers & Core Team',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1B2E),
                  ),
                ),
                const SizedBox(height: 12),

                // Grid of other leaders
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: otherLeaders.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.88,
                  ),
                  itemBuilder: (context, index) {
                    final leader = otherLeaders[index];
                    return LeadershipCard(member: leader);
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
