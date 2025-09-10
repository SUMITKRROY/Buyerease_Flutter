import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:buyerease/components/add_image_icon.dart';
import 'package:buyerease/components/over_all_dropdown.dart';
import 'package:buyerease/utils/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/over_all_dropdown_section_wise.dart';
import '../../components/remarks.dart';
import '../../config/theame_data.dart';
import '../../database/table/qr_po_item_dtl_table.dart';
import '../../model/digitals_upload_model.dart';
import '../../model/po_item_dtl_model.dart';
import '../../model/simple_model.dart';
import '../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../services/general/GeneralMasterHandler.dart';
import '../../services/general/GeneralModel.dart';
import '../../services/poitemlist/po_item_dtl_handler.dart';
import '../../utils/app_constants.dart';

class PackingMeasurement extends StatefulWidget {
  final String id;
  final String pRowId;
  final POItemDtl poItemDtl;
  final VoidCallback onChanged; // ✅ Add this

  const PackingMeasurement(
      {super.key,
      required this.id,
      required this.onChanged,
      required this.pRowId,
      required this.poItemDtl});

  @override
  State<PackingMeasurement> createState() => _PackingMeasurementState();
}

class _PackingMeasurementState extends State<PackingMeasurement> {
  TextEditingController lController = TextEditingController();

  List<GeneralModel> overAllResultStatusList = [];

  List<SampleModel> sampleModals = [];
  String selectedResult = '';

  String selectedSample = "";

  List<String> statsList = [];
  int selectedResultPos = 0;
  List<String> sampleList = [];
  int selectedSamplePos = 0;

  final bController = TextEditingController();
  final hController = TextEditingController();
  final wtController = TextEditingController();
  final cbmController = TextEditingController();
  String quantityController = "";
  final remarkController = TextEditingController();
  late POItemDtl poItemDtl;

  List<POItemDtl> poItems = [];
  bool isLoading = true;

  // Attachments by title
  Map<String, List<String>> attachmentMap = {
    "Unit pack": [],
    "Shipping pack": [],
    "Inner pack": [],
    "Master pack": [],
    "Pallet pack": [],
  };

  @override
  void initState() {
    super.initState();

    poItemDtl = widget.poItemDtl;
    _loadData();
    handleSpinner();
    handlePackaging();
  }

  Future<void> _loadData() async {
    try {
      final qrPoItemDtlTable = QRPOItemDtlTable();
      final items = await qrPoItemDtlTable.getByCustomerItemRefAndEnabled(
          widget.id, widget.pRowId);
      setState(() {
        poItems = items;

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (poItems.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final item = poItems.first; // Get the first item for now

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            // Over All Result Row
            buildOverallResultDropdown(),
            const Divider(thickness: 1, color: ColorsData.primaryColor),

            // Measurement Card
            Card(
              color: Colors.grey.shade100,
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Item Dimension",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            const Text("In inch",
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        SizedBox(
                          width:
                              100, // fixed width for dropdown, adjust as needed
                          child: DropdownButton<String>(
                            isExpanded: false,
                            value: selectedSample,
                            underline:
                                SizedBox(), // removes the default underline
                            isDense: true, // makes it more compact vertically
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedSample = newValue;
                                  int index = sampleList.indexOf(newValue);
                                  poItemDtl.pkgMeInnerSampleSizeID =
                                      sampleModals[index].sampleCode;
                                });
                              }
                            },
                            items: sampleList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style:
                                      TextStyle(color: ColorsData.primaryColor),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    /// Table Header
                    Row(
                      children: [
                        for (var col in [
                          "L",
                          "B",
                          "H",
                          "Wt.",
                          "CBM",
                          "Quantity"
                        ])
                          Expanded(
                            child: Text(
                              col,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    /// Table Data Row
                    Row(
                      children: [
                        Expanded(
                            child: Text(item.unitL?.toString() ?? '0.0',
                                style: const TextStyle(fontSize: 12))),
                        Expanded(
                            child: Text(item.unitW?.toString() ?? '0.0',
                                style: const TextStyle(fontSize: 12))),
                        Expanded(
                            child: Text(item.unitH?.toString() ?? '0.0',
                                style: const TextStyle(fontSize: 12))),
                        Expanded(
                            child: Text(item.weight?.toString() ?? '0',
                                style: const TextStyle(fontSize: 12))),
                        Expanded(
                            child: Text(item.cbm?.toString() ?? '0.0',
                                style: const TextStyle(fontSize: 12))),
                        Expanded(
                            child: Text(item.mapCountUnit?.toString() ?? '',
                                style: const TextStyle(fontSize: 12))),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// Findings Row
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Findings",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    /// Editable Measurement Inputs (below Findings)
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (var label in [
                          "L",
                          "B",
                          "H",
                          "Wt.",
                          "CBM",
                          "Quantity"
                        ])
                          Expanded(
                            child: Text(
                              label,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Row(
                      spacing: 05.sp,
                      children: [
                        Expanded(
                            child: TextField(
                                controller: lController,
                                decoration: _input(""),
                                keyboardType: TextInputType.number)),
                        Expanded(
                            child: TextField(
                                controller: bController,
                                decoration: _input(""),
                                keyboardType: TextInputType.number)),
                        Expanded(
                            child: TextField(
                                controller: hController,
                                decoration: _input(""),
                                keyboardType: TextInputType.number)),
                        Expanded(
                            child: TextField(
                                controller: wtController,
                                decoration: _input(""),
                                keyboardType: TextInputType.number)),
                        Expanded(
                            child: TextField(
                                controller: cbmController,
                                decoration: _input(""),
                                keyboardType: TextInputType.number)),
                        Expanded(child: Text("$quantityController")),
                      ],
                    ),

                    const SizedBox(height: 8),

                    /// Result Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Result label and dropdown
                        Row(
                          children: [
                            const Text(
                              "Result",
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 10),
                            DropdownButton<String>(
                              value: item.pkgMeInspectionResult ?? "PASS",
                              style: const TextStyle(fontSize: 12),
                              items: const [
                                DropdownMenuItem(
                                    value: "PASS",
                                    child: Text("PASS",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: ColorsData.primaryColor))),
                                DropdownMenuItem(
                                    value: "FAIL",
                                    child: Text("FAIL",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: ColorsData.primaryColor))),
                              ],
                              onChanged: (val) {},
                            ),
                          ],
                        ),

                        // Camera icon and count
                        AddImageIcon(
                          title: "Unit pack",
                          id: widget.id,
                          pRowId: '',
                          poItemDtl: widget.poItemDtl,
                          onImageAdded: () {
                            saveChanges();
                            //handlePackagingAppearanceUpload(fetchAllDigitalsUploadModals());
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Remarks(
              controller: remarkController,
              onChanged: (_) {
                widget.onChanged();
              },
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _input(String label) {
    return InputDecoration(
      hintText: label,
      hintStyle: const TextStyle(fontSize: 12),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
      border: const OutlineInputBorder(),
    );
  }

  Map<String, dynamic> collectMeasurementData() {
    return {
      'L': lController.text.trim(),
      'B': bController.text.trim(),
      'H': hController.text.trim(),
      'Weight': wtController.text.trim(),
      'CBM': cbmController.text.trim(),
      'Quantity': quantityController.trim(),
      'Remark': remarkController.text.trim(),
    };
  }

  Future<void> saveChanges() async {
    final data = collectMeasurementData();
    print("Measurement Data: $data"); // for debug or actual save
    updatePKGMeRemark();
    // TODO: Save it to DB or send to server...

    widget.onChanged.call();
    setState(() {});
  }

  void updatePKGMeRemark() {
    poItemDtl.pkgMeRemark = remarkController.text;

    // Update unit finding measurements
    poItemDtl.pkgMeUnitFindingL = double.tryParse(lController.text);
    poItemDtl.pkgMeUnitFindingB = double.tryParse(bController.text);
    poItemDtl.pkgMeUnitFindingH = double.tryParse(hController.text);
    poItemDtl.pkgMeUnitFindingWt = double.tryParse(wtController.text);
    poItemDtl.pkgMeUnitFindingCBM = double.tryParse(cbmController.text);
    poItemDtl.pkgMeUnitFindingQty = double.tryParse(quantityController);

    developer.log("Updated poItemDtl JSON: ${jsonEncode(poItemDtl)}");
    ItemInspectionDetailHandler()
        .updatePackagingFindingMeasurementList(poItemDtl);
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
        poItemDtl = packList[0];
        remarkController.text = poItemDtl.pkgMeRemark!;
        lController.text = (poItemDtl.pkgMeUnitFindingL ?? 0).toString();
        bController.text = (poItemDtl.pkgMeUnitFindingB ?? 0).toString();
        hController.text = (poItemDtl.pkgMeUnitFindingH ?? 0).toString();
        wtController.text = (poItemDtl.pkgMeUnitFindingWt ?? 0).toString();
        cbmController.text = (poItemDtl.pkgMeUnitFindingCBM ?? 0).toString();
        quantityController = (poItemDtl.pkgMeUnitFindingQty ?? 0).toString();
      });
    }
  }

  Widget buildOverallResultDropdown() {
    return SOverAllDropdown(
      poItemDtl: widget.poItemDtl,
      selectInspectionResultId: poItemDtl.pkgMeInspectionResultID ?? '',
      onChange: (newId) async {
        // Handle DB update here
        await ItemInspectionDetailHandler()
            .updatePackagingFindingMeasurementList(
          poItemDtl..pkgMeInspectionResultID = newId,
        );
        print("Updated OverallInspectionResultID to $newId");
      },
    );
  }

  Future<void> handleSpinner() async {
    overAllResultStatusList = await GeneralMasterHandler.getGeneralList(
        FEnumerations.overallResultStatusGenId);

    if (overAllResultStatusList.isNotEmpty) {
      for (int i = 0; i < overAllResultStatusList.length; i++) {
        statsList.add(overAllResultStatusList[i].mainDescr ?? '');
        if (overAllResultStatusList[i].pGenRowID ==
            poItemDtl.pkgMeInnerInspectionResultID) {
          selectedResultPos = i;
        }
      }
      selectedResult = statsList[selectedResultPos];
    }

    sampleModals = await POItemDtlHandler.getSampleSizeList();
    if (sampleModals.isNotEmpty) {
      for (int i = 0; i < sampleModals.length; i++) {
        final sampleDescription =
            "${sampleModals[i].mainDescr} (${sampleModals[i].sampleVal})";
        sampleList.add(sampleDescription);

        if (sampleModals[i].sampleCode == poItemDtl.pkgMeInnerSampleSizeID) {
          selectedSamplePos = i;
        }
      }
      selectedSample = sampleList[selectedSamplePos];
      if (selectedSamplePos == 0) {
        poItemDtl.pkgMeInnerSampleSizeID = sampleModals[0].sampleCode;
      }
    }
  }
}
