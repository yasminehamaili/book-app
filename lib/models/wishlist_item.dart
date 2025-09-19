
import 'book.dart';

class WishlistItem {
  final String id;
  final String userId;
  final String bookId;
  final DateTime createdAt;
  final Book? book;

  WishlistItem({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.createdAt,
    this.book,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'].toString(),
      userId: json['user_id'],
      bookId: json['book_id'].toString(),
      createdAt: DateTime.parse(json['created_at']),
      book: json['books'] != null ? Book.fromJson(json['books']) : null,
    );
  }
}