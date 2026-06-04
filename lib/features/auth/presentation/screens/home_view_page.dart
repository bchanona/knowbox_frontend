import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_buttons.dart';

class HomeViewPage extends StatelessWidget {
  const HomeViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.surfaceContainerLowest,
            ],
            stops: const [0.0, 0.95],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PrimaryAuthButton(
                  text: 'Sign In',
                  onPressed: () {
                    context.go('/login');
                  },
                ),
                const SizedBox(height: 16),
                SecondaryAuthButton(
                  text: 'Create Account',
                  onPressed: () {
                    context.go('/register');
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
