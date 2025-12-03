import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/skin_detection_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analysis History')),
      body: Consumer<SkinDetectionModel>(
        builder: (context, skinModel, child) {
          if (skinModel.history.isEmpty) {
            return const Center(
              child: Text(
                'No analysis results in history yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: skinModel.history.length,
            itemBuilder: (context, index) {
              final result = skinModel.history[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(Icons.history, color: Theme.of(context).colorScheme.primary),
                  title: Text('${result.method} Result: ${result.skinType}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Date: ${result.timestamp.day}/${result.timestamp.month}/${result.timestamp.year}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Detail: ${result.detail}')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}