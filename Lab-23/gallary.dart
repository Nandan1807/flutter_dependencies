import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GalleryImagePickerScreen(),
    );
  }
}

class GalleryImagePickerScreen extends StatefulWidget {
  @override
  _GalleryImagePickerScreenState createState() =>
      _GalleryImagePickerScreenState();
}

class _GalleryImagePickerScreenState extends State<GalleryImagePickerScreen> {
  File? _image;

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Image from Gallery'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display the selected image or a placeholder
            _image != null
                ? Image.file(
                    _image!,
                    height: 250, // Set height for the image
                    width: 250,  // Set width for the image
                    fit: BoxFit.cover, // Set the image fit style
                  )
                : Text('No image selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage, // Call the pick image function
              child: Text('Pick Image from Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
