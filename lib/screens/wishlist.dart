
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/providers.dart';
import '../models/wishlist_item.dart';
import '../config/theme.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Wishlist',
          style: TextStyle(
            color: AppTheme.darkBrown,
            fontWeight: FontWeight.bold,
            fontFamily: 'Coolvetica',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: wishlist.when(
        data: (wishlistItems) => wishlistItems.isEmpty
            ? _buildEmptyState()
            : _buildWishlistItems(wishlistItems, ref),
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryBrown,
          ),
        ),
        error: (error, _) => _buildErrorState(ref),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'Your wishlist is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              fontFamily: 'Coolvetica',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start exploring and add books you love!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
              fontFamily: 'Coolvetica',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {

            },
            child: const Text(
              'Explore Books',
              style: TextStyle(fontFamily: 'Coolvetica'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref) {
    return Center(
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
            'Error loading wishlist',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontFamily: 'Coolvetica',
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => ref.refresh(wishlistNotifierProvider),
            child: const Text(
              'Retry',
              style: TextStyle(fontFamily: 'Coolvetica'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItems(List<WishlistItem> items, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _WishlistItemCard(
          item: item,
          onRemove: () => _removeFromWishlist(ref, item.bookId),
        );
      },
    );
  }

  void _removeFromWishlist(WidgetRef ref, String bookId) {
    ref.read(wishlistNotifierProvider.notifier).toggleWishlist(bookId);
  }
}

class _WishlistItemCard extends StatelessWidget {
  final WishlistItem item;
  final VoidCallback onRemove;

  const _WishlistItemCard({
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final book = item.book;
    
    if (book == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              width: 80,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: book.coverImageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppTheme.lightBrown.withOpacity(0.2),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryBrown,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppTheme.lightBrown.withOpacity(0.2),
                    child: const Icon(
                      Icons.book,
                      color: AppTheme.primaryBrown,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Coolvetica',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'Coolvetica',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.lightBrown.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      book.category,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.darkBrown,
                        fontFamily: 'Coolvetica',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: 'Coolvetica',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            Column(
              children: [
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  tooltip: 'Remove from wishlist',
                ),
                const SizedBox(height: 8),
                IconButton(
                  onPressed: () {

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening ${book.title}...')),
                    );
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.primaryBrown,
                    size: 16,
                  ),
                  tooltip: 'View details',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}