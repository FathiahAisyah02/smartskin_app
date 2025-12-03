import 'package:flutter/material.dart';
import 'ingredient_suggestion_screen.dart';
import 'educational_module_screen.dart';     
import 'skin_quiz_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Menu')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to Smartskin',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              
              // 1. SKIN TYPE DETECTION QUIZ button
              _buildMainMenuButton(
                context,
                text: 'TAKE SKIN TYPE DETECTION QUIZ',
                onPressed: () {
                    Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (c) => const SkinQuizScreen())
                    );
                },
              ),
              const SizedBox(height: 20),

              // 2. SKINCARE INGREDIENT SUGGESTION button
              _buildMainMenuButton(
                context,
                text: 'SKINCARE INGREDIENT SUGGESTION',
                onPressed: () {
                    Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (c) => const IngredientSuggestionScreen())
                    );
                },
              ),
              const SizedBox(height: 20),

              // 3. EDUCATIONAL MODULE button
              _buildMainMenuButton(
                context,
                text: 'EDUCATIONAL MODULE',
                onPressed: () {
                    Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (c) => const EducationalModuleScreen())
                    );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainMenuButton(BuildContext context, {required String text, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(50), 
          foregroundColor: Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}