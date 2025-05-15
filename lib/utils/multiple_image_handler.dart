import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import 'package:buyerease/utils/fsl_log.dart';

// Placeholder for FEnumerations
class FEnumerations {
    static const int photoPermission = 1;
    static const int permissionRequest = 100;
    static const int resultLoadImage = 222;
    static const int imageCapture = 1111;
    static const int pickfileResultCode = 333;
    static const int resultCamera = 1;
    static const int resultGallery = 2;
    static const int resultCameraDenied = 3;
    static const int resultReadStorageDenied = 4;
}

// Placeholder for FClientConstants
class FClientConstants {
    static const String textSelectPhoto = 'Select Photo';
}

// Placeholder for UserSession
class UserSession {
    final BuildContext context;
    UserSession(this.context);
    String getDeLNO() => 'DEL123'; // Placeholder
    String getInspectionDt() => '2023-01-01'; // Placeholder
}

// Placeholder for GenUtils
class GenUtils {
    static void safeToastShow(String tag, BuildContext context, SnackBar snackBar) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    static void grantAllUriPermissions(
        BuildContext context, dynamic intent, Uri uri) {
        // Not needed in Flutter; handled by image_picker/file_picker
    }

    static void forInfoAlertDialog(
        BuildContext context,
        String positiveButton,
        String title,
        String message,
        VoidCallback? onPositive,
        ) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: [
                    TextButton(
                        onPressed: () {
                            Navigator.of(context).pop();
                            onPositive?.call();
                        },
                        child: Text(positiveButton),
                    ),
                ],
            ),
        );
    }
}

// Callback for bitmap result
typedef GetBitmap = void Function(
    Uint8List? imageBytes,
    List<String> imagePathArrayList,
    String? valueReturned,
    bool isGallery,
    );

class MultipleImageHandler {
    static const String tag = 'MultipleImageHandler';
    static const int carPhoto = 1;
    static const int profilePhoto = 2;
    static const int document = 3;

    static String? _valueToBeReturnedToSource;
    static const String sharedProviderAuthority = 'com.buyereasefsl.myfileprovider';
    static int photoSource = 0;
    static Uri? _imageUri;
    static BuildContext? _currentContext;
    static List<String> imagesArrayList = [];
    static int pickerViewer = -1;

    // Show dialog for camera permission
    static void showDialog(
        BuildContext context,
        int photoSource, {
            String? valueToBeReturned,
            int? selected,
        }) async {
        _valueToBeReturnedToSource = valueToBeReturned;
        _currentContext = context;
        MultipleImageHandler.photoSource = photoSource;

        if (selected == FEnumerations.resultGallery) {
            await _pickImageFromGallery(context);
        } else if (selected == FEnumerations.resultCamera) {
            await _pickImageFromCamera(context);
        } else {
            await _showDialog(context, photoSource);
        }
    }

    // Show dialog for file or image selection
    static void showDialogForFileOrImages(BuildContext context, int photoSource) {
        _checkPermissionShowDialog(context, photoSource);
    }

    // Check permissions and show dialog
    static Future<void> _showDialog(BuildContext context, int photoSource) async {
        _currentContext = context;
        MultipleImageHandler.photoSource = photoSource;

        final cameraStatus = await Permission.camera.status;
        final storageStatus = await Permission.storage.status;

        if (cameraStatus.isGranted && storageStatus.isGranted) {
            FslLog.d(tag, 'Camera and storage permissions granted');
            //_showCompleteDialogNow(context);
        } else {
            FslLog.d(tag, 'Requesting camera or storage permission');
            final result = await [
                Permission.camera,
                Permission.storage,
            ].request();

            if (result[Permission.camera]!.isGranted &&
                result[Permission.storage]!.isGranted) {
              //  _showCompleteDialogNow(context);
            } else if (result[Permission.camera]!.isDenied) {
             //   _showGalleryDialogNow(context);
            } else if (result[Permission.storage]!.isDenied) {
             //   _showCameraDialogNow(context);
            } else {
                FslLog.e(tag, 'Required permission denied');
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Required permissions denied')),
                );
            }
        }
    }

    // Check permissions and show file/image dialog
    static Future<void> _checkPermissionShowDialog(
        BuildContext context, int photoSource) async {
        _currentContext = context;
        MultipleImageHandler.photoSource = photoSource;

        final cameraStatus = await Permission.camera.status;
        final storageStatus = await Permission.storage.status;

        if (cameraStatus.isGranted && storageStatus.isGranted) {
            FslLog.d(tag, 'Camera and storage permissions granted');
         //   _showCompleteForFileDialogNow(context);
        } else {
            FslLog.d(tag, 'Requesting camera or storage permission');
            final result = await [
                Permission.camera,
                Permission.storage,
            ].request();

            if (result[Permission.camera]!.isGranted &&
                result[Permission.storage]!.isGranted) {
               // _showCompleteForFileDialogNow(context);
            } else {
                FslLog.e(tag, 'Required permission denied');
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Required permissions denied')),
                );
            }
        }
    }

    // static void _showCompleteDialogNow(BuildContext context) {
    //     showDialog(
    //         context: context,
    //         barrierDismissible: false,
    //         builder: (context) => AlertDialog(
    //             title: const Text('Select Photo'),
    //             content: SingleChildScrollView(
    //                 child: Column(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: [
    //                         ElevatedButton(
    //                             onPressed: () async {
    //                                 await _pickImageFromCamera(context);
    //                                 pickerViewer = FEnumerations.resultCamera;
    //                                 Navigator.of(context).pop();
    //                             },
    //                             child: const Text('Camera'),
    //                         ),
    //                         ElevatedButton(
    //                             onPressed: () async {
    //                                 await _pickImageFromGallery(context);
    //                                 pickerViewer = FEnumerations.resultGallery;
    //                                 Navigator.of(context).pop();
    //                             },
    //                             child: const Text('Gallery'),
    //                         ),
    //                         ElevatedButton(
    //                             onPressed: () => Navigator.of(context).pop(),
    //                             child: const Text('Cancel'),
    //                         ),
    //                     ],
    //                 ),
    //             ),
    //         ),
    //     );
    // }

    // // Show dialog for file/image selection
    // static void _showCompleteForFileDialogNow(BuildContext context) {
    //     showDialog(
    //         context: context,
    //         barrierDismissible: false,
    //         builder: (context) => AlertDialog(
    //             title: const Text(FClientConstants.textSelectPhoto),
    //             content: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                     ElevatedButton(
    //                         onPressed: () {
    //                             _pickFile(context);
    //                             Navigator.of(context).pop();
    //                         },
    //                         child: const Text('File'),
    //                     ),
    //                     ElevatedButton(
    //                         onPressed: () {
    //                             _pickImageFromGallery(context);
    //                             Navigator.of(context).pop();
    //                         },
    //                         child: const Text('Image'),
    //                     ),
    //                     ElevatedButton(
    //                         onPressed: () => Navigator.of(context).pop(),
    //                         child: const Text('Cancel'),
    //                     ),
    //                 ],
    //             ),
    //         ),
    //     );
    // }
    //
    // // Show gallery-only dialog
    // static void _showGalleryDialogNow(BuildContext context) {
    //     showDialog(
    //         context: context,
    //         barrierDismissible: false,
    //         builder: (context) => AlertDialog(
    //             title: const Text(FClientConstants.textSelectPhoto),
    //             content: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                     ElevatedButton(
    //                         onPressed: () {
    //                             _pickImageFromGallery(context);
    //                             Navigator.of(context).pop();
    //                         },
    //                         child: const Text('Gallery'),
    //                     ),
    //                     ElevatedButton(
    //                         onPressed: () => Navigator.of(context).pop(),
    //                         child: const Text('Cancel'),
    //                     ),
    //                 ],
    //             ),
    //         ),
    //     );
    // }
    //
    // // Show camera-only dialog
    // static void _showCameraDialogNow(BuildContext context) {
    //     showDialog(
    //         context: context,
    //         barrierDismissible: false,
    //         builder: (context) => AlertDialog(
    //             title: const Text(FClientConstants.textSelectPhoto),
    //             content: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                     ElevatedButton(
    //                         onPressed: () {
    //                             _pickImageFromCamera(context);
    //                             Navigator.of(context).pop();
    //                         },
    //                         child: const Text('Camera'),
    //                     ),
    //                     ElevatedButton(
    //                         onPressed: () => Navigator.of(context).pop(),
    //                         child: const Text('Cancel'),
    //                     ),
    //                 ],
    //             ),
    //         ),
    //     );
    // }

    // Pick image from camera
    static Future<void> _pickImageFromCamera(BuildContext context) async {
        try {
            final picker = ImagePicker();
            final pickedFile = await picker.pickImage(source: ImageSource.camera);
            if (pickedFile != null) {
                _imageUri = Uri.parse(pickedFile.path);
                imagesArrayList = [pickedFile.path];
            } else {
                FslLog.d(tag, 'No image captured');
            }
        } catch (e, stackTrace) {
            FslLog.e(tag, 'Error picking image from camera: $e', stackTrace);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Couldn’t initiate camera. Try picking from gallery.')),
            );
        }
    }

    // Pick file (e.g., PDF)
    static Future<void> _pickFile(BuildContext context) async {
        try {
            final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'],
            );
            if (result != null && result.files.isNotEmpty) {
                imagesArrayList = result.files.map((file) => file.path!).toList();
            } else {
                FslLog.d(tag, 'No file selected');
            }
        } catch (e, stackTrace) {
            FslLog.e(tag, 'Error picking file: $e', stackTrace);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please install a file manager.')),
            );
        }
    }

    // Pick image from gallery
    static Future<void> _pickImageFromGallery(BuildContext context) async {
        try {
            final picker = ImagePicker();
            final pickedFiles = await picker.pickMultiImage();
            if (pickedFiles.isNotEmpty) {
                imagesArrayList = pickedFiles.map((file) => file.path).toList();
            } else {
                FslLog.d(tag, 'No images selected');
            }
        } catch (e, stackTrace) {
            FslLog.e(tag, 'Error picking images from gallery: $e', stackTrace);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Couldn’t find photo viewer app')),
            );
        }
    }

    // Handle activity result (called from widget)
    static void onActivityResult(
        BuildContext context,
        int requestCode,
        int resultCode,
        dynamic data,
        GetBitmap getBitmap,
        ) async {
        FslLog.d(tag, 'onActivityResult requestCode: $requestCode, resultCode: $resultCode');
        try {
            if (requestCode == FEnumerations.resultLoadImage && resultCode == -1) {
                if (imagesArrayList.isNotEmpty) {
                    for (final path in imagesArrayList) {
                        await _startFeatherFromCamera(context, Uri.parse(path), getBitmap, true);
                    }
                }
                return;
            }

            if (requestCode == FEnumerations.imageCapture && resultCode == -1) {
                if (_imageUri != null) {
                    await _startFeatherFromCamera(context, _imageUri!, getBitmap, false);
                }
            }

            if (requestCode == FEnumerations.permissionRequest) {
                if (_currentContext != null) {
                    if (resultCode == -1) {
                        //_showCompleteDialogNow(context);
                    } else if (resultCode == FEnumerations.resultCameraDenied) {
                     //  _showGalleryDialogNow(context);
                    } else if (resultCode == FEnumerations.resultReadStorageDenied) {
                       // _showCameraDialogNow(context);
                    } else {
                        FslLog.e(tag, 'Required permission denied');
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Couldn’t select photo as required permission denied')),
                        );
                    }
                } else {
                    FslLog.e(tag, 'currentContext is null');
                }
            }
        } catch (e, stackTrace) {
            FslLog.e(tag, 'Error in onActivityResult: $e', stackTrace);
            GenUtils.forInfoAlertDialog(
                context,
                'OK',
                'Out of Memory',
                'Insufficient memory to load image. Close some apps and try again.',
                null,
            );
        }
    }

    // Process image and invoke callback
    static Future<void> _startFeatherFromCamera(
        BuildContext context,
        Uri selectedImage,
        GetBitmap getBitmap,
        bool isGallery,
        ) async {
        try {
            final file = File(selectedImage.path);
            final bytes = await file.readAsBytes();
            final image = img.decodeImage(bytes);
            if (image == null) {
                FslLog.e(tag, 'Failed to decode image');
                return;
            }

            // Rotate image if needed
            final rotatedImage = await _rotateImageIfRequired(context, image, selectedImage);

            // Save rotated image
            final filename = await _getFileName(context, selectedImage);
            final imagePath = await _getImageUri(context, rotatedImage, filename);

            if (imagesArrayList.isEmpty) {
                imagesArrayList = [imagePath];
            } else {
                imagesArrayList = [imagePath];
            }

            final rotatedBytes = img.encodeJpg(rotatedImage);
            getBitmap(Uint8List.fromList(rotatedBytes), imagesArrayList, _valueToBeReturnedToSource, isGallery);
        } catch (e, stackTrace) {
            FslLog.e(tag, 'Error processing image: $e', stackTrace);
        }
    }

    // Get image URI and save to storage
    static Future<String> _getImageUri(
        BuildContext context, img.Image image, String fileName) async {
        final userSession = UserSession(context);
        final folderName = '${userSession.getDeLNO()}_${userSession.getInspectionDt()}';
        final directory = await getExternalStorageDirectory();
        final folderPath = Directory('${directory!.path}/$folderName');

        if (!await folderPath.exists()) {
            await folderPath.create(recursive: true);
            FslLog.d(tag, '$folderName new folder created');
        } else {
            FslLog.d(tag, '$folderName folder already exists');
        }

        final file = File('${folderPath.path}/$fileName');
        if (await file.exists()) {
            await file.delete();
            FslLog.d(tag, 'Image already exists, deleted');
        }

        await file.writeAsBytes(img.encodeJpg(image));
        FslLog.d(tag, 'Image saved: ${file.path}');
        return file.path;
    }

    // Get file name from URI
    static Future<String> _getFileName(BuildContext context, Uri uri) async {
        try {
            final file = File(uri.path);
            return file.path.split('/').last;
        } catch (e, stackTrace) {
            FslLog.e(tag, 'Error getting file name: $e', stackTrace);
            return 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
        }
    }

    // Rotate image based on EXIF orientation
    static Future<img.Image> _rotateImageIfRequired(
        BuildContext context, img.Image image, Uri selectedImage) async {
        try {
            final file = File(selectedImage.path);
            final bytes = await file.readAsBytes();
       //     final exif = img.ExifData.fromImage(img.decodeImage(bytes)!);
         //   final orientation = exif.orientation;

            // switch (orientation) {
            //     case 3:
            //         return img.copyRotate(image, angle: 180);
            //     case 6:
            //         return img.copyRotate(image, angle: 90);
            //     case 8:
            //         return img.copyRotate(image, angle: 270);
            //     default:
            //         return image;
            // }
            return image;
        } catch (e, stackTrace) {
            FslLog.e(tag, 'Error rotating image: $e', stackTrace);
            return image;
        }
    }
}