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





class HandleDescriptionSpinner extends StatefulWidget {
  final List<OnSiteModal> onSiteList;

  HandleDescriptionSpinner({required this.onSiteList});

  @override
  _HandleDescriptionSpinnerState createState() => _HandleDescriptionSpinnerState();
}

class _HandleDescriptionSpinnerState extends State<HandleDescriptionSpinner> {
  List<InsLvHdrModal> insLvHdrModals = [];
  List<String> inspectionAbbrvs = [];
  List<int?> selectedIndexes = List.filled(10, null);
  bool spinnerTouched = false;

  @override
  void initState() {
    super.initState();
    handleDescriptionSpinner(widget.onSiteList);
  }

  Future<void> handleDescriptionSpinner(List<OnSiteModal> onSiteList) async {
    // Simulate DB/API fetch
    insLvHdrModals = await InsLvHdrHandler.getInsLvHdrList();

    inspectionAbbrvs = insLvHdrModals.map((e) => e.inspAbbrv).toList();

    for (int i = 0; i < onSiteList.length; i++) {
      final site = onSiteList[i];
      final index = insLvHdrModals.indexWhere((modal) => modal.pRowID == site.inspectionLevelID);
      if (index != -1) {
        selectedIndexes[i] = index;
      }
    }

    setState(() {});
  }

  void handleSelection(int dropdownIndex, int selectedIndex) {
    if (dropdownIndex >= widget.onSiteList.length) return;

    final selectedModal = insLvHdrModals[selectedIndex];
    final onSiteModal = widget.onSiteList[dropdownIndex];

    onSiteModal.inspectionLevelID = selectedModal.pRowID;
    updateOnSite(onSiteModal);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(10, (index) {
        return DropdownButtonFormField<int>(
          value: selectedIndexes[index],
          decoration: InputDecoration(
            labelText: "Select Inspection Level ${index + 1}",
            border: OutlineInputBorder(),
          ),
          items: List.generate(inspectionAbbrvs.length, (i) {
            return DropdownMenuItem<int>(
              value: i,
              child: Text(inspectionAbbrvs[i]),
            );
          }),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedIndexes[index] = value;
                handleSelection(index, value);
              });
            }
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
