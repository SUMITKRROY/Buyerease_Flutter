import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

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


}

