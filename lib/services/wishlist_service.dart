
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/wishlist_item.dart';

final wishlistServiceProvider = Provider((ref) => WishlistService());

class WishlistService {
  final _supabase = Supabase.instance.client;

  Future<List<WishlistItem>> getUserWishlist() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    try {
      final response = await _supabase
          .from('wishlist')
          .select('*, books(*)')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((item) => WishlistItem.fromJson(item))
          .toList();
    } catch (e) {

      return [];
    }
  }

  Future<bool> isBookInWishlist(String bookId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    try {
      final response = await _supabase
          .from('wishlist')
          .select('id')
          .eq('user_id', user.id)
          .eq('book_id', bookId);
      
      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> addToWishlist(String bookId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      await _supabase.from('wishlist').insert({
        'user_id': user.id,
        'book_id': bookId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add to wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(String bookId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      await _supabase
          .from('wishlist')
          .delete()
          .eq('user_id', user.id)
          .eq('book_id', bookId);
    } catch (e) {
      throw Exception('Failed to remove from wishlist: $e');
    }
  }
}