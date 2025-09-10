import 'dart:convert';
import 'dart:developer' as developer;

import 'package:buyerease/model/workmanship_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/ResponsiveCustomTable.dart';
import '../../../components/over_all_dropdown_section_wise.dart';
import '../../../components/remarks.dart';
import '../../../config/theame_data.dart';
import '../../../database/table/qr_po_item_dtl_table.dart';
import '../../../model/POItemDtl1.dart';
import '../../../model/inspection_model.dart';
import '../../../model/po_item_dtl_model.dart';
import '../../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../../services/poitemlist/po_item_dtl_handler.dart';
import 'add_workmanship.dart';

class WorkManShip extends StatefulWidget {
  final String id;
  final String pRowId;
  final InspectionModal inspectionModal;
  final POItemDtl poItemDtl;
  final VoidCallback onChanged; // ✅ Add this

  const WorkManShip(
      {super.key,
      required this.id,
      required this.onChanged,
      required this.pRowId,
      required this.poItemDtl,
      required this.inspectionModal});

  @override
  State<WorkManShip> createState() => _WorkManShipState();
}

class _WorkManShipState extends State<WorkManShip> {
  String overallResult = 'PASS';
  List<POItemDtl> pOItemDtlList = [];
  List<PoItemDtl1> uniqueList = [];
  final List<String> resultOptions = ['PASS', 'FAIL'];
  bool loading = true;
  bool noData = false;
  List<POItemDtl> poItems = [];
  POItemDtl packagePoItemDetalDetail = POItemDtl();
  final TextEditingController _workmanShipRemark = TextEditingController();

  late POItemDtl poItemDtl;
  int totalCritical = 0;
  int totalMajor = 0;
  int totalMinor = 0;

  Future<void> syncData() async {
    try {
      final qrPoItemDtlTable = QRPOItemDtlTable();
      final items = await qrPoItemDtlTable.getByCustomerItemRefAndEnabled(
          widget.id, widget.pRowId);
      setState(() {
        poItems = items;
        pOItemDtlList.addAll(poItems);
        if (items.isNotEmpty) {
          overallResult = items.first.workmanshipInspectionResult ?? 'PASS';
        }
        loading = false;
      });
      _handleReduAction();
    } catch (e) {
      setState(() {
        loading = false;
        noData = true;
      });
      print('Error loading data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    poItemDtl = widget.poItemDtl;
    syncData();
    setAdaptor();
    handlePackaging();
  }

  List<WorkManShipModel> workManShipModels = [];
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (noData || poItems.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          spacing: 10.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Result Row
            // OverAllDropdown(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildOverallResultDropdown(),
                Row(
                  spacing: 5,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddWorkManShip(poItemDtl: poItemDtl)),
                        );
                        workManShipModels.add(result);
                        await setAdaptor(); // 🔄 Refresh after returning
                      },
                      icon: Icon(
                        Icons.add_circle_outline,
                        size: 28.h,
                      ),
                    ),
                    Text(
                      "Add",
                      style: TextStyle(
                          color: ColorsData.primaryColor, fontSize: 16.sp),
                    )
                  ],
                )
              ],
            ),

            ResponsiveCustomTable(
              headers: [
                'Code',
                'Critical',
                'Major',
                'Minor',
                'Total',
              ],
              rows: workManShipModels.map((item) {
                final id = item.pRowID ?? '';
                //final itemId = item.qrItemID ?? '';
                return [
                  item.code ?? '',
                  item.critical ?? '',
                  item.major ?? '',
                  item.minor ?? '',
                  ((item.major ?? 0) + (item.minor ?? 0) + (item.critical ?? 0))
                      .toString(),
                ];
              }).toList(),
              onRowTap: (index) async {
                final itemToEdit = workManShipModels[index];
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddWorkManShip(
                      poItemDtl: poItemDtl,
                      existingModel: itemToEdit,
                    ),
                  ),
                );
                await setAdaptor(); // 🔄 Always refresh
              },
              descriptions: workManShipModels
                  .map((item) => '"description : ${item.description}"')
                  .toList(),
              onDelete: (index) async {
                final item = workManShipModels[index];
                final id = item.pRowID ?? '';
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Item'),
                    content:
                        Text('Are you sure you want to delete ${item.pRowID}?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel')),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context); // Close the dialog
                          await ItemInspectionDetailHandler()
                              .deleteWorkmanship(id);
                          await setAdaptor();
                        },
                        child: const Text('Delete',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Find Button
            ElevatedButton(
              onPressed: () {
                // Find logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
              child: Text(
                "Find",
                style: TextStyle(color: Colors.black, fontSize: 14.h),
              ),
            ),
            ResponsiveCustomTable(
              headers: [
                '',
                'Critical',
                'Major',
                'Minor',
              ],
              rows: [
                [
                  'Total',
                  totalCritical.toString(),
                  totalMajor.toString(),
                  totalMinor.toString()
                ],
                [
                  'Permissible\nDefect',
                  "${pOItemDtlList.first.criticalDefectsAllowed ?? 0}",
                  "${pOItemDtlList.first.majorDefectsAllowed ?? 0}",
                  "${pOItemDtlList.first.minorDefectsAllowed ?? 0}"
                ], // index 0
                // index 1
              ],
              specialRowIndexes: [0, 1], // mark both rows as "special"
            ),

            Remarks(
              controller: _workmanShipRemark,
            )
          ],
        ),
      ),
    );
  }

  Future<void> setAdaptor() async {
    setState(() {
      isLoading = true;
    });

    List<WorkManShipModel> list =
        await ItemInspectionDetailHandler().getWorkmanShip(
      poItemDtl.qrHdrID ?? '',
      poItemDtl.qrpoItemHdrID ?? '',
      poItemDtl.qrItemID ?? '',
    );

    setState(() {
      workManShipModels.clear();
      workManShipModels.addAll(list);
      totalCritical = workManShipModels.fold<int>(
        0,
        (sum, item) => sum + (item.critical ?? 0),
      );

      totalMajor = workManShipModels.fold<int>(
        0,
        (sum, item) => sum + (item.major ?? 0),
      );

      totalMinor = workManShipModels.fold<int>(
        0,
        (sum, item) => sum + (item.minor ?? 0),
      );
      if (pOItemDtlList.isNotEmpty) {
        pOItemDtlList.first.criticalDefect = totalCritical;
        pOItemDtlList.first.majorDefect = totalMajor;
        pOItemDtlList.first.minorDefect = totalMinor;
      }
      isLoading = false;
    });

    developer.log("workmanship modal list ${jsonEncode(workManShipModels)}");
  }

  void handleWorkmanshipRemark() {
    String workmanshipRemark = _workmanShipRemark.text;

    if (workmanshipRemark != packagePoItemDetalDetail.workmanshipRemark) {
      packagePoItemDetalDetail.workmanshipRemark = workmanshipRemark;
      ItemInspectionDetailHandler.updateWorkmanshipRemark(
        packagePoItemDetalDetail,
      );
    }
  }

  void handleWorkManship() {
    // ItemInspectionDetailHandler.updateWorkmanshipOverAllResult(
    //   this,
    //   packagePoItemDetalDetail,
    // );

    /*
  if (workManShipModels != null && workManShipModels.isNotEmpty) {
    for (var model in workManShipModels) {
      String wRowID = ItemInspectionDetailHandler.updateWorkmanShip(
        this,
        poItemDtl.qrHdrID,
        poItemDtl.qrPOItemHdrID,
        poItemDtl.qrItemID,
        model,
      );
      addAsDigitalImageFromWorkmanShip(model, wRowID);
    }
  }
  */

    // updateTotalWorkmanship();
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
        _workmanShipRemark.text = packagePoItemDetalDetail.workmanshipRemark!;
      });
    }
  }




  Future<void> updateTotalWorkmanship() async {
    // Fetch the work defects
    List<WorkManShipModel> lWorkDefect = await ItemInspectionDetailHandler().getWorkmanShip(
      poItemDtl.qrHdrID ?? "",
      poItemDtl.qrpoItemHdrID ?? '',
      poItemDtl.qrItemID ?? "",
    );

    poItemDtl.criticalDefect = totalCritical;
    poItemDtl.majorDefect = totalMajor;
    poItemDtl.minorDefect = totalMinor;

    await ItemInspectionDetailHandler().updateDefect( poItemDtl);

    // // Update UI
    // int totalCritical = poItemDtl.criticalDefect;
    // int totalMajor = poItemDtl.majorDefect;
    // int totalMinor = poItemDtl.minorDefect;
    //
    // txtTotalCritical.text = totalCritical.toString();
    // txtTotalMajor.text = totalMajor.toString();
    // txtTotalMinor.text = totalMinor.toString();
    //
    // txtTotalCritical.style = TextStyle(
    //   color: totalCritical > poItemDtl.criticalDefectsAllowed
    //       ? Colors.red
    //       : Colors.black,
    // );
    //
    // txtTotalMajor.style = TextStyle(
    //   color: totalMajor > poItemDtl.majorDefectsAllowed
    //       ? Colors.red
    //       : Colors.black,
    // );
    //
    // txtTotalMinor.style = TextStyle(
    //   color: totalMinor > poItemDtl.minorDefectsAllowed
    //       ? Colors.red
    //       : Colors.black,
    // );
    //
    // txtPermissibleMinor.text = poItemDtl.minorDefectsAllowed.toString();
    // txtPermissibleMajor.text = poItemDtl.majorDefectsAllowed.toString();
    // txtPermissibleCritical.text = poItemDtl.criticalDefectsAllowed.toString();
  }


  Future<void> saveChanges() async {
    setState(() {});
    setAdaptor();
    handleWorkmanshipRemark();
    updateTotalWorkmanship();
    widget.onChanged.call();
  }

  Widget buildOverallResultDropdown() {
    return SOverAllDropdown(
      poItemDtl: widget.poItemDtl,
      selectInspectionResultId: poItemDtl.workmanshipInspectionResultID ?? '',
      onChange: (newId) async {
        // Handle DB update here
        await ItemInspectionDetailHandler()
            .updatePackagingFindingMeasurementList(
          poItemDtl..workmanshipInspectionResultID = newId,
        );
        print("Updated workmanshipInspectionResultID to $newId");
      },
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
