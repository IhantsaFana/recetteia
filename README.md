# 📱 Recette Générée - Application Mobile de Recettes IA

Bienvenue dans **Recette Générée**, une application mobile Flutter qui utilise l'**API Google Gemini** pour générer des recettes personnalisées à partir d'ingrédients, de types de cuisine et de durée de préparation.

> ⚡ Moderne, intuitive et compatible Android/iOS.

---

## 📸 Captures d'Écran

<p align="center">
  <img src="/Screenshot_2025-05-17-18-14-31-73.jpg" alt="Home" width="200"/>
  <img src="/Screenshot_2025-05-17-18-14-38-25.jpg" alt="Cuisine" width="200"/>
  <img src="/Screenshot_2025-05-17-18-14-51-47.jpg" alt="Durée" width="200"/>
  <img src="/Screenshot_2025-05-17-18-14-54-07.jpg" alt="Recette" width="200"/>
</p>


---

## 📝 Fonctionnalités

- ✅ Entrer une liste d'ingrédients (ex. `poulet, riz, oignon`)
- ✅ Choisir un type de cuisine (Italienne, Asiatique, Végétarienne, etc.)
- ✅ Définir une durée maximale de préparation
- ✅ Générer une recette complète avec :
  - Titre
  - Liste d’ingrédients
  - Instructions étape par étape
- ✅ Interface moderne avec splash screen animé et design responsive

---

## 🚀 Prérequis

Avant de commencer :

- [Flutter SDK](https://flutter.dev)
- Android Studio ou Xcode
- Un émulateur ou appareil physique Android/iOS
- **Clé API Google Gemini** :
  - Créez un projet sur [Google Cloud Console](https://console.cloud.google.com/)
  - Activez l’API Gemini
  - Générez une clé API dans `APIs & Services > Credentials`

> ⚙️ Outils supplémentaires :
- `ADB` (Android Debug Bridge) pour le debug
- `Git` pour le versioning

---

## 🛠️ Installation

### 1. Cloner le projet

```bash
git clone https://github.com/IhantsaFana/recetteia.git
cd recetteia
```
### 2. Installer les dépendances
```bash
flutter pub get
```
### 3. Configurer l’API

Créer le fichier `lib/config/api_config.dart` :
```bash
const String geminiApiKey = 'VOTRE_CLÉ_API_GEMINI';
const String geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
```
> 🛡️ Ne pas oublier d'ajouter ce fichier dans .gitignore.

### 4. Vérifier les permissions

Ajoutez dans `android/app/src/main/AndroidManifest.xml` :

```bash
<uses-permission android:name="android.permission.INTERNET"/>
```

# 🗂️ Structure du Projet
```bash
recipe_generator/
├── .gitignore
├── pubspec.yaml
├── lib/
│   ├── config/
│   │   └── api_config.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── home_screen.dart
│   │   └── recipe_screen.dart
│   └── main.dart
├── android/
├── ios/
└── build/
```
# ▶️ Exécution
Lancer l'application :
```bash
flutter run
```
## Générer un APK (mode release) :
```
flutter build apk --release
```

## 🧪 Tester la Génération de Recette

    Entrez des ingrédients sur l’écran d’accueil

    Sélectionnez un type de cuisine

    Choisissez une durée

    Appuyez sur "Générer Recette"

    La recette apparaît sur RecipeScreen
