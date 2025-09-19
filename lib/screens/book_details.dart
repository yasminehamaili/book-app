
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/providers.dart';
import '../models/book.dart';
import '../config/theme.dart';

class BookDetailsScreen extends ConsumerWidget {
  final String bookId;

  const BookDetailsScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsync = ref.watch(bookDetailsProvider(bookId));
    final isInWishlistAsync = ref.watch(isBookInWishlistProvider(bookId));

    return Scaffold(
      body: bookAsync.when(
        data: (book) => book == null
            ? _buildNotFound(context)
            : _buildBookDetails(context, ref, book, isInWishlistAsync),
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryBrown,
          ),
        ),
        error: (error, _) => _buildError(context, ref),
      ),
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryBrown),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Book not found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
                fontFamily: 'Coolvetica',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryBrown),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading book',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontFamily: 'Coolvetica',
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => ref.refresh(bookDetailsProvider(bookId)),
              child: const Text(
                'Retry',
                style: TextStyle(fontFamily: 'Coolvetica'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookDetails(
    BuildContext context,
    WidgetRef ref,
    Book book,
    AsyncValue<bool> isInWishlistAsync,
  ) {
    return CustomScrollView(
      slivers: [

        SliverAppBar(
          expandedHeight: 400,
          pinned: true,
          backgroundColor: Colors.white,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: AppTheme.primaryBrown),
              onPressed: () => context.pop(),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.lightBrown.withOpacity(0.1),
                    Colors.white,
                  ],
                ),
              ),
              child: Center(
                child: Hero(
                  tag: 'book_${book.id}',
                  child: Container(
                    width: 200,
                    height: 300,
                    margin: const EdgeInsets.only(top: 80),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: book.coverImageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppTheme.lightBrown.withOpacity(0.2),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.primaryBrown,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppTheme.lightBrown.withOpacity(0.2),
                          child: const Icon(
                            Icons.book,
                            color: AppTheme.primaryBrown,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        book.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkBrown,
                          fontFamily: 'Coolvetica',
                        ),
                      ),
                    ),
                    if (book.isFeatured) ...[
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Featured',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Coolvetica',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'by ${book.author}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontFamily: 'Coolvetica',
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBrown.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    book.category,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.darkBrown,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Coolvetica',
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBrown,
                    fontFamily: 'Coolvetica',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  book.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.6,
                    fontFamily: 'Coolvetica',
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: isInWishlistAsync.when(
                    data: (isInWishlist) => ElevatedButton.icon(
                      onPressed: () => _toggleWishlist(ref, book.id),
                      icon: Icon(
                        isInWishlist ? Icons.favorite : Icons.favorite_border,
                        color: isInWishlist ? Colors.red : Colors.white,
                      ),
                      label: Text(
                        isInWishlist ? 'Remove from Wishlist' : 'Add to Wishlist',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Coolvetica',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInWishlist 
                            ? Colors.white 
                            : AppTheme.primaryBrown,
                        foregroundColor: isInWishlist 
                            ? AppTheme.primaryBrown 
                            : Colors.white,
                        side: isInWishlist 
                            ? const BorderSide(color: AppTheme.primaryBrown)
                            : null,
                      ),
                    ),
                    loading: () => const ElevatedButton(
                      onPressed: null,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    error: (_, __) => ElevatedButton.icon(
                      onPressed: () => _toggleWishlist(ref, book.id),
                      icon: const Icon(Icons.favorite_border),
                      label: const Text(
                        'Add to Wishlist',
                        style: TextStyle(fontFamily: 'Coolvetica'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _toggleWishlist(WidgetRef ref, String bookId) {
    ref.read(wishlistNotifierProvider.notifier).toggleWishlist(bookId);
  }
}