import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../components/ResponsiveCustomTable.dart';
import '../../components/remarks.dart';
import '../../database/table/qr_po_item_dtl_table.dart';
import '../../model/inspection_model.dart';
import '../../model/po_item_dtl_model.dart';
import '../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../services/poitemlist/po_item_dtl_handler.dart';

class ItemQuantity extends StatefulWidget {
  final String pRowId;
  final String itemId;
  final POItemDtl poItemDtl;
  final InspectionModal inspectionModal;
  final VoidCallback onChanged;

  const ItemQuantity({
    super.key,
    required this.pRowId,
    required this.itemId,
    required this.poItemDtl,
    required this.inspectionModal,
    required this.onChanged,
  });

  @override
  State<ItemQuantity> createState() => _ItemQuantityState();
}

class _ItemQuantityState extends State<ItemQuantity>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late POItemDtl poItemDtl;
  List<POItemDtl> pOItemDtlList = [];
  bool isLoading = true;
  final TextEditingController _qtyRemarkController = TextEditingController();
  String latestDate = "";
  String orderQty = "";
  String availableQty = "";
  String acceptedQty = "";
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    poItemDtl = widget.poItemDtl;
    developer.log("PO Detail OrderQty: ${jsonEncode(poItemDtl)}");
    _loadData();
  }

  @override
  void dispose() {
    _qtyRemarkController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      latestDate = await POItemDtlHandler.getPOListItemLatestDelDate(
        widget.pRowId,
        poItemDtl,
      );
pOItemDtlList.add(widget.poItemDtl);
    //  pOItemDtlList = await POItemDtlHandler.getItemList(widget.pRowId);
      orderQty = poItemDtl.orderQty ?? "";
      availableQty = (poItemDtl.availableQty ?? 0).toString();
      acceptedQty = (poItemDtl.acceptedQty ?? 0).toString();

      // Attach latest delivery date
      poItemDtl.latestDelDt = latestDate;

      // Handle packaging remarks
      await _handlePackaging();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      developer.log('Error loading data: $e');
    }
  }

  void _markAsChanged() {
    setState(() {
      _hasUnsavedChanges = true;
    });
    widget.onChanged();
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final DateTime date = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      developer.log('Error formatting date: $e');
      return dateStr;
    }
  }

  Future<void> saveChanges() async {
    poItemDtl.qtyRemark = _qtyRemarkController.text;
    _updateQtyRemark();

    setState(() {
      _hasUnsavedChanges = false;
    });

    developer.log('Qty Remark saved: ${poItemDtl.qtyRemark}');
  }

  void _updateQtyRemark() {
    poItemDtl.qtyRemark = _qtyRemarkController.text;
    developer.log("Updated POItemDtl: ${jsonEncode(poItemDtl)}");

    ItemInspectionDetailHandler()
        .updatePackagingFindingMeasurementList(poItemDtl);
  }

  List<String> get _headers => [
    'Latest Delivery Date',
    'Ship Via',
    'Order Quantity',
    'Available Quantity',
    'Accepted Quantity',
  ];

  List<List<dynamic>> get _rows => [
    [
      formatDate(latestDate),
      '', // Ship Via (not available yet in model)
      orderQty,
      availableQty,
      acceptedQty,

    ],
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (pOItemDtlList.isEmpty) {
      return const Text("No data found");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Table
        SizedBox(
          height: 120.h,
          child: ResponsiveCustomTable(
            headers: _headers,
            rows: _rows,
            showTotalRow: false,
          ),
        ),
        const SizedBox(height: 16),
        // Remarks input
        Remarks(
          controller: _qtyRemarkController,
          onChanged: (val) {
            _markAsChanged();
          },
        ),
      ],
    );
  }

  Future<void> _handlePackaging() async {
    List<POItemDtl> packDetailList =
    await ItemInspectionDetailHandler().getPackagingMeasurementList(
      poItemDtl.qrHdrID ?? '',
      poItemDtl.qrpoItemHdrID ?? '',
    );

    List<POItemDtl> packFindingList =
    await ItemInspectionDetailHandler().getPackagingFindingMeasurementList(
      itemId: poItemDtl.itemID ?? '',
      qrpoItemHdrID: poItemDtl.qrpoItemHdrID ?? '',
    );

    List<POItemDtl> packList =
    ItemInspectionDetailHandler().copyFindingDataToSpecification(
      packDetailList,
      packFindingList,
    );

    if (packList.isNotEmpty) {
      setState(() {
        poItemDtl = packList[0];
        _qtyRemarkController.text = poItemDtl.qtyRemark ?? '';
      });
    }
  }
}
