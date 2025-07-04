import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import '../database/table/qr_po_item_dtl_image_table.dart';
import 'dart:typed_data';

import '../database/table/qr_po_item_dtl_table.dart';
import '../utils/camera.dart';

class AddImageIcon extends StatefulWidget {
  final String title;
  final String id;
  final VoidCallback? onImageAdded;
  final bool isCountShow;

  AddImageIcon({
    super.key,
    required this.title,
    required this.id,
    this.onImageAdded,
    this.isCountShow = false,
  });

  @override
  State<AddImageIcon> createState() => _AddImageIconState();
}

class _AddImageIconState extends State<AddImageIcon> {
  final ImagePickerService _imagePickerService = ImagePickerService();

  bool loading = true;
  bool noData = false;
  String qrHdrID = "";
  String qrPOItemHdrID = "";
  int totalCount = 0;

  @override
  void initState() {
    super.initState();
    syncData();
  }

  Future<void> syncData() async {
    try {
      final qrPoItemDtlTable = QRPOItemDtlTable();
      final items = await qrPoItemDtlTable.getByCustomerItemRefAndEnabled(widget.id);
      if (mounted) {
        setState(() {
          if (items.isNotEmpty) {
            qrHdrID = items.first.qrHdrID ?? "";
            qrPOItemHdrID = items.first.qrpoItemHdrID ?? "";
          }
        });
      }
      await getImageCount();
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
          noData = true;
        });
      }
      print('Error loading data: $e');
    }
  }

  Future<void> getImageCount() async {
    if (qrHdrID.isEmpty || qrPOItemHdrID.isEmpty) return;

    final images = await QrPoItemDtlImageTable().getByHdrIDAndTitle(qrPOItemHdrID, widget.title);
    int count = images.where((img) =>
    img is Map &&
        img['Title'] == widget.title &&
        img['QRPOItemHdrID'] == qrPOItemHdrID).length;

    if (mounted) {
      setState(() {
        totalCount = count;
      });
    }
  }

  Future<List<Map>> getFilteredImages() async {
    final images = await QrPoItemDtlImageTable().getAll();
    return images.where((img) =>
    img is Map &&
        img['Title'] == widget.title &&
        img['QRPOItemHdrID'] == qrPOItemHdrID).cast<Map>().toList();
  }

  Future<void> _showGallery() async {
    final filteredImages = await getFilteredImages();
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryScreen(images: filteredImages),
      ),
    );
  }

  Future<String> _saveImageLocally(File imageFile) async {
    final directory = await Directory.systemTemp.createTemp();
    final imageName = path.basename(imageFile.path);
    final localPath = path.join(directory.path, imageName);
    final newImage = await imageFile.copy(localPath);
    return newImage.path;
  }

  Future<void> _saveImageToDb(File imageFile) async {
    if (qrHdrID.isEmpty || qrPOItemHdrID.isEmpty) {
      print('Missing IDs: qrHdrID or qrPOItemHdrID');
      return;
    }

    final localPath = await _saveImageLocally(imageFile);
    final now = DateTime.now().toIso8601String();

    final map = {
      'QRHdrID': qrHdrID,
      'title': widget.title,
      'LocID': "DEL",
      'imageName': "ImNameDEL",
      'QRPOItemHdrID': qrPOItemHdrID,
      'ImagePathID': localPath,
      'recDt': now,
      'recAddDt': now,
    };

    await QrPoItemDtlImageTable().insert(map);
    await getImageCount();

    // ✅ Trigger the parent callback after successful save
    widget.onImageAdded?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!widget.isCountShow)
          GestureDetector(
            onTap: _showGallery,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "$totalCount",
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        IconButton(
          onPressed: () async {
            final File? image = await _imagePickerService.pickImage(context);
            if (image != null) {
              await _saveImageToDb(image);
            } else {
              debugPrint('No image selected.');
            }
          },
          icon: const Icon(Icons.camera_alt),
        ),
      ],
    );
  }
}



class GalleryScreen extends StatefulWidget {
  final List<Map> images;

  const GalleryScreen({super.key, required this.images});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final validImages = widget.images.where((img) =>
    img['ImagePathID'] != null && (img['ImagePathID'] as String).isNotEmpty).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${_currentPage + 1} of ${validImages.length}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: validImages.isEmpty
          ? const Center(child: Text('No images available'))
          : PageView.builder(
        controller: _pageController,
        itemCount: validImages.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final imagePath = validImages[index]['ImagePathID'] as String;

          return Center(
            child: Image.file(
              File(imagePath),
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
          );
        },
      ),
    );
  }
}


class FullScreenImage extends StatelessWidget {
  final String imagePath;

  const FullScreenImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.file(
            File(imagePath),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
