## Recette Générée - Application de Génération de Recettes IA
Bienvenue dans Recette Générée, une application mobile développée avec Flutter qui utilise l'API Google Gemini pour générer des recettes personnalisées à partir d'ingrédients, de types de cuisine et de durées de préparation. Cette application est conçue pour offrir une expérience utilisateur moderne et intuitive, compatible avec Android et iOS.


## Capture d'écran :
<img src="/Screenshot_2025-05-17-18-14-31-73.jpg" alt="Home Page"/>
<img src="/Screenshot_2025-05-17-18-14-38-25.jpg" alt=""/>
<img src="/Screenshot_2025-05-17-18-14-51-47.jpg" alt=""/>
<img src="/Screenshot_2025-05-17-18-14-54-07.jpg" alt=""/>

## Description du Projet
Recette Générée permet aux utilisateurs de :
`
Saisir une liste d'ingrédients (séparés par des virgules).
Choisir un type de cuisine (ex. Italienne, Asiatique, Végétarienne).
Définir une durée de préparation maximale.
Générer une recette avec un titre, une liste d'ingrédients et des instructions étape par étape.
Visualiser la recette dans une interface claire et attrayante.
`
L'application intègre un splash screen animé, une homepage pour la saisie des paramètres, et une recipe screen avec un design moderne (cartes, icônes, espacement optimisé).
Prérequis
Avant de commencer, assurez-vous d'avoir les éléments suivants installés :

Flutter SDK : Téléchargez et configurez-le via flutter.dev.
Android Studio ou Xcode : Pour émulateurs ou compilation native (Android/iOS).
Clé API Google Gemini :
Créez un projet sur Google Cloud Console.
Activez l'API Gemini et générez une clé API dans APIs & Services > Credentials.


`ADB` (Android Debug Bridge) : Pour capturer les logs sur un appareil réel.
`Git` : Pour cloner le dépôt.

# Installation

Cloner le Répertoire :
```bash
git clone https://github.com/IhantsaFana/recetteia.git
cd recetteia
```

Installer les Dépendances :
```bash
flutter pub get
```

Configurer la Clé API :

Créez un fichier `lib/config/api_config.dart` (à ajouter dans .gitignore pour sécurité).
Ajoutez votre clé API Gemini :`const String geminiApiKey = 'VOTRE_CLÉ_API_GEMINI';` // Remplacez par votre clé
`const String geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';`


Assurez-vous que ce fichier est exclu du contrôle de version via .gitignore.


Vérifier les Permissions :

Ouvrez `android/app/src/main/AndroidManifest.xml` et ajoutez :`<uses-permission android:name="android.permission.INTERNET"/>`





Structure du Projet
Le projet est organisé comme suit :
```bash
recipe_generator/
├── .gitignore              # Fichier pour ignorer les fichiers sensibles (ex. api_config.dart)
├── pubspec.yaml            # Dépendances et configuration du projet
├── lib/
│   ├── config/             # Configuration de l'API (api_config.dart)
│   ├── screens/            # Écrans de l'application
│   │   ├── splash_screen.dart    # Écran de démarrage avec animation
│   │   ├── home_screen.dart      # Écran principal pour saisir les ingrédients, cuisine, et durée
│   │   └── recipe_screen.dart    # Écran pour afficher la recette générée
│   └── main.dart           # Point d'entrée de l'application
├── android/                # Configuration Android (build.gradle, AndroidManifest.xml)
├── ios/                    # Configuration iOS
└── build/                  # Fichiers générés (ignorés par git)
```

`lib/config/api_config.dart` : Stocke la clé API et l'URL de l'API Gemini (à sécuriser).
`lib/screens/` : Contient les trois écrans principaux avec une UI/UX moderne.
`pubspec.yaml` : Liste les dépendances (http, flutter_spinkit, etc.).

 ## Exécution

# Lancer l'Application :

Connectez un émulateur ou un appareil réel.
Exécutez :flutter run


Ou générez un APK pour tester :flutter build apk --release




# Tester la Génération de Recette :

Sur HomeScreen, entrez des ingrédients (ex. "poulet, riz, oignon").
Sélectionnez une cuisine (ex. Asiatique).
Ajustez la durée (ex. 45 min).
Cliquez sur "Générer Recette" et vérifiez la recette sur RecipeScreen.


# Capturer les Logs (si erreur) :

Utilisez :adb logcat | grep flutter
Partagez les erreurs pour un dépannage.
Dépannage Commun

# APK Ne Fonctionne Pas en Mode Release :
Vérifiez les permissions Internet dans AndroidManifest.xml.
Testez sans obfuscation : flutter build apk --release --no-obfuscate.
Assurez-vous que la clé API Gemini est valide (testez avec Postman).


# Erreur Réseau :
Confirmez que votre appareil a une connexion Internet.
Vérifiez les logs pour des erreurs comme "SocketException" ou "Timeout".



## Contribution
Les contributions sont les bienvenues ! Pour contribuer :

# Forkez le dépôt.
Créez une branche (`git checkout -b feature/nouvelle-fonction`).
Faites vos modifications et committez (`git commit -m "Description`").
Poussez vers votre fork (git push origin feature/nouvelle-fonction).
Créez une pull request.

## Prochaines Étapes

`Améliorations UI/UX` : Ajouter des images placeholders, des animations avec flutter_animate.
`Autocomplétion` : Intégrer autocomplete_textfield pour suggérer des ingrédients.
`Cache Local` : Sauvegarder les recettes avec shared_preferences.
`Tests` : Ajouter des tests unitaires et d'intégration.

## Licence
Ce projet est sous `licence MIT`. Voir le fichier `LICENSE` pour plus de détails.
Remerciements
Merci à Google pour l'`API Gemini` et à la communauté Flutter pour ses ressources.
