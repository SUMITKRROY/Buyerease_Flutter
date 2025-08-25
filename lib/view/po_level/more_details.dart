import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/ResponsiveCustomTable.dart';
import '../../components/custom_table.dart';
import '../../database/table/qr_po_item_dtl_table.dart';
import '../../model/inspection_model.dart';
import '../../model/po_item_dtl_model.dart';
import '../../services/poitemlist/po_item_dtl_handler.dart';
import '../item_level/item_level_tab.dart';

class MoreDetails extends StatefulWidget {
  final String pRowId;
  final VoidCallback? onChanged;
  final InspectionModal inspectionModal;
  const MoreDetails({super.key, required this.pRowId,this.onChanged, required this.inspectionModal});

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

      poItems =  await POItemDtlHandler.getItemList(widget.pRowId);

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
      child: ResponsiveCustomTable(
        headers: [
          'PO',
          'Item',
          'Packaging Measurement',
          'Digitals Uploaded',
          'Test Report',
          'Measurements',
          'Inspection Result',
          'Hologram No',
        ],
        rows: poItems.map((item) {
          return [
            item.poNo ?? '',
            item.itemCode ?? '',
            item.packagingMeasurementhdr ?? '',
            (item.digitals ?? 0).toString(),
            item.testReportStatus == 1 ? 'Pending' : 'Completed',
            item.measurementshdr ?? '',
            item.overallInspectionResult ?? '',
            item.hologramNo ?? '',
          ];
        }).toList(),
        onRowTap: (index) {
          final selectedItem = poItems[index];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemLevelTab(
                id: selectedItem.customerItemRef ?? '',
                pRowId: widget.pRowId, // or dynamic value
                poItemDtl: selectedItem, inspectionModal: widget.inspectionModal,
              ),
            ),
          );
        },
        showTotalRow: true,
        totalRowData: [
          'Total',
          '',
          '',
          poItems.fold(0, (sum, item) => sum + (item.digitals ?? 0)).toString(),
          '',
          '',
          '',
          '',
        ],
      ),
    );
  }
  Future<void> saveChanges() async {
    try {
      setState(() {
        isLoading = true;
      });
      // _updateThedata();

      // Removed call to updateQualityParameter
      setState(() {
        isLoading = false;
      });
      widget.onChanged?.call();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
