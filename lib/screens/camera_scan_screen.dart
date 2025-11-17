import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class CameraScanScreen extends StatefulWidget {
  const CameraScanScreen({super.key});

  @override
  State<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreen> {
  String? _analysisResult;
  String? _error;
  final ImagePicker _picker = ImagePicker();

  Future<void> _openCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo == null) return;

      await _analyzeSkin(photo.path);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Camera access failed: $e');
    }
  }

  Future<void> _analyzeSkin(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        setState(() => _error = 'Unable to process image.');
        return;
      }

      int totalR = 0;
      int totalG = 0;
      int totalB = 0;
      int count = 0;
      const int step = 20;

      for (int y = 0; y < image.height; y += step) {
        for (int x = 0; x < image.width; x += step) {
          final pixel = image.getPixel(x, y);
          totalR += pixel.r.toInt();
          totalG += pixel.g.toInt();
          totalB += pixel.b.toInt();
          count++;
        }
      }

      if (count == 0) {
        setState(() => _error = 'No valid pixels found.');
        return;
      }

      final avgR = totalR ~/ count;
      final avgG = totalG ~/ count;
      final avgB = totalB ~/ count;

      // Rule-based decision
      String skinType;
      if (avgR > avgG && avgR > avgB) {
        skinType = "Oily Skin";
      } else if (avgG > avgR && avgG > avgB) {
        skinType = "Dry Skin";
      } else if ((avgB - avgR).abs() < 10 && (avgG - avgR).abs() < 10) {
        skinType = "Normal Skin";
      } else {
        skinType = "Combination Skin";
      }

      setState(() {
        _analysisResult =
            "Detected skin type: $skinType\n\n💡 Tip: Maintain hydration and avoid harsh cleansers.";
        _error = null;
      });
    } catch (e) {
      setState(() => _error = 'Analysis failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SmartSkin Camera Scan 📸"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFC1CC), Color(0xFFF8BBD0), Color(0xFFFCE4EC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.face_retouching_natural_rounded,
                size: 150,
                color: Colors.pinkAccent,
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: _openCamera,
                icon: const Icon(Icons.camera_alt_rounded),
                label: const Text("Open Camera"),
              ),
              const SizedBox(height: 20),
              if (_analysisResult != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.shade100.withValues(alpha: 0.5),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    _analysisResult!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.pink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
