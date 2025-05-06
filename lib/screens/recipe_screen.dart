import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    return isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;
  }
}

class RecipeScreen extends StatelessWidget {
  final String recipeText;

  RecipeScreen({required this.recipeText});

  Map<String, dynamic> _parseRecipeText(String text) {
    final lines = text.split('\n');
    String title = 'Recette Générée';
    List<String> ingredients = [];
    List<String> instructions = [];
    String currentSection = '';

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      if (line.startsWith('**') && line.endsWith('**')) {
        if (line.contains('Ingrédients')) {
          currentSection = 'ingredients';
        } else if (line.contains('Instructions')) {
          currentSection = 'instructions';
        } else {
          title = line.replaceAll('**', '').trim().capitalize();
          currentSection = '';
        }
      } else if (currentSection == 'ingredients' && line.startsWith('-')) {
        ingredients.add(line.replaceFirst('-', '').trim().capitalize());
      } else if (currentSection == 'instructions' &&
          RegExp(r'^\d+\.').hasMatch(line)) {
        instructions.add(line.trim().capitalize());
      }
    }

    return {
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
    };
  }

  @override
  Widget build(BuildContext context) {
    final recipeData = _parseRecipeText(recipeText);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipeData['title']),
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipeData['title'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Ingrédients',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ...recipeData['ingredients'].map<Widget>(
                    (ingredient) => Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        '- $ingredient',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Instructions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ...recipeData['instructions'].map<Widget>(
                    (instruction) => Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(instruction, style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Retour'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
