import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension StringExtension on String {
  String capitalize() {
    if (this == null || isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
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
      line = line.trim().replaceAll('**', '');
      if (line.isEmpty) continue;

      if (line.contains('Ingrédients')) {
        currentSection = 'ingredients';
      } else if (line.contains('Instructions')) {
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

    // Nettoyage des ingrédients pour gérer les unités (ex. "500g de poulet")
    final cleanedIngredients =
        ingredients.map((ing) {
          final parts = ing.split(
            RegExp(
              r'\s+(de|d'
              ')\s*',
            ),
          );
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
        title: Text(
          recipeData['title'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: recipeText));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Recette copiée dans le presse-papiers'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre avec icône décorative
                Row(
                  children: [
                    Icon(Icons.restaurant_menu, color: Colors.teal, size: 30),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        recipeData['title'],
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[700],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Section Ingrédients
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.teal[50],
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ingrédients',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[800],
                          ),
                        ),
                        SizedBox(height: 10),
                        ...recipeData['ingredients'].map<Widget>(
                          (ingredient) => Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Colors.teal[600],
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    ingredient,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Section Instructions
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.teal[50],
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Instructions',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[800],
                          ),
                        ),
                        SizedBox(height: 10),
                        ...recipeData['instructions']
                            .asMap()
                            .entries
                            .map<Widget>(
                              (entry) => Padding(
                                padding: EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${entry.key + 1}.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal[600],
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        entry.value,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[800],
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Bouton Retour
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Retour',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
