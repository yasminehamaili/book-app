
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/providers.dart';
import '../models/book.dart';
import '../config/theme.dart';

class BooksListScreen extends ConsumerWidget {
  const BooksListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(allBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Books',
          style: TextStyle(
            color: AppTheme.darkBrown,
            fontWeight: FontWeight.bold,
            fontFamily: 'Coolvetica',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryBrown),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppTheme.darkBrown),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search feature coming soon!')),
              );
            },
          ),
        ],
      ),
      body: books.when(
        data: (bookList) => bookList.isEmpty
            ? _buildEmptyState()
            : _buildBooksGrid(bookList),
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
            Icons.book_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No books available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              fontFamily: 'Coolvetica',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new arrivals!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
              fontFamily: 'Coolvetica',
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
            'Error loading books',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontFamily: 'Coolvetica',
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => ref.refresh(allBooksProvider),
            child: const Text(
              'Retry',
              style: TextStyle(fontFamily: 'Coolvetica'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBooksGrid(List<Book> books) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return _BookGridItem(book: book);
        },
      ),
    );
  }
}

class _BookGridItem extends StatelessWidget {
  final Book book;

  const _BookGridItem({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/book/${book.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: book.coverImageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
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
                            size: 48,
                          ),
                        ),
                      ),

                      if (book.isFeatured)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Featured',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Coolvetica',
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Coolvetica',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    Text(
                      book.author,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontFamily: 'Coolvetica',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.lightBrown.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        book.category,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.darkBrown,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Coolvetica',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}