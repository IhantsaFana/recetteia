import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import 'recipe_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _ingredientsController = TextEditingController();
  String _cuisine = 'Italienne';
  String _language = 'Français';
  double _duration = 30;
  bool _isLoading = false;

  final List<String> cuisines = [
    'Italienne',
    'Asiatique',
    'Malagasy',
    'Chinoise',
    'Végétarienne',
  ];
  final List<String> languages = ['Français', 'Anglais', 'Malagasy'];

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _generateRecipe() async {
    final rawIngredients = _ingredientsController.text.trim();
    if (rawIngredients.isEmpty) {
      _showSnack('Veuillez entrer des ingrédients');
      return;
    }

    setState(() => _isLoading = true);

    final ingredients = rawIngredients.split(',').map((e) => e.trim()).toList();
    final mealType =
        _cuisine.toLowerCase() == 'végétarienne' ? 'végétarien' : 'dîner';
    final languagePrompt =
        _language == 'Français'
            ? 'en français'
            : _language == 'Anglais'
            ? 'in English'
            : 'amin\'ny teny Malagasy';

    final prompt = '''
Génère une recette $languagePrompt avec ces ingrédients : ${ingredients.join(', ')}.
La recette doit être de type $mealType, prête en moins de ${_duration.toInt()} minutes pour 2 personnes.
Structure : 
1. Titre
2. Liste d'ingrédients
3. Instructions étape par étape.
''';

    try {
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

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final recipeText =
            json['candidates']?[0]['content']['parts'][0]['text'] ??
            'Aucune recette générée';
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => RecipeScreen(recipeText: recipeText),
            transitionsBuilder:
                (_, animation, __, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        );
      } else {
        _handleApiError(response.statusCode);
      }
    } catch (e) {
      _showSnack('Erreur réseau : vérifiez votre connexion internet');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleApiError(int code) {
    final messages = {
      400: 'Requête mal formée',
      401: 'Clé API Gemini invalide',
      429: 'Limite de requêtes atteinte',
    };
    _showSnack(messages[code] ?? 'Erreur API : $code');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une Recette'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextCard(
              label: 'Ingrédients (ex. riz, poulet)',
              icon: Icons.food_bank,
              controller: _ingredientsController,
            ),
            const SizedBox(height: 16),
            CustomDropdownCard(
              label: 'Type de cuisine',
              icon: Icons.restaurant,
              value: _cuisine,
              items: cuisines,
              onChanged: (val) => setState(() => _cuisine = val!),
            ),
            const SizedBox(height: 16),
            CustomDropdownCard(
              label: 'Langue de la recette',
              icon: Icons.language,
              value: _language,
              items: languages,
              onChanged: (val) => setState(() => _language = val!),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Durée de préparation: ${_duration.toInt()} min',
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child:
                _isLoading
                    ? const SpinKitFadingCircle(color: Colors.white, size: 40.0)
                    : ElevatedButton.icon(
                      onPressed: _generateRecipe,
                      icon: const Icon(Icons.restaurant_menu),
                      label: const Text('Générer Recette'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 12.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
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

// Widget personnalisé : Champ de texte dans une carte
class CustomTextCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  const CustomTextCard({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            prefixIcon: Icon(icon, color: Colors.teal),
          ),
        ),
      ),
    );
  }
}

// Widget personnalisé : Dropdown dans une carte
class CustomDropdownCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;

  const CustomDropdownCard({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            prefixIcon: Icon(icon, color: Colors.teal),
          ),
          onChanged: onChanged,
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
