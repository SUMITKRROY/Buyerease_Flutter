import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:buyerease/database/table/qr_po_item_dtl_table.dart';
import 'package:buyerease/model/po_item_dtl_model.dart';
import '../../components/custom_table.dart';

class PoItem extends StatefulWidget {
  final String pRowId;
  final VoidCallback? onChanged;

  const PoItem({super.key, required this.pRowId, this.onChanged});

  @override
  State<PoItem> createState() => _PoItemState();
}

class _PoItemState extends State<PoItem> {
  List<POItemDtl> poItems = [];
  bool isLoading = true;

  final Map<String, TextEditingController>  availableControllers = {};
  final Map<String, TextEditingController> acceptControllers = {};
  final Map<String, TextEditingController> shortControllers = {};

  void rebuildControllers() {
    availableControllers.clear();
    acceptControllers.clear();
    shortControllers.clear();
    for (var item in poItems) {
      final id = item.pRowID ?? '';
      availableControllers[id] = TextEditingController(text: (item.availableQty ?? 0).toString());
      acceptControllers[id] = TextEditingController(text: (item.acceptedQty ?? 0).toString());
      shortControllers[id] = TextEditingController(text: (item.shortStockQty ?? 0).toString());
    }
  }

  @override
  void dispose() {
    availableControllers.values.forEach((c) => c.dispose());
    acceptControllers.values.forEach((c) => c.dispose());
    shortControllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

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
      developer.log('developer length of  QRPOItemDtl: ${poItems.length}');

      for (var item in poItems) {
        final id = item.pRowID ?? '';
        availableControllers[id] = TextEditingController(text: (item.availableQty ?? 0).toString());
        acceptControllers[id] = TextEditingController(text: (item.acceptedQty ?? 0).toString());
        shortControllers[id] = TextEditingController(text: (item.shortStockQty ?? 0).toString());
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      developer.log('Error fetching QRPOItemDtl: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateField(String pRowID, String field, String value) async {
    int? intValue = int.tryParse(value);
    if (intValue == null) return;

    Map<String, dynamic> updateMap = {};
    if (field == 'available') {
      updateMap['AvailableQty'] = intValue;
    } else if (field == 'accept') {
      updateMap['AcceptedQty'] = intValue;
    } else if (field == 'short') {
      updateMap['ShortStockQty'] = intValue;
    } else if (field == 'furtherInspectionReqd') {
      updateMap['FurtherInspectionReqd'] = intValue;
    }

    await QRPOItemDtlTable().updateRecordByItemId(pRowID, updateMap);
  }

  void resetQuantities() async {
    for (var item in poItems) {
      final id = item.qrHdrID ?? '';
      item.availableQty = 0;
      item.acceptedQty = 0;
      item.shortStockQty = 0;

      availableControllers[id]?.text = '0';
      acceptControllers[id]?.text = '0';
      shortControllers[id]?.text = '0';

      await QRPOItemDtlTable().reSetRecord(id, {
        'AvailableQty': 0,
        'AcceptedQty': 0,
        'ShortStockQty': 0,
      });
    }
    rebuildControllers();
    setState(() {});
    widget.onChanged?.call();
  }

  int getTotalOrderQty() {
    return poItems.fold(0, (sum, item) {
      if (item.orderQty == null) return sum;
      try {
        return sum + double.parse(item.orderQty!).toInt();
      } catch (_) {
        return sum;
      }
    });
  }

  int getTotalAvailableQty() => poItems.fold(0, (sum, item) => sum + (item.availableQty ?? 0));
  int getTotalAcceptedQty() => poItems.fold(0, (sum, item) => sum + (item.acceptedQty ?? 0));
  int getTotalShortQty() => poItems.fold(0, (sum, item) => sum + (item.shortStockQty ?? 0));

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
                'Po', 'Item', 'Order', 'Inspested\nTill Date',
                'Available', 'Accept', 'Short', 'Inspect Later'
              ].map((e) => Text(e, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp))).toList(),
              isHeader: true,
            ),
            ...poItems.map((item) {
              final id = item.pRowID ?? '';
                  final itemId = item.qrItemID ?? '';
              return CustomTable(
                rowData: [
                  item.poNo ?? '',
                  item.customerItemRef,
                  item.orderQty ?? '0',
                  item.inspectedQty?.toString() ?? '0',
                  buildEditableField(id, 'available', item),
                  buildEditableField(id, 'accept', item),
                  buildEditableField(id, 'short', item),
                  Checkbox(
                    value: item.furtherInspectionReqd == 1,
                    onChanged: (val) async {
                      setState(() => item.furtherInspectionReqd = val == true ? 1 : 0);
                      await updateField(itemId, 'furtherInspectionReqd', val == true ? '1' : '0');
                      widget.onChanged?.call();
                    },
                  ),
                ].map((data) => data is Widget ? data : Text(data.toString(), style: TextStyle(fontSize: 10.sp))).toList(),
                description: '${item.itemDescr} - ${item.customerItemRef ?? ''}',
                customerItemRef: item.customerItemRef,
                onDelete: () async {
                  bool isDeleting = false;
                  await showDialog<bool>(
                    context: context,
                    builder: (context) => StatefulBuilder(
                      builder: (context, setStateDialog) {
                        return AlertDialog(
                          title: const Text('Delete Item'),
                          content: Text('Are you sure you want to delete ${item.pRowID}?'),
                          actions: [
                            TextButton(
                              onPressed: isDeleting ? null : () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: isDeleting
                                  ? null
                                  : () async {
                                      setStateDialog(() {
                                        isDeleting = true;
                                      });
                                      try {
                                        await QRPOItemDtlTable().deleteRecord(id);
                                        await fetchItemsByQRHdrID();
                                        if (mounted) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Item deleted successfully')),
                                          );
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Failed to delete item')),
                                          );
                                        }
                                      } finally {
                                        if (mounted) {
                                          setStateDialog(() {
                                            isDeleting = false;
                                          });
                                        }
                                      }
                                    },
                              child: isDeleting
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            }).toList(),
            SizedBox(width: 390, child: const Divider(thickness: 1, color: Colors.black12)),
            CustomTable(
              rowData: [
                'Total', '', getTotalOrderQty().toString(), '',
                getTotalAvailableQty().toString(),
                getTotalAcceptedQty().toString(),
                getTotalShortQty().toString(), ''
              ].map((e) => Text(e, style: TextStyle(fontSize: 10.sp))).toList(),
              isFirstCellClickable: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditableField(String id, String field, POItemDtl item) {
    TextEditingController controller;
    int? Function() getValue;
    void Function(int?) setValue;

    if (field == 'available') {
      controller = availableControllers[id] ?? TextEditingController(text: (item.availableQty ?? 0).toString());
      getValue = () => item.availableQty;
      setValue = (v) => item.availableQty = v;
    } else if (field == 'accept') {
      controller = acceptControllers[id] ?? TextEditingController(text: (item.acceptedQty ?? 0).toString());
      getValue = () => item.acceptedQty;
      setValue = (v) => item.acceptedQty = v;
    } else {
      controller = shortControllers[id] ?? TextEditingController(text: (item.shortStockQty ?? 0).toString());
      getValue = () => item.shortStockQty;
      setValue = (v) => item.shortStockQty = v;
    }

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 10.sp),
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
    for (var item in poItems) {
      final id = item.pRowID ?? '';
      item.availableQty = int.tryParse(availableControllers[id]?.text ?? '0') ?? 0;
      item.acceptedQty = int.tryParse(acceptControllers[id]?.text ?? '0') ?? 0;
      item.shortStockQty = int.tryParse(shortControllers[id]?.text ?? '0') ?? 0;
      await QRPOItemDtlTable().updateRecordByItemId(id, {
        'AvailableQty': item.availableQty,
        'AcceptedQty': item.acceptedQty,
        'ShortStockQty': item.shortStockQty,
        'FurtherInspectionReqd': item.furtherInspectionReqd ?? 0,
      });
    }
    setState(() {});
    widget.onChanged?.call();
  }

}
