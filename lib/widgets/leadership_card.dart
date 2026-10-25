import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
import 'tilt_3d_card.dart';

class LeadershipCard extends StatelessWidget {
  final LeadershipMember member;
  final bool isFeatured;

  const LeadershipCard({
    super.key,
    required this.member,
    this.isFeatured = false,
  });

  ImageProvider _getImageProvider(String url) {
    if (url.startsWith('assets/')) {
      return AssetImage(url);
    }
    return NetworkImage(url);
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardTheme.color ?? Colors.white;

    if (isFeatured) {
      return Tilt3DCard(
        borderRadius: 22,
        elevation: 16,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor.withValues(alpha: 0.12),
              AppTheme.primaryColor.withValues(alpha: 0.03),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.35),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryColor, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.25),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 54, // President size
                backgroundColor: AppTheme.primaryLight.withValues(alpha: 0.3),
                backgroundImage: _getImageProvider(member.imageUrl),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                member.role,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              member.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            if (member.description.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  member.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              member.phone,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
      );
    }

    return Tilt3DCard(
      borderRadius: 16,
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 41, // Equal size for other leaders (82px diameter)
              backgroundColor: AppTheme.primaryLight.withValues(alpha: 0.2),
              backgroundImage: _getImageProvider(member.imageUrl),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                member.role,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              member.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            if (member.description.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                member.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  height: 1.3,
                ),
              ),
            ],
            const SizedBox(height: 6),
            Text(
              member.phone,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
