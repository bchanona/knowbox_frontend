import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:knowbox/features/auth/presentation/providers/auth_provider.dart';
import 'package:knowbox/features/auth/presentation/screens/dashboard_page.dart';
import 'package:knowbox/features/auth/presentation/screens/home_view_page.dart';
import 'package:knowbox/features/auth/presentation/screens/login_page.dart';
import 'package:knowbox/features/auth/presentation/screens/register_page.dart';
import 'package:provider/provider.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final authProvider = context.read<AuthProvider>();
    final bool isLoggedIn = authProvider.isAuthenticated;
    final bool isHome = state.matchedLocation == '/';
    final bool isLoggingIn = state.matchedLocation == '/login';
    final bool isRegistering = state.matchedLocation == '/register';

    if (!isLoggedIn && !isHome && !isLoggingIn && !isRegistering) {
      return '/login';
    }
    if (isLoggedIn && (isHome || isLoggingIn || isRegistering)) {
      return '/dashboard';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeViewPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.matchedLocation}'),
    ),
  ),
);