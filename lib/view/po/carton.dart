import 'package:buyerease/components/custom_table.dart';
import 'package:buyerease/database/database_helper.dart';
import 'package:buyerease/database/table/qr_po_item_dtl_table.dart';
import 'package:buyerease/model/po_item_dtl_model.dart';
import 'package:buyerease/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Carton extends StatefulWidget {
  final String pRowId;
  const Carton({super.key, required this.pRowId});

  @override
  State<Carton> createState() => _CartonState();
}

class _CartonState extends State<Carton> {
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTable(
              rowData: ['PO', 'Item', 'Packed', 'Available', 'To \nInspected']
                  .map((data) => Text(data,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),))
                  .toList(),
              isHeader: true,
            ),
            ...poItems.map((item) => CustomTable(
              rowData: [
                item.poNo ?? '',
                item.itemCode ?? '',
                item.cartonsPacked?.toString() ?? '0',
                item.cartonAvailable ?? '0',
                item.cartonToInspectedhdr ?? '0'
              ].map((data) => Text(data.toString(), style: TextStyle(fontSize: 10.sp))).toList(),
            )).toList(),
            const SizedBox(
              width: 390,
              child: Divider(thickness: 1, color: Colors.black12),
            ),
            CustomTable(
              rowData: [
                'Total',
                '',
                poItems.fold(0, (sum, item) => sum + (item.cartonsPacked ?? 0)).toString(),
                poItems.fold(0, (sum, item) => sum + (int.tryParse(item.cartonAvailable ?? '0') ?? 0)).toString(),
                poItems.fold(0, (sum, item) => sum + (int.tryParse(item.cartonToInspectedhdr ?? '0') ?? 0)).toString(),
              ].map((data) => Text(data, style: TextStyle(fontSize: 10.sp))).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

