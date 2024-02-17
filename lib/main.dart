import 'package:flutter/material.dart';
import 'package:shopping/modules/shopping-list/shopping-list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 253, 175, 57),
              primary: Color.fromARGB(255, 253, 175, 57),
              onPrimary: Colors.white,
              secondary: Colors.grey),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color.fromARGB(255, 253, 175, 57),
            foregroundColor: Colors.white,
          ),
          useMaterial3: true),
      home: ShoppingListPage(),
    );
  }
}
