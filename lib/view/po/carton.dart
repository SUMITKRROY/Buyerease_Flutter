import 'package:buyerease/components/custom_table.dart';
import 'package:buyerease/database/database_helper.dart';
import 'package:buyerease/database/table/qr_po_item_dtl_table.dart';
import 'package:buyerease/model/po_item_dtl_model.dart';
import 'package:buyerease/utils/loading.dart';
import 'package:buyerease/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Carton extends StatefulWidget {
  final String pRowId;
  final VoidCallback? onChanged;
  const Carton({super.key, required this.pRowId,this.onChanged});

  @override
  State<Carton> createState() => _CartonState();
}

class _CartonState extends State<Carton> {
  List<POItemDtl> poItems = [];
  bool isLoading = true;
  Map<String, TextEditingController> packedControllers = {};
  Map<String, TextEditingController> availableControllers = {};
  Map<String, TextEditingController> toInspectControllers = {};

  @override
  void initState() {
    super.initState();
    fetchItemsByQRHdrID();
  }

  @override
  void dispose() {
    // Dispose all controllers
    packedControllers.values.forEach((controller) => controller.dispose());
    availableControllers.values.forEach((controller) => controller.dispose());
    toInspectControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> fetchItemsByQRHdrID() async {
    try {
      setState(() {
        isLoading = true;
      });

      List<Map<String, dynamic>> items = await QRPOItemDtlTable().getByQRHdrID(widget.pRowId);
      poItems = items.map((item) => POItemDtl.fromJson(item)).toList();

      // Initialize controllers for each item
      for (var item in poItems) {
        String itemId = item.pRowID ?? '';
        packedControllers[itemId] = TextEditingController(
          text: item.cartonsPacked?.toString() ?? '0'
        );
        availableControllers[itemId] = TextEditingController(
          text: item.cartonAvailable ?? '0'
        );
        toInspectControllers[itemId] = TextEditingController(
          text: item.cartonToInspectedhdr ?? '0'
        );
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateItemValues(String itemId, String field, String value) async {
    try {
      Map<String, dynamic> updateData = {};
      
      switch (field) {
        case 'packed':
          updateData[QRPOItemDtlTable.colCartonsPacked] = int.tryParse(value) ?? 0;
          break;
        case 'available':
          updateData[QRPOItemDtlTable.colAvailableQty] = double.tryParse(value) ?? 0;
          break;
        case 'toInspect':
          updateData[QRPOItemDtlTable.colAllowedCartonInspection] = int.tryParse(value) ?? 0;
          break;
      }

      await QRPOItemDtlTable().updateRecord(itemId, updateData);
      
      // Update the local model
      var itemIndex = poItems.indexWhere((item) => item.pRowID == itemId);
      if (itemIndex != -1) {
        setState(() {
          switch (field) {
            case 'packed':
              poItems[itemIndex].cartonsPacked = int.tryParse(value) ?? 0;
              break;
            case 'available':
              poItems[itemIndex].cartonAvailable = value;
              break;
            case 'toInspect':
              poItems[itemIndex].cartonToInspectedhdr = value;
              break;
          }
        });
      }
      
      showToast('Updated successfully', false);
    } catch (e) {
      showToast('Error updating value: $e', true);
    }
  }

  Widget _buildEditableField(String itemId, String field, TextEditingController controller, String initialValue) {
    return Container(
      width: 80,
      height: 30,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 10.sp),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        ),
        onChanged: (value) {
          // Update in real-time as user types
          widget.onChanged?.call();
        },
        onEditingComplete: () {
          updateItemValues(itemId, field, controller.text);
        },
      ),
    );
  }

  Future<void> saveChanges() async {
    try {
      for (var item in poItems) {
        String itemId = item.pRowID ?? '';
        await updateItemValues(itemId, 'packed', packedControllers[itemId]?.text ?? '0');
        await updateItemValues(itemId, 'available', availableControllers[itemId]?.text ?? '0');
        await updateItemValues(itemId, 'toInspect', toInspectControllers[itemId]?.text ?? '0');
      }
      showToast('All changes saved!', false);
    } catch (e) {
      showToast('Error saving changes: $e', true);
    }
  }

  void resetQuantities() {
    for (var item in poItems) {
      String itemId = item.pRowID ?? '';
      packedControllers[itemId]?.text = item.cartonsPacked?.toString() ?? '0';
      availableControllers[itemId]?.text = item.cartonAvailable ?? '0';
      toInspectControllers[itemId]?.text = item.cartonToInspectedhdr ?? '0';
    }
    setState(() {});
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
            ...poItems.map((item) {
              String itemId = item.pRowID ?? '';
              return CustomTable(
                rowData: [
                  Text(item.poNo ?? '', style: TextStyle(fontSize: 10.sp)),
                  Text(item.itemCode ?? '', style: TextStyle(fontSize: 10.sp)),
                  _buildEditableField(itemId, 'packed', packedControllers[itemId]!, item.cartonsPacked?.toString() ?? '0'),
                  _buildEditableField(itemId, 'available', availableControllers[itemId]!, item.cartonAvailable ?? '0'),
                  _buildEditableField(itemId, 'toInspect', toInspectControllers[itemId]!, item.cartonToInspectedhdr ?? '0'),
                ],
                customerItemRef: item.customerItemRef,
                pRowId: widget.pRowId,
              );
            }).toList(),
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

