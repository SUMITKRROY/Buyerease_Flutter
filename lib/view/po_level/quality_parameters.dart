import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/add_image_icon.dart';
import '../../model/digitals_upload_model.dart';
import '../../model/inspection_model.dart';
import '../../model/po_item_dtl_model.dart';
import '../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../model/quality_parameter_model.dart';
import '../../services/poitemlist/po_item_dtl_handler.dart';
import '../../utils/app_constants.dart';

class QualityParameters extends StatefulWidget {
  final String pRowId;
  final InspectionModal inspectionModal;
  final VoidCallback? onChanged;

  const QualityParameters({
    Key? key,
    required this.pRowId,
    this.onChanged,
    required this.inspectionModal,
  }) : super(key: key);

  @override
  _QualityParametersState createState() => _QualityParametersState();
}

class _QualityParametersState extends State<QualityParameters> {
  List<QualityParameter> _qualityParameters = [];
  List<POItemDtl> poItems = [];
  bool isLoading = true;

  Map<String, bool> checkboxStates = {};
  Map<String, String> radioStates = {};
  Map<String, String> dropdownSelections = {};
  Map<String, String> remarks = {};
  Map<String, int> imageCounts = {};
  String returnPRowID = "";

  @override
  void initState() {
    super.initState();
    fetchItemsAndThenQualityParameters();
  }

  
  Future<void> fetchItemsAndThenQualityParameters() async {
    await fetchItemsByQRHdrID();
    await _fetchQualityParameters();
    // setQualityParameterAdaptor();
  }


  // Future<void> setQualityParameterAdaptor() async {
  //   // Fetch list of quality parameters (this method needs to be implemented)
  //   List<QualityParameter> list = await ItemInspectionDetailHandler().getListQualityParameter(
  //
  //  inspectionModal: widget.inspectionModal, QRHdrID: poItems.first.qrHdrID ?? '', QRPOItemHdrID: poItems.first.qrpoItemHdrID ?? '',
  //   );
  //
  //   // Initialize or clear the list
  //   _qualityParameters.clear();
  //
  //   _qualityParameters.addAll(list);
  //
  //
  // }


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
      final result = await ItemInspectionDetailHandler().getListQualityParameterForItemLevel(widget.inspectionModal);

      developer.log("widget.inspectionModal: ${jsonEncode(widget.inspectionModal)}");

      setState(() {
        _qualityParameters = result;
        developer.log(
            "getListQualityParameter Fetched Parameters: ${jsonEncode(_qualityParameters)}");
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
    // ✅ Auto-select checkbox if IsApplicable == 1
    checkboxStates.putIfAbsent(title, () => param.isApplicable == 1);

    final options = parseDropdownOptions(param.optionValue);
    final selectedCode = param.optionSelected?.toString() ??
        (options.isNotEmpty ? options.first.code : "0");

    dropdownSelections.putIfAbsent(
      title,
          () => options.isNotEmpty
          ? options
          .firstWhere((opt) => opt.code == selectedCode,
          orElse: () => options.first)
          .label
          : "",
    );

    // ✅ Pre-fill remarks if available
    remarks.putIfAbsent(title, () => param.remarks ?? "");

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
            _updateThedataForParam(param);
            widget.onChanged?.call();
          },
          controlAffinity: ListTileControlAffinity.trailing,
        ),
        if (checkboxStates[title] == true)
          _buildSharedFields(title, param, options),
      ],
    );
  }


  Widget _buildRadioTile(String title, QualityParameter param) {
    // ✅ Pre-select radio based on OptionSelected
    // Assuming OptionSelected = 1 means Yes, 0 means No
    radioStates.putIfAbsent(
      title,
          () => (param.optionSelected == 1) ? "Yes" : "No",
    );

    final options = parseDropdownOptions(param.optionValue);
    final selectedCode = param.optionSelected?.toString() ??
        (options.isNotEmpty ? options.first.code : "0");

    dropdownSelections.putIfAbsent(
      title,
          () => options.isNotEmpty
          ? options
          .firstWhere((opt) => opt.code == selectedCode,
          orElse: () => options.first)
          .label
          : "",
    );

    // ✅ Pre-fill remarks
    remarks.putIfAbsent(title, () => param.remarks ?? "");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                  _updateThedataForParam(param);
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
                  _updateThedataForParam(param);
                  widget.onChanged?.call();
                },
              ),
            ),
          ],
        ),
        // ✅ Only show fields if "Yes" is selected
        if (radioStates[title] == "Yes")
          _buildSharedFields(title, param, options),
      ],
    );
  }


  String getAppearanceTitle(QualityParameter param) {
    return (param.mainDescr ?? '').trim();
  }

  Future<void> _updateThedata() async {
    // QualityParameter myQualityParameter = ...; // create or get a valid instance
    // POItemDtl myPOItemDtl = ...; // create or get a valid instance
    developer.log("");
    await ItemInspectionDetailHandler().updateQualityParameter(
      qualityParameter: _qualityParameters.first,
      poItemDtl: poItems.first,
    );
  }

  Widget _buildSharedFields(
    String title,
    QualityParameter param,
    List<DropdownOption> options,
  ) {
    final appearanceTitle = getAppearanceTitle(param);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (options.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: DropdownButton<String>(
              value: dropdownSelections[title]?.isNotEmpty == true && 
                     options.any((opt) => opt.label == dropdownSelections[title])
                  ? dropdownSelections[title]
                  : null,
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  dropdownSelections[title] = value!;
                });
                _updateThedataForParam(param);
                widget.onChanged?.call();
              },
              items: options
                  .map((opt) => DropdownMenuItem(
                        value: opt.label,
                        child: Text(opt.label),
                      ))
                  .toList(),
            ),
          ),
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
              _updateThedataForParam(param);
              widget.onChanged?.call();
            },
          ),
        ),
        if (param.imageRequired != 0 && poItems.isNotEmpty)
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

    await ItemInspectionDetailHandler().updateQualityParameterForItemLevel(
      qualityParameter: param,
      inspectionModal: widget.inspectionModal,
    );
  }

  Future<void> handleQualityImage(
      DigitalsUploadModel digitalsUploadModal) async {
    // Generate pRowID if invalid
    if (digitalsUploadModal.pRowID == null ||
        digitalsUploadModal.pRowID!.length != 10) {
      digitalsUploadModal.pRowID =
          await ItemInspectionDetailHandler().generatePK(
        FEnumerations.tableNameQrpoItemDtlImage,
      );
    }

    // Save the image and get back the new pRowID from DB
    final imgPRowID = await updateDBWithImage(digitalsUploadModal);
    print('Image saved ID: $imgPRowID');

    if (imgPRowID != null &&
        imgPRowID.isNotEmpty &&
        returnPRowID.isNotEmpty &&
        returnPRowID.toLowerCase() != 'null') {
      final dtlList = await ItemInspectionDetailHandler()
          .getListQualityParameterAccordingRowId(returnPRowID!);

      if (dtlList.isNotEmpty) {
        final mPo = dtlList.first;

        if (mPo.digitals != null &&
            mPo.digitals!.isNotEmpty &&
            mPo.digitals!.toLowerCase() != 'null') {
          mPo.digitals = '${mPo.digitals}, $imgPRowID';
        } else {
          mPo.digitals = imgPRowID;
        }

        if (_qualityParameters.isNotEmpty) {
          _qualityParameters.first.digitals = mPo.digitals;
        }

        await ItemInspectionDetailHandler()
            .updateDigitalsQualityMeasurement(mPo);
      }
    }
  }

  Future<String?> updateDBWithImage(
      DigitalsUploadModel digitalsUploadModal) async {
    return await ItemInspectionDetailHandler().updateImageFromQualityParameter(
      qrHdrID: widget.inspectionModal.pRowID ?? '',
      qrPOItemHdrID: returnPRowID ?? '',
      digitalsUploadModal: digitalsUploadModal,
      itemID: widget.inspectionModal.itemID ?? '',
    );
  }

  Future<void> updateQualityParameterInspectionLevel() async {
    if (_qualityParameters.isNotEmpty) {
      returnPRowID =
          (await ItemInspectionDetailHandler().updateQualityParameterForItemLevel(
        qualityParameter: _qualityParameters.first,
        inspectionModal: widget.inspectionModal,
      ))!;
    }
  }
}

class DropdownOption {
  final String label;
  final String code;

  DropdownOption({required this.label, required this.code});
}
