import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../components/custom_table.dart';
import '../../components/remarks.dart';
import '../../config/theame_data.dart';
import '../../database/table/qr_po_item_dtl_table.dart';
import '../../model/po_item_dtl_model.dart';
import '../../services/po_item_dtl_handler.dart';

class ItemQuantity extends StatefulWidget {
  final String pRowId;
  final POItemDtl? poItemDtl;
  final VoidCallback onChanged; // Add this

  const ItemQuantity({super.key, required this.pRowId, required this.onChanged, this.poItemDtl});

  @override
  State<ItemQuantity> createState() => _ItemQuantityState();
}

class _ItemQuantityState extends State<ItemQuantity> {
  List<POItemDtl>? poItems = [];
  bool isLoading = true;
  String? remark;
String latestDate = "";
  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final DateTime date = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      print('Error formatting date: $e');
      return dateStr;
    }
  }
  bool _hasUnsavedChanges = false;
  bool _isSaving = false;

  void _markAsChanged() {
    setState(() {
      _hasUnsavedChanges = true;
    });
  }


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      latestDate =    await POItemDtlHandler.getPOListItemLatestDelDate(widget.pRowId,widget.poItemDtl!);
      print('loading data: ${widget.poItemDtl}');
      // developer.log('loading data: ${jsonEncode(widget.poItemDtl?.toJson())}');
      // final qrPoItemDtlTable = QRPOItemDtlTable();
      // final items = await qrPoItemDtlTable.getByCustomerItemRefAndEnabled(widget.id,widget.pRowId);
      setState(() {
        poItems = widget.poItemDtl != null ? [widget.poItemDtl!] : [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }



    return Column(
      spacing: 05.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomTable(
                rowData: [
                  'Latest\nDelivery\nDate',
                  'Ship Via',
                  'Order Quantity',
                  'Available Quantity',
                  'Accepted Quantity',
                ].map((data) => Text(data, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),))
                    .toList(),
                isHeader: true,
                isFirstCellClickable: false,
              ),
              ...?poItems?.map((item) => CustomTable(
                rowData: [
                  formatDate(latestDate),
                  item.shipToBreakUP ?? '',
                  item.orderQty ?? '',
                  item.availableQty?.toString() ?? '0',
                  item.acceptedQty?.toString() ?? '0',
                ].map((data) => Text(data, style: TextStyle(fontSize: 10.sp),)).toList(),
                isFirstCellClickable: false,
              )).toList(),
            ],
          ),
        ),
        // Remark
        Remarks()
      ],
    );
  }
}
