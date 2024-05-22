import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'dart:io';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  ImagePickerScreenState createState() => ImagePickerScreenState();
}

class ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    StreamingSharedPreferences prefs =
        await StreamingSharedPreferences.instance;
    Preference<String> imagePath =
        prefs.getString('avatarPath', defaultValue: '');
    setState(() {
      _image = File(imagePath.getValue());
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      StreamingSharedPreferences prefs =
          await StreamingSharedPreferences.instance;
      await prefs.setString('avatarPath', pickedFile.path);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
        content: IntrinsicHeight(
            child: Column(children: [
      _image == null
          ? const Text('No image selected.')
          : CircleAvatar(
              backgroundImage: FileImage(_image!),
              minRadius: 90,
            ),
      ElevatedButton(
          onPressed: () async {
            _pickImage();
          },
          child: const Text("Pick an Image!")),
    ])));
  }
}
