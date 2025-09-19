
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/book.dart';

final bookServiceProvider = Provider((ref) => BookService());

class BookService {
  final _supabase = Supabase.instance.client;


  List<Book> get sampleBooks => [
    Book(
      id: '1',
      title: 'To Kill a Mockingbird',
      author: 'Harper Lee',
      description: 'A gripping tale of racial injustice and loss of innocence in the American South.',
      category: 'Fiction',
      coverImageUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&h=600&fit=crop',
      isFeatured: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Book(
      id: '2',
      title: '1984',
      author: 'George Orwell',
      description: 'A dystopian social science fiction novel about totalitarian control.',
      category: 'Science Fiction',
      coverImageUrl: 'https://images.unsplash.com/photo-1495640388908-05fa85288e61?w=400&h=600&fit=crop',
      isFeatured: true,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
    ),
    Book(
      id: '3',
      title: 'Pride and Prejudice',
      author: 'Jane Austen',
      description: 'A romantic novel of manners set in Georgian England.',
      category: 'Romance',
      coverImageUrl: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=600&fit=crop',
      isFeatured: false,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Book(
      id: '4',
      title: 'The Catcher in the Rye',
      author: 'J.D. Salinger',
      description: 'A controversial novel narrated by a troubled teenager in New York City.',
      category: 'Fiction',
      coverImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop',
      isFeatured: true,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Book(
      id: '5',
      title: 'Dune',
      author: 'Frank Herbert',
      description: 'A science fiction epic set in the distant future amidst a feudal interstellar society.',
      category: 'Science Fiction',
      coverImageUrl: 'https://images.unsplash.com/photo-1506880018603-83d5b814b5a6?w=400&h=600&fit=crop',
      isFeatured: true,
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
    Book(
      id: '6',
      title: 'The Great Gatsby',
      author: 'F. Scott Fitzgerald',
      description: 'A classic American novel set in the Jazz Age on Long Island.',
      category: 'Fiction',
      coverImageUrl: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=600&fit=crop',
      isFeatured: false,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Book(
      id: '7',
      title: 'Sapiens',
      author: 'Yuval Noah Harari',
      description: 'A brief history of humankind exploring how we conquered the world.',
      category: 'Non-Fiction',
      coverImageUrl: 'https://images.unsplash.com/photo-1532012197267-da84d127e765?w=400&h=600&fit=crop',
      isFeatured: false,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
    Book(
      id: '8',
      title: 'The Hobbit',
      author: 'J.R.R. Tolkien',
      description: 'A fantasy adventure following Bilbo Baggins on an unexpected journey.',
      category: 'Fantasy',
      coverImageUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&h=600&fit=crop',
      isFeatured: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Book(
      id: '9',
      title: 'Educated',
      author: 'Tara Westover',
      description: 'A memoir about a woman who grows up in a survivalist family.',
      category: 'Biography',
      coverImageUrl: 'https://images.unsplash.com/photo-1495640388908-05fa85288e61?w=400&h=600&fit=crop',
      isFeatured: false,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Book(
      id: '10',
      title: 'Atomic Habits',
      author: 'James Clear',
      description: 'A practical guide to building good habits and breaking bad ones.',
      category: 'Self-Help',
      coverImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop',
      isFeatured: false,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  Future<List<Book>> getAllBooks() async {

    try {
      final response = await _supabase
          .from('books')
          .select()
          .order('created_at', ascending: false);
      
      return (response as List).map((book) => Book.fromJson(book)).toList();
    } catch (e) {
      return sampleBooks;
    }
  }

  Future<List<Book>> getFeaturedBooks() async {
    try {
      final response = await _supabase
          .from('books')
          .select()
          .eq('is_featured', true)
          .limit(5);
      
      return (response as List).map((book) => Book.fromJson(book)).toList();
    } catch (e) {
      return sampleBooks.where((book) => book.isFeatured).toList();
    }
  }

  Future<Book?> getBookById(String id) async {
    try {
      final response = await _supabase
          .from('books')
          .select()
          .eq('id', id)
          .single();
      
      return Book.fromJson(response);
    } catch (e) {
      return sampleBooks.firstWhere((book) => book.id == id);
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _supabase
          .from('books')
          .select('category')
          .order('category');
      
      final categories = (response as List)
          .map((item) => item['category'] as String)
          .toSet()
          .toList();
      
      return categories;
    } catch (e) {

      return sampleBooks
          .map((book) => book.category)
          .toSet()
          .toList();
    }
  }

  Future<List<Book>> getBooksByCategory(String category) async {
    try {
      final response = await _supabase
          .from('books')
          .select()
          .eq('category', category)
          .order('created_at', ascending: false);
      
      return (response as List).map((book) => Book.fromJson(book)).toList();
    } catch (e) {

      return sampleBooks
          .where((book) => book.category == category)
          .toList();
    }
  }
}