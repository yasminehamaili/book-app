
class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String category;
  final String coverImageUrl;
  final bool isFeatured;
  final DateTime createdAt;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.category,
    required this.coverImageUrl,
    this.isFeatured = false,
    required this.createdAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'].toString(),
      title: json['title'],
      author: json['author'],
      description: json['description'],
      category: json['category'],
      coverImageUrl: json['cover_image_url'],
      isFeatured: json['is_featured'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'category': category,
      'cover_image_url': coverImageUrl,
      'is_featured': isFeatured,
      'created_at': createdAt.toIso8601String(),
    };
  }
}