import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:buyerease/components/add_image_icon.dart';
import 'package:buyerease/model/digitals_upload_model.dart';
import 'package:buyerease/model/simple_model.dart';
import 'package:buyerease/utils/camera.dart';
import 'package:buyerease/view/barcode/widget/custom_barcode_card.dart';
import 'package:flutter/material.dart';

import '../../components/over_all_dropdown.dart';
import '../../components/over_all_dropdown_section_wise.dart';
import '../../components/remarks.dart';
import '../../config/theame_data.dart';
import '../../model/po_item_dtl_model.dart';
import '../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../services/general/GeneralMasterHandler.dart';
import '../../services/general/GeneralModel.dart';
import '../../services/poitemlist/po_item_dtl_handler.dart';
import '../../utils/app_constants.dart';

class BarCode extends StatefulWidget {
  final String id;
  final POItemDtl poItemDtl;
  final VoidCallback onChanged; // <-- Add this

  const BarCode(
      {super.key,
      required this.id,
      required this.onChanged,
      required this.poItemDtl});

  @override
  State<BarCode> createState() => _BarCodeState();
}

class _BarCodeState extends State<BarCode> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  final specificationController = TextEditingController();
  final visualController = TextEditingController();
  // code java to dart
  int selectedUnitSampleIndex = 0;
  int selectedInnerSampleIndex = 0;
  int selectedMasterSampleIndex = 0;
  int selectedPalletSampleIndex = 0;

  List<String> sampleDropdownItems = [];
  List<SampleModel> sampleDropdownModals = [];

  // over all result data
  List<String> statusDropdownItems = [];
  List<GeneralModel> overAllStatusModels = [];

  int selectedMasterStatusIndex = 0;
  int selectedInnerStatusIndex = 0;
  int selectedUnitStatusIndex = 0;
  int selectedPalletStatusIndex = 0;
  List<String> overallStatusDropdownItems = [];
  List<GeneralModel> overallStatusModels = [];
  int selectedOverallStatusIndex = 0;

  String? barcodeUnitVisual;
  String? barcodeInnerVisual;
  String? barcodeMasterVisual;
  String? barcodePalletVisual;

  String? barcodeUnitScan;
  String? barcodeInnerScan;
  String? barcodeMasterScan;
  String? barcodePalletScan;

  String? _dropDownValue;
  String? remark;
  List dataBarCode = ['Unit Packing', 'Master Packing'];
  List<String> base64string = [];
  String? imageType;
  String imageName = '';
  late POItemDtl poItemDtl;
  POItemDtl packagePoItemDetalDetail = POItemDtl();

  Map<String, List<String>> barcodeAttachmentMap = {
    "Unit Barcode": [],
    "Inner Barcode": [],
    "Master Barcode": [],
    "Pallet Barcode": [],
  };

  Map<String, int> barcodeAttachmentCount = {
    "Unit Barcode": 0,
    "Inner Barcode": 0,
    "Master Barcode": 0,
    "Pallet Barcode": 0,
  };
  TextEditingController editPackingBarcodeRemark = TextEditingController();
  void updateBarcodeUI() {
    // Clear all lists
    barcodeAttachmentMap.forEach((key, value) => value.clear());

    // Update count
    barcodeAttachmentCount
        .updateAll((key, value) => barcodeAttachmentMap[key]?.length ?? 0);

    setState(() {}); // Refresh UI
  }

  Map<String, TextEditingController> specificationControllers = {};
  Map<String, TextEditingController> visualControllers = {};

  @override
  void initState() {
    super.initState();
    poItemDtl = widget.poItemDtl;
    packagePoItemDetalDetail = widget.poItemDtl;
    developer.log("packagePoItemDetalDetail jsonEncode ${jsonEncode(packagePoItemDetalDetail)}");
    for (var type in ["Unit", "Inner", "Master", "Pallet"]) {
      specificationControllers[type] = TextEditingController();
      visualControllers[type] = TextEditingController();
      scanControllers[type] = TextEditingController(); // Add this map

      // Visual/Spec Auto-fill
      String? visual = getVisual(type);
      if (visual != null &&
          visual.trim().isNotEmpty &&
          visual.toLowerCase() != 'null') {
        visualControllers[type]!.text = visual;
        specificationControllers[type]!.text = visual;
      }

      // Scan Auto-fill
      String? scan = getScan(type);
      if (scan != null &&
          scan.trim().isNotEmpty &&
          scan.toLowerCase() != 'null') {
        scanControllers[type] = TextEditingController(text: scan);
      } else {
        scanControllers[type] = TextEditingController();
      }
    }
    handleBarcodeTab();
    // updateBarcodeUI();
  }

  String? getVisual(String type) {
    switch (type) {
      case "Unit":
        return poItemDtl.barcodeUnitVisual;
      case "Inner":
        return poItemDtl.barcodeInnerVisual;
      case "Master":
        return poItemDtl.barcodeMasterVisual;
      case "Pallet":
        return poItemDtl.barcodePalletVisual;
      default:
        return null;
    }
  }

  String? getScan(String type) {
    switch (type) {
      case "Unit":
        return poItemDtl.barcodeUnitScan;
      case "Inner":
        return poItemDtl.barcodeInnerScan;
      case "Master":
        return poItemDtl.barcodeMasterScan;
      case "Pallet":
        return poItemDtl.barcodePalletScan;
      default:
        return null;
    }
  }

  Map<String, TextEditingController> scanControllers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              buildOverallResultDropdown(),
              buildBarCodeUnitCard(),
              if (poItemDtl.ipQty != null && poItemDtl.ipQty! > 0)
                buildBarCodeCard("Inner Packing", "Inner Barcode"),
              if (poItemDtl.opQty != null && poItemDtl.opQty! > 0)
                buildBarCodeCard("Master Packing", "Master Barcode"),
              if (poItemDtl.palletQty != null && poItemDtl.palletQty! > 0)
                buildBarCodeCard("Pallet Packing", "Pallet Barcode"),
              Remarks(
                controller: editPackingBarcodeRemark,
                onChanged: (String value) {
                  packagePoItemDetalDetail.barcodeRemark = value;
                  widget.onChanged();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveChanges() async {
    setState(() {});
    widget.onChanged.call();
    updateOverallResultFromChildren(); // <-- add this
    updateBarCodeRemark();
    updateBarcodeUI(); // Refresh count
  }

  Widget buildBarCodeUnitCard() {
    return BarcodeCard(
      title: "Unit Packing",
      imageTitle: "Unit Barcode",
      sampleDropdownItems: sampleDropdownItems,
      sampleDropdownModals: sampleDropdownModals,
      selectedSampleIndex: selectedUnitSampleIndex,
      onSampleChanged: (index) {
        setState(() {
          selectedUnitSampleIndex = index;
          packagePoItemDetalDetail.barcodeUnitSampleSizeID =
              sampleDropdownModals[index].sampleCode;
        });
      },
      specController: specificationControllers["Unit"]!,
      visualController: visualControllers["Unit"]!,
      scanController: scanControllers["Unit"]!,
      resultDropdownItems: statusDropdownItems,
      resultModels: overAllStatusModels,
      selectedResultIndex: selectedUnitStatusIndex,
      onResultChanged: (index) {
        setState(() {
          selectedUnitStatusIndex = index;
          packagePoItemDetalDetail.barcodeUnitInspectionResultID =
              overAllStatusModels[index].pGenRowID;

          updateOverallResultFromChildren(); // <-- Add this
        });
      },

      /*     onResultChanged: (index) {
        setState(() {
          selectedUnitStatusIndex = index;
          packagePoItemDetalDetail.barcodeUnitInspectionResultID =
              overAllStatusModels[index].pGenRowID;

          if (packagePoItemDetalDetail.barcodeUnitInspectionResultID ==
              FEnumerations.overAllFailResult) {
            packagePoItemDetalDetail.barcodeInspectionResultID =
                packagePoItemDetalDetail.barcodeUnitInspectionResultID;
            updateOverResultBarcode();
          }
        });
      },*/
      barcodeId: widget.id,
      poItemDtl: poItemDtl,
      attachmentCount: barcodeAttachmentCount["Unit Barcode"] ?? 0,
      onImageAdded: () {
        widget.onChanged();
        updateBarcodeUI();
      },
      onVisualChanged: (String value) {
        packagePoItemDetalDetail.barcodeUnitVisual = value;
      },
      onScanChanged: (String value) {
        packagePoItemDetalDetail.barcodeUnitScan = value;
      },
    );
  }

  Widget buildBarCodeCard(String title, String imageTitle) {
    final attachmentCount = barcodeAttachmentCount[imageTitle] ?? 0;

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + dropdown + count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: selectedUnitSampleIndex,
                      items: List.generate(sampleDropdownItems.length, (index) {
                        return DropdownMenuItem(
                          value: index,
                          child: Text(sampleDropdownItems[index]),
                        );
                      }),
                      onChanged: (int? newIndex) {
                        if (newIndex != null) {
                          setState(() {
                            selectedUnitSampleIndex = newIndex;
                            packagePoItemDetalDetail.barcodeUnitSampleSizeID =
                                sampleDropdownModals[newIndex].sampleCode;
                          });
                        }
                      },
                    )

                    // DropdownButton<String>(
                    //   value: "A(5)",
                    //   items: const [
                    //     DropdownMenuItem(value: "A(5)", child: Text("A(5)", style: TextStyle(fontSize: 12))),
                    //     DropdownMenuItem(value: "B(2)", child: Text("B(2)", style: TextStyle(fontSize: 12))),
                    //   ],
                    //   onChanged: (val) => saveChanges(),
                    // ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Specification & Visual
            Row(
              children: [
                Expanded(child: TextField(decoration: _input("Specification"))),
                const SizedBox(width: 8),
                Expanded(child: TextField(decoration: _input("Visual"))),
              ],
            ),

            const SizedBox(height: 16),

            /// Scan + Result
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: TextField(
                        controller: scanControllers[title.split(' ')[0]],
                        decoration: _input("Scan"))),
                const SizedBox(width: 8),
                Expanded(
                    flex: 2,
                    child: DropdownButton<int>(
                      value: selectedMasterStatusIndex,
                      items: List.generate(statusDropdownItems.length, (index) {
                        return DropdownMenuItem<int>(
                          value: index,
                          child: Text(statusDropdownItems[index]),
                        );
                      }),
                      onChanged: (int? newIndex) {
                        if (newIndex != null) {
                          setState(() {
                            selectedMasterStatusIndex = newIndex;
                            packagePoItemDetalDetail
                                    .barcodeMasterInspectionResultID =
                                overAllStatusModels[newIndex].pGenRowID;

                            if (packagePoItemDetalDetail
                                    .barcodeMasterInspectionResultID ==
                                FEnumerations.overAllFailResult) {
                              packagePoItemDetalDetail
                                      .barcodeInspectionResultID =
                                  packagePoItemDetalDetail
                                      .barcodeMasterInspectionResultID;
                              updateOverResultBarcode();
                              //handleOverAllResult();
                            }
                          });
                        }
                      },
                    )

                    /*DropdownButtonFormField<String>(
                    value: "PASS",
                    items: const [
                      DropdownMenuItem(value: "PASS", child: Text("PASS", style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: "FAIL", child: Text("FAIL", style: TextStyle(fontSize: 12))),
                    ],
                    onChanged: (val) => saveChanges(),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),*/
                    ),
              ],
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: AddImageIcon(
                title: imageTitle,
                id: widget.id,
                onImageAdded: () {
                  widget.onChanged();
                  updateBarcodeUI(); // Refresh count
                },
                pRowId: '',
                poItemDtl: poItemDtl,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _input(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        border: const OutlineInputBorder(),
      );

  void handleBarcodeTab() {
    handlePackaging();
    handleSampleSizeBarcodeSpinner();
    handleOverAllResultBarcodeSpinner();
    updateOverResultBarcode();
    handleBarcodeVisual();
    updateBarcodeUI();
  }

  Future<void> handlePackaging() async {

    List<POItemDtl> packDetailList =
        await ItemInspectionDetailHandler().getPackagingMeasurementList(
      poItemDtl.qrHdrID ?? '',
      poItemDtl.qrpoItemHdrID ?? '',
    );
developer.log("packDetailList ${jsonEncode(packDetailList)}");
    List<POItemDtl> packFindingList =
        await ItemInspectionDetailHandler().getPackagingFindingMeasurementList(
      itemId: poItemDtl.itemID ?? '',
      qrpoItemHdrID: poItemDtl.qrpoItemHdrID ?? '',
    );
developer.log("packFindingList ${jsonEncode(packFindingList)}");
    List<POItemDtl> packList =
        ItemInspectionDetailHandler().copyFindingDataToSpecification(
      packDetailList,
      packFindingList,
    );
    developer.log("packList ${jsonEncode(packList)}");
    if (packList.isNotEmpty) {
      packagePoItemDetalDetail = packList.first;
      editPackingBarcodeRemark.text =
          packagePoItemDetalDetail.barcodeRemark ?? '';
      handleBarcodeVisual();
    }
  }

  Future<void> handleSampleSizeBarcodeSpinner() async {
    List<SampleModel> sampleModals = await POItemDtlHandler.getSampleSizeList();
    List<String> sampleList = [];

    if (sampleModals.isNotEmpty) {
      int selectedUnitPos = 0;
      int selectedInnerPos = 0;
      int selectedMasterPos = 0;
      int selectedPalletPos = 0;
      int selectedOPos = 0;

      for (int i = 0; i < sampleModals.length; i++) {
        SampleModel modal = sampleModals[i];
        sampleList.add("${modal.mainDescr} (${modal.sampleVal})");

        if (modal.sampleCode ==
            packagePoItemDetalDetail.barcodeMasterSampleSizeID) {
          selectedMasterPos = i;
        }
        if (modal.sampleCode ==
            packagePoItemDetalDetail.barcodeInnerSampleSizeID) {
          selectedInnerPos = i;
        }
        if (modal.sampleCode ==
            packagePoItemDetalDetail.barcodeUnitSampleSizeID) {
          selectedUnitPos = i;
        }
        if (modal.sampleCode ==
            packagePoItemDetalDetail.barcodePalletSampleSizeID) {
          selectedPalletPos = i;
        }
        if (modal.sampleCode ==
            packagePoItemDetalDetail.barcodeInspectionLevelID) {
          selectedOPos = i;
        }
      }

      // Now you can use these to populate DropdownButton widgets in your UI
      setState(() {
        // Example usage: these variables are bound to DropdownButton values
        selectedUnitSampleIndex = selectedUnitPos;
        selectedInnerSampleIndex = selectedInnerPos;
        selectedMasterSampleIndex = selectedMasterPos;
        selectedPalletSampleIndex = selectedPalletPos;

        sampleDropdownItems = sampleList;
        sampleDropdownModals = sampleModals;
      });
    }
  }

  Future<void> handleOverAllResultBarcodeSpinner() async {
    List<String> statusList = [];
    List<GeneralModel> overAllResultStatusList =
        await GeneralMasterHandler.getGeneralList(
            FEnumerations.overallResultStatusGenId);

    if (overAllResultStatusList.isNotEmpty) {
      int selectedMPos = 0;
      int selectedIPos = 0;
      int selectedUPos = 0;
      int selectedPPos = 0;
      int selectedOPos = 0;

      for (int i = 0; i < overAllResultStatusList.length; i++) {
        statusList.add(overAllResultStatusList[i].mainDescr ?? '');

        if (overAllResultStatusList[i].pGenRowID ==
            packagePoItemDetalDetail.barcodeMasterInspectionResultID) {
          selectedMPos = i;
        }
        if (overAllResultStatusList[i].pGenRowID ==
            packagePoItemDetalDetail.barcodeInnerInspectionResultID) {
          selectedIPos = i;
        }
        if (overAllResultStatusList[i].pGenRowID ==
            packagePoItemDetalDetail.barcodeUnitInspectionResultID) {
          selectedUPos = i;
        }
        if (overAllResultStatusList[i].pGenRowID ==
            packagePoItemDetalDetail.barcodePalletInspectionResultID) {
          selectedPPos = i;
        }
        if (overAllResultStatusList[i].pGenRowID ==
            packagePoItemDetalDetail.barcodeInspectionResultID) {
          selectedOPos = i;
        }
      }

      setState(() {
        // Dropdown values you’ll use in the UI
        statusDropdownItems = statusList;
        overAllStatusModels = overAllResultStatusList;

        selectedMasterStatusIndex = selectedMPos;
        selectedInnerStatusIndex = selectedIPos;
        selectedUnitStatusIndex = selectedUPos;
        selectedPalletStatusIndex = selectedPPos;
      });

      updateOverResultBarcode();
    }
  }

  Future<void> updateOverResultBarcode() async {
    List<GeneralModel> overAllResultStatusList =
        await GeneralMasterHandler.getGeneralList(
            FEnumerations.overallResultStatusGenId);

    if (overAllResultStatusList.isNotEmpty) {
      List<String> statusList = [];
      int selectedOPos = 0;

      for (int i = 0; i < overAllResultStatusList.length; i++) {
        statusList.add(overAllResultStatusList[i].mainDescr ?? '');
        if (overAllResultStatusList[i].pGenRowID ==
            packagePoItemDetalDetail.barcodeInspectionResultID) {
          selectedOPos = i;
        }
      }

      // Update UI state
      setState(() {
        overallStatusDropdownItems = statusList;
        overallStatusModels = overAllResultStatusList;
        selectedOverallStatusIndex = selectedOPos;
      });
    }
  }

  void handleBarcodeVisual() {
    void updateIfValid(String key, String? value,
        Map<String, TextEditingController> controllerMap) {
      if (_isValidString(value)) {
        controllerMap[key]?.text = value!;
      }
    }

    updateIfValid(
        "Unit", packagePoItemDetalDetail.barcodeUnitVisual, visualControllers);
    updateIfValid("Inner", packagePoItemDetalDetail.barcodeInnerVisual,
        visualControllers);
    updateIfValid("Master", packagePoItemDetalDetail.barcodeMasterVisual,
        visualControllers);
    updateIfValid("Pallet", packagePoItemDetalDetail.barcodePalletVisual,
        visualControllers);

// ✅ Correctly assign SPECIFICATION fields
    updateIfValid("Unit", packagePoItemDetalDetail.barcodeUnitVisual,
        specificationControllers);
    updateIfValid("Inner", packagePoItemDetalDetail.barcodeInnerVisual,
        specificationControllers);
    updateIfValid("Master", packagePoItemDetalDetail.barcodeMasterVisual,
        specificationControllers);
    updateIfValid("Pallet", packagePoItemDetalDetail.barcodePalletVisual,
        specificationControllers);

    updateIfValid(
        "Unit", packagePoItemDetalDetail.barcodeUnitScan, scanControllers);
    updateIfValid(
        "Inner", packagePoItemDetalDetail.barcodeInnerScan, scanControllers);
    updateIfValid(
        "Master", packagePoItemDetalDetail.barcodeMasterScan, scanControllers);
    updateIfValid(
        "Pallet", packagePoItemDetalDetail.barcodePalletScan, scanControllers);
  }

  bool _isValidString(String? str) {
    return str != null &&
        str.trim().isNotEmpty &&
        str.trim().toLowerCase() != 'null';
  }

  void updateBarCodeRemark() {
    packagePoItemDetalDetail.barcodeRemark = editPackingBarcodeRemark.text;

    packagePoItemDetalDetail.barcodeUnitVisual =
        visualControllers["Unit"]?.text ?? '';
    packagePoItemDetalDetail.barcodeInnerVisual =
        visualControllers["Inner"]?.text ?? '';
    packagePoItemDetalDetail.barcodeMasterVisual =
        visualControllers["Master"]?.text ?? '';
    packagePoItemDetalDetail.barcodePalletVisual =
        visualControllers["Pallet"]?.text ?? '';

    packagePoItemDetalDetail.barcodeUnitScan =
        scanControllers["Unit"]?.text ?? '';
    packagePoItemDetalDetail.barcodeInnerScan =
        scanControllers["Inner"]?.text ?? '';
    packagePoItemDetalDetail.barcodeMasterScan =
        scanControllers["Master"]?.text ?? '';
    packagePoItemDetalDetail.barcodePalletScan =
        scanControllers["Pallet"]?.text ?? '';
developer.log("packagePoItemDetalDetail jsonEncode ${jsonEncode(packagePoItemDetalDetail)}");
    ItemInspectionDetailHandler()
        .updatePackagingFindingMeasurementList(packagePoItemDetalDetail);
    }


  Widget buildOverallResultDropdown() {
    return     SOverAllDropdown(
      poItemDtl: widget.poItemDtl,
      selectInspectionResultId: poItemDtl.barcodeInspectionResultID ??'',
      onChange: (newId) async {
        // Handle DB update here
        await ItemInspectionDetailHandler().updatePackagingFindingMeasurementList(
          packagePoItemDetalDetail..barcodeInspectionResultID = newId,
        );
        print("Updated OverallInspectionResultID to $newId");
      },
    );
  }
  void updateOverallResultFromChildren() {
    // If any of the child statuses is FAIL, overall should also be FAIL
    if (packagePoItemDetalDetail.barcodeUnitInspectionResultID == FEnumerations.overAllFailResult ||
        packagePoItemDetalDetail.barcodeInnerInspectionResultID == FEnumerations.overAllFailResult ||
        packagePoItemDetalDetail.barcodeMasterInspectionResultID == FEnumerations.overAllFailResult ||
        packagePoItemDetalDetail.barcodePalletInspectionResultID == FEnumerations.overAllFailResult) {
      packagePoItemDetalDetail.barcodeInspectionResultID = FEnumerations.overAllFailResult;
    } else {
      // Otherwise, take the latest "pass" or chosen result
      packagePoItemDetalDetail.barcodeInspectionResultID =
          packagePoItemDetalDetail.barcodeUnitInspectionResultID ??
              packagePoItemDetalDetail.barcodeInnerInspectionResultID ??
              packagePoItemDetalDetail.barcodeMasterInspectionResultID ??
              packagePoItemDetalDetail.barcodePalletInspectionResultID;
    }

    // Update DB
    ItemInspectionDetailHandler()
        .updatePackagingFindingMeasurementList(packagePoItemDetalDetail);

    setState(() {}); // Refresh UI
  }

}
