
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/splash.dart';
import '../screens/sign_in.dart';
import '../screens/sign_up.dart';
import '../screens/forgot_password.dart';
import '../screens/main_navigation.dart';
import '../screens/books_list.dart';
import '../screens/book_details.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = Supabase.instance.client.auth.currentSession != null;
      final isGoingToAuth = state.fullPath?.startsWith('/auth') ?? false;
      final isOnSplash = state.fullPath == '/splash';


      if (isOnSplash) return null;


      if (!isLoggedIn && !isGoingToAuth) {
        return '/auth/signin';
      }


      if (isLoggedIn && isGoingToAuth) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth/signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/auth/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: '/books',
        builder: (context, state) => const BooksListScreen(),
      ),
      GoRoute(
        path: '/book/:id',
        builder: (context, state) {
          final bookId = state.pathParameters['id']!;
          return BookDetailsScreen(bookId: bookId);
        },
      ),
    ],
  );
});