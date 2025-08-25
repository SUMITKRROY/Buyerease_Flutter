import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:buyerease/model/po_item_dtl_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/api_route.dart';
import '../../model/enclosure_modal.dart';
import '../../model/inspection_model.dart';
import '../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../components/ResponsiveCustomTable.dart';

class EnclosureTable extends StatefulWidget {
  final POItemDtl poItemDtl;
  final VoidCallback onChanged;
  final InspectionModal inspectionModal;

  const EnclosureTable({
    super.key,
    required this.poItemDtl,
    required this.onChanged,
    required this.inspectionModal,
  });

  @override
  State<EnclosureTable> createState() => _EnclosureTableState();
}

class _EnclosureTableState extends State<EnclosureTable> {
  List<EnclosureModal> data = [];
  bool isLoading = true;
  String? errorMessage;
  final ItemInspectionDetailHandler _handler = ItemInspectionDetailHandler();

  @override
  void initState() {
    super.initState();
    _loadEnclosureData();
  }

  Future<void> _loadEnclosureData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final qrHdrId = widget.poItemDtl.qrHdrID ?? '';
      developer.log("QR Header ID nqrHrid : $qrHdrId ");
      if (qrHdrId.isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage = 'QR Header ID not found';
        });
        return;
      }

      final enclosures = await _handler.getSyncEnclosureList(qrHdrId);
      setState(() {
        data = enclosures;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading enclosure data: $e';
      });
    }
  }

  List<String> get _headers => [
    'Enclosure Type',
    'Customer Ref No',
    'Tn A',
    'File Type',
    'Title',
  ];

  List<List<dynamic>> get _rows {
    return data.map((item) => [
      item.enclType ?? '',
      _buildFileIcon(item), // pass whole object
      item.contextDs2 ?? '',
      item.enclFileType ?? '',
      item.title ?? '',
    ]).toList();
  }

  Widget _buildFileIcon(EnclosureModal enclosure) {
    final ext = enclosure.fileExt;
    if (ext == null) {
      return const Icon(Icons.insert_drive_file, color: Colors.grey);
    }

    IconData iconData;
    Color color;

    if (ext.contains("xls")) {
      iconData = Icons.grid_on;
      color = Colors.green;
    } else if (ext.contains("doc")) {
      iconData = Icons.description;
      color = Colors.blue;
    } else if (ext.contains("pdf")) {
      iconData = Icons.picture_as_pdf;
      color = Colors.red;
    } else {
      iconData = Icons.attach_file;
      color = Colors.black87;
    }

    return InkWell(
      onTap: () {
        final downloadUrl =
            "${ApiRoute.downloadBase}Enclousers/${enclosure.imageName}&PathToken=${enclosure.imagePathId}";
        developer.log("Downloading from: $downloadUrl");
        _downloadFile(downloadUrl);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, color: color, size: 20.sp),
          if (enclosure.contextDs != null && enclosure.contextDs!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Text(
                enclosure.contextDs!,
                style: TextStyle(fontSize: 12.sp, color: Colors.black87),
              ),
            ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadEnclosureData,
              child: const Text("Retry"),
            )
          ],
        ),
      );
    }

    if (data.isEmpty) {
      return const Center(
        child: Text("No enclosure data found", style: TextStyle(color: Colors.grey)),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      //    _buildHeader(),
          const SizedBox(height: 8),
          Expanded(
            child: ResponsiveCustomTable(
              headers: _headers,
              rows: _rows,
              showTotalRow: false,
              totalRowData: ['Total', '', '', '', '${data.length}'],
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _downloadFile(String url) async {
    try {
      String encodedUrl = Uri.encodeFull(url);
      await launch(encodedUrl);
    } catch (e) {
      print('Error launching URL: $e');
      // Handle the error, for example, show a snackbar or log the error
    }
  }

  // Widget _buildHeader() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  //     color: Colors.blue[50],
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text('Enclosure List',
  //             style: TextStyle(
  //                 fontSize: 18.sp,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.blue[800])),
  //         Row(
  //           children: [
  //             Icon(Icons.attachment, color: Colors.blue[400]),
  //             const SizedBox(width: 6),
  //             Text('Documents', style: TextStyle(fontSize: 14.sp, color: Colors.blue)),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }
}
