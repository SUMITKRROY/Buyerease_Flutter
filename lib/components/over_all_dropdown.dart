import 'package:buyerease/model/po_item_dtl_model.dart';
import 'package:buyerease/services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/theame_data.dart';
import '../database/table/qr_po_item_hdr_table.dart';
import '../model/item_measurement_modal.dart';
import '../services/general/GeneralMasterHandler.dart';
import '../services/general/GeneralModel.dart';
import '../utils/app_constants.dart';

class OverAllDropdown extends StatefulWidget {
  final POItemDtl poItemDtl;
    OverAllDropdown({super.key, required this.poItemDtl});

  @override
  State<OverAllDropdown> createState() => _OverAllDropdownState();
}

class _OverAllDropdownState extends State<OverAllDropdown> {
  late   POItemDtl poItemDtl;
  POItemDtl packagePoItemDetalDetail =   POItemDtl();
  String selectedResult = '';
  String selectedResultId = '';
  int selectedResultPos = 0;
  List<String> statsList = [];
  List<GeneralModel> overAllResultStatusList = [];
  ItemMeasurementModal itemMeasurementModal = ItemMeasurementModal();
  String? _dropDownValue;
  @override
  void initState() {
    poItemDtl = widget.poItemDtl;
    super.initState();
    initDropdown();
  }

  Future<void> initDropdown() async {
    // Step 1: Load list of possible results
    overAllResultStatusList = await GeneralMasterHandler.getGeneralList(
      FEnumerations.overallResultStatusGenId,
    );
    statsList = overAllResultStatusList.map((e) => e.mainDescr ?? '').toList();

    // Step 2: Get the most up-to-date inspection result from DB
    await handlePackaging(); // This updates selectedResultId from DB

    // Step 3: Decide what should be selected
    if (selectedResultId.isNotEmpty) {
      // Match DB value to description
      int index = overAllResultStatusList.indexWhere(
            (element) => element.pGenRowID.toString() == selectedResultId,
      );
      if (index != -1) {
        selectedResult = statsList[index];
      } else {
        selectedResult = statsList.first; // fallback
      }
    } else {
      selectedResult = statsList.first;
    }

    setState(() {});
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

    List<POItemDtl> packList = ItemInspectionDetailHandler()
        .copyFindingDataToSpecification(packDetailList, packFindingList);

    if (packList.isNotEmpty) {
      packagePoItemDetalDetail = packList.first;
      selectedResultId = packagePoItemDetalDetail.overallInspectionResultID ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10.w,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Over All Result', style: TextStyle(fontSize: 14.sp)),
        Container(
          height: 45.h,
          width: MediaQuery.of(context).size.width * 0.3.w,
          child: DropdownButtonFormField<String>(
            value: selectedResult.isNotEmpty && statsList.contains(selectedResult)
                ? selectedResult
                : null,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: statsList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(fontSize: 12.sp)),
              );
            }).toList(),
            onChanged: (String? newValue) async {
              if (newValue != null) {
                setState(() {
                  selectedResult = newValue;
                  int index = statsList.indexOf(newValue);
                  String newId =
                  overAllResultStatusList[index].pGenRowID.toString();

                  poItemDtl.overallInspectionResultID = newId;
                  itemMeasurementModal.inspectionResultID =
                      overAllResultStatusList[index].pGenRowID;
                });

                // Update DB and fetch updated record
                final updatedRow =
                await ItemInspectionDetailHandler().updateOverAllResult(
                  poItemDtl,
                );

                print("Updated DB row: $updatedRow");
              }
            },
          ),
        ),
      ],
    );
  }


  // Future<void> handleSpinner() async {
  //   overAllResultStatusList = await GeneralMasterHandler.getGeneralList(FEnumerations.overallResultStatusGenId);
  //
  //   if (overAllResultStatusList.isNotEmpty) {
  //     for (int i = 0; i < overAllResultStatusList.length; i++) {
  //       statsList.add(overAllResultStatusList[i].mainDescr ?? '');
  //       if (overAllResultStatusList[i].pGenRowID == itemMeasurementModal.inspectionResultID) {
  //         selectedResultPos = i;
  //       }
  //     }
  //     selectedResult = statsList[selectedResultPos];
  //   }
  //
  // }
}
