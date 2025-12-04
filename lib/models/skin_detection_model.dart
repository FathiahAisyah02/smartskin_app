import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  // Function to save to JSON
  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'method': method,
    'skinType': skinType,
    'detail': detail,
  };

  // Function to load from JSON
  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      timestamp: DateTime.parse(json['timestamp'] as String),
      method: json['method'] as String,
      skinType: json['skinType'] as String,
      detail: json['detail'] as String,
    );
  }
}


class SkinDetectionModel extends ChangeNotifier {
  // ---------------------------------------------
  // 1. Profile Properties
  // ---------------------------------------------
  String _userName = 'Aisyah Ghazali'; 
  int _userAge = 28; 

  String get userName => _userName;
  int get userAge => _userAge;

  void updateProfile({required String name, required int age}) {
    _userName = name;
    _userAge = age;
    _saveAllData(); 
    notifyListeners(); 
  }
  
  // ---------------------------------------------
  // 2. Detection Properties
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
    await _saveAllData();
    notifyListeners();
  }
  
  void clearAllData() {
    _history.clear();
    _latestSkinType = 'Unknown';
    _detectionResult = 'No analysis data available yet. Start a scan or take the quiz.';
    _userName = 'Aisyah Ghazali';
    _userAge = 28;
    _saveAllData(); 
    notifyListeners();
  }
  
  // ==========================================================
  // PERSISTENCE FUNCTIONS
  // ==========================================================
  
  // FUNCTION TO LOAD INITIAL DATA (Wajib dipanggil di HomeScreen menggunakan FutureBuilder)
  Future<void> loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load Profile
    _userName = prefs.getString('userName') ?? 'Aisyah Ghazali'; 
    _userAge = prefs.getInt('userAge') ?? 28; 
    
    // Load Latest Result
    _latestSkinType = prefs.getString('latestSkinType') ?? 'Unknown';
    _detectionResult = prefs.getString('detectionResult') ?? 'No analysis data available yet. Start a scan or take the quiz.';

    // Load History
    final historyJson = prefs.getStringList('analysisHistory') ?? [];
    _history.clear();
    for (var jsonString in historyJson) {
      _history.add(AnalysisResult.fromJson(jsonDecode(jsonString))); 
    }

    notifyListeners();
  }

  // HELPER FUNCTION TO SAVE ALL DATA
  Future<void> _saveAllData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save Profile
    await prefs.setString('userName', _userName);
    await prefs.setInt('userAge', _userAge);
    
    // Save Latest Result
    await prefs.setString('latestSkinType', _latestSkinType);
    await prefs.setString('detectionResult', _detectionResult);

    // Save History (Convert List<AnalysisResult> to List<String> of JSON)
    final historyJsonList = _history.map((result) => jsonEncode(result.toJson())).toList();
    await prefs.setStringList('analysisHistory', historyJsonList);
  }

}