import 'package:flutter/material.dart';
import 'skin_quiz_screen.dart';
import 'camera_scan_screen.dart';
import 'info_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFC1CC), Color(0xFFF8BBD0), Color(0xFFFCE4EC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Welcome to SmartSkin 💕",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFAD1457),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Discover your skin type, scan for analysis, and learn proper skincare.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.pink.shade800,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Buttons
                  _buildFeatureCard(
                    context,
                    icon: Icons.quiz_rounded,
                    title: "Skin Type Quiz",
                    color: Colors.pink.shade300,
                    screen: const SkinQuizScreen(),
                  ),
                  const SizedBox(height: 20),

                  _buildFeatureCard(
                    context,
                    icon: Icons.camera_alt_rounded,
                    title: "Scan My Skin",
                    color: Colors.pink.shade200,
                    screen: const CameraScanScreen(),
                  ),
                  const SizedBox(height: 20),

                  _buildFeatureCard(
                    context,
                    icon: Icons.book_rounded,
                    title: "Learn About Skincare",
                    color: Colors.pink.shade100,
                    screen: const InfoScreen(),
                  ),

                  const SizedBox(height: 40),
                  const Text(
                    "💗 Your skin deserves smart care 💗",
                    style: TextStyle(
                      color: Colors.pink,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context,
      {required IconData icon,
      required String title,
      required Color color,
      required Widget screen}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.shade100.withValues(alpha: 0.5),

              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
