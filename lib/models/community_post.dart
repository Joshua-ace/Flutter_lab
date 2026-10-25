class CommunityPost {
  final int id;
  final int userId;
  final String title;
  final String body;
  final int likes;
  final String tag;
  final String authorName;

  CommunityPost({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.likes = 0,
    this.tag = 'Fan Discussion',
    this.authorName = 'Association Member',
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    // Generate realistic tags and author names based on ID
    final tags = ['Charity', 'Fan Meet', 'Movie Updates', 'Celebration', 'General'];
    final authors = ['Ramesh K.', 'Sneha P.', 'Vikas Reddy', 'Arjun Kumar', 'Pooja Sharma'];
    final id = json['id'] as int? ?? 1;

    return CommunityPost(
      id: id,
      userId: json['userId'] as int? ?? 1,
      title: json['title'] as String? ?? 'Untitled Post',
      body: json['body'] as String? ?? '',
      likes: (id * 17) % 150 + 5,
      tag: tags[id % tags.length],
      authorName: authors[id % authors.length],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'likes': likes,
      'tag': tag,
      'authorName': authorName,
    };
  }
}
