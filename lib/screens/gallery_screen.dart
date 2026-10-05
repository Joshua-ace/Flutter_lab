import 'package:flutter/material.dart';
import '../models/gallery_item.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
import '../widgets/gallery_card.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Photos',
    'Events',
    'Fan meets',
  ];

  void _openFullScreenViewer(BuildContext context, GalleryItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Text(item.title, style: const TextStyle(fontSize: 16)),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sharing photo link...')),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.8,
              maxScale: 4.0,
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                },
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.black.withValues(alpha: 0.9),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.category,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        item.date,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        '${item.likes} fans liked',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
        final filteredItems = db.gallery.where((item) {
          if (_selectedCategory == 'All') return true;
          return item.category.toLowerCase() == _selectedCategory.toLowerCase();
        }).toList();

        return Scaffold(
          backgroundColor: AppTheme.bgLight,
          appBar: AppBar(
            title: Row(
              children: const [
                Text('📸 ', style: TextStyle(fontSize: 20)),
                Text('Association Gallery'),
              ],
            ),
          ),
          body: Column(
            children: [
              // Category filter tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

              // Photos Grid
              Expanded(
                child: filteredItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.photo_library_outlined, size: 50, color: Colors.grey),
                            SizedBox(height: 12),
                            Text('No photos found in this category.', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredItems.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return GalleryCard(
                            item: item,
                            onTap: () => _openFullScreenViewer(context, item),
                            onLikeToggle: () => db.toggleGalleryLike(item.id),
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
