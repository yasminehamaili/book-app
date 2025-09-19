import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authServiceProvider = Provider((ref) => AuthService());

class AuthService {
  final _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
  }) async {

    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'name': name,
      },
    );

    return response;
  }


  Future<void> createProfile({
    required String name,
    String? avatarUrl,
  }) async {
    final user = currentUser;
    if (user == null) throw Exception('No authenticated user');

    await _supabase.from('profiles').upsert({
      'id': user.id,
      'name': name,
      'email': user.email ?? '',
      'avatar_url': avatarUrl,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }


  Future<bool> profileExists() async {
    final user = currentUser;
    if (user == null) return false;

    try {
      final response = await _supabase
          .from('profiles')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }


  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      return await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();
    } catch (e) {
      print('Error getting profile: $e');
      return null;
    }
  }
}