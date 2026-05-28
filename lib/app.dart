import 'package:flutter/material.dart';
import 'package:knowbox/features/auth/presentation/providers/auth_provider.dart';
import 'package:knowbox/features/auth/presentation/screens/dashboard_page.dart';
import 'package:knowbox/features/auth/presentation/screens/home_view_page.dart';
import 'package:knowbox/features/auth/presentation/screens/login_page.dart';
import 'package:knowbox/features/auth/presentation/screens/register_page.dart';
import 'package:knowbox/features/files/presentation/providers/files_provider.dart';
import 'package:knowbox/shared/theme/theme.dart';
import 'package:knowbox/shared/theme/util.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;
  final FilesProvider filesProvider;

  const MyApp({
    super.key,
    required this.authProvider,
    required this.filesProvider,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, 'Lato', 'Playfair Display');
    MaterialTheme materialTheme = MaterialTheme(textTheme);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: filesProvider),
      ],
      child: MaterialApp(
        title: 'KnowBox',
        theme: materialTheme.light(),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeViewPage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/dashboard': (context) => const DashboardPage(),
        },
      ),
    );
  }
}
