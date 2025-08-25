import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/ResponsiveCustomTable.dart';
import '../../../database/table/qr_po_item_dtl_table.dart';
import '../../../model/POItemDtl1.dart';
import '../../../model/inspection_model.dart';
import '../../../model/po_item_dtl_model.dart';
import '../../../services/poitemlist/po_item_dtl_handler.dart';
import '../../item_level/item_level_tab.dart';

class PoWorkmanship extends StatefulWidget {
  final String pRowId;
  final InspectionModal inspectionModal;
  final POItemDtl poItemDtl;
  final VoidCallback? onChanged;

  const PoWorkmanship({
    super.key,
    required this.pRowId,
    this.onChanged,
    required this.inspectionModal,
    required this.poItemDtl,
  });

  @override
  State<PoWorkmanship> createState() => _PoWorkmanshipState();
}

class _PoWorkmanshipState extends State<PoWorkmanship> {
  List<POItemDtl> poItems = [];
  List<POItemDtl> pOItemDtlList = [];
  List<PoItemDtl1> uniqueList = [];
  int aqlFormula = 0;
  bool isLoading = true;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();

    aqlFormula = widget.inspectionModal.aqlFormula!;

    fetchItemsByQRHdrID();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> fetchItemsByQRHdrID() async {
    try {
      setState(() {
        isLoading = true;
      });

      poItems = await POItemDtlHandler.getItemList(widget.pRowId);
      pOItemDtlList.addAll(poItems);
      developer.log("developer poItems: ${jsonEncode(poItems)}");
      for (var item in poItems) {
        final id = item.pRowID ?? '';
        _controllers[id] = TextEditingController(
          text: (item.inspectedQty ?? 0).toString(),
        );
        _controllers[id]!.addListener(() {
          item.inspectedQty = int.tryParse(_controllers[id]!.text) ?? 0;
        });
      }

      setState(() {
        isLoading = false;
      });
      _handleReduAction();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildEditableField(String id, POItemDtl item) {
    if (!_controllers.containsKey(id)) {
      _controllers[id] = TextEditingController(
        text: (item.inspectedQty ?? 0).toString(),
      );

      _controllers[id]!.addListener(() {
        item.inspectedQty = int.tryParse(_controllers[id]!.text) ?? 0;
      });
    }

    return SizedBox(
      width: 60.0,
      child: TextFormField(
        controller: _controllers[id],
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 10.sp),
        onChanged: (val) {
          setState(() {
            item.inspectedQty = int.tryParse(val) ?? 0;
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

  Future<void> saveChanges() async {
    try {
      setState(() {
        isLoading = true;
      });

      bool allUpdated = true;
      for (var item in poItems) {
        final id = item.qrItemID ?? '';
        item.inspectedQty = int.tryParse(_controllers[id]?.text ?? '0') ?? 0;

        bool updatedDtl =
            await POItemDtlHandler.updatePOItemDtlOfWorkmanshipAndCarton(item);
        bool updatedHdr =
            await POItemDtlHandler.updatePOItemHdrOnInspection(item);
        if (!updatedDtl) allUpdated = false;
      }

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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 750.w,
        child: ResponsiveCustomTable(
          headers: const [
            'Po',
            'Item',
            'To\nInspection',
            'Inspected',
            'Critical',
            'Major',
            'Minor'
          ],
          rows: poItems.map((item) {
            int? actualCritical = item.criticalDefect;
            int? defectCritical = item.criticalDefectsAllowed;
            int? actualMajor = item.majorDefect;
            int? defectMajor = item.majorDefectsAllowed;
            int? actualMinor = item.minorDefect;
            int? defectMinor = item.minorDefectsAllowed;
            return [
              item.poNo ?? '',
              item.itemCode ?? '',
              widget.poItemDtl.sampleSizeInspection ?? 'A',
              buildEditableField(item.pRowID ?? '', item),
              // item.criticalhdr ?? '0',
              // item.majorhdr ?? '0',
              // item.minorhdr ?? '0',
              aqlFormula == 0
                  ? actualCritical
                  : "$actualCritical/$defectCritical",
              aqlFormula == 0 ? actualMajor : "$actualMajor/$defectMajor",
              aqlFormula == 0 ? actualMinor : "$actualMinor/$defectMinor",
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
                  poItemDtl: selectedItem,
                  inspectionModal: widget.inspectionModal,
                ),
              ),
            );
          },
          poItems: poItems,
          pRowId: widget.pRowId,
          onDelete: (index) {
            setState(() {
              poItems.removeAt(index);
            });
          },
          showTotalRow: true,
          totalRowData: [
            'Total',
            '',
            '', // poItems.fold(0, (sum, item) => sum + (int.tryParse(item.workmanshipToInspectionhdr ?? '0') ?? 0)).toString(),
            '',
            aqlFormula != 0
                ? poItems
                    .fold(0, (sum, item) => sum + (item.criticalDefect ?? 0))
                    .toString()
                : "${poItems.fold(0, (sum, item) => sum + (item.criticalDefect ?? 0)).toString()}/${pOItemDtlList.first.criticalDefectsAllowed}",
            aqlFormula != 0
                ? poItems
                    .fold(0, (sum, item) => sum + (item.majorDefect ?? 0))
                    .toString()
                : "${poItems.fold(0, (sum, item) => sum + (item.majorDefect ?? 0)).toString()}/${pOItemDtlList.first.majorDefectsAllowed}",
            aqlFormula != 0
                ? poItems
                    .fold(0, (sum, item) => sum + (item.minorDefect ?? 0))
                    .toString()
                : "${poItems.fold(0, (sum, item) => sum + (item.minorDefect ?? 0)).toString()}/${pOItemDtlList.first.majorDefectsAllowed}",
            // poItems
            //     .fold(
            //         0,
            //         (sum, item) =>
            //             sum + (int.tryParse("${item.criticalDefect}") ?? 0))
            //     .toString(),
            // poItems
            //     .fold(
            //         0,
            //         (sum, item) =>
            //             sum + (int.tryParse("${item.majorDefect}") ?? 0))
            //     .toString(),
            // poItems
            //     .fold(
            //         0,
            //         (sum, item) =>
            //             sum + (int.tryParse("${item.minorDefect}") ?? 0))
            //     .toString(),
          ],
        ),
      ),
    );
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

          // If you want to re-enable the commented-out part:
          /*
        if ((pOItemDtlList[i].poMasterPackQty ?? 0) > 0) {
          final or = double.tryParse(orderQtyStr) ?? 0;
          pOItemDtlList[i].cartonsPacked =
              (or / pOItemDtlList[i].poMasterPackQty!).toInt();
        }
        */
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
                (double.tryParse(pOItemDtlList[i].orderQty ?? "0") ?? 0)
                    .toInt();
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
