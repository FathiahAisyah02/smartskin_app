import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/skin_detection_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State to toggle between viewing and editing mode
  bool _isEditing = false;
  
  // Controllers for the input fields
  late TextEditingController _nameController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Populate controllers with current model data when dependencies change
    final skinModel = Provider.of<SkinDetectionModel>(context, listen: false);
    if (_nameController.text.isEmpty) {
        _nameController.text = skinModel.userName;
        _ageController.text = skinModel.userAge.toString();
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  // --- Logic to Save Profile Changes ---
  void _saveProfile(SkinDetectionModel model) {
    // 1. Validate data
    final newName = _nameController.text.trim();
    final newAgeString = _ageController.text.trim();
    final newAge = int.tryParse(newAgeString);

    if (newName.isEmpty || newAge == null || newAge <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid name and age.')),
      );
      return;
    }

    // 2. Call the model method to update data in memory
    model.updateProfile(name: newName, age: newAge);

    // 3. Update the local UI state and switch back to view mode
    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Consumer rebuilds the widget whenever the SkinDetectionModel changes (i.e., when updateProfile is called)
    return Consumer<SkinDetectionModel>(
      builder: (context, skinModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Profile'),
            actions: [
              TextButton(
                onPressed: () {
                  if (_isEditing) {
                    _saveProfile(skinModel);
                  } else {
                    setState(() {
                      _isEditing = true;
                    });
                  }
                },
                child: Text(
                  _isEditing ? 'SAVE' : 'EDIT',
                  style: TextStyle(
                    color: _isEditing ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 60),
                  ),
                ),
                const SizedBox(height: 30),
                
                // --- User Name Field ---
                _isEditing
                    ? _buildEditableField(
                        context,
                        label: 'Name',
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                      )
                    : _buildReadOnlyField(
                        context,
                        label: 'Name',
                        value: skinModel.userName,
                      ),
                const Divider(height: 30),

                // --- User Age Field ---
                _isEditing
                    ? _buildEditableField(
                        context,
                        label: 'Age',
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                      )
                    : _buildReadOnlyField(
                        context,
                        label: 'Age',
                        value: skinModel.userAge.toString(),
                      ),
                const Divider(height: 30),
                
                // Placeholder for other profile actions
                const ListTile(
                  leading: Icon(Icons.history_toggle_off),
                  title: Text('View Analysis History'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: null, // Add navigation later
                ),
                const ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('Sign Out', style: TextStyle(color: Colors.red)),
                  onTap: null, // Add sign-out logic later
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget for Read-Only Profile Information
  Widget _buildReadOnlyField(BuildContext context, {required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // Widget for Editable Profile Fields
  Widget _buildEditableField(BuildContext context, {required String label, required TextEditingController controller, required TextInputType keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
    );
  }
}