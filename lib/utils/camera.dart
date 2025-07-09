import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker picker = ImagePicker();

  /// Picks a single image (camera or gallery) using bottom sheet
  Future<File?> pickImage(BuildContext context) async {
    Completer<File?> completer = Completer<File?>();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () async {
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  Navigator.of(context).pop();
                  completer.complete(pickedFile != null ? File(pickedFile.path) : null);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  final pickedFile = await picker.pickImage(source: ImageSource.camera);
                  Navigator.of(context).pop();
                  completer.complete(pickedFile != null ? File(pickedFile.path) : null);
                },
              ),
            ],
          ),
        );
      },
    );

    return completer.future;
  }

  /// Picks multiple images from gallery
  Future<List<File>> pickMultipleImages() async {
    final pickedFiles = await picker.pickMultiImage(); // No UI needed, system picker opens directly
    return pickedFiles.map((e) => File(e.path)).toList();
  }

  /// Repeatedly picks images from camera until user cancels
  Future<void> captureMultipleImagesAuto(Function(File) onImageCaptured) async {
    while (true) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        onImageCaptured(file); // Call save for each image
      } else {
        break; // User cancelled camera
      }
    }
  }



}
