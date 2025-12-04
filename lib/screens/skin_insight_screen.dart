import 'package:flutter/material.dart';
import 'ingredient_suggestion_screen.dart';
import 'educational_module_screen.dart';     


class SkinInsightsScreen extends StatelessWidget {  // Renamed to SkinInsightsScreen
  const SkinInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skin Insights')),  // Updated AppBar title
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50),
              
              // 1. SKINCARE INGREDIENT SUGGESTION button
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

              // 2. EDUCATIONAL MODULE button
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
