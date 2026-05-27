import 'package:flutter/material.dart';
import 'package:knowbox/shared/theme/theme.dart';
import 'package:knowbox/shared/theme/util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, 'Lato', 'Playfair Display');
    MaterialTheme materialTheme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: materialTheme.light(),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
