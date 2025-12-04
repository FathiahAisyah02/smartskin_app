import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/skin_detection_model.dart';
import '../models/navigation_model.dart';
import 'skin_quiz_screen.dart';
import 'skin_insight_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Consumer2<SkinDetectionModel, NavigationModel>(
      builder: (context, skinModel, navModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('SmartSkin Home'),
            // Button to access the dedicated Main Menu screen
            leading: IconButton(
              icon: const Icon(Icons.apps),
              tooltip: 'Open Main Menu',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SkinInsightsScreen()),
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.clear_all),
                tooltip: 'Clear All Data',
                onPressed: () {
                  skinModel.clearAllData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All local data cleared.')),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildWelcomeCard(skinModel.userName, skinModel.userAge, primaryColor),
                
                const SizedBox(height: 24),
                
                Text(
                  'Latest Skin Analysis',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                _buildAnalysisCard(
                  skinModel.latestSkinType, 
                  skinModel.detectionResult, 
                  primaryColor
                ),

                const SizedBox(height: 30),
                
                // Quick Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => navModel.setIndex(1), // Go to Scan Tab
                        icon: const Icon(Icons.photo_camera),
                        label: const Text('Start Scan'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Go directly to the Skin Type Detection Quiz flow
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const SkinQuizScreen()),
                          );
                        },
                        icon: const Icon(Icons.quiz),
                        label: const Text('Take Quiz'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(fontSize: 16),
                          side: BorderSide(color: primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeCard(String name, int age, Color primaryColor) {
    return Card(
      elevation: 4,
      color: primaryColor.withAlpha(26), // Soft background tint
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome Back,', style: TextStyle(fontSize: 18, color: primaryColor)),
            const SizedBox(height: 4),
            Text(name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Divider(height: 20),
            Row(
              children: [
                Icon(Icons.person_outline, color: primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(age > 0 ? '$age years old' : 'Age not set', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisCard(String type, String detail, Color primaryColor) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Skin Type:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              type,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: type == 'Unknown' ? Colors.red : primaryColor,
              ),
            ),
            const Divider(height: 24),
            const Text('Detailed Summary:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(detail, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}