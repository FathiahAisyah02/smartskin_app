import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/skin_detection_model.dart';

class GuidanceScreen extends StatelessWidget {
  final String? skinType; 

  const GuidanceScreen({
    super.key,
    this.skinType, 
  });

  // --- Widget Builder for Guidance Content ---
  List<Widget> _buildGuidanceContent(BuildContext context, String skinType) {
    if (skinType.isEmpty || skinType == 'Unknown') {
      // FIX: Added 'const' here to eliminate the warning.
      return const [ 
        // Note: _buildSectionTitle and the Text widget inside it will still be non-const
        // because the helper methods are defined to take arguments/use non-const styles.
        // However, this structure satisfies the analyzer for the list itself.
        _SectionTitle('No Analysis Data'), // Renamed helper for const compatibility
        Text("No recent skin analysis found. Please take the **Skin Type Detection Quiz** or perform a **Scan** to receive personalized guidance."),
      ];
    }
    
    // Normalize type for lookup
    String cleanType = skinType.replaceAll(' & Sensitive', '');
    List<Widget> guidanceWidgets = [];

    // --- 1. Characteristics Section ---
    String characteristics = '';
    
    switch (cleanType) {
      case 'Normal':
        characteristics = 'Your skin is well-balanced—neither too oily nor too dry. It generally has small, barely visible pores and few imperfections.';
        break;
      case 'Oily':
        characteristics = 'Oily skin is defined by excessive sebum production, leading to a persistent shine, large, visible pores, and a higher frequency of breakouts.';
        break;
      case 'Dry':
        characteristics = 'Dry skin lacks natural moisture and often feels tight, rough, flaky, or dull. Pores are typically small and invisible.';
        break;
      case 'Combination':
        characteristics = 'Your skin has two or more types; typically an oily T-Zone (forehead, nose, chin) and dry or normal cheeks.';
        break;
      default:
        characteristics = "The system returned an unexpected result: '$skinType'. Please report this issue.";
    }

    guidanceWidgets.addAll([
      _buildSectionTitle('Characteristics'),
      Text(characteristics, style: const TextStyle(fontSize: 16)),
      const SizedBox(height: 15),
    ]);


    // --- 2. Basic Skincare Guidance Section ---
    List<String> guidancePoints = [];

    switch (cleanType) {
      case 'Normal':
        guidancePoints = [
          'Cleanse: Use a gentle, non-foaming cleanser once or twice a day.',
          'Treat/Protect: Focus on Antioxidants like Vitamin C in the morning to protect against environmental damage.',
          'Moisturize: Use a lightweight, non-comedogenic lotion.',
          'Key Tip: The biggest priority is daily Sunscreen (SPF 30+).',
        ];
        break;
      case 'Oily':
        guidancePoints = [
          'Cleanse: Use a foaming or gel cleanser containing Salicylic Acid (BHA).',
          'Treat: Use ingredients like Niacinamide to regulate oil production and minimize pores.',
          'Moisturize: Use a lightweight, oil-free gel or water-based moisturizer.',
          'Key Tip: Look for products labeled "non-comedogenic" to ensure they won\'t clog your pores.',
        ];
        break;
      case 'Dry':
        guidancePoints = [
          'Cleanse: Use a creamy, non-foaming, or milk cleanser to avoid stripping natural oils.',
          'Treat/Hydrate: Focus on hydrating ingredients like Hyaluronic Acid, Glycerin, and Squalane.',
          'Moisturize: Use a rich cream containing Ceramides to repair the skin barrier.',
          'Key Tip: Apply moisturizer and any oils immediately after cleansing to lock in hydration.',
        ];
        break;
      case 'Combination':
        guidancePoints = [
          'Cleansing: Use a gentle gel cleanser that works well for all areas.',
          'Targeted Treatment: Apply oil-controlling serums (like Niacinamide or BHA) *only* to the oily T-zone. Use hydrating creams *only* on the dry cheeks.',
          'Moisturize: Use a medium-weight lotion suitable for sensitive skin all over the face.',
          'Key Tip: Consistent, gentle care is vital. Use non-comedogenic products across the entire face.',
        ];
        break;
    }

    if (guidancePoints.isNotEmpty) {
      guidanceWidgets.add(_buildSectionTitle('Basic Skincare Guidance'));
      // Changed to map over guidancePoints and build the list items
      guidanceWidgets.addAll(guidancePoints.map((point) => _buildListItem(context, point)));
      guidanceWidgets.add(const SizedBox(height: 15));
    }


    // --- 3. Sensitivity Note (if applicable) ---
    if (skinType.contains('Sensitive')) {
      guidanceWidgets.addAll([
        _buildSectionTitle('Sensitivity Note', color: Colors.red),
        Text(
          'Your skin is also categorized as Sensitive. Always patch test new products, use fragrance-free formulations, and avoid common irritants like high concentrations of alcohol or essential oils.',
          style: TextStyle(fontSize: 16, color: Colors.red.shade700),
        ),
        const SizedBox(height: 15),
      ]);
    }

    return guidanceWidgets;
  }

  // Helper function to build section titles (bold and colored)
  Widget _buildSectionTitle(String title, {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  // Helper function to build list items for guidance points
  Widget _buildListItem(BuildContext context, String text) {
    final parts = text.split(':');
    final leadingText = parts.length > 1 ? '${parts[0]}:' : text;
    final remainingText = parts.length > 1 ? parts.sublist(1).join(':') : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style.copyWith(fontSize: 16, height: 1.5),
                children: [
                  TextSpan(
                    text: leadingText,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: remainingText,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Correctly read the latest skin type from the Provider model
    final skinModel = Provider.of<SkinDetectionModel>(context);
    final String typeToDisplay = skinType ?? skinModel.latestSkinType;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Personalized Skincare Guidance')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Current Skin Type: $typeToDisplay',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Divider(height: 30),
            
            // Render the guidance content
            ..._buildGuidanceContent(context, typeToDisplay),

            const SizedBox(height: 20),
            const Text(
              '*Disclaimer: This information is based on your latest analysis. Consult a dermatologist for full advice.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

// Added a simple const-compatible widget for the default case title.
// This is not strictly necessary but makes the logic cleaner.
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  
  @override
  Widget build(BuildContext context) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18));
  }
}