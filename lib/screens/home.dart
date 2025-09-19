
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/providers.dart';
import '../models/book.dart';
import '../config/theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredBooks = ref.watch(featuredBooksProvider);
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Discover Books',
              style: TextStyle(
                color: AppTheme.darkBrown,
                fontWeight: FontWeight.bold,
                fontFamily: 'Coolvetica',
              ),
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

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.lightBrown.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkBrown,
                        fontFamily: 'Coolvetica',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover your next favorite book',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontFamily: 'Coolvetica',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured Books',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBrown,
                      fontFamily: 'Coolvetica',
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/books'),
                    child: const Text(
                      'See All',
                      style: TextStyle(fontFamily: 'Coolvetica'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 280,
              child: featuredBooks.when(
                data: (books) => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return BookCard(book: book);
                  },
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryBrown,
                  ),
                ),
                error: (error, _) => Center(
                  child: Text(
                    'Error loading books',
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Coolvetica',
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Browse by Category',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBrown,
                  fontFamily: 'Coolvetica',
                ),
              ),
            ),
          ),

          categories.when(
            data: (categoryList) => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = categoryList[index];
                    return CategoryCard(category: category);
                  },
                  childCount: categoryList.length,
                ),
              ),
            ),
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryBrown,
                ),
              ),
            ),
            error: (error, _) => SliverToBoxAdapter(
              child: Center(
                child: Text(
                  'Error loading categories',
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Coolvetica',
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () => context.push('/book/${book.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
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
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening $category books...')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryBrown,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            category,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Coolvetica',
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}