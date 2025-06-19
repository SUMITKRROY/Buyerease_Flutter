import 'package:flutter/material.dart';
import '../../components/add_image_icon.dart';
import '../../database/table/qr_po_item_dtl_table.dart';
import '../../model/digital_image_model.dart';
import '../../database/table/qr_po_item_dtl_image_table.dart';
import 'dart:io';

class DigitalUploaded extends StatefulWidget {
  final String id;
    DigitalUploaded({
    super.key, required this.id,
  });

  @override
  State<DigitalUploaded> createState() => _DigitalUploadedState();
}

class _DigitalUploadedState extends State<DigitalUploaded> {
  List<DigitalImageModel> images = [];
  final QrPoItemDtlImageTable _imageTable = QrPoItemDtlImageTable();
  bool isLoading = true;


  bool noData = false;
  String qrHdrID = "";
  String qrPOItemHdrID = "";

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await syncData();
    await _loadImages();
  }

  Future<void> syncData() async {
    try {
      final qrPoItemDtlTable = QRPOItemDtlTable();
      final items = await qrPoItemDtlTable.getByCustomerItemRefAndEnabled(widget.id);
      setState(() {
        if(items.isNotEmpty){
          qrHdrID = items.first.qrHdrID ?? "";
          qrPOItemHdrID = items.first.qrpoItemHdrID ?? "";
        }
      });

    } catch (e) {
      setState(() {
        isLoading = false;
        noData = true;
      });
      print('Error loading data: $e');
    }
  }

  Future<void> _loadImages() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Fetch all images from the database
      final List<Map<String, dynamic>> imageData = await _imageTable.getByQrPOItemHdrID(qrPOItemHdrID);

      setState(() {
        images = imageData.map((image) {
          return DigitalImageModel(
            pRowID: image[QrPoItemDtlImageTable.pRowID] ?? '',
            title: image[QrPoItemDtlImageTable.title] ?? '',
            imagePath: image[QrPoItemDtlImageTable.imagePathID] ?? '',
            description: image[QrPoItemDtlImageTable.imageName] ?? '',
          );
        }).where((image) => image.imagePath.isNotEmpty).toList();
      });
    } catch (e) {
      print('Error loading images: $e');
      setState(() {
        images = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteImage(String pRowID) async {
    try {
      await _imageTable.delete(pRowID);
      await _loadImages(); // Reload the images after deletion
    } catch (e) {
      print('Error deleting image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete image')),
      );
    }
  }

  Widget _buildImageWidget(String imagePath, {double width = 30, double height = 30}) {
    if (imagePath.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image, size: 20),
      );
    }

    return Image.file(
      File(imagePath),
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print('Error loading image: $error');
        return Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 20),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.black),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Add Images',
                  style: TextStyle(fontSize: 15),
                ),
                AddImageIcon(title: "none", id: widget.id, isCountShow: true,)
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.black),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 30,child: Text('Title', style: TextStyle(fontSize: 12))),
                SizedBox(width: 70,child: Text('Description', style: TextStyle(fontSize: 12))),
                SizedBox(width: 75,child: Text('Attachments', style: TextStyle(fontSize: 12))),
                SizedBox(width: 40,child: Text('Delete', style: TextStyle(fontSize: 12)))
              ],
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : images.isEmpty
                    ? const Center(child: Text('No images found'))
                    : ListView.builder(
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          final image = images[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  image.title,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  image.description ?? '',
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () => _showFullScreenImage(context, image),
                                  child: _buildImageWidget(image.imagePath),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                  icon: const Icon(Icons.delete, size: 20),
                                  onPressed: () => _deleteImage(image.pRowID),
                                ),
                              ),
                            ],
                          );
                        }),
          )
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, DigitalImageModel image) {
    if (image.imagePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image not available')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(image.title),
            backgroundColor: Colors.black,
          ),
          body: Container(
            color: Colors.black,
            child: Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: _buildImageWidget(
                  image.imagePath,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
