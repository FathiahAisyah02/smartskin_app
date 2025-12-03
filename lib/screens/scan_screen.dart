import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; 
import 'package:provider/provider.dart';
import '../models/skin_detection_model.dart';
import '../models/navigation_model.dart';
// REMOVED: import 'package:flutter/foundation.dart'; // No longer needed as debugPrint is in material.dart

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      
      if (_cameras.isEmpty) {
        if (mounted) setState(() {}); 
        return; 
      }

      // Try to find the front camera, default to the first one found
      CameraDescription frontCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras[0],
      );

      _controller = CameraController(
        frontCamera, // Use front camera
        ResolutionPreset.medium,
      );

      _initializeControllerFuture = _controller.initialize();
      
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _cameras = []; 
        });
      }
      debugPrint('Camera initialization error: $e'); 
    }
  }

  @override
  void dispose() {
    if (_controller.value.isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _takePicture(
      SkinDetectionModel skinModel, NavigationModel navModel) async {
    if (!_controller.value.isInitialized || _controller.value.isTakingPicture) {
      return;
    }
      
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Capturing image and analyzing...')),
    );

    try {
      await _initializeControllerFuture; 
      final XFile file = await _controller.takePicture(); 

      if (!mounted) return; 

      // 1. Run inference (simulated)
      await skinModel.runMlInference(file.path); 

      if (!mounted) return; // FIX: Guard context use after runMlInference

      // 2. Show the pop-up with the analysis result
      _showResultDialog(
        context,
        method: 'ML Scan',
        skinType: skinModel.latestSkinType, 
        analysisDetail: skinModel.detectionResult,
        navModel: navModel,
      );
      
      messenger.showSnackBar(
        const SnackBar(content: Text('Analysis Complete!')),
      );

    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to take picture. Permissions or initialization error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final skinModel = Provider.of<SkinDetectionModel>(context, listen: false);
    final navModel = Provider.of<NavigationModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Skin Scan')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!_controller.value.isInitialized) {
              return const Center(child: Text("Camera not initialized or permissions denied.", style: TextStyle(fontSize: 16)));
            }
            
            // Stack to overlay the camera feed with the face guide
            return Stack(
              children: <Widget>[
                // 1. Full Camera Preview
                Positioned.fill(
                  child: CameraPreview(_controller),
                ),
                // 2. Face Overlay Guide
                const _FaceOverlay(),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _takePicture(skinModel, navModel),
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Result Pop-up Dialog
  void _showResultDialog(
    BuildContext context, 
    {required String method, 
     required String skinType, 
     required String analysisDetail,
     required NavigationModel navModel}) {
       
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('$method Result', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: Icon(Icons.face_retouching_natural, size: 40, color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: 15),
                const Text('Detected Skin Type:', style: TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  skinType,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                ),
                const Divider(),
                const Text('Summary:', style: TextStyle(fontWeight: FontWeight.w600)),
                Text(analysisDetail, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('View Full Details'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
                navModel.setIndex(0); // Navigate to Home Tab
              },
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }
}

// Custom Widget for the Oval Face Overlay
class _FaceOverlay extends StatelessWidget {
  const _FaceOverlay();

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withAlpha(128), 
        BlendMode.srcOut,
      ),
      child: Stack(
        children: [
          // This container is the black background
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              backgroundBlendMode: BlendMode.dstOut,
            ),
          ),
          // This container defines the 'hole' (the oval shape)
          Center(
            child: Container(
              width: 300, 
              height: 450, 
              decoration: BoxDecoration(
                color: Colors.white, // The color doesn't matter, only its shape
                borderRadius: BorderRadius.circular(225), // Creates the oval shape
                border: Border.all(color: Colors.white, width: 4), // White border for guidance
              ),
            ),
          ),
        ],
      ),
    );
  }
}