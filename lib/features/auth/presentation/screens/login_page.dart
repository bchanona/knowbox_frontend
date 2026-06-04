import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:knowbox/features/auth/presentation/providers/auth_provider.dart';
import 'package:knowbox/features/auth/presentation/widgets/auth_buttons.dart';
import 'package:knowbox/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthProvider>().addListener(_onAuthChanged);
    });
  }

  @override
  void dispose() {
    context.read<AuthProvider>().removeListener(_onAuthChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onAuthChanged() {
    if (!mounted) return;
    final provider = context.read<AuthProvider>();

    if (provider.state.status == AuthStatus.success) {
      context.go('/dashboard');
    } else if (provider.state.status == AuthStatus.error) {
      provider.resetState();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.state.errorMessage ?? 'An error occurred')),
      );
    }
  }

  void _handleLogin(AuthProvider provider) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    provider.login(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<AuthProvider>(
      builder: (context, provider, _) {
        final isLoading = provider.state.status == AuthStatus.loading;

        return Scaffold(
          backgroundColor: const Color(0xFFEEEEEE),
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 60),

                    Text(
                      'KnowBox',
                      style: TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 42,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 40),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome to KnowBox\nlogin now!',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),

                          const SizedBox(height: 36),

                          CustomTextField(
                            label: 'Email',
                            hintText: 'joedoe75@gmail.com',
                            controller: _emailController,
                          ),

                          const SizedBox(height: 24),

                          CustomTextField(
                            label: 'Password',
                            hintText: '***************',
                            obscureText: true,
                            controller: _passwordController,
                          ),

                          const SizedBox(height: 40),

                          PrimaryAuthButton(
                            text: 'Log In',
                            isLoading: isLoading,
                            onPressed: isLoading ? null : () => _handleLogin(provider),
                          ),

                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
