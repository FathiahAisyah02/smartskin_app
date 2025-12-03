import 'package:flutter/material.dart';

class EducationalModuleScreen extends StatelessWidget {
  const EducationalModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Educational Modules')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader(context, 'Skin Types'),
          _buildSkinTypeTile(context, 'Normal Skin', 'Balanced, minimal issues.'),
          _buildSkinTypeTile(context, 'Oily Skin', 'Excess sebum production, prone to breakouts.'),
          _buildSkinTypeTile(context, 'Dry Skin', 'Lacks moisture and natural oils, often flaky.'),
          _buildSkinTypeTile(context, 'Combination Skin', 'Oily in the T-Zone, dry elsewhere.'),
          
          const SizedBox(height: 30),
          _buildSectionHeader(context, 'Skincare Myths'),
          _buildSkinTypeTile(context, 'Myth: Soap Cures Acne', 'Reality: Can strip the skin and cause irritation.'),
          _buildSkinTypeTile(context, 'Myth: Tanning is Healthy', 'Reality: Sun exposure accelerates aging and damage.'),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSkinTypeTile(BuildContext context, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Placeholder navigation to a detailed page
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => _EducationalDetailPage(title: title, content: _getEducationalDetail(title)),
            ),
          );
        },
      ),
    );
  }
  
  // Hardcoded detailed content placeholder
  String _getEducationalDetail(String title) {
    switch (title) {
      case 'Oily Skin':
        return "Oily skin is characterized by excess sebum production. This excess oil can lead to large, visible pores and a higher frequency of breakouts. \n\n**Basic Guidance:** Use lightweight, non-comedogenic (won't clog pores) products. Look for ingredients like Niacinamide and Salicylic Acid to control oil and exfoliate pores.";
      case 'Dry Skin':
        return "Dry skin lacks natural moisture and often feels tight, flaky, or rough. This condition can be exacerbated by harsh weather or cleansing products. \n\n**Basic Guidance:** Focus on intense hydration and barrier repair. Key ingredients include Hyaluronic Acid, Ceramides, and Glycerin. Avoid strong physical scrubs.";
      case 'Normal Skin':
        return "Normal skin is well-balanced—neither too oily nor too dry. It generally has few imperfections and small pores. \n\n**Basic Guidance:** Maintain balance with a gentle cleanser, a simple moisturizer, and most importantly, daily SPF. You can introduce active ingredients slowly.";
      case 'Combination Skin':
        return "Combination skin means different areas of your face have different needs, typically an oily T-Zone (forehead, nose, chin) and dry or normal cheeks. \n\n**Basic Guidance:** Adopt a mixed routine. Use oil-controlling products on the T-zone and hydrating products on the cheeks. Gentle exfoliation can help manage both areas.";
      default:
        return "This module will contain detailed information about $title. Data loading from the database is coming soon!";
    }
  }
}

// Placeholder for the detail page
class _EducationalDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const _EducationalDetailPage({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          content,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}