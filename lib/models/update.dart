class UpdateItem {
  final String id;
  final String title;
  final String description;
  final String category; // 'Announcements', 'News', 'Association activities'
  final String date;
  final String? imageUrl;
  final bool isPinned;
  final int likes;

  UpdateItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    this.imageUrl,
    this.isPinned = false,
    this.likes = 0,
  });

  UpdateItem copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? date,
    String? imageUrl,
    bool? isPinned,
    int? likes,
  }) {
    return UpdateItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      isPinned: isPinned ?? this.isPinned,
      likes: likes ?? this.likes,
    );
  }
}
