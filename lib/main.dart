import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groceries/widgets/grocery_list.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Groceries',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color.fromARGB(255, 61, 194, 194),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 2, 44, 44),
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: const GroceryListScreen(),
    );
  }
}
