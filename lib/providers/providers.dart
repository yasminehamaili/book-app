
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/book_service.dart';
import '../services/wishlist_service.dart';
import '../models/book.dart';
import '../models/wishlist_item.dart';


final authStateProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return authService.authStateChanges;
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.session?.user,
    loading: () => null,
    error: (_, __) => null,
  );
});


final allBooksProvider = FutureProvider<List<Book>>((ref) {
  final bookService = ref.read(bookServiceProvider);
  return bookService.getAllBooks();
});

final featuredBooksProvider = FutureProvider<List<Book>>((ref) {
  final bookService = ref.read(bookServiceProvider);
  return bookService.getFeaturedBooks();
});

final categoriesProvider = FutureProvider<List<String>>((ref) {
  final bookService = ref.read(bookServiceProvider);
  return bookService.getCategories();
});

final booksByCategoryProvider = 
    FutureProvider.family<List<Book>, String>((ref, category) {
  final bookService = ref.read(bookServiceProvider);
  return bookService.getBooksByCategory(category);
});

final bookDetailsProvider = 
    FutureProvider.family<Book?, String>((ref, bookId) {
  final bookService = ref.read(bookServiceProvider);
  return bookService.getBookById(bookId);
});


final wishlistProvider = FutureProvider<List<WishlistItem>>((ref) {
  final wishlistService = ref.read(wishlistServiceProvider);
  return wishlistService.getUserWishlist();
});

final isBookInWishlistProvider = 
    FutureProvider.family<bool, String>((ref, bookId) {
  final wishlistService = ref.read(wishlistServiceProvider);
  return wishlistService.isBookInWishlist(bookId);
});

final wishlistNotifierProvider = 
    StateNotifierProvider<WishlistNotifier, AsyncValue<List<WishlistItem>>>(
  (ref) => WishlistNotifier(ref.read(wishlistServiceProvider)),
);

class WishlistNotifier extends StateNotifier<AsyncValue<List<WishlistItem>>> {
  final WishlistService _wishlistService;

  WishlistNotifier(this._wishlistService) : super(const AsyncValue.loading()) {
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    try {
      state = const AsyncValue.loading();
      final wishlist = await _wishlistService.getUserWishlist();
      state = AsyncValue.data(wishlist);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> toggleWishlist(String bookId) async {
    try {
      final isInWishlist = await _wishlistService.isBookInWishlist(bookId);
      
      if (isInWishlist) {
        await _wishlistService.removeFromWishlist(bookId);
      } else {
        await _wishlistService.addToWishlist(bookId);
      }
      
      await loadWishlist();
    } catch (error) {
      print('Error toggling wishlist: $error');
    }
  }
}