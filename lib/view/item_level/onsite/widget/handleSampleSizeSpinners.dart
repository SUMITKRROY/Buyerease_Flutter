import 'package:buyerease/components/over_all_dropdown.dart';
import 'package:buyerease/model/simple_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../model/InsLvHdrModal.dart';
import '../../../../model/on_site_modal.dart';
import '../../../../services/InsLvHdrHandler.dart';
import '../../../../services/general/GeneralMasterHandler.dart';
import '../../../../services/general/GeneralModel.dart';
import '../../../../services/poitemlist/po_item_dtl_handler.dart';
import '../../../../utils/app_constants.dart';


class HandleSampleSizeSpinners extends StatefulWidget {
  final List<OnSiteModal> onSiteList;

  const HandleSampleSizeSpinners({super.key, required this.onSiteList});

  @override
  State<HandleSampleSizeSpinners> createState() => _HandleSampleSizeSpinnersState();
}

class _HandleSampleSizeSpinnersState extends State<HandleSampleSizeSpinners> {
  List<SampleModel> sampleModals = [];
  List<String> sampleList = [];
  List<int?> selectedIndexes = List.filled(10, null);
  bool spinnerSampleSizeTouched = false;

  @override
  void initState() {
    super.initState();
    handleSampleSizeSpinners(widget.onSiteList);
  }

  Future<void> handleSampleSizeSpinners(List<OnSiteModal> onSiteList) async {
    spinnerSampleSizeTouched = false;

    sampleModals = await POItemDtlHandler.getSampleSizeList();

    sampleList = sampleModals
        .map((e) => "${e.mainDescr} (${e.sampleVal})")
        .toList();

    // Match selected index for each onSite entry
    for (int i = 0; i < onSiteList.length; i++) {
      final matchIndex = sampleModals.indexWhere((sample) =>
      sample.sampleCode == onSiteList[i].sampleSizeID);
      if (matchIndex != -1) {
        selectedIndexes[i] = matchIndex;
      }
    }

    setState(() {});
  }

  void handleSampleSelection(int dropdownIndex, int selectedIndex) {
    if (dropdownIndex >= widget.onSiteList.length) return;

    final onSite = widget.onSiteList[dropdownIndex];
    final selectedSample = sampleModals[selectedIndex];

    onSite.pRowID = onSite.pRowID;
    if (onSite.inspectionLevelID != null) {
      onSite.inspectionLevelID = onSite.inspectionLevelID;
    }

    onSite.sampleSizeID = selectedSample.sampleCode;
    onSite.sampleSizeValue = selectedSample.sampleVal.toString();

    updateOnSite(onSite);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(10, (index) {
        return DropdownButtonFormField<int>(
          value: selectedIndexes[index],
          decoration: InputDecoration(
            labelText: "Sample Size ${index + 1}",
            border: OutlineInputBorder(),
          ),
          items: List.generate(sampleList.length, (i) {
            return DropdownMenuItem<int>(
              value: i,
              child: Text(sampleList[i]),
            );
          }),
          onTap: () {
            // Mimics setOnTouchListener logic
            spinnerSampleSizeTouched = true;
          },
          onChanged: (value) {
            if (!spinnerSampleSizeTouched || value == null) return;
            spinnerSampleSizeTouched = false;

            setState(() {
              selectedIndexes[index] = value;
              handleSampleSelection(index, value);
            });
          },
        );
      }),
    );
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
}
