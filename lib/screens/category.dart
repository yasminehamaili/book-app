
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/providers.dart';
import '../models/book.dart';
import '../config/theme.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
          style: TextStyle(
            color: AppTheme.darkBrown,
            fontWeight: FontWeight.bold,
            fontFamily: 'Coolvetica',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: categories.when(
        data: (categoryList) => selectedCategory == null
            ? _buildCategoryGrid(categoryList)
            : _buildCategoryBooks(selectedCategory!),
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryBrown,
          ),
        ),
        error: (error, _) => Center(
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
                'Error loading categories',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontFamily: 'Coolvetica',
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.refresh(categoriesProvider),
                child: const Text(
                  'Retry',
                  style: TextStyle(fontFamily: 'Coolvetica'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(List<String> categories) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryTile(
            category: category,
            onTap: () => setState(() => selectedCategory = category),
          );
        },
      ),
    );
  }

  Widget _buildCategoryBooks(String category) {
    final books = ref.watch(booksByCategoryProvider(category));
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              IconButton(
                onPressed: () => setState(() => selectedCategory = null),
                icon: const Icon(Icons.arrow_back),
                color: AppTheme.primaryBrown,
              ),
              Text(
                category,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBrown,
                  fontFamily: 'Coolvetica',
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: books.when(
            data: (bookList) => bookList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No books found in this category',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontFamily: 'Coolvetica',
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: bookList.length,
                      itemBuilder: (context, index) {
                        final book = bookList[index];
                        return _BookGridItem(book: book);
                      },
                    ),
                  ),
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryBrown,
              ),
            ),
            error: (error, _) => Center(
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
                    onPressed: () => ref.refresh(booksByCategoryProvider(category)),
                    child: const Text(
                      'Retry',
                      style: TextStyle(fontFamily: 'Coolvetica'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String category;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryBrown,
              AppTheme.darkBrown,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBrown.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getCategoryIcon(category),
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              category,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Coolvetica',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fiction':
        return Icons.auto_stories;
      case 'non-fiction':
        return Icons.fact_check;
      case 'science fiction':
        return Icons.rocket_launch;
      case 'fantasy':
        return Icons.castle;
      case 'romance':
        return Icons.favorite;
      case 'mystery':
        return Icons.search;
      case 'biography':
        return Icons.person;
      case 'self-help':
        return Icons.psychology;
      default:
        return Icons.book;
    }
  }
}

class _BookGridItem extends StatelessWidget {
  final Book book;

  const _BookGridItem({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening ${book.title}...')),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: book.coverImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
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
              ),
            ),
          ),
          const SizedBox(height: 8),

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
        ],
      ),
    );
  }
}