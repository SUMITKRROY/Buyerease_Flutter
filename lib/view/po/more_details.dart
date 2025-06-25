import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/custom_table.dart';
import '../../database/table/qr_po_item_dtl_table.dart';
import '../../model/po_item_dtl_model.dart';

class MoreDetails extends StatefulWidget {
  final String pRowId;
  final VoidCallback? onChanged;
  const MoreDetails({super.key, required this.pRowId,this.onChanged});

  @override
  State<MoreDetails> createState() => _MoreDetailsState();
}

class _MoreDetailsState extends State<MoreDetails> {
  List<POItemDtl> poItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItemsByQRHdrID();
  }

  Future<void> fetchItemsByQRHdrID() async {
    try {
      setState(() {
        isLoading = true;
      });

      List<Map<String, dynamic>> items = await QRPOItemDtlTable().getByQRHdrID(widget.pRowId);
      poItems = items.map((item) => POItemDtl.fromJson(item)).toList();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTable(
            rowData: [
              'PO',
              'Item',
              'Packaging Measurement',
              'Digitals Uploaded',
              'Test Report',
              'Measurements',
              'Over All Inspection Result',
              'HologramNo',
            ].map((data) => Text(data, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp))).toList(),
            isHeader: true,
          ),
          ...poItems.map((item) => CustomTable(
            rowData: [
              item.poNo ?? '',
              item.itemCode ?? '',
              item.packagingMeasurementhdr ?? '',
              item.digitals?.toString() ?? '0',
              item.testReportStatus == 1 ? 'Pending' : 'Completed',
              item.measurementshdr ?? '',
              item.overallInspectionResult ?? '',
              item.hologramNo ?? '',
            ].map((data) => Text(data.toString(), style: TextStyle(fontSize: 10.sp))).toList(),
          )).toList(),
          SizedBox(width: 390, child: const Divider(thickness: 1, color: Colors.black12)),
          CustomTable(
            rowData: [
              'Total',
              '',
              '',
              poItems.fold(0, (sum, item) => sum + (item.digitals ?? 0)).toString(),
              '',
              '',
              '',
              '',
            ].map((data) => Text(data, style: TextStyle(fontSize: 10.sp))).toList(),
          ),
        ],
      ),
    );
  }
}
