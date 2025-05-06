import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import 'recipe_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _ingredientsController = TextEditingController();
  String _cuisine = 'Italienne';
  double _duration = 30;
  bool _isLoading = false;

  final List<String> cuisines = ['Italienne', 'Asiatique', 'Végétarienne'];

  Future<void> _generateRecipe() async {
    if (_ingredientsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer des ingrédients')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(chefGptApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $chefGptApiKey',
        },
        body: jsonEncode({
          'ingredients': _ingredientsController.text,
          'cuisine': _cuisine,
          'duration': _duration.toInt(),
        }),
      );

      if (response.statusCode == 200) {
        final recipeData = jsonDecode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => RecipeScreen(
                  recipe: recipeData['recipe'] ?? 'Recette générée',
                ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la génération de la recette')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur réseau : $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer une Recette')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _ingredientsController,
                decoration: InputDecoration(
                  labelText: 'Ingrédients (ex. poulet, riz)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.food_bank),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _cuisine,
                decoration: InputDecoration(
                  labelText: 'Type de cuisine',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _cuisine = value!),
                items:
                    cuisines
                        .map(
                          (cuisine) => DropdownMenuItem(
                            value: cuisine,
                            child: Text(cuisine),
                          ),
                        )
                        .toList(),
              ),
              SizedBox(height: 16),
              Text('Durée de préparation: ${_duration.toInt()} min'),
              Slider(
                value: _duration,
                min: 15,
                max: 60,
                divisions: 3,
                label: '${_duration.toInt()} min',
                onChanged: (value) => setState(() => _duration = value),
              ),
              SizedBox(height: 20),
              Center(
                child:
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton.icon(
                          onPressed: _generateRecipe,
                          icon: Icon(Icons.restaurant_menu),
                          label: Text('Générer Recette'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ingredientsController.dispose();
    super.dispose();
  }
}
