import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

class RecipeScreen extends StatelessWidget {
  final String recipeText;

  const RecipeScreen({super.key, required this.recipeText});

  Map<String, dynamic> _parseRecipeText(String text) {
    final lines = text.split('\n');
    String title = 'Recette Générée';
    List<String> ingredients = [];
    List<String> instructions = [];
    String currentSection = '';

    for (var line in lines) {
      line = line.trim().replaceAll('**', '');
      if (line.isEmpty) continue;

      if (line.toLowerCase().contains('ingrédient')) {
        currentSection = 'ingredients';
      } else if (line.toLowerCase().contains('instruction') ||
                 line.toLowerCase().contains('préparation')) {
        currentSection = 'instructions';
      } else if (currentSection.isEmpty &&
          !line.startsWith('-') &&
          !RegExp(r'^\d+\.').hasMatch(line)) {
        title = line.capitalize();
      } else if (currentSection == 'ingredients' && line.startsWith('-')) {
        ingredients.add(line.replaceFirst('-', '').trim().capitalize());
      } else if (currentSection == 'instructions' &&
          RegExp(r'^\d+\.').hasMatch(line)) {
        instructions.add(
          line.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim().capitalize(),
        );
      }
    }

    // Nettoyage des ingrédients : gestion du "de" ou "d'"
    final cleanedIngredients = ingredients.map((ing) {
      final parts = ing.split(RegExp(r"\s+(de|d')\s*"));
      if (parts.length > 1) {
        return '${parts[0].trim()} ${parts.sublist(1).join(' ').trim().capitalize()}';
      }
      return ing;
    }).toList();

    return {
      'title': title,
      'ingredients': cleanedIngredients,
      'instructions': instructions,
    };
  }

  @override
  Widget build(BuildContext context) {
    final recipeData = _parseRecipeText(recipeText);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipeData['title']),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: recipeText));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Recette copiée !')),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Ingrédients', Icons.kitchen),
            ...recipeData['ingredients'].map<Widget>((ingredient) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Text('- $ingredient'),
                )),
            SizedBox(height: 24),
            _buildSectionTitle('Instructions', Icons.list_alt),
            ...recipeData['instructions'].asMap().entries.map<Widget>((entry) {
              final index = entry.key + 1;
              final step = entry.value;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('$index. $step'),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            ),
          ),
        ],
      ),
    );
  }
}
