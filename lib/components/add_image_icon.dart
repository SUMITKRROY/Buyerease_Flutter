import 'dart:io';

import 'package:flutter/material.dart';

import '../utils/camera.dart';

class AddImageIcon extends StatefulWidget {
  const AddImageIcon({super.key});

  @override
  State<AddImageIcon> createState() => _AddImageIconState();
}

class _AddImageIconState extends State<AddImageIcon> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  String imageName = '';
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          final File? image = await _imagePickerService.pickImage(context);
          if (image != null) {
            imageName = image.path.split('/').last.toString();
            setState(() {});
          } else {
            debugPrint('No image selected.');
          }
        },
        icon: const Icon(Icons.camera_alt));
  }
}
