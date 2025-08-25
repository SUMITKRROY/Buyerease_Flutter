import 'dart:convert';
import 'dart:developer' as developer;

import 'package:buyerease/model/po_item_dtl_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/theame_data.dart';
import '../database/table/qr_po_item_hdr_table.dart';
import '../model/item_measurement_modal.dart';
import '../services/general/GeneralMasterHandler.dart';
import '../services/general/GeneralModel.dart';
import '../utils/app_constants.dart';

class SOverAllDropdown extends StatefulWidget {
  final POItemDtl poItemDtl;
  final String selectInspectionResultId; // <-- fixed name casing
  final ValueChanged<String>? onChange;

  const SOverAllDropdown({
    super.key,
    required this.poItemDtl,
    required this.selectInspectionResultId,
    this.onChange,
  });

  @override
  State<SOverAllDropdown> createState() => _SOverAllDropdownState();
}

class _SOverAllDropdownState extends State<SOverAllDropdown> {
  late POItemDtl poItemDtl;
  String selectedResult = '';
  List<String> statsList = [];
  List<GeneralModel> overAllResultStatusList = [];
  ItemMeasurementModal itemMeasurementModal = ItemMeasurementModal();

  @override
  void initState() {
    super.initState();
    poItemDtl = widget.poItemDtl;
    developer.log("Updated OverallInspectionResultID to ${(widget.selectInspectionResultId)}");
    handleSpinner();
  }

  Future<void> handleSpinner() async {
    overAllResultStatusList = await GeneralMasterHandler.getGeneralList(
      FEnumerations.overallResultStatusGenId,
    );

    statsList = overAllResultStatusList.map((e) => e.mainDescr ?? '').toList();

    // Auto select from passed inspection result ID
    if (widget.selectInspectionResultId.isNotEmpty) {
      int index = overAllResultStatusList.indexWhere(
            (element) =>
        element.pGenRowID.toString() == widget.selectInspectionResultId,
      );
      if (index != -1) {
        selectedResult = statsList[index];
        itemMeasurementModal.inspectionResultID =
            overAllResultStatusList[index].pGenRowID;
      } else {
        selectedResult = statsList.isNotEmpty ? statsList[0] : '';
      }
    } else {
      selectedResult = statsList.isNotEmpty ? statsList[0] : '';
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10.w,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Over All Result',
          style: TextStyle(fontSize: 14.sp),
        ),
        Container(
          height: 45.h,
          width: MediaQuery.of(context).size.width * 0.3.w,
          child: DropdownButtonFormField<String>(
            isExpanded: false,
            value: statsList.contains(selectedResult) ? selectedResult : null,
            decoration: const InputDecoration(
              // border: OutlineInputBorder(),
            ),
            items: statsList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(fontSize: 12.sp)),
              );
            }).toList(),
            onChanged: (String? newValue) async {
              if (newValue == null) return;

              setState(() {
                selectedResult = newValue;
                int index = statsList.indexOf(newValue);
                itemMeasurementModal.inspectionResultID =
                    overAllResultStatusList[index].pGenRowID;
              });

              // Update database

              // Trigger parent callback
              widget.onChange?.call(
                itemMeasurementModal.inspectionResultID.toString(),
              );
            },
          ),
        ),
      ],
    );
  }
}


