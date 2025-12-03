import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:smartskin_app/models/navigation_model.dart';
import 'package:smartskin_app/models/skin_detection_model.dart';
import 'package:smartskin_app/screens/main_screen.dart'; // We test the root screen

void main() {
  testWidgets('App loads successfully and shows SmartSkin Home title', (WidgetTester tester) async {
    // 1. Set up the Provider structure required by MainScreen
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          // Provide the actual models used by the app
          ChangeNotifierProvider(create: (_) => NavigationModel()),
          ChangeNotifierProvider(create: (_) => SkinDetectionModel()),
        ],
        // The widget we want to test is the MainScreen (which contains the home screen)
        child: const MaterialApp(
          home: MainScreen(), 
        ),
      ),
    );
    
    // 2. Wait for initial load and data synchronization
    await tester.pumpAndSettle();

    // 3. Verify the main components are present

    // Check for the title of the HomeScreen
    expect(find.text('SmartSkin Home'), findsOneWidget); 
    
    // Verify the Home icon is present in the BottomNavigationBar
    expect(find.byIcon(Icons.home), findsOneWidget);
    
    // Verify the "Latest Skin Analysis" section is present
    expect(find.text('Latest Skin Analysis'), findsOneWidget);
  });
}