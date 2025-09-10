import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/add_image_icon.dart';
import '../../main.dart';
import '../../model/inspection_model.dart';
import '../../model/po_item_dtl_model.dart';
import '../../model/quality_parameter_model.dart';
import '../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../services/poitemlist/po_item_dtl_handler.dart';

class QualityParametersResult extends StatefulWidget {
  final String id;
  final String pRowId;
  final POItemDtl poItemDtl;
  final InspectionModal inspectionModal;
  final VoidCallback? onChanged;

  const QualityParametersResult({
    Key? key,
    required this.pRowId,
    this.onChanged,
    required this.inspectionModal, required this.id, required this.poItemDtl,
  }) : super(key: key);

  @override
  State<QualityParametersResult> createState() => _QualityParametersResultState();
}

class _QualityParametersResultState extends State<QualityParametersResult> {
  List<QualityParameter> _qualityParameters = [];
  List<POItemDtl> poItems = [];
  bool isLoading = true;

  Map<String, bool> checkboxStates = {};
  Map<String, String> radioStates = {};
  Map<String, String> dropdownSelections = {};
  Map<String, String> remarks = {};
  Map<String, int> imageCounts = {};

  @override
  void initState() {
    super.initState();
    fetchItemsAndThenQualityParameters();
  }

  Future<void> fetchItemsAndThenQualityParameters() async {
    await fetchItemsByQRHdrID();
    await _fetchQualityParameters();

  }

  Future<void> fetchItemsByQRHdrID() async {
    try {
      setState(() => isLoading = true);
      poItems = await POItemDtlHandler.getItemList(widget.pRowId);
      developer.log("poDetail is here ${jsonEncode(poItems)}");
      setState(() => isLoading = false);
    } catch (e) {
      developer.log('Error fetching QRPOItemDtl: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchQualityParameters() async {
    if (poItems.isEmpty) {
      developer.log("No PO items found.");
      setState(() => isLoading = false);
      return;
    }

    setState(() => isLoading = true);

    try {

      final result = await ItemInspectionDetailHandler()
          .getListQualityParameter( inspectionModal: widget.inspectionModal, QRHdrID: poItems.first.qrHdrID ?? '', QRPOItemHdrID: poItems.first.qrpoItemHdrID ?? '');

      // developer.log("Fetched Parameters: ${jsonEncode(getQualityList)}");

      developer.log("Fetched Parameters: ${jsonEncode(result)}");

      setState(() {
        _qualityParameters = result;
        isLoading = false;
      });

    } catch (e) {
      setState(() => isLoading = false);
      developer.log("Error: $e");
    }
  }

  List<DropdownOption> parseDropdownOptions(String? optionValue) {
    if (optionValue == null || optionValue.isEmpty) return [];

    final cleanPart = optionValue.split(')S(').first;

    return cleanPart
        .split('|')
        .map((item) {
      final parts = item.split('~');
      if (parts.length == 2) {
        return DropdownOption(label: parts[0], code: parts[1]);
      }
      return null;
    })
        .whereType<DropdownOption>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: _qualityParameters.map((param) {
                final title = param.mainDescr ?? "Untitled";

                if (param.promptType == 0) {
                  return _buildCheckboxTile(title, param);
                } else {
                  return _buildRadioTile(title, param);
                }
              }).toList(),
            ),
          ),
        ),
        // Removed Save button here
      ],
    );
  }

  Widget _buildCheckboxTile(String title, QualityParameter param) {
    checkboxStates.putIfAbsent(title, () => false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: Text(title, style: TextStyle(fontSize: 12.sp)),
          value: checkboxStates[title],
          onChanged: (val) {
            setState(() {
              checkboxStates[title] = val ?? false;
            });
            _updateThedataForParam(param); // <-- call with the current param
            widget.onChanged?.call();
          },
          controlAffinity: ListTileControlAffinity.trailing,
        ),
        if (checkboxStates[title] == true)
          _buildSharedFields(title, param, ),
      ],
    );
  }

  Widget _buildRadioTile(String title, QualityParameter param) {
    radioStates.putIfAbsent(title, () => "No");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(title, style: TextStyle(fontSize: 12.sp)),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text("Yes", style: TextStyle(fontSize: 12.sp)),
                value: "Yes",
                groupValue: radioStates[title],
                onChanged: (value) {
                  setState(() {
                    radioStates[title] = value!;
                  });
                  _updateThedataForParam(param); // <-- call with the current param
                  widget.onChanged?.call();
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text("No", style: TextStyle(fontSize: 12.sp)),
                value: "No",
                groupValue: radioStates[title],
                onChanged: (value) {
                  setState(() {
                    radioStates[title] = value!;
                  });
                  _updateThedataForParam(param); // <-- call with the current param
                  widget.onChanged?.call();
                },
              ),
            ),
          ],
        ),
        if (radioStates[title] != null)
          _buildSharedFields(title, param,),
      ],
    );
  }
  String getAppearanceTitle(QualityParameter param) {
    return (param.mainDescr ?? '').trim();
  }


  Future<void> _updateThedata() async {
    // QualityParameter myQualityParameter = ...; // create or get a valid instance
    // POItemDtl myPOItemDtl = ...; // create or get a valid instance

    await ItemInspectionDetailHandler().updateQualityParameter(
      qualityParameter: _qualityParameters.first,
      poItemDtl: poItems.first,
    );
  }
  Widget _buildSharedFields(
      String title,
      QualityParameter param,
     // List<DropdownOption> options,
      ) {
    final appearanceTitle = getAppearanceTitle(param);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Remarks',
              isDense: true,
            ),
            initialValue: remarks[title] ?? '',
            onChanged: (value) {
              setState(() {
                remarks[title] = value;
              });
              widget.onChanged?.call();
            },
          ),
        ),
        if (param.imageRequired != 0)
          AddImageIcon(
            title: appearanceTitle,
            id: poItems.first.customerItemRef ?? "",
            pRowId: '',
            poItemDtl: poItems.first,
            onImageAdded: () {
              saveChanges();
            },
          )
      ],
    );
  }

  Future<void> saveChanges() async {
    try {
      setState(() {
        isLoading = true;
      });
      _updateThedata();
      // Removed call to updateQualityParameter
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

  Future<void> _updateThedataForParam(QualityParameter param) async {
    // Find the matching POItemDtl (adjust logic as needed)
    final poItem = poItems.isNotEmpty ? poItems.first : null;
    if (poItem == null) return;

    // Update the param's state based on UI (checkbox/radio/dropdown/remarks)
    // Example for checkbox:
    param.isApplicable = checkboxStates[param.mainDescr] == true ? 1 : 0;
    // Example for radio:
    param.optionSelected = radioStates[param.mainDescr] == "Yes" ? 1 : 0;
    // Example for remarks:
    param.remarks = remarks[param.mainDescr] ?? "";

    await ItemInspectionDetailHandler().updateQualityParameter(
      qualityParameter: param,
      poItemDtl: poItem,
    );
  }


}


class DropdownOption {
  final String label;
  final String code;

  DropdownOption({required this.label, required this.code});
}
