import 'dart:developer' as developer;
import 'package:buyerease/components/size_adapter.dart';
import 'package:buyerease/model/POItemDtl1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:buyerease/database/table/qr_po_item_dtl_table.dart';
import 'package:buyerease/model/po_item_dtl_model.dart';
import '../../components/ResponsiveCustomTable.dart';
import '../../model/SizeQtyModel.dart';
import '../../model/inspection_model.dart';
import '../../services/SizeQtyModelHandler.dart';
import '../../services/poitemlist/po_item_dtl_handler.dart';
import '../item_level/item_level_tab.dart';

class PoItem extends StatefulWidget {
  final String pRowId;
  final InspectionModal inspectionModal;
  final VoidCallback? onChanged;

  const PoItem({super.key, required this.pRowId, this.onChanged, required this.inspectionModal});

  @override
  State<PoItem> createState() => _PoItemState();
}
  
class _PoItemState extends State<PoItem> {
  List<POItemDtl> poItems = [];
  List<POItemDtl> pOItemDtlList = [];
  List<PoItemDtl1> uniqueList = [];
  late List<SizeQtyModel> sizeQtyModelList;
  bool isLoading = true;

  final Map<String, TextEditingController> availableControllers = {};
  final Map<String, TextEditingController> acceptControllers = {};
  final Map<String, TextEditingController> shortControllers = {};
  int _cartonTotal = 0;
  int _cartonTotalPacked = 0;
  int _cartonTotalAvalable = 0;
  int _cartonTotalInspected = 0;
  int _qualityTotalOrder = 0;
  int _totalQualityAvailable = 0;
  int _totalQualityAccepted = 0;
  int _totalQualityShort = 0;
  int _TotalCritical = 0;
  int _TotalMajor = 0;
  int _TotalMinor = 0;
  int _CriticalDefectsAllowed = 0;
  int _MajorDefectsAllowed = 0;
  int _MinorDefectsAllowed = 0;


  @override
  void initState() {
    super.initState();
    fetchItemsByQRHdrID();

  }

  @override
  void dispose() {
    availableControllers.values.forEach((c) => c.dispose());
    acceptControllers.values.forEach((c) => c.dispose());
    shortControllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

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

  Future<void> fetchItemsByQRHdrID() async {
    try {
      setState(() => isLoading = true);
      poItems = await POItemDtlHandler.getItemList(widget.pRowId);
      pOItemDtlList.addAll(poItems);
      for (var item in poItems) {
        final id = item.pRowID ?? '';
        availableControllers[id] = TextEditingController(text: (item.availableQty ?? 0).toString());
        acceptControllers[id] = TextEditingController(text: (item.acceptedQty ?? 0).toString());
        shortControllers[id] = TextEditingController(text: (item.shortStockQty ?? 0).toString());
      }

      if (poItems.isNotEmpty) calculate();

      setState(() => isLoading = false);
      _handleReduAction();
    } catch (e) {
      developer.log('Error fetching QRPOItemDtl: $e');
      setState(() => isLoading = false);
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

    for(var item in poItems) {
      final status = POItemDtlHandler.updateItemForQty(item);

      debugPrint("POItemDtlHandler status: $status");
     // await QRPOItemDtlTable().updateRecordByItemId(pRowID, updateMap);
    }
  }

  void resetQuantities() async {
    for (var item in poItems) {
      final id = item.pRowID ?? '';
      final dbId = item.qrItemID ?? '';
      int orderQty = 0;
      int inspectedTillDatehdr = 0;
      int acceptedQty = item.acceptedQty ?? 0;

      if (item.orderQty != null) {
        try {
          orderQty = double.parse(item.orderQty!).toInt();
        } catch (_) {}
      }

      inspectedTillDatehdr = int.tryParse(item.inspectedTillDatehdr.toString()) ?? 0;
      int shortQty = orderQty - inspectedTillDatehdr - acceptedQty;
      if (shortQty < 0) shortQty = 0;

      item.availableQty = orderQty - inspectedTillDatehdr;
      item.acceptedQty = orderQty - inspectedTillDatehdr;
      item.shortStockQty = shortQty;

      availableControllers[id]?.text = '0';
      acceptControllers[id]?.text = '0';
      shortControllers[id]?.text = shortQty.toString();

      await QRPOItemDtlTable().reSetRecord(dbId, {
        'AvailableQty': item.availableQty ?? 0,
        'AcceptedQty': item.acceptedQty ?? 0,
        'ShortStockQty': shortQty,
      });
    }
    rebuildControllers();
    setState(() {});
    widget.onChanged?.call();
  }

  int getTotalOrderQty() => poItems.fold(0, (sum, item) {
    try {
      return sum + double.parse(item.orderQty ?? '0').toInt();
    } catch (_) {
      return sum;
    }
  });

  int getTotalAvailableQty() => poItems.fold(0, (sum, item) => sum + (item.availableQty ?? 0));
  int getTotalAcceptedQty() => poItems.fold(0, (sum, item) => sum + (item.acceptedQty ?? 0));
  int getTotalShortQty() => poItems.fold(0, (sum, item) => sum + (item.shortStockQty ?? 0));

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 750.w,
        child: ResponsiveCustomTable(
          headers: [
            'Po',
            'Item',
            'Order',
            'Inspested\nTill Date',
            'Available',
            'accepted',
            'Short',
            'Inspect Later',
          ],
          rows: poItems.map((item) {
            final id = item.pRowID ?? '';
            final itemId = item.qrItemID ?? '';

            return [
              item.poNo ?? '',
              item.customerItemRef ?? '',
              item.orderQty ?? '0',
              item.inspectedTillDatehdr?.toString() ?? '0',
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
            ];
          }).toList(),
            onRowTap: (index) {
              final selectedItem = poItems[index];
              final id = selectedItem.pRowID ?? '';

              // 🔑 Sync latest values from controllers
              selectedItem.availableQty = int.tryParse(availableControllers[id]?.text ?? '0') ?? 0;
              selectedItem.acceptedQty = int.tryParse(acceptControllers[id]?.text ?? '0') ?? 0;
              selectedItem.shortStockQty = int.tryParse(shortControllers[id]?.text ?? '0') ?? 0;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemLevelTab(
                    id: selectedItem.customerItemRef ?? '',
                    pRowId: widget.pRowId,
                    poItemDtl: selectedItem,
                    inspectionModal: widget.inspectionModal,
                  ),
                ),
              );
            },
            descriptions: poItems.map((item) =>
          '${item.itemDescr} - ${item.customerItemRef ?? ''}').toList(),
          onDelete: (index) async {
            final item = poItems[index];
            final id = item.pRowID ?? '';

            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Item'),
                content: Text('Are you sure you want to delete ${item.pRowID}?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                  TextButton(
                    onPressed: () async {
                      await QRPOItemDtlTable().deleteRecord(id);
                      Navigator.pop(context, true);
                    },
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              await fetchItemsByQRHdrID();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item deleted successfully')),
                );
              }
            }
          },
          showTotalRow: true,
          totalRowData: [
            'Total',
            '',
            getTotalOrderQty().toString(),
            '',
            getTotalAvailableQty().toString(),
            getTotalAcceptedQty().toString(),
            getTotalShortQty().toString(),
            ''
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
      controller = availableControllers[id]!;
      getValue = () => item.availableQty;
      setValue = (v) => item.availableQty = v;
    } else if (field == 'accept') {
      controller = acceptControllers[id]!;
      getValue = () => item.acceptedQty;
      setValue = (v) => item.acceptedQty = v;
    } else {
      controller = shortControllers[id]!;
      getValue = () => item.shortStockQty;
      setValue = (v) => item.shortStockQty = v;
    }

    Color? textColor;
    if (field == 'short') {
      int value = int.tryParse(controller.text) ?? 0;
      if (value < 0) {
        textColor = Colors.red;
      }
    }

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 12.sp, color: textColor),
      onChanged: (val) async {
        final newVal = int.tryParse(val) ?? 0;
        setValue(newVal);

        // ✅ When available is changed, auto-adjust accept if needed
        if (field == 'available') {
          final acceptVal = int.tryParse(acceptControllers[id]?.text ?? '0') ?? 0;
          if (acceptVal < newVal) {
            acceptControllers[id]?.text = newVal.toString();
            item.acceptedQty = newVal;

            // ✅ Update DB for accept as well
            await updateField(item.qrItemID ?? "", 'accept', newVal.toString());
          }
        }

        calculate();
        widget.onChanged?.call();
      },
      onFieldSubmitted: (val) async {
        final newVal = int.tryParse(val) ?? 0;
        setValue(newVal);

        // ✅ When available is submitted, recheck and sync accept
        if (field == 'available') {
          final acceptVal = int.tryParse(acceptControllers[id]?.text ?? '0') ?? 0;
          if (acceptVal < newVal) {
            acceptControllers[id]?.text = newVal.toString();
            item.acceptedQty = newVal;
            await updateField(item.qrItemID ?? "", 'accept', newVal.toString());
          }
        }

        await updateField(item.qrItemID ?? "", field, val);

        calculate();
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
    bool allUpdated = true;
    for (var item in poItems) {
      bool updated = await POItemDtlHandler.updatePOItemDtl(item);
      if (!updated) allUpdated = false;

      // Get latest values from controllers
      calculate();
      handleUpdateData();
    }
    // for (var item in poItems) {
    //   final id = item.pRowID ?? '';
    //   // Get latest values from controllers
    //   item.availableQty = int.tryParse(availableControllers[id]?.text ?? '0') ?? 0;
    //   item.acceptedQty = int.tryParse(acceptControllers[id]?.text ?? '0') ?? 0;
    //   // Parse orderQty (string to int)
    //   int orderQty = 0;
    //   if (item.orderQty != null) {
    //     try {
    //       orderQty = double.parse(item.orderQty!).toInt();
    //     } catch (_) {
    //       orderQty = 0;
    //     }
    //   }
    //   int inspectedTillDatehdr = item.inspectedTillDatehdr ?? 0;
    //   int acceptedQty = item.acceptedQty ?? 0;
    //   // Calculate shortStockQty
    //   int shortQty = orderQty - inspectedTillDatehdr - acceptedQty;
    //   if (shortQty < 0) shortQty = 0;
    //   item.shortStockQty = shortQty;
    //   shortControllers[id]?.text = shortQty.toString();
    //
    //   // await QRPOItemDtlTable().updateRecordByItemId(id, {
    //   //   'AvailableQty': item.availableQty,
    //   //   'AcceptedQty': item.acceptedQty,
    //   //   'ShortStockQty': item.shortStockQty,
    //   //   'FurtherInspectionReqd': item.furtherInspectionReqd ?? 0,
    //   // });
    // }

    setState(() {});
    widget.onChanged?.call();
  }





  void calculate() {
    for (var item in poItems) {
      final id = item.pRowID ?? '';

      // Get latest values from controllers
      int available = int.tryParse(availableControllers[id]?.text ?? '0') ?? 0;
      int accept = int.tryParse(acceptControllers[id]?.text ?? '0') ?? 0;

      // ✅ Enforce: Accept must be >= Available
      if (accept > available) {
        accept = available;
        acceptControllers[id]?.text = accept.toString();
        item.acceptedQty = accept;
      }

      item.availableQty = available;
      item.acceptedQty = accept;

      // Parse order quantity
      int orderQty = 0;
      if (item.orderQty != null) {
        try {
          orderQty = double.parse(item.orderQty!).toInt();
        } catch (_) {}
      }

      int inspectedTillDatehdr = int.tryParse(item.inspectedTillDatehdr.toString()) ?? 0;

      // Recalculate short quantity
      int shortQty = orderQty - inspectedTillDatehdr - accept;
      if (shortQty < 0) shortQty = 0;

      item.shortStockQty = shortQty;
      shortControllers[id]?.text = shortQty.toString();
    }
  }
  Future<void> onSaveClick({
    required List<SizeQtyModel> updatedSizeQtyModelList,
    required POItemDtl item,
  }) async {
    int totalAcceptedQty = 0;
    int totalAvailableQty = 0;
    int shortQty = 0;

    for (var model in updatedSizeQtyModelList) {
      totalAcceptedQty += model.acceptedQty ?? 0;
      totalAvailableQty += model.availableQty ?? 0;

      int orderQty = model.orderQty ?? 0;
      int earlierInspected = model.earlierInspected ?? 0;
      int acceptedQty = model.acceptedQty ?? 0;

      int short = orderQty - (earlierInspected + acceptedQty);
      shortQty += short < 0 ? 0 : short;

      // Save size-wise quantities to DB
      await SizeQtyModelHandler.insertSizeQty(model);
    }
    handleUpdateData();
    // Update parent item
    item.acceptedQty = totalAcceptedQty;
    item.availableQty = totalAvailableQty;
    item.shortStockQty = shortQty < 0 ? 0 : shortQty;
    handleToUpdateTotal();
    // Save updated parent item
    bool status = await POItemDtlHandler.updateItemForQty(item);
    debugPrint("POItemDtlHandler status: $status");

    // Optionally show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Quantity Updated Successfully")),
    );
  }
  Future<void> handleUpdateData() async {
    bool status = false;
    for (var i = 0; i < poItems.length; i++) {
      status = await POItemDtlHandler.updatePOItemHdrOnInspection(poItems[i]);
      status = await POItemDtlHandler.updatePOItemDtlOnInspection(poItems[i]);
    }
  }
  void handleToUpdateTotal() {
    _cartonTotal = 0;
    _cartonTotalPacked = 0;
    _cartonTotalAvalable = 0;
    _cartonTotalInspected = 0;
    _qualityTotalOrder = 0;
    _totalQualityAvailable = 0;
    _totalQualityAccepted = 0;
    _totalQualityShort = 0;
    _TotalCritical = 0;
    _TotalMajor = 0;
    _TotalMinor = 0;
    _CriticalDefectsAllowed = 0;
    _MajorDefectsAllowed = 0;
    _MinorDefectsAllowed = 0;

    if (poItems != null && poItems.isNotEmpty) {
     /* for (var item in pOItemDtlList) {
        print("_totalQuality QualityShort=${item.shortQty}");

        // If OrderQty is not empty or "null"
        if (item.orderQty != null && item.orderQty.trim().isNotEmpty && item.orderQty != "null") {
          double f = double.tryParse(item.orderQty) ?? 0;
          _qualityTotalOrder += f.toInt();
        }

        // Calculate Short
        double f = double.tryParse(item.orderQty) ?? 0;
        item.shortQty = f.toInt() - (item.earlierInspected + item.acceptedQty);

        // Totals
        _totalQualityAvailable += item.availableQty!;
        _totalQualityAccepted += item.acceptedQty!;
        _totalQualityShort += item.short!;
      }*/

      print("_totalQuality _totalQualityAvailable=$_totalQualityAvailable");
      print("_totalQuality _totalQualityAccepted=$_totalQualityAccepted");
      print("_totalQuality _totalQualityShort=$_totalQualityShort");

      if (uniqueList != null && uniqueList.isNotEmpty) {
        for (int j = 0; j < uniqueList.length; j++) {
          var uItem = uniqueList[j];
          var pItem = poItems[j];

          _cartonTotal += uItem.cartonsPacked2!;
          _cartonTotalPacked += uItem.cartonsPacked2!;
          _cartonTotalAvalable += uItem.cartonsPacked2!;
          _cartonTotalInspected += uItem.cartonsInspected!;

          _TotalCritical += pItem.criticalDefect!;
          _TotalMajor += pItem.majorDefect!;
          _TotalMinor += pItem.minorDefect!;

          _CriticalDefectsAllowed += pItem.criticalDefectsAllowed!;
          _MajorDefectsAllowed += pItem.majorDefectsAllowed!;
          _MinorDefectsAllowed += pItem.minorDefectsAllowed!;
        }
      }
    }
  }
  void _handleReduAction() {
    changeOnReduAvailable();
  }

  void changeOnReduAvailable() {
    if (pOItemDtlList != null && pOItemDtlList.isNotEmpty) {
      for (var i = 0; i < pOItemDtlList.length; i++) {
        final orderQtyStr = pOItemDtlList[i].orderQty;
        if (orderQtyStr != null &&
            orderQtyStr.isNotEmpty &&
            orderQtyStr.toLowerCase() != "null") {
          final f = double.tryParse(orderQtyStr) ?? 0;
          pOItemDtlList[i].availableQty =
              f.toInt() - (pOItemDtlList[i].earlierInspected ?? 0);
          pOItemDtlList[i].acceptedQty =
              f.toInt() - (pOItemDtlList[i].earlierInspected ?? 0);

        }
      }
      changeOnAvailable();
    }
  }




  Future<void> changeOnAvailable() async {
    InspectionModal inspectionModal = widget.inspectionModal;

    if (pOItemDtlList.isNotEmpty) {
      for (var j = 0; j < uniqueList.length; j++) {
        int tAvailableQty = 0;
        int totalOrder = 0;
        int qualityAccepted = 0;

        for (var i = 0; i < pOItemDtlList.length; i++) {
          if (uniqueList[j].qrpoItemHdrId == pOItemDtlList[i].qrpoItemHdrID) {
            tAvailableQty += pOItemDtlList[i].availableQty ?? 0;
            totalOrder +=
                (double.tryParse(pOItemDtlList[i].orderQty ?? "0") ?? 0).toInt();
            qualityAccepted += pOItemDtlList[i].acceptedQty ?? 0;
          }
        }

        uniqueList[j].orderQty = totalOrder.toString();
        uniqueList[j].availableQty = tAvailableQty;
        uniqueList[j].acceptedQty = qualityAccepted;

        developer.log(
          'UniqueList[$j] - orderQty: ${uniqueList[j].orderQty}, '
              'availableQty: ${uniqueList[j].availableQty}, '
              'acceptedQty: ${uniqueList[j].acceptedQty}',
          name: 'changeOnAvailable',
        );

        var pOItemDtl1 = uniqueList[j];
        List<String>? toInspDtl = await POItemDtlHandler.getToInspect(
          inspectionModal.inspectionLevel!,
          pOItemDtl1.availableQty ?? 0,
        );

        developer.log('UniqueList[$j] - getToInspect: $toInspDtl',
            name: 'changeOnAvailable');

        if (toInspDtl != null) {
          if (inspectionModal.qlMinor == "DEL0000013" ||
              inspectionModal.qlMajor == "DEL0000013" ||
              inspectionModal.activityID == "SYS0000001") {
            pOItemDtl1
              ..sampleSizeInspection = null
              ..inspectedQty = 0
              ..allowedinspectionQty = 0
              ..minorDefectsAllowed = 0
              ..majorDefectsAllowed = 0
              ..cartonsPacked2 = 0
              ..cartonsPacked = 0;
          } else {
            String sampleCode = toInspDtl[0];
            pOItemDtl1.sampleSizeInspection = toInspDtl[1];
            pOItemDtl1.inspectedQty = int.tryParse(toInspDtl[2]) ?? 0;
            pOItemDtl1.allowedinspectionQty = int.tryParse(toInspDtl[2]) ?? 0;

            List<String>? minorDefect =
            await POItemDtlHandler.getDefectAccepted(
              inspectionModal.qlMinor!,
              sampleCode,
            );
            developer.log(
                'UniqueList[$j] - MinorDefect($sampleCode): $minorDefect',
                name: 'changeOnAvailable');
            pOItemDtl1.minorDefectsAllowed =
            minorDefect != null ? int.tryParse(minorDefect[1]) ?? 0 : 0;

            List<String>? majorDefect =
            await POItemDtlHandler.getDefectAccepted(
              inspectionModal.qlMajor!,
              sampleCode,
            );
            developer.log(
                'UniqueList[$j] - MajorDefect($sampleCode): $majorDefect',
                name: 'changeOnAvailable');
            pOItemDtl1.majorDefectsAllowed =
            majorDefect != null ? int.tryParse(majorDefect[1]) ?? 0 : 0;

            if ((pOItemDtl1.poMasterPackQty ?? 0) > 0) {
              double or = (pOItemDtl1.acceptedQty ?? 0).toDouble();
              pOItemDtl1.cartonsPacked2 =
                  (or / pOItemDtl1.poMasterPackQty!).toInt();
            }
          }
        }
      }

      // --- Loop for pOItemDtlList ---
      for (var i = 0; i < pOItemDtlList.length; i++) {
        var pOItemDtl = pOItemDtlList[i];
        List<String>? toInspDtl = await POItemDtlHandler.getToInspect(
          inspectionModal.inspectionLevel!,
          pOItemDtl.availableQty ?? 0,
        );

        developer.log('POItemDtl[$i] - getToInspect: $toInspDtl',
            name: 'changeOnAvailable');

        if (toInspDtl != null) {
          if (inspectionModal.qlMinor == "DEL0000013" ||
              inspectionModal.qlMajor == "DEL0000013" ||
              inspectionModal.activityID == "SYS0000001") {
            pOItemDtl
              ..sampleSizeInspection = null
              ..inspectedQty = 0
              ..allowedinspectionQty = 0
              ..minorDefectsAllowed = 0
              ..majorDefectsAllowed = 0
              ..cartonsPacked2 = 0
              ..cartonsPacked = 0;
          } else {
            String sampleCode = toInspDtl[0];
            pOItemDtl.sampleSizeInspection = toInspDtl[1];
            pOItemDtl.inspectedQty = int.tryParse(toInspDtl[2]) ?? 0;
            pOItemDtl.allowedinspectionQty = int.tryParse(toInspDtl[2]) ?? 0;

            List<String>? minorDefect =
            await POItemDtlHandler.getDefectAccepted(
              widget.inspectionModal.qlMinor!,
              sampleCode,
            );
            developer.log(
                'POItemDtl[$i] - MinorDefect($sampleCode): $minorDefect',
                name: 'changeOnAvailable');
            pOItemDtl.minorDefectsAllowed =
            minorDefect != null ? int.tryParse(minorDefect[1]) ?? 0 : 0;

            List<String>? majorDefect =
            await POItemDtlHandler.getDefectAccepted(
              widget.inspectionModal.qlMajor!,
              sampleCode,
            );
            developer.log(
                'POItemDtl[$i] - MajorDefect($sampleCode): $majorDefect',
                name: 'changeOnAvailable');
            pOItemDtl.majorDefectsAllowed =
            majorDefect != null ? int.tryParse(majorDefect[1]) ?? 0 : 0;

            if ((pOItemDtl.poMasterPackQty ?? 0) > 0) {
              double or = (pOItemDtl.acceptedQty ?? 0).toDouble();
              pOItemDtl.cartonsPacked2 =
                  (or / pOItemDtl.poMasterPackQty!).toInt();
              pOItemDtl.cartonsPacked = pOItemDtl.cartonsPacked2;
            }
          }
        }
      }
    }
  }



}
