import 'dart:convert';
import 'dart:developer' as developer;
import 'package:buyerease/database/table/qr_po_item_hdr_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../components/ResponsiveCustomTable.dart';
import '../../components/remarks.dart';
import '../../config/theame_data.dart';
import '../../database/table/qr_po_item_dtl_table.dart';
import '../../model/inspection_model.dart';
import '../../model/po_item_dtl_model.dart';
import '../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../services/poitemlist/po_item_dtl_handler.dart';

class ItemQuantity extends StatefulWidget {
  final String pRowId;
  final POItemDtl poItemDtl;
  final InspectionModal inspectionModal;
  final VoidCallback onChanged;

  const ItemQuantity({
    super.key,
    required this.pRowId,
    required this.onChanged,
    required this.poItemDtl,
    required this.inspectionModal,
  });

  @override
  State<ItemQuantity> createState() => _ItemQuantityState();
}

class _ItemQuantityState extends State<ItemQuantity> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true; // Keep the widget state alive
  late POItemDtl poItemDtl;
  List<POItemDtl> pOItemDtlList = [];
  bool isLoading = true;
  TextEditingController _qtyRemarkController = TextEditingController();
  String latestDate = "";
  bool _hasUnsavedChanges = false;
  POItemDtl packagePoItemDetalDetail = POItemDtl();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _qtyRemarkController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      // Get latest delivery date
      latestDate = await POItemDtlHandler.getPOListItemLatestDelDate(
        widget.pRowId,
        widget.poItemDtl,
      );

      // Load PO item detail
      pOItemDtlList = await POItemDtlHandler.getItemList(widget.pRowId);

      // Initialize poItemDtl with widget value (or from loaded list)
      poItemDtl = widget.poItemDtl;
      poItemDtl.latestDelDt = latestDate;
      developer.log(
          "developer ler with saved remark ${jsonEncode(widget.poItemDtl)}");
      developer.log(
          "developer ler with saved latestDelDt ${(widget.poItemDtl.latestDelDt)}");

      await handlePackaging();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading data: $e');
    }
  }

  void _markAsChanged() {
    setState(() {
      _hasUnsavedChanges = true;
    });
    widget.onChanged(); // Notify parent (OverAllResult)
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final DateTime date = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(date); // ✅ Now DD-MM-YYYY
    } catch (e) {
      print('Error formatting date: $e');
      return dateStr;
    }
  }


  // 🔁 Equivalent to Java handleItemQtyRemark()
  Future<void> saveChanges() async {
    final pkgAppRemark = _qtyRemarkController.text ?? '';

    // Update local model
    poItemDtl.qtyRemark = pkgAppRemark;

    updateQtyRemark();

    // Save to server (optional, but mimics Java method)
    // await ItemInspectionDetailHandler.updatePackagingFindingMeasurementList(poItemDtl);

    setState(() {
      _hasUnsavedChanges = false;
    });

    developer.log('Qty Remark saved: $pkgAppRemark');
  }

  void updateQtyRemark() {
    poItemDtl.qtyRemark = _qtyRemarkController.text;

    developer
        .log("packagePoItemDetalDetail jsonEncode ${jsonEncode(poItemDtl)}");
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
          formatDate(poItemDtl.latestDelDt),
          // pOItemDtlList.first.latestDelDt ?? '',
          pOItemDtlList.first.shipToBreakUP ?? '',
          pOItemDtlList.first.orderQty?.toString() ?? '0',
          pOItemDtlList.first.availableQty?.toString() ?? '0',
          pOItemDtlList.first.acceptedQty?.toString() ?? '0',
        ],
      ];

  @override
  Widget build(BuildContext context) {
    super.build(context); // Important to call super.build when using mixin
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Table showing delivery & quantity details
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
            _markAsChanged(); // Your internal state update
            widget.onChanged(); // Notify the parent (already non-nullable)
          },
        ),
      ],
    );
  }

  Future<void> handlePackaging() async {
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
        packagePoItemDetalDetail = packList[0];
        _qtyRemarkController.text = packagePoItemDetalDetail.qtyRemark!;
      });
    }
  }


}
