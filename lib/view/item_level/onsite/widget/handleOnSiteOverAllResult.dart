import 'package:buyerease/components/over_all_dropdown.dart';
import 'package:buyerease/model/simple_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../model/InsLvHdrModal.dart';
import '../../../../model/on_site_modal.dart';
import '../../../../model/po_item_dtl_model.dart';
import '../../../../services/InsLvHdrHandler.dart';
import '../../../../services/general/GeneralMasterHandler.dart';
import '../../../../services/general/GeneralModel.dart';
import '../../../../services/poitemlist/po_item_dtl_handler.dart';
import '../../../../utils/app_constants.dart';




class HandleOnSiteOverAllResult extends StatefulWidget {
  final List<OnSiteModal> onSiteList;

  const HandleOnSiteOverAllResult({super.key, required this.onSiteList});

  @override
  State<HandleOnSiteOverAllResult> createState() =>
      _HandleOnSiteOverAllResultState();
}

class _HandleOnSiteOverAllResultState
    extends State<HandleOnSiteOverAllResult> {
  List<GeneralModel> statusOptions = [];
  List<String?> statusLabels = [];
  List<int?> selectedIndexes = List.filled(10, null);
  bool spinnerTouched = false;
  List<GeneralModel> _statusOptions = [];
  int? _selectedOverAllResultIndex;
  POItemDtl packagePoItemDetalDetail = POItemDtl();

  @override
  void initState() {
    super.initState();
    handleOnSiteOverAllResult(widget.onSiteList);
  }

  Future<void> handleOnSiteOverAllResult(List<OnSiteModal> onSiteList) async {
    spinnerTouched = false;
    statusOptions = await GeneralMasterHandler.getGeneralList(
      FEnumerations.overallResultStatusGenId,
    );
    statusLabels = statusOptions.map((e) => e.mainDescr).toList();
    for (int i = 0; i < onSiteList.length; i++) {
      final idx = statusOptions.indexWhere((opt) =>
      opt.pGenRowID == onSiteList[i].inspectionResultID);
      if (idx != -1) selectedIndexes[i] = idx;
    }

    setState(() {});
  }

  void handleSelection(int idx, int selectedIdx) {
    final onSite = widget.onSiteList[idx];
    final status = statusOptions[selectedIdx];

    onSite.inspectionResultID = status.pGenRowID;

    updateOnSite(onSite);
    updateOverAllResultOnsite();
    handleOverAllResult();
  }

  @override
  Widget build(BuildContext context) {
    if (statusLabels.isEmpty) {
      return const Text("Loading...");
    }
    return Column(
      children: List.generate(10, (i) {
        return DropdownButtonFormField<int>(
          value: selectedIndexes[i],
          decoration: InputDecoration(
            labelText: "Overall Result ${i + 1}",
            border: const OutlineInputBorder(),
          ),
          items: List.generate(statusLabels.length, (j) {
            return DropdownMenuItem(value: j, child: Text(statusLabels[j]!));
          }),
          onTap: () {
            spinnerTouched = true;
          },
          onChanged: (value) {
            if (!spinnerTouched || value == null) return;
            spinnerTouched = false;
            setState(() {
              selectedIndexes[i] = value;
              handleSelection(i, value);
            });
          },
        );
      }),
    );
  }


  Future<void> updateOverAllResultOnsite() async {
    List<String> statusList = [];
    int selectedPos = 0;

    final overAllResultStatusList = await GeneralMasterHandler.getGeneralList(
      FEnumerations.overallResultStatusGenId,
    );

    if (overAllResultStatusList.isNotEmpty) {
      for (int i = 0; i < overAllResultStatusList.length; i++) {
        statusList.add(overAllResultStatusList[i].mainDescr ?? '');
        if (overAllResultStatusList[i].pGenRowID ==
            packagePoItemDetalDetail.onSiteTestInspectionResultID) {
          selectedPos = i;
        }
      }

      setState(() {
        _statusOptions = overAllResultStatusList;
        _selectedOverAllResultIndex = selectedPos;
      });
    }
  }

  void updateOnSite(OnSiteModal onSiteModalItem) async {
    if (onSiteModalItem.pRowID != null) {
      final List<GeneralModel> onSiteMasterList = await GeneralMasterHandler.getGeneralList(
        FEnumerations.onsiteOverallResultStatusGenId,
      );

      debugPrint("onSiteMasterList size: ${onSiteMasterList.length}");

      await POItemDtlHandler.updateOnSite(onSiteModalItem);

      /*
    // Optional block: uncomment if needed in future
    for (var item in onSiteMasterList) {
      if (onSiteModalItem.pRowID == item.pGenRowID) {
        await POItemDtlHandler.updateOnSite(onSiteModalItem);
      }
    }
    */
    }


  }
  void handleOverAllResult() {
    final detail = packagePoItemDetalDetail;

    var fail = FEnumerations.overAllFailResult;
    var hold = FEnumerations.overAllHoldResult;
    var desc = FEnumerations.overAllDescResult;

    // FAIL conditions
    if (detail.itemMeasurementInspectionResultID != null &&
        detail.itemMeasurementInspectionResultID == fail) {
      detail.overallInspectionResultID = detail.itemMeasurementInspectionResultID;
    } else if (detail.workmanshipInspectionResultID != null &&
        detail.workmanshipInspectionResultID == fail) {
      detail.overallInspectionResultID = detail.workmanshipInspectionResultID;
    } else if (detail.pkgMeInspectionResultID != null &&
        detail.pkgMeInspectionResultID == fail) {
      detail.overallInspectionResultID = detail.pkgMeInspectionResultID;
    }

    // HOLD conditions
    else if (detail.itemMeasurementInspectionResultID != null &&
        detail.itemMeasurementInspectionResultID == hold) {
      detail.overallInspectionResultID = detail.itemMeasurementInspectionResultID;
    } else if (detail.workmanshipInspectionResultID != null &&
        detail.workmanshipInspectionResultID == hold) {
      detail.overallInspectionResultID = detail.workmanshipInspectionResultID;
    } else if (detail.pkgMeInspectionResultID != null &&
        detail.pkgMeInspectionResultID == hold) {
      detail.overallInspectionResultID = detail.pkgMeInspectionResultID;
    }

    // DESC conditions
    else if (detail.pkgMeInspectionResultID != null &&
        detail.pkgMeInspectionResultID == desc) {
      detail.overallInspectionResultID = detail.pkgMeInspectionResultID;
    } else if (detail.onSiteTestInspectionResultID != null &&
        detail.onSiteTestInspectionResultID == desc) {
      detail.overallInspectionResultID = detail.onSiteTestInspectionResultID;
    } else if (detail.barcodeInspectionResultID != null &&
        detail.barcodeInspectionResultID == desc) {
      detail.overallInspectionResultID = detail.barcodeInspectionResultID;
    } else if (detail.pkgAppInspectionResultID != null &&
        detail.pkgAppInspectionResultID == desc) {
      detail.overallInspectionResultID = detail.pkgAppInspectionResultID;
    }

    handleHoleOverAllResult(); // Final call
  }


  Future<void> handleHoleOverAllResult() async {
    final statusList = <String>[];
    final overAllResultStatusList = await GeneralMasterHandler.getGeneralList(
      FEnumerations.overallResultStatusGenId,
    );

    if (overAllResultStatusList.isNotEmpty) {
      int selectedIndex = 0;

      for (int i = 0; i < overAllResultStatusList.length; i++) {
        statusList.add(overAllResultStatusList[i].mainDescr ?? "");
        if (overAllResultStatusList[i].pGenRowID ==
            packagePoItemDetalDetail.overallInspectionResultID) {
          selectedIndex = i;
        }
      }

      setState(() {
        // _holeResultOptions = overAllResultStatusList;
        // _selectedHoleResultIndex = selectedIndex;
      });
    }
  }

}
