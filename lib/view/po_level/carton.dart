
import 'package:buyerease/database/table/qr_po_item_dtl_table.dart';
import 'package:buyerease/model/po_item_dtl_model.dart';
import 'package:buyerease/services/poitemlist/po_item_dtl_handler.dart';
import 'package:buyerease/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/ResponsiveCustomTable.dart';
import '../../model/inspection_model.dart';
import '../item_level/item_level_tab.dart';

class Carton extends StatefulWidget {
  final String pRowId;
  final InspectionModal inspectionModal;
  final VoidCallback? onChanged;

  const Carton({Key? key, required this.pRowId, this.onChanged, required this.inspectionModal}) : super(key: key);

  @override
  State<Carton> createState() => _CartonState();
}

class _CartonState extends State<Carton> {
  List<POItemDtl> poItems = [];
  bool isLoading = true;

  final Map<String, TextEditingController> packedControllers = {};
  final Map<String, TextEditingController> availableControllers = {};
  final Map<String, TextEditingController> toInspectControllers = {};

  @override
  void initState() {
    super.initState();
    fetchItemsByQRHdrID();
  }

  @override
  void dispose() {
    packedControllers.values.forEach((c) => c.dispose());
    availableControllers.values.forEach((c) => c.dispose());
    toInspectControllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  Future<void> fetchItemsByQRHdrID() async {
    setState(() => isLoading = true);
    try {
      poItems = await POItemDtlHandler.getItemList(widget.pRowId);

      for (var item in poItems) {
        String id = item.pRowID ?? '';
        packedControllers[id] = TextEditingController(text: (item.cartonsPacked ?? 0).toString());
        availableControllers[id] = TextEditingController(text: item.cartonAvailable ?? '0');
        toInspectControllers[id] = TextEditingController(text: item.cartonToInspectedhdr ?? '0');
      }
    } catch (e) {
      showToast('Error loading items', true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> updateField(String pRowID, String field, String value) async {
    int? intValue = int.tryParse(value);
    if (intValue == null) return;

    Map<String, dynamic> updateMap = {};
    switch (field) {
      case 'packed':
        updateMap['CartonsPacked'] = intValue;
        break;
      case 'available':
        updateMap['CartonAvailable'] = intValue;
        break;
      case 'toInspect':
        updateMap['CartonsInspected'] = intValue;
        break;
    }

    await QRPOItemDtlTable().updateRecordByItemId(pRowID, updateMap);
  }

  Widget _buildEditableField(String id, String field, POItemDtl item) {
    late TextEditingController controller;
    late void Function(int?) setValue;

    if (field == 'packed') {
      controller = packedControllers[id]!;
      setValue = (v) => item.cartonsPacked = v;
    } else if (field == 'available') {
      controller = availableControllers[id]!;
      setValue = (v) => item.cartonAvailable = v?.toString() ?? '0';
    } else {
      controller = toInspectControllers[id]!;
      setValue = (v) => item.cartonToInspectedhdr = v?.toString() ?? '0';
    }

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 12.sp),
      textAlign: TextAlign.center,
      onChanged: (val) {
        setValue(int.tryParse(val));
        widget.onChanged?.call();
      },
      onFieldSubmitted: (val) async {
        setValue(int.tryParse(val));
        await updateField(item.qrItemID ?? "", field, val);
        widget.onChanged?.call();
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      ),
    );
  }

  Future<void> saveChanges() async {
    try {
      bool allUpdated = true;
      for (var item in poItems) {
        bool updatedDtl = await POItemDtlHandler.updatePOItemDtlOfWorkmanshipAndCarton(item);
        bool updatedHdr = await POItemDtlHandler.updatePOItemHdrOnInspection(item);
        if (!updatedDtl || !updatedHdr) allUpdated = false;
      }
      setState(() {});
      widget.onChanged?.call();
    } catch (e) {
      showToast('Error saving changes: $e', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      width: 750.w,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ResponsiveCustomTable(
          headers: ['PO', 'Item', 'Packed', 'Available', 'To\nInspected'],
          rows: poItems.map((item) {
            final id = item.pRowID ?? '';
            return [
              item.poNo ?? '',
              item.itemCode ?? '',
              _buildEditableField(id, 'packed', item),
              _buildEditableField(id, 'available', item),
              _buildEditableField(id, 'toInspect', item),
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
            poItems.fold(0, (sum, item) => sum + (item.cartonsPacked ?? 0)).toString(),
            poItems.fold(0, (sum, item) => sum + (int.tryParse(item.cartonAvailable ?? '0') ?? 0)).toString(),
            poItems.fold(0, (sum, item) => sum + (int.tryParse(item.cartonToInspectedhdr ?? '0') ?? 0)).toString(),
          ],
        ),
      ),
    );
  }
}
