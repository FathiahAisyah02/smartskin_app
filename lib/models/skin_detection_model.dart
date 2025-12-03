import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnalysisResult {
  final DateTime timestamp;
  final String method;
  final String skinType;
  final String detail;

  AnalysisResult({
    required this.timestamp,
    required this.method,
    required this.skinType,
    required this.detail,
  });
}

class SkinDetectionModel extends ChangeNotifier {
  // ---------------------------------------------
  // 1. Profile Properties (Editable via ProfileScreen)
  // ---------------------------------------------
  String _userName = 'Aisyah Ghazali'; 
  int _userAge = 28;  

  String get userName => _userName;
  int get userAge => _userAge;

  void updateProfile({required String name, required int age}) {
    _userName = name;
    _userAge = age;
    // Notifies all listeners (like the ProfileScreen) to rebuild.
    notifyListeners(); 
  }
  
  // ---------------------------------------------
  // 2. Detection Properties (Used by Quiz/Scan)
  // ---------------------------------------------
  String _latestSkinType = 'Unknown';
  String _detectionResult = 'No analysis data available yet. Start a scan or take the quiz.';

  String get latestSkinType => _latestSkinType;
  String get detectionResult => _detectionResult;

  final List<AnalysisResult> _history = [];
  List<AnalysisResult> get history => _history.reversed.toList();

  Future<void> runMlInference(String imagePath) async {
    // Simulated delay for ML processing
    await Future.delayed(const Duration(seconds: 3));

    // Simulated results based on a random outcome
    final results = [
      {'type': 'Oily', 'detail': 'High sebum production, prone to acne and large pores.'},
      {'type': 'Dry', 'detail': 'Lack of moisture, often feeling tight or flaky.'},
      {'type': 'Normal', 'detail': 'Well-balanced moisture and oil production.'},
      {'type': 'Combination', 'detail': 'Oily in the T-Zone, dry/normal on the cheeks.'},
    ];
    final result = results[DateTime.now().second % 4];

    await recordDetection(
      method: 'ML Scan',
      type: result['type']!,
      detail: result['detail']!,
    );
  }

  Future<void> recordDetection({
    required String method,
    required String type,
    required String detail,
  }) async {
    _latestSkinType = type;
    _detectionResult = detail;
    _history.add(AnalysisResult(
      timestamp: DateTime.now(),
      method: method,
      skinType: type,
      detail: detail,
    ));
    notifyListeners();
  }
  
  void clearAllData() {
    _history.clear();
    _latestSkinType = 'Unknown';
    _detectionResult = 'No analysis data available yet. Start a scan or take the quiz.';
    notifyListeners();
  }
}