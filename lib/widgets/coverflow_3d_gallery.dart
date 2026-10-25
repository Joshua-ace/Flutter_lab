import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/gallery_item.dart';
import '../theme/app_theme.dart';

/// 3D Coverflow Perspective Gallery Carousel
class Coverflow3DGallery extends StatefulWidget {
  final List<GalleryItem> items;
  final Function(GalleryItem item) onItemTap;
  final Function(GalleryItem item) onLikeToggle;
  final double height;

  const Coverflow3DGallery({
    super.key,
    required this.items,
    required this.onItemTap,
    required this.onLikeToggle,
    this.height = 360,
  });

  @override
  State<Coverflow3DGallery> createState() => _Coverflow3DGalleryState();
}

class _Coverflow3DGalleryState extends State<Coverflow3DGallery> {
  late PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.68,
      initialPage: 0,
    );
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(
          child: Text('No photos to display in 3D Coverflow'),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = widget.items[index];
              final delta = index - _currentPage;

              // 3D Math Calculations
              // Rotate around Y-axis based on distance from center
              final angle = (delta * 0.42).clamp(-0.65, 0.65);
              final scale = (1.0 - (delta.abs() * 0.18)).clamp(0.76, 1.0);
              final opacity = (1.0 - (delta.abs() * 0.35)).clamp(0.4, 1.0);
              final translateZ = -delta.abs() * 80;

              final matrix = Matrix4.identity()
                ..setEntry(3, 2, 0.0016)
                ..translateByDouble(delta * -18, 0.0, translateZ, 1.0)
                ..rotateY(angle);

              return Center(
                child: Transform(
                  alignment: delta > 0 ? Alignment.centerLeft : Alignment.centerRight,
                  transform: matrix,
                  child: Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: _buildCoverflowCard(context, item, delta.abs() < 0.4),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // Indicator Bar & Info
        if (widget.items.isNotEmpty) ...[
          Builder(
            builder: (context) {
              final currentIndex = _currentPage.round().clamp(0, widget.items.length - 1);
              final activeItem = widget.items[currentIndex];
              return Column(
                children: [
                  Text(
                    activeItem.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          activeItem.category,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        activeItem.date,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          const Icon(Icons.favorite, size: 14, color: Colors.red),
                          const SizedBox(width: 3),
                          Text(
                            '${activeItem.likes}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          // Dot Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              math.min(widget.items.length, 11),
              (index) {
                final isCurrent = index == _currentPage.round().clamp(0, widget.items.length - 1);
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isCurrent ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: isCurrent
                        ? AppTheme.primaryColor
                        : AppTheme.primaryColor.withValues(alpha: 0.25),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCoverflowCard(BuildContext context, GalleryItem item, bool isCenter) {
    return GestureDetector(
      onTap: () => widget.onItemTap(item),
      child: Container(
        width: 250,
        height: 330,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isCenter ? 0.35 : 0.18),
              blurRadius: isCenter ? 24 : 12,
              offset: Offset(0, isCenter ? 14 : 6),
            ),
            if (isCenter)
              BoxShadow(
                color: AppTheme.primaryColor.withValues(alpha: 0.28),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Photo Image
              item.imageUrl.startsWith('assets/')
                  ? Image.asset(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppTheme.primaryLight.withValues(alpha: 0.2),
                        child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    )
                  : Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppTheme.primaryLight.withValues(alpha: 0.2),
                        child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    ),

              // 3D Glass / Specular Sheen across active card
              if (isCenter)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.25),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.75),
                      ],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                ),

              // Like button top right
              Positioned(
                top: 12,
                right: 12,
                child: InkWell(
                  onTap: () => widget.onLikeToggle(item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 16,
                          color: item.isLiked ? Colors.red : Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item.likes}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 3D Badge on bottom left
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(Icons.fullscreen, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
