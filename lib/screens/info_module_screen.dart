import 'package:flutter/material.dart';

class InfoModuleScreen extends StatelessWidget {
  const InfoModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learn About Skincare')),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Here you can add skincare tips, ingredient information, and facts about different skin types.',
        ),
      ),
    );
  }
}
