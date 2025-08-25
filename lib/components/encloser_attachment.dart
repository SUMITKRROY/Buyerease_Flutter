
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:buyerease/model/enclosure_modal.dart';
import 'package:buyerease/model/inspection_model.dart';
import 'package:buyerease/model/po_item_dtl_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import '../database/table/qr_po_item_dtl_image_table.dart';
import '../database/table/qr_po_item_dtl_table.dart';
import '../model/digitals_upload_model.dart';
import '../model/po_item_pkg_app_detail_model.dart';
import '../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../utils/app_constants.dart';
import '../utils/camera.dart';

class EnclosureAttachment extends StatefulWidget {
  final InspectionModal inspectionModal;
  final EnclosureModal encloser;
  final String title;

  final String pRowId;
  final POItemDtl poItemDtl;

  final VoidCallback? onImageAdded;
  final bool isCountShow;

  EnclosureAttachment({
    super.key,
    required this.title,

    this.onImageAdded,
    this.isCountShow = false, required this.pRowId, required this.poItemDtl, required this.inspectionModal, required this.encloser,
  });

  @override
  State<EnclosureAttachment> createState() => _EnclosureAttachmentState();
}

class _EnclosureAttachmentState extends State<EnclosureAttachment> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  late POItemDtl poItemDtl;
  POItemPkgAppDetail pOItemPkgAppDetail =  POItemPkgAppDetail();
  bool loading = true;
  bool noData = false;
  String qrHdrID = "";
  String qrPOItemHdrID = "";
  int totalCount = 0;

  @override
  void initState() {
    super.initState();
    poItemDtl = widget.poItemDtl;
    syncData();
  }

  Future<void> syncData() async {
    try {
      final qrPoItemDtlTable = QRPOItemDtlTable();
      final items = await qrPoItemDtlTable.getByCustomerItemRefAndEnabled(widget.poItemDtl.itemID ?? '',   widget.pRowId,);
      developer.log("developer ${jsonEncode(poItemDtl)}");
      if (mounted) {
        setState(() {
          qrHdrID = poItemDtl.qrHdrID ?? "";
          qrPOItemHdrID = poItemDtl.qrpoItemHdrID ?? "";
        });
      }
     // await getImageCount();
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

  // Future<void> getImageCount() async {
  //   if (qrHdrID.isEmpty || qrPOItemHdrID.isEmpty) return;
  //
  //   final images = await QrPoItemDtlImageTable().getByHdrIDAndTitle(qrPOItemHdrID, widget.title);
  //   int count = images.where((img) =>
  //   img is Map &&
  //       img['Title'] == widget.title &&
  //       img['QRPOItemHdrID'] == qrPOItemHdrID).length;
  //
  //   if (mounted) {
  //     setState(() {
  //       totalCount = count;
  //     });
  //   }
  // }

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

    // final map = {
    //   'QRHdrID': qrHdrID,
    //   'title': widget.title,
    //   'LocID': "DEL",
    //   'imageName': "ImNameDEL",
    //   'QRPOItemHdrID': qrPOItemHdrID,
    //   'ImagePathID': localPath,
    //   'recDt': now,
    //   'recAddDt': now,
    // };
    //
    // await QrPoItemDtlImageTable().insert(map);
    await addASDigitalPkgAppear(
      imagePathList: [localPath], // pass list
      title: widget.title,
    );
    //await getImageCount();

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

        /// 🔄 New PopupMenu instead of IconButton
        IconButton(
          icon: const Icon(Icons.camera_alt),
          onPressed: () => _showImageSourceSheet(context),
        ),
      ],
    );
  }
  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take Photo(s)'),
                onTap: () async {
                  Navigator.pop(context); // Close sheet
                  await _imagePickerService.captureMultipleImagesAuto((File img) async {
                    await _saveImageToDb(img); // 👈 Auto-save each image
                  });

                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Select from Gallery'),
                onTap: () async {
                  Navigator.pop(context); // Close sheet
                  final images = await _imagePickerService.pickMultipleImages();
                  for (var img in images) {
                    await _saveImageToDb(img);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> addASDigitalPkgAppear({
    required List<String> imagePathList,
    required String title,
  }) async {
    if (imagePathList.isNotEmpty) {
      for (String imagePath in imagePathList) {
        DigitalsUploadModel modal = DigitalsUploadModel(
          selectedPicPath: imagePath,
          title: title,
          imageExtn: FEnumerations.imageExtn,
          pRowID: await ItemInspectionDetailHandler().generatePK(

            FEnumerations.tableNameQrpoItemDtlImage,
          ),
        );
        String? pRowId = await updateDBWithImage(modal);
        if(pRowId != null){
          print("pRowId is $pRowId");
        //  getImageCount();
        }
        // String imgPRowID = updateDBWithImage(modal);

        // // Add image path to the appropriate list based on title
        // switch (title) {
        //   case 'Unit pack appearance':
        //     pOItemPkgAppDetail.unitPkgAppAttachmentList.add(modal.selectedPicPath!);
        //     break;
        //   case 'Shipping pack appearance':
        //     pOItemPkgAppDetail.shippingPkgAppAttachmentList.add(modal.selectedPicPath!);
        //     break;
        //   case 'Inner pack appearance':
        //     pOItemPkgAppDetail.innerPkgAppAttachmentList.add(modal.selectedPicPath!);
        //     break;
        //   case 'Master pack appearance':
        //     pOItemPkgAppDetail.masterPkgAppAttachmentList.add(modal.selectedPicPath!);
        //     break;
        //   case 'Pallet pack appearance':
        //     pOItemPkgAppDetail.palletPkgAppAttachmentList.add(modal.selectedPicPath!);
        //     break;
        // }
      }

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attachment added successfully')),
      );

      // Update the UI

    }
  }

  Future<String?> updateDBWithImage(DigitalsUploadModel digitalsUploadModal) {

    return ItemInspectionDetailHandler().updateImage(
      qrHdrID:  poItemDtl.qrHdrID ?? "", qrPOItemHdrID: poItemDtl.qrpoItemHdrID ?? "", digitalsUploadModal: digitalsUploadModal,
    );

  }
  void updateEnclosure(EnclosureModal enclosureModal) {
    if (widget.inspectionModal != null) {
      ItemInspectionDetailHandler().updateEnclosure(

        widget.inspectionModal,
        enclosureModal,
      );
    }
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


