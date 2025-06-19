import 'dart:developer' as developer;

import 'package:buyerease/database/database_helper.dart';
import 'package:buyerease/database/table/qr_po_item_dtl_table.dart';
import 'package:buyerease/model/po_item_dtl_model.dart';
import 'package:buyerease/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/custom_table.dart';
import '../over_all_result/over_all_result.dart';

class PoItem extends StatefulWidget {
  final String pRowId;
  const PoItem({super.key, required this.pRowId});

  @override
  State<PoItem> createState() => _PoItemState();
}

class _PoItemState extends State<PoItem> {
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

      developer.log('Items fetched: ${widget.pRowId}');

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      developer.log('Error fetching QRPOItemDtl by QRHdrID: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  int getTotalOrderQty() {
    return poItems.fold(0, (sum, item) {
      if (item.orderQty == null) return sum;
      try {
        double orderQtyDouble = double.parse(item.orderQty!);
        return sum + orderQtyDouble.toInt();
      } catch (e) {
        developer.log('Error parsing orderQty: ${item.orderQty}');
        return sum;
      }
    });
  }

  int getTotalAvailableQty() {
    return poItems.fold(0, (sum, item) => sum + (item.availableQty ?? 0));
  }

  int getTotalAcceptedQty() {
    return poItems.fold(0, (sum, item) => sum + (item.acceptedQty ?? 0));
  }

  int getTotalShortQty() {
    return poItems.fold(0, (sum, item) => sum + (item.short ?? 0));
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
              rowData: [
                'Po',
                'Item',
                'order',
                'inspested\ntill date',
                'available',
                'Accept',
                'Short',
                'inspect later'
              ].map((data) => Text(data, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp))).toList(),
              isHeader: true,
            ),
            ...poItems.map((item) => CustomTable(
              rowData: [
                item.poNo ?? '',
                item.customerItemRef,
                item.orderQty ?? '0',
                item.inspectedQty?.toString() ?? '0',
                item.availableQty?.toString() ?? '0',
                item.acceptedQty?.toString() ?? '0',
                item.short?.toString() ?? '0',
                item.furtherInspectionReqd == 1 ? 'Yes' : ''
              ].map((data) => Text(data.toString(), style: TextStyle(fontSize: 10.sp))).toList(),
              description: '${item.itemDescr} - ${item.customerItemRef ?? ''}',customerItemRef:  item.customerItemRef,
            )).toList(),
            SizedBox(width: 390, child: const Divider(thickness: 1, color: Colors.black12)),
            CustomTable(
              rowData: [
                'Total',
                '',
                getTotalOrderQty().toString(),
                '',
                getTotalAvailableQty().toString(),
                getTotalAcceptedQty().toString(),
                getTotalShortQty().toString(),
                ''
              ].map((data) => Text(data, style: TextStyle(fontSize: 10.sp))).toList(),isFirstCellClickable: false,
            ),
          ],
        ),
      ),
    );
  }
}
