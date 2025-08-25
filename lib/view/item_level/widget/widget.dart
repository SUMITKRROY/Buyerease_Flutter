import 'package:buyerease/model/po_item_dtl_model.dart';
import 'package:flutter/material.dart';

import '../../../services/general/GeneralMasterHandler.dart';
import '../../../utils/app_constants.dart';

class HoleOverAllResultDropdown extends StatelessWidget {
  final POItemDtl packagePoItemDetalDetail;
  final void Function(String? newResultID) onResultChanged;

  const HoleOverAllResultDropdown({
    super.key,
    required this.packagePoItemDetalDetail,
    required this.onResultChanged,
  });

  Future<Map<String, String>> handleHoleOverAllResult() async {
    final resultStatusList = await GeneralMasterHandler.getGeneralList(
      FEnumerations.overallResultStatusGenId,
    );

    Map<String, String> statusMap = {};

    if (resultStatusList != null && resultStatusList.isNotEmpty) {
      for (var model in resultStatusList) {
        statusMap[model.mainDescr ?? ""] = model.pGenRowID ?? "";
      }
    }

    return statusMap;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: handleHoleOverAllResult(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final statusMap = snapshot.data!;

        // Initial selected key based on ID
        String selectedDescr = statusMap.entries.firstWhere(
              (entry) => entry.value == packagePoItemDetalDetail.overallInspectionResultID,
          orElse: () => const MapEntry("", ""),
        ).key;

        return StatefulBuilder(
          builder: (context, setState) {
            return DropdownButton<String>(
              isExpanded: true,
              value: selectedDescr.isNotEmpty ? selectedDescr : null,
              hint: const Text('Select Overall Result'),
              items: statusMap.keys.map((descr) {
                return DropdownMenuItem<String>(
                  value: descr,
                  child: Text(descr),
                );
              }).toList(),
              onChanged: (String? newDescr) {
                if (newDescr != null) {
                  setState(() {
                    selectedDescr = newDescr;
                  });

                  final selectedId = statusMap[newDescr];
                  onResultChanged(selectedId);
                }
              },
            );
          },
        );
      },
    );
  }
}

