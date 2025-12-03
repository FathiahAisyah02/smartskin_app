import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/navigation_model.dart';
import 'models/skin_detection_model.dart';
import 'screens/main_screen.dart';

void main() {
  // Ensure camera dependencies are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationModel()),
        ChangeNotifierProvider(create: (_) => SkinDetectionModel()),
      ],
      child: const SmartSkinApp(),
    ),
  );
}

class SmartSkinApp extends StatelessWidget {
  const SmartSkinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartSkin App',
      theme: ThemeData(
        // Soft Pink/Neutral Theme
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink.shade300, 
          primary: Colors.pink.shade300,
          secondary: Colors.pink.shade500,
          // DEPRECATED 'background: Colors.white' REMOVED
          surface: Colors.grey.shade50, // This color is used for cards, sheets, etc.
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pink.shade50, // Very light pink
          foregroundColor: Colors.black87,
          elevation: 0.5,
        ),
      ),
      home: const MainScreen(),
    );
  }
}