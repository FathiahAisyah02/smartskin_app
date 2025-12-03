// lib/screens/result_screen.dart (Final Code)
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String skinType;
  final String description;
  final List<String> suggestions;

  const ResultScreen({
    super.key,
    required this.skinType,
    required this.description,
    required this.suggestions,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Quiz Result'),
        // REMOVED backgroundColor: Uses theme color from main.dart
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detected Skin Type:', 
              style: TextStyle(fontSize: 20, color: Colors.grey.shade700)
            ),
            Text(
              skinType, 
              // Uses the soft theme color
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: primaryColor)
            ),
            const Divider(height: 30),
            
            Text(description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 25),
            
            Text(
              'Suggested Routine Focus:', 
              // Uses the soft theme color
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)
            ),
            const SizedBox(height: 10),
            
            // Displaying suggestions - icons also use the soft theme color
            ...suggestions.map((s) => Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline, size: 20, color: primaryColor),
                    const SizedBox(width: 8),
                    Expanded(child: Text(s, style: const TextStyle(fontSize: 16))),
                  ],
                ),
              )),
              
            const SizedBox(height: 40),
            
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('Go to Home/Guidance Screen'),
              ),
            )
          ],
        ),
      ),
    );
  }
}