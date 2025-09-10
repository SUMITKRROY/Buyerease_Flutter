import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as dio;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/api_route.dart';
import '../../model/inspection_model.dart';
import '../../model/po_item_dtl_model.dart';
import '../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../components/ResponsiveCustomTable.dart';

class History extends StatefulWidget {
  final String id;
  final POItemDtl poItemDtl;
  final String pRowId;
  final VoidCallback onChanged;
  const History({super.key, required this.id, required this.poItemDtl, required this.onChanged, required this.pRowId});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<InspectionModal> _inspectionLevels = [];
  String dateFormat = "";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchHistoryList();
  }

  Future<void> fetchHistoryList() async {
    _inspectionLevels = await ItemInspectionDetailHandler().getHistoryList(
      widget.poItemDtl.qrHdrID ?? '',
      widget.poItemDtl.qrpoItemHdrID ?? '',
    );
developer.log("this is the data ${jsonEncode(_inspectionLevels)}");
    setState(() {
      loading = false;
    });
  }

  List<String> get _headers => [
    'Inspection No.',
    'Inspection Date',
    'Activity',
    'QR',
    'Inspector',
  ];

  List<List<dynamic>> get _rows {
    return _inspectionLevels.map((item) {
      String inspectionDate = item.inspectionDt ?? "";
      String dateFormat = formatDate(inspectionDate);
      return [
        item.qrHdrID ?? '',
        dateFormat,
        item.activity ?? '',
        item.qr ?? '',
        item.inspector ?? '',
      ];
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : _inspectionLevels.isEmpty
                  ? const Center(child: Text('No Data Found'))
                  : ResponsiveCustomTable(
                headers: _headers,
                rows: _rows,
                onRowTap: (index) {
                  final selectedItem = _inspectionLevels[index];

                  _redirectWebView(context, selectedItem);
                },
                showTotalRow: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
  String formatDate(String dateString) {
    if (dateString.isEmpty) return '';

    DateTime parsedDate = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);
    return formattedDate;
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

}



Future<void> _redirectWebView(BuildContext context, InspectionModal inspectionModal) async {
  // Show loading dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const Center(child: CircularProgressIndicator()),
  );

  try {
    final dio = Dio();

    // Prepare request
    final Map<String, dynamic> params = {
      "InspectionpRowID": inspectionModal.qrHdrID ?? '',
    };

    final response = await dio.post(
      ApiRoute.encryptHistory,
      data: params,
      options: Options(
        headers: {"Content-Type": "application/json"},
      ),
    );

    Navigator.of(context).pop(); // hide loading

    if (response.statusCode == 200) {
      final data = response.data;
      final String? token = data["EncryptValue"];

      if (token != null && token.isNotEmpty) {
        final String rdUrl = "${ApiRoute.historyDetails}$token";
        debugPrint("Redirecting to: $rdUrl");

        final Uri uri = Uri.parse(rdUrl);

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not open link")),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response.statusCode}")),
      );
    }
  } catch (e) {
    Navigator.of(context).pop(); // hide loading if error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error loading: $e")),
    );
  }
}

