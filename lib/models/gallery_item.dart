class GalleryItem {
  final String id;
  final String title;
  final String category; // 'Photos', 'Events', 'Fan meets'
  final String imageUrl;
  final String date;
  final int likes;
  final bool isLiked;

  GalleryItem({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.date,
    this.likes = 0,
    this.isLiked = false,
  });

  GalleryItem copyWith({
    String? id,
    String? title,
    String? category,
    String? imageUrl,
    String? date,
    int? likes,
    bool? isLiked,
  }) {
    return GalleryItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      date: date ?? this.date,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
