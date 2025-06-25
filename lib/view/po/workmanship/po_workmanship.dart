import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/custom_table.dart';
import '../../../database/table/qr_po_item_dtl_table.dart';
import '../../../model/po_item_dtl_model.dart';

class PoWorkmanship extends StatefulWidget {
  final String pRowId;
  final VoidCallback? onChanged;
  
  const PoWorkmanship({
    super.key, 
    required this.pRowId,
    this.onChanged,
  });

  @override
  State<PoWorkmanship> createState() => _PoWorkmanshipState();
}

class _PoWorkmanshipState extends State<PoWorkmanship> {
  List<POItemDtl> poItems = [];
  List<POItemDtl> originalPoItems = [];
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
      // Create a deep copy of the original items for undo functionality
      originalPoItems = items.map((item) => POItemDtl.fromJson(item)).toList();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveChanges() async {
    try {
      setState(() {
        isLoading = true;
      });

      for (var item in poItems) {
        final originalItem = originalPoItems.firstWhere(
          (original) => original.qrItemID == item.qrItemID,
        );

        if (item.inspectedhdr != originalItem.inspectedhdr) {
          await updateField(item.qrItemID ?? "", item.inspectedhdr ?? "0");
        }
      }

      // Update originalPoItems with current values
      originalPoItems = poItems.map((item) => POItemDtl.fromJson(item.toJson())).toList();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void resetQuantities() {
    setState(() {
      // Reset poItems to original values
      poItems = originalPoItems.map((item) => POItemDtl.fromJson(item.toJson())).toList();
    });
  }

  final TextStyle headerStyle = const TextStyle(fontWeight: FontWeight.bold);
  final TextStyle normalStyle = const TextStyle(fontSize: 14);

  Widget buildCell(String text, {double width = 80, bool isHeader = false}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: isHeader ? headerStyle : normalStyle,
      ),
    );
  }

  Widget buildRow(List<String> data, {bool isHeader = false}) {
    final widths = [50.0, 80.0, 60.0, 110.0, 60.0, 60.0, 60.0, 80.0];
    return Row(
      children: [
        for (int i = 0; i < data.length; i++)
          buildCell(data[i], width: widths[i], isHeader: isHeader),
      ],
    );
  }

  Widget buildMergedDescription(String text) {
    return Container(
      width: 560, // Sum of all cell widths above
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey.shade100,
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
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
                'Po', 'Item', 'To\nInspection', 'Inspected',
                'Critical', 'Major', 'Minor'
              ].map((data) => Text(data,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),)).toList(),
              isHeader: true,
            ),

            ...poItems.map((item) => CustomTable(
              rowData: [
                item.poNo ?? '',
                item.itemCode ?? '',
                item.workmanshipToInspectionhdr ?? '0',
                buildEditableField(item.qrItemID ?? '', item),
                item.criticalhdr ?? '0',
                item.majorhdr ?? '0',
                item.minorhdr ?? '0'
              ].map((data) => data is Widget ? data : Text(data.toString(), style: TextStyle(fontSize: 10.sp))).toList(),
            )).toList(),

            SizedBox(width: 390, child: const Divider(thickness: 1, color: Colors.black12)),
            CustomTable(
              rowData: [
                'Total',
                '',
                poItems.fold(0, (sum, item) => sum + (int.tryParse(item.workmanshipToInspectionhdr ?? '0') ?? 0)).toString(),
                poItems.fold(0, (sum, item) => sum + (int.tryParse(item.inspectedhdr ?? '0') ?? 0)).toString(),
                poItems.fold(0, (sum, item) => sum + (int.tryParse(item.criticalhdr ?? '0') ?? 0)).toString(),
                poItems.fold(0, (sum, item) => sum + (int.tryParse(item.majorhdr ?? '0') ?? 0)).toString(),
                poItems.fold(0, (sum, item) => sum + (int.tryParse(item.minorhdr ?? '0') ?? 0)).toString(),
              ].map((data) => Text(data, style: TextStyle(fontSize: 10.sp))).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditableField(String id, POItemDtl item) {
    final controller = TextEditingController(text: (item.inspectedhdr ?? '0').toString());
    return SizedBox(
      width: 60.0,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 10.sp),
        onChanged: (val) {
          setState(() {
            item.inspectedhdr = val;
          });
          widget.onChanged?.call();
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        ),
      ),
    );
  }

  Future<void> updateField(String id, String value) async {
    await QRPOItemDtlTable().updateRecord(id, {'inspectedhdr': value});
  }
}


