import 'package:flutter/material.dart';

class IngredientSuggestionScreen extends StatefulWidget {
  const IngredientSuggestionScreen({super.key});

  @override
  State<IngredientSuggestionScreen> createState() => _IngredientSuggestionScreenState();
}

class _IngredientSuggestionScreenState extends State<IngredientSuggestionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  final List<Map<String, String>> _allIngredients = [
    {'name': 'Hyaluronic Acid', 'function': 'Hydrator', 'suitable': 'Dry, Normal, Combination'},
    {'name': 'Salicylic Acid (BHA)', 'function': 'Exfoliant', 'suitable': 'Oily, Acne-Prone'},
    {'name': 'Niacinamide (Vitamin B3)', 'function': 'Barrier Support', 'suitable': 'All Skin Types'},
    {'name': 'Vitamin C (Ascorbic Acid)', 'function': 'Antioxidant', 'suitable': 'Normal, Combination'},
    {'name': 'Benzoyl Peroxide', 'function': 'Acne Treatment', 'suitable': 'Acne-Prone, Oily'},
    {'name': 'Ceramides', 'function': 'Barrier Repair', 'suitable': 'Dry, Sensitive'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredIngredients {
    if (_searchText.isEmpty) {
      return _allIngredients;
    }
    return _allIngredients.where((ingredient) {
      return ingredient['name']!.toLowerCase().contains(_searchText);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skincare Ingredients')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Ingredient (e.g., Hyaluronic)',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _filteredIngredients.isEmpty
                ? const Center(child: Text('No ingredients found.', style: TextStyle(fontSize: 16)))
                : ListView.builder(
                    itemCount: _filteredIngredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = _filteredIngredients[index];
                      return ListTile(
                        title: Text(ingredient['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Function: ${ingredient['function']}'),
                            Text('Suitable For: ${ingredient['suitable']}'),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          // Placeholder for navigating to a detail page
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Viewing details for ${ingredient['name']}... (Placeholder)')),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}