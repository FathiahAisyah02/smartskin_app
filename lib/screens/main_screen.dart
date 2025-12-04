import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/navigation_model.dart';
import 'home_screen.dart';
import 'scan_screen.dart';
import 'guidance_screen.dart'; // Skincare Advice Tab
import 'history_screen.dart';
import 'profile_screen.dart';
import 'skin_insight_screen.dart'; // Import MainMenuScreen

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  // The screens assigned to the 5 bottom navigation tabs, including MainMenuScreen
  final List<Widget> _screens = const [
    HomeScreen(),
    ScanScreen(),
    GuidanceScreen(), // Skincare Advice Tab
    HistoryScreen(),
    SkinInsightsScreen(), // Main Menu added as a new screen
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationModel>(
      builder: (context, navModel, child) {
        return Scaffold(
          body: IndexedStack(
            index: navModel.currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: navModel.currentIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            onTap: navModel.setIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt_outlined),
                activeIcon: Icon(Icons.camera_alt),
                label: 'Scan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border), 
                activeIcon: Icon(Icons.favorite),
                label: 'Guidance', // Skincare Advice
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_outlined),
                activeIcon: Icon(Icons.history),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_outlined),
                activeIcon: Icon(Icons.menu),
                label: 'SkinInsights', // Added "Main Menu" label
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
