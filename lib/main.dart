import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(RecipeGeneratorApp());
}

class RecipeGeneratorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: SplashScreen(),
    );
  }
}
