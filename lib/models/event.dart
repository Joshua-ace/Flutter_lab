class Event {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String description;
  final String category; // 'Fan Meet', 'Celebration', 'Charity', 'Premier'
  final String imageUrl;
  final int registeredCount;
  final bool isRegistered;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.category,
    required this.imageUrl,
    this.registeredCount = 0,
    this.isRegistered = false,
  });

  Event copyWith({
    String? id,
    String? title,
    String? date,
    String? time,
    String? location,
    String? description,
    String? category,
    String? imageUrl,
    int? registeredCount,
    bool? isRegistered,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      registeredCount: registeredCount ?? this.registeredCount,
      isRegistered: isRegistered ?? this.isRegistered,
    );
  }
}
