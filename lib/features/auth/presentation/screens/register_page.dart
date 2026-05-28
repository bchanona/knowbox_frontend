import 'package:flutter/material.dart';
import 'package:knowbox/features/auth/presentation/providers/auth_provider.dart';
import 'package:knowbox/features/auth/presentation/widgets/auth_buttons.dart';
import 'package:knowbox/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onAuthChanged() {
    if (!mounted) return;
    final provider = context.read<AuthProvider>();

    if (provider.state.status == AuthStatus.success) {
      provider.resetState();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created! Please log in.')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else if (provider.state.status == AuthStatus.error) {
      provider.resetState();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.state.errorMessage ?? 'An error occurred')),
      );
    }
  }

  void _handleRegister(AuthProvider provider) {
    final fullname = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (fullname.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    provider.register(email: email, password: password, fullname: fullname);
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
                          const SizedBox(height: 12),

                          CustomTextField(
                            label: 'Name',
                            hintText: 'joe doe',
                            controller: _nameController,
                          ),

                          const SizedBox(height: 24),

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
                            text: 'Create Account',
                            isLoading: isLoading,
                            onPressed: isLoading ? null : () => _handleRegister(provider),
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
