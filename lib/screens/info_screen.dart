import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Learn About Skincare"),
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFC1CC), Color(0xFFF8BBD0), Color(0xFFFCE4EC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildInfoCard(
              title: "Why Skin Type Matters",
              content:
                  "Knowing your skin type helps you choose the right skincare routine and avoid irritation.",
              icon: Icons.favorite,
            ),
            _buildInfoCard(
              title: "Basic Skin Types",
              content:
                  "• Oily — Shiny, larger pores, prone to acne.\n• Dry — Rough or flaky.\n• Combination — Oily in T-zone, dry on cheeks.\n• Sensitive — Easily irritated or red.",
              icon: Icons.face_retouching_natural,
            ),
            _buildInfoCard(
              title: "Simple Routine Tips",
              content:
                  "1️⃣ Cleanse gently\n2️⃣ Moisturize daily\n3️⃣ Always wear sunscreen\n4️⃣ Avoid harsh scrubs",
              icon: Icons.spa,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                label: const Text("Back to Home"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade300,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      shadowColor: Colors.pink.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.pink.shade300, size: 28),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(content,
                      style: TextStyle(fontSize: 15, color: Colors.grey[800])),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
