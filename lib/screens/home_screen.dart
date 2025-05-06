import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import 'recipe_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
      final ingredients =
          _ingredientsController.text.split(',').map((e) => e.trim()).toList();
      final mealType =
          _cuisine.toLowerCase() == 'végétarienne' ? 'végétarien' : 'dîner';
      final prompt =
          'Génère une recette en français utilisant les ingrédients suivants : ${ingredients.join(', ')}. La recette doit être de type $mealType, prendre maximum ${_duration.toInt()} minutes, et être adaptée à 2 personnes. Structure la réponse avec un titre, une liste d\'ingrédients, et des instructions étape par étape.';

      final response = await http.post(
        Uri.parse('$geminiApiUrl?key=$geminiApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topP': 0.95,
            'maxOutputTokens': 512,
          },
        }),
      );

      print('Code de statut: ${response.statusCode}');
      print('Réponse: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final recipeText =
            responseData['candidates']?[0]['content']['parts'][0]['text'] ??
            'Aucune recette générée';
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeScreen(recipeText: recipeText),
          ),
        );
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Clé API Gemini invalide')));
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Requête mal formée')));
      } else if (response.statusCode == 429) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Limite de requêtes dépassée')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur API: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Erreur réseau: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur réseau: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer une Recette'),
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _ingredientsController,
                    decoration: InputDecoration(
                      labelText:
                          'Ingrédients (séparés par des virgules, ex. poulet, riz)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.food_bank, color: Colors.teal),
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _cuisine,
                    decoration: InputDecoration(
                      labelText: 'Type de cuisine',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.restaurant, color: Colors.teal),
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
                  Text(
                    'Durée de préparation: ${_duration.toInt()} min',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _duration,
                    min: 15,
                    max: 60,
                    divisions: 3,
                    label: '${_duration.toInt()} min',
                    activeColor: Colors.teal,
                    onChanged: (value) => setState(() => _duration = value),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child:
                        _isLoading
                            ? SpinKitCircle(color: Colors.teal, size: 50.0)
                            : ElevatedButton.icon(
                              onPressed: _generateRecipe,
                              icon: Icon(Icons.restaurant_menu),
                              label: Text('Générer Recette'),
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

  @override
  void dispose() {
    _ingredientsController.dispose();
    super.dispose();
  }
}
