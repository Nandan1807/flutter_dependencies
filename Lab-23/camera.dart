///please read text file in this folder before copying the code.


import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late List<CameraDescription> cameras;
  late CameraDescription camera;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Initialize the camera
  Future<void> _initializeCamera() async {
    // Get available cameras
    cameras = await availableCameras();
    camera = cameras.first; // Use the first camera (usually rear camera)

    _controller = CameraController(camera, ResolutionPreset.high);
    await _controller.initialize();
    setState(() {
      isCameraInitialized = true;
    });
  }

  // Request camera permission
  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  // Capture and store image
  Future<void> _captureImage() async {
    final hasPermission = await _requestCameraPermission();
    if (!hasPermission) {
      // If permission is not granted, show a dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Permission Denied'),
          content: Text('Camera permission is required to capture an image.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
      return;
    }

    try {
      final image = await _controller.takePicture();

      // Get the external directory to store the image
      final directory = await getExternalStorageDirectory();
      final path = '${directory!.path}/captured_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Save image to the file system
      final File file = File(path);
      await file.writeAsBytes(await image.readAsBytes());

      // Show a confirmation message
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Image Captured'),
          content: Text('The image has been saved at $path'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } catch (e) {
      // Handle error during capture
      print('Error capturing image: $e');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('There was an error capturing the image. Please try again.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Capture Image')),
      body: Center(
        child: isCameraInitialized
            ? CameraPreview(_controller)
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _captureImage,
        child: Icon(Icons.camera),
      ),
    );
  }
}