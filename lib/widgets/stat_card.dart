import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatItemData {
  final String value;
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const StatItemData({
    required this.value,
    required this.label,
    required this.icon,
    this.onTap,
  });
}

class StatCard extends StatelessWidget {
  final List<StatItemData> stats;

  const StatCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(stats.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Container(
              height: 38,
              width: 1,
              color: Colors.grey.shade200,
            );
          }
          final stat = stats[index ~/ 2];
          return Expanded(
            child: InkWell(
              onTap: stat.onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(stat.icon, size: 16, color: AppTheme.primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          stat.value,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E1B2E),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stat.label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
