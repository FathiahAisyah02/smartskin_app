import 'package:flutter/material.dart';

class KnowledgeQuizScreen extends StatelessWidget {
  const KnowledgeQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Skincare Knowledge Test')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Basic Skincare Knowledge Quiz',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
                textAlign: TextAlign.center,
              ),
              const Divider(height: 30),
              
              // Sample Question 1: (Factual)
              const Text(
                'Question: What is the primary characteristic of Oily Skin?', 
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              
              // Options
              _buildQuizOption(context, 'A) Excessive shine and large pores', true),
              const SizedBox(height: 15),
              _buildQuizOption(context, 'B) Tight, flaky texture and redness', false),
              const SizedBox(height: 15),
              _buildQuizOption(context, 'C) Balanced moisture and minimal visible pores', false),
              const SizedBox(height: 50),

              // Button to simulate completion and show score
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle),
                label: const Text('Submit Quiz & View Score (Simulated)'),
                onPressed: () => _showScoreDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizOption(BuildContext context, String text, bool isCorrect) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isCorrect ? 'Correct!' : 'Incorrect.'),
              backgroundColor: isCorrect ? Colors.green.shade400 : Colors.red.shade400,
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          // FIX: Replaced .withOpacity(0.5) with .withAlpha(128) to remove deprecation warning
          side: BorderSide(color: Theme.of(context).colorScheme.primary.withAlpha(128)),
        ),
        child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
      ),
    );
  }

  void _showScoreDialog(BuildContext context) {
    // Navigate back to the Educational Module screen first
    Navigator.of(context).pop(); 
    
    // Show the score pop-up
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return const AlertDialog(
          title: Text('Quiz Score'),
          content: Text(
            '✅ Congratulations! You scored 4/5.\n\nKeep learning to improve your skincare knowledge.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }
}