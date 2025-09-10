import 'dart:convert';
import 'dart:developer' as developer;

import 'package:buyerease/components/remarks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/ResponsiveCustomTable.dart';
import '../../../components/custom_table.dart';
import '../../../components/over_all_dropdown_section_wise.dart';
import '../../../config/theame_data.dart';
import '../../../main.dart';
import '../../../model/inspection_model.dart';
import '../../../model/item_measurement_modal.dart';
import '../../../model/po_item_dtl_model.dart';
import '../../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../../services/general/GeneralMasterHandler.dart';
import '../../../services/general/GeneralModel.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/gen_utils.dart';
import 'add_measurement.dart';

class ItemMeasurement extends StatefulWidget {
  final String id;
  final POItemDtl poItemDtl;
  final VoidCallback onChanged;
  final InspectionModal inspectionModal;
  const ItemMeasurement({super.key, required this.inspectionModal, required this.id, required this.poItemDtl, required this.onChanged});

  @override
  State<ItemMeasurement> createState() => _ItemMeasurementState();
}

class _ItemMeasurementState extends State<ItemMeasurement> {
  TextEditingController _itemMeasurementRemark = TextEditingController();
  late final POItemDtl poItemDtl;
  String overallResult = 'PASS';
  final List<String> resultOptions = ['PASS', 'FAIL'];

  String? toleranceRange;
  String? description;

  // List to store measurements
  List<ItemMeasurementModal> measurements = [];

  @override
  void initState() {
    super.initState();
    poItemDtl = widget.poItemDtl;
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(08.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Over All Result + Add Item Row
            Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildOverallResultDropdown(),
                Row(
                  spacing: 5,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddItemMeasurement(poItemDtl: poItemDtl),
                          ),
                        );
                    // 🔄 Always refresh after returning from next page
                        await _initializeData();

                      },
                      icon:  Icon(Icons.add_circle_outline,size: 28.h,),
                    ),
                    Text("Add Item",style: TextStyle(color: ColorsData.primaryColor,fontSize: 16.sp),)
                  ],
                )
              ],
            ),

            ResponsiveCustomTable(
              headers: [
                'Length',
                'Height',
                'Width',
                'Sample Size',
              ],
              rows: itemMeasurementModalList.map((item) {
                final id = item.pRowID ?? '';
                //final itemId = item.qrItemID ?? '';
                return [
                  item.dimLength ?? '',
                  item.dimHeight ?? '',
                  item.dimWidth ?? '',
                  item.sampleSizeValue ?? '',
                ];
              }).toList(),
                onRowTap: (index) async {
                  final itemToEdit = itemMeasurementModalList[index];
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddItemMeasurement(
                        poItemDtl: poItemDtl,
                        existingMeasurement: itemToEdit,
                      ),
                    ),
                  );

// Refresh list after edit
                  await _initializeData();

                },
              descriptions: itemMeasurementModalList.map((item) =>
              'Tolerance_range: ${item.toleranceRange}\n description :${item.itemMeasurementDescr}').toList(),
              onDelete: (index) async {
                final item = itemMeasurementModalList[index];
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
                          Navigator.pop(context); // Close the dialog

                          List<ItemMeasurementModal> relatedFindings =
                          await ItemInspectionDetailHandler().getFindingItemMeasurementList(item);

                          for (var finding in relatedFindings) {
                            await ItemInspectionDetailHandler().deleteFindingItemMeasurement(finding.pRowIDForFinding ?? '');
                          }

                          await ItemInspectionDetailHandler().deleteItemMeasurement(item.pRowID ?? '');

                          // Refresh UI with only remaining data
                          List<ItemMeasurementModal> updatedList = await ItemInspectionDetailHandler().getItemMeasurementList(
                            poItemDtl.qrHdrID ?? '',
                            poItemDtl.qrpoItemHdrID ?? '',
                          );

                          await resetAndAddMeasurements(updatedList);
                        },
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                // if (confirm == true) {
                //   await fetchItemsByQRHdrID();
                //   if (mounted) {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(content: Text('Item deleted successfully')),
                //     );
                //   }
                // }
              },
            ),

            Remarks(
              controller: _itemMeasurementRemark,
              onChanged: (_) {
                widget.onChanged();
              },
            ),
          ],
        ),
      ),

    );
  }

  List<ItemMeasurementModal> itemMeasurementModalList = [];
  List<ItemMeasurementModal> itemMeasurementHistoryModalList = [];

  Future<void> _initializeData() async {
    // Fetch lists
    List<ItemMeasurementModal> measurements = await ItemInspectionDetailHandler().getItemMeasurementList(
      poItemDtl.qrHdrID ?? '',
      poItemDtl.qrpoItemHdrID ?? '',
    );
developer.log("ItemMeasurementModal measurements ${jsonEncode(measurements)}");
    List<ItemMeasurementModal> history = await ItemInspectionDetailHandler().getItemMeasurementHistoryList(
      poItemDtl.qrpoItemHdrID ?? '',
    );
    developer.log("ItemMeasurementModal history ${jsonEncode(history)}");
    setState(() {
      itemMeasurementModalList = measurements;
      itemMeasurementHistoryModalList = history;
      measurements = itemMeasurementHistoryModalList;
      // selectedOverallResult = overallResults.first;
    });
    handlePackaging();
  }

  void handleToInitiateItemMeasurement() async {
    // Navigate to AddItemMeasurement screen
/*    GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddItemMeasurement(
              poItemDtl: GenUtils.serializePOItemModal(poItemDtl),
            ),
          ),
        );

        // You can handle the result here if needed
      },
      child: Container(
        // Your UI for addItemMeasurementContainer
      ),
    );*/

    updateItemMeasurementDropdown(); // Implement accordingly

    // Item Measurement List
    List<ItemMeasurementModal> itemMeasurementModalList = [];

    List<ItemMeasurementModal>? lItemMeasurement = await ItemInspectionDetailHandler().getItemMeasurementList(
      poItemDtl.qrHdrID ?? '',
      poItemDtl.qrpoItemHdrID ?? '',
    );

    if (lItemMeasurement != null) {
      itemMeasurementModalList.clear();
      itemMeasurementModalList.addAll(lItemMeasurement);
      measurements = itemMeasurementModalList;
    }

    // Item Measurement History List
    List<ItemMeasurementModal> itemMeasurementHistoryModalList = [];

    List<ItemMeasurementModal>? lItemMeasurementHistory = await ItemInspectionDetailHandler().getItemMeasurementHistoryList(

      poItemDtl.qrpoItemHdrID ?? '',
    );

    if (lItemMeasurementHistory != null) {
      itemMeasurementHistoryModalList.clear();
      itemMeasurementHistoryModalList.addAll(lItemMeasurementHistory);
    }

  /*  // Example widgets for displaying history
    if (itemMeasurementHistoryModalList.isNotEmpty) {
      itemActivity = itemMeasurementHistoryModalList[0].activity;
      inspectionItemID = itemMeasurementHistoryModalList[0].pRowID;
      itemHistoryDate = DateUtils.formatDate(itemMeasurementHistoryModalList[0].inspectionDate); // Assume you have this
    }*/

    getOverAllStatusOfItemMeasurement(); // Implement accordingly

    // Update state/UI
    setState(() {
      // Update UI with the fetched lists
    });
  }


  List<String> statusList = [];
  List<GeneralModel> overAllResultStatusList = [];
  POItemDtl packagePoItemDetalDetail =   POItemDtl();
  String? selectedStatus;
  String? selectedStatusID;

  Future<void> updateItemMeasurementDropdown() async {
    // Fetch list
    overAllResultStatusList = await GeneralMasterHandler.getGeneralList(
      FEnumerations.overallResultStatusGenId,
    );

    if (overAllResultStatusList.isNotEmpty) {
      int selectedMPos = 0;

      // Extract display strings and match selected
      for (int i = 0; i < overAllResultStatusList.length; i++) {
        statusList.add(overAllResultStatusList[i].mainDescr ?? '');
        if (overAllResultStatusList[i].pGenRowID == packagePoItemDetalDetail.itemMeasurementInspectionResultID) {
          selectedMPos = i;
        }
      }

      setState(() {
        selectedStatus = statusList[selectedMPos];
        selectedStatusID = overAllResultStatusList[selectedMPos].pGenRowID;
      });
    }
  }

  void getOverAllStatusOfItemMeasurement() {
    if (itemMeasurementModalList.isNotEmpty) {
      for (var item in itemMeasurementModalList) {
        if (item.inspectionResultID == FEnumerations.overAllFailResult) {
          packagePoItemDetalDetail.itemMeasurementInspectionResultID = item.inspectionResultID;
          break;
        }
      }

      updateItemMeasurementDropdown(); // This updates the DropdownButton
      // handleOverAllResult(); // Your custom logic
    }
  }
  Future<void> resetAndAddMeasurements(List<ItemMeasurementModal> newMeasurements) async {
    setState(() {
      itemMeasurementModalList.clear(); // Clear existing UI list
      itemMeasurementModalList.addAll(newMeasurements); // Add new data
    });
  }
  bool isLoading = true;

  Future<void> setAdaptor() async {
    setState(() {
      isLoading = true;
    });

    List<ItemMeasurementModal>? lItemMeasurement = await ItemInspectionDetailHandler().getItemMeasurementList(
      poItemDtl.qrHdrID ?? '',
      poItemDtl.qrpoItemHdrID ?? '',
    );
    setState(() {
    itemMeasurementModalList.clear();
    itemMeasurementModalList.addAll(lItemMeasurement);
    measurements = itemMeasurementModalList;
      });
    // Item Measurement History List
    List<ItemMeasurementModal> itemMeasurementHistoryModalList = [];

    List<ItemMeasurementModal>? lItemMeasurementHistory = await ItemInspectionDetailHandler().getItemMeasurementHistoryList(

      poItemDtl.qrpoItemHdrID ?? '',
    );
    setState(() {
    if (lItemMeasurementHistory != null) {
      itemMeasurementHistoryModalList.clear();
      itemMeasurementHistoryModalList.addAll(lItemMeasurementHistory);
    }
  });
    developer.log("workmanship modal list ${jsonEncode(itemMeasurementHistoryModalList)}");
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
        _itemMeasurementRemark.text = packagePoItemDetalDetail.itemMeasurementRemark!;
      });
    }
  }
  void handleWorkmanshipRemark() {
    String itemMeasurementRemark = _itemMeasurementRemark.text;

    if (itemMeasurementRemark != packagePoItemDetalDetail.workmanshipRemark) {
      packagePoItemDetalDetail.itemMeasurementRemark = itemMeasurementRemark;
      ItemInspectionDetailHandler.updateItemMeasurementRemark(
        packagePoItemDetalDetail,
      );
    }
  }
  Future<void> saveChanges() async {
    setState(() {
      isLoading = true;

      itemMeasurementModalList.clear();
      itemMeasurementHistoryModalList.clear();
    });

    handleWorkmanshipRemark();
    // Fetch new measurement data
    List<ItemMeasurementModal>? newMeasurements = await ItemInspectionDetailHandler().getItemMeasurementList(
      poItemDtl.qrHdrID ?? '',
      poItemDtl.qrpoItemHdrID ?? '',
    );

    // Fetch new history data
    List<ItemMeasurementModal>? newHistory = await ItemInspectionDetailHandler().getItemMeasurementHistoryList(
      poItemDtl.qrpoItemHdrID ?? '',
    );

    setState(() {
      if (newMeasurements != null) {
        itemMeasurementModalList.addAll(newMeasurements);
      }

      if (newHistory != null) {
        itemMeasurementHistoryModalList.addAll(newHistory);
      }

      isLoading = false;
    });

    // 🧾 Print / Log the fetched data
    developer.log("🟢 ItemMeasurementModal List: ${jsonEncode(itemMeasurementModalList)}");
    developer.log("📜 ItemMeasurementModal History List: ${jsonEncode(itemMeasurementHistoryModalList)}");

    // 🔔 Notify parent
    widget.onChanged.call();
  }


  Widget buildOverallResultDropdown() {
    return     SOverAllDropdown(
      poItemDtl: widget.poItemDtl,
      selectInspectionResultId: poItemDtl.itemMeasurementInspectionResultID ?? '',
      onChange: (newId) async {
        // Handle DB update here
        await ItemInspectionDetailHandler().updatePackagingFindingMeasurementList(
          poItemDtl..itemMeasurementInspectionResultID = newId,
        );
        print("Updated itemMeasurementInspectionResultID to $newId");
      },
    );
  }


}
