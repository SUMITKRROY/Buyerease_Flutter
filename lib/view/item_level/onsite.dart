import 'dart:convert';
import 'dart:developer' as developer;

import 'package:buyerease/components/over_all_dropdown.dart';
import 'package:buyerease/model/simple_model.dart';
import 'package:buyerease/view/item_level/onsite/widget/handleDescriptionSpinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/custom_table.dart';
import '../../components/over_all_dropdown_section_wise.dart';
import '../../components/remarks.dart';
import '../../config/theame_data.dart';
import '../../database/table/genmst.dart';
import '../../model/InsLvHdrModal.dart';
import '../../model/inspection_level_model.dart';
import '../../model/on_site_modal.dart';
import '../../model/po_item_dtl_model.dart';
import '../../services/InsLvHdrHandler.dart';
import '../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../services/general/GeneralMasterHandler.dart';
import '../../services/general/GeneralModel.dart';
import '../../services/inspection_level_handler.dart';
import '../../services/poitemlist/po_item_dtl_handler.dart';
import '../../utils/app_constants.dart';
import 'onsite/widget/handleOnSiteOverAllResult.dart';
import 'onsite/widget/handleSampleSizeSpinners.dart';

class OnSite extends StatefulWidget {
  final POItemDtl poItemDtl;
  final VoidCallback onChanged;
  const OnSite({super.key, required this.poItemDtl, required this.onChanged});

  @override
  State<OnSite> createState() => _OnSiteState();
}

class _OnSiteState extends State<OnSite> {
  late final POItemDtl poItemDtl;
  final List<Map<String, dynamic>> rows = [];

  String? _selectedInspectionLevel;
  // Add inspection level state
  List<InspectionLevelModel> _inspectionLevels = [];
  List<String> _items = [];
  String selectedResult = '';
  POItemDtl packagePoItemDetalDetail = POItemDtl();
  String? _selected;
  List<String> statsList = [];
  bool _loading = true;
  TextEditingController _onSiteRemark = TextEditingController();
  List<DropdownMenuItem<String>> dropdownOnSiteOverallResultItems = [];
  String? selectedOnSiteOverallResult;
  List<DropdownMenuItem<String>> dropdownHoleOverAllResultItems = [];
  String? selectedHoleOverAllResult;

  String? remark;
  List<String> sampleList = [];
  bool spinnerTouched = false;
  List<SampleModel> sampleModals = [];
  // List<String> sampleList = [];
  String selectedSample = "";

  int selectedResultPos = 0;

  int selectedSamplePos = 0;

  List<GeneralModel> overAllResultStatusList = [];
  List<GeneralModel> doverAllResultStatusList = [];

  // New state variables for tracking selections
  List<int?> selectedSampleIndices = List.generate(10, (_) => null);
  List<int?> selectedInspectionLevelIndices = List.generate(10, (_) => null);
  List<int?> selectedResultIndices = List.generate(10, (_) => null);

  @override
  void initState() {
    super.initState();
    poItemDtl = widget.poItemDtl;
    _loadInspectionLevels();
    _loadItems();
    loadSampleData();
    handleOnSiteTab();
  }

  Future<void> loadSampleData() async {
    sampleModals = await POItemDtlHandler.getSampleSizeList();
    sampleList =
        sampleModals.map((s) => '${s.mainDescr}(${s.sampleVal})').toList();

    setState(() {});
  }

  Future<void> _loadItems() async {
    try {
      poItemDtl = widget.poItemDtl;
      final genMst = GenMst();
      final data = await genMst.getDataByGenID("545");
      // Extract only MainDescr from each item
      setState(() {
        _items = List<String>.from(data
            .map((item) => item['MainDescr'] as String? ?? '')
            .where((desc) => desc.isNotEmpty));
        _loading = false;
      });
    } catch (e) {
      print('Error loading items: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _loadInspectionLevels() async {
    final levels = await InspectionLevelHandler.getInspectionLevels();
    setState(() {
      _inspectionLevels = levels;

      if (levels.isNotEmpty) {
        _selectedInspectionLevel = levels.first.inspAbbrv;
      }
    });
  }

  // New methods for handling dropdown changes
  void _onSampleDropdownChanged(int dropdownIndex, int selectedIndex) {
    if (dropdownIndex < onSiteList.length) {
      final detail = onSiteList[dropdownIndex];
      final selectedSample = sampleModals[selectedIndex];

      setState(() {
        selectedSampleIndices[dropdownIndex] = selectedIndex;
      });

      detail.sampleSizeID = selectedSample.sampleCode;
      detail.sampleSizeValue = selectedSample.sampleVal?.toString();

      updateOnSite(detail);
    }
  }

  void _onInspectionLevelDropdownChanged(int dropdownIndex, int selectedIndex) {
    if (dropdownIndex < onSiteList.length) {
      final detail = onSiteList[dropdownIndex];
      final selectedLevel = _inspectionLevels[selectedIndex];

      setState(() {
        selectedInspectionLevelIndices[dropdownIndex] = selectedIndex;
      });

      detail.inspectionLevelID = selectedLevel.pRowID;

      updateOnSite(detail);
    }
  }

  void _onResultDropdownChanged(int rowIndex, int selectedIndex) {
    if (rowIndex < onSiteList.length) {
      final detail = onSiteList[rowIndex];

      // Get the selected result object from overAllResultStatusList
      final selectedResultModel = doverAllResultStatusList[selectedIndex];
      developer.log("selectmodal ${jsonEncode(selectedResultModel)}");
      setState(() {
        // Track which dropdown index was selected for this row
        selectedResultIndices[rowIndex] = selectedIndex;
      });

      // Store the pGenRowID in the model (this is what will go into DB)
      detail.inspectionResultID = selectedResultModel.pGenRowID;

      developer.log(
        "Row $rowIndex → ${selectedResultModel.mainDescr} "
        "(pGenRowID: ${selectedResultModel.pGenRowID})",
      );

      // Save this updated detail to the database
      updateOnSite(detail);
    }
  }

  void _initializeSelections() {
    for (int i = 0; i < onSiteList.length && i < 10; i++) {
      final detail = onSiteList[i];

      // Initialize sample size selections
      if (detail.sampleSizeID != null) {
        final sampleIndex = sampleModals.indexWhere(
          (sample) => sample.sampleCode == detail.sampleSizeID,
        );
        if (sampleIndex != -1) {
          selectedSampleIndices[i] = sampleIndex;
        }
      }

      // Initialize inspection level selections
      if (detail.inspectionLevelID != null) {
        final levelIndex = _inspectionLevels.indexWhere(
          (level) => level.pRowID == detail.inspectionLevelID,
        );
        if (levelIndex != -1) {
          selectedInspectionLevelIndices[i] = levelIndex;
        }
      }

      // Initialize result selections
      if (detail.inspectionResultID != null) {
        final resultIndex = doverAllResultStatusList.indexWhere(
          (result) => result.pGenRowID == detail.inspectionResultID,
        );
        if (resultIndex != -1) {
          selectedResultIndices[i] = resultIndex;
        } else {
          selectedResultIndices[i] = null;
        }
      }

      /*     // Initialize result selections
      if (detail.inspectionResultID != null) {
        final resultIndex = overAllResultStatusList.indexWhere(
          (result) => result.pGenRowID == detail.inspectionResultID,
        );
        if (resultIndex != -1) {
          selectedResultIndices[i] = resultIndex;
        }
      }*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overall Result Row
        /*     HandleSampleSizeSpinners(onSiteList: onSiteList),
          OverAllDropdown(),*/
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildOverallResultDropdown(),
            IconButton(
              onPressed: handleOnSiteDesc,
              icon: Icon(
                Icons.add_circle_outline,
                size: 28.h,
              ),
            )
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Expanded(
                flex: 3,
                child: Text("Description",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(
                flex: 3,
                child: Text("Inspection\nlevel",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(
                flex: 3,
                child: Text("Sample Size",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(
                flex: 2,
                child: Text("Result",
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        SizedBox(height: 20),
        // Displaying the selected rows
        _loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                shrinkWrap:
                    true, // This makes the ListView take only the space it needs
                physics:
                    NeverScrollableScrollPhysics(), // Disable scrolling for the list
                itemCount: rows.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Text(rows[index]['purpose'],
                                  style: TextStyle(fontSize: 12))),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                border: OutlineInputBorder(),
                              ),
                              value: selectedInspectionLevelIndices[index],
                              items: _inspectionLevels.isEmpty
                                  ? []
                                  : List.generate(_inspectionLevels.length,
                                      (i) {
                                      final level = _inspectionLevels[i];
                                      return DropdownMenuItem<int>(
                                        value: i,
                                        child: Text('${level.inspAbbrv}',
                                            style: TextStyle(fontSize: 12.sp)),
                                      );
                                    }),
                              onChanged: _inspectionLevels.isEmpty
                                  ? null
                                  : (val) {
                                      if (val != null) {
                                        _onInspectionLevelDropdownChanged(
                                            index, val);
                                      }
                                    },
                            ),
                          ),
                          // Sample Size Dropdown
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                border: OutlineInputBorder(),
                              ),
                              value: selectedSampleIndices[index],
                              items: sampleModals.isEmpty
                                  ? []
                                  : List.generate(sampleModals.length, (i) {
                                      final sample = sampleModals[i];
                                      return DropdownMenuItem<int>(
                                        value: i,
                                        child: Text(
                                            '${sample.mainDescr}(${sample.sampleVal})',
                                            style:
                                                const TextStyle(fontSize: 12)),
                                      );
                                    }),
                              onChanged: sampleModals.isEmpty
                                  ? null
                                  : (val) {
                                      if (val != null) {
                                        _onSampleDropdownChanged(index, val);
                                      }
                                    },
                            ),
                          ),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: (selectedResultIndices[index] != null &&
                                      selectedResultIndices[index]! >= 0 &&
                                      selectedResultIndices[index]! <
                                          statsList.length)
                                  ? statsList[selectedResultIndices[index]!]
                                  : null,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              items: statsList.toSet().map((String value) {
                                // remove duplicates
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: const TextStyle(fontSize: 12)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  final selectedIndex = statsList.indexOf(val);
                                  if (selectedIndex != -1) {
                                    _onResultDropdownChanged(
                                        index, selectedIndex);
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

        // Remark
        Remarks(
          controller: _onSiteRemark,
        )
      ],
    );
  }

  List<OnSiteModal> onSiteList = [];
  OnSiteModal onSiteListModal = OnSiteModal();

  List<bool> onSiteVisibilityFlags = List.filled(10, false);
  List<String?> onSiteDescriptions = List.filled(10, null);

  // Old methods removed - replaced by new dropdown implementation
  Future<void> updateOnSite(OnSiteModal onSiteModalItem) async {
    if (onSiteModalItem.pRowID != null) {
      final List<GeneralModel> onSiteMasterList =
          await GeneralMasterHandler.getGeneralList(
        FEnumerations.onsiteOverallResultStatusGenId,
      );

      debugPrint('onSiteMasterList size: ${onSiteMasterList.length}');

      await POItemDtlHandler.updateOnSite(onSiteModalItem);

      // Optional check logic (commented out like Java code)
      // for (final item in onSiteMasterList) {
      //   if (onSiteModalItem.pRowID == item.pGenRowID) {
      //     await POItemDtlHandler.updateOnSite(context, onSiteModalItem);
      //     break;
      //   }
      // }
    }

    handleOnSiteRemark(); // Assuming this is a method in your class
  }

  void handleOnSiteRemark() {
    final String pkgAppRemark = _onSiteRemark.text;
    packagePoItemDetalDetail.onSiteTestRemark = pkgAppRemark;

    ItemInspectionDetailHandler().updatePackagingFindingMeasurementList(
      packagePoItemDetalDetail,
    );
  }

  Future<void> updateOverAllResultOnsite() async {
    List<String> statusList = [];
    int selectedOPos = 0;

    final overAllResultStatusList = await GeneralMasterHandler.getGeneralList(
      FEnumerations.overallResultStatusGenId,
    );

    if (overAllResultStatusList != null && overAllResultStatusList.isNotEmpty) {
      for (int i = 0; i < overAllResultStatusList.length; i++) {
        statusList.add(overAllResultStatusList[i].mainDescr ?? '');

        if (overAllResultStatusList[i].pGenRowID ==
            packagePoItemDetalDetail.onSiteTestInspectionResultID) {
          selectedOPos = i;
        }
      }

      dropdownOnSiteOverallResultItems = statusList
          .map((status) => DropdownMenuItem<String>(
                value: status,
                child: Text(status),
              ))
          .toList();

      selectedOnSiteOverallResult = statusList[selectedOPos];
      //handleOverAllResult();
    }
  }

  Future<void> handleOnSiteTab() async {
    setState(() {
      spinnerTouched = false;
      _loading = true; // Set loading to true at the start
    });

    // Call other handlers
    handlePackaging();
    updateOverAllResultOnsite();
    onSiteList = await POItemDtlHandler.getOnSiteList();
    HandleDescriptionSpinner(
      onSiteList: onSiteList,
    );
    HandleSampleSizeSpinners(
      onSiteList: onSiteList,
    );
    HandleOnSiteOverAllResult(
      onSiteList: onSiteList,
    );

    overAllResultStatusList = await GeneralMasterHandler.getGeneralList(
      FEnumerations.onsiteOverallResultStatusGenId,
    );
    setState(() {
      rows.clear(); // clear existing rows if any
      for (var onSite in onSiteList) {
        rows.add({
          'purpose': getPurposeFromGenId(onSite.onSiteTestID)
              .toString(), // helper method
          'samples': 0, // or use onSite.sampleSizeValue if available
        });
      }
      _loading = false; // Set loading to false when data is loaded
    });

    if (overAllResultStatusList.isNotEmpty && onSiteList.isNotEmpty) {
      for (int i = 0; i < onSiteList.length && i < 10; i++) {
        final onSiteItem = onSiteList[i];

        for (int j = 0; j < overAllResultStatusList.length; j++) {
          if (onSiteItem.onSiteTestID == overAllResultStatusList[j].pGenRowID) {
            setState(() {
              onSiteVisibilityFlags[i] = true;
              onSiteDescriptions[i] = overAllResultStatusList[j].mainDescr;
            });
            break;
          }
        }
      }
    }
    await handleSpinner();
    // Initialize selections after data is loaded
    _initializeSelections();
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
        packagePoItemDetalDetail = packList[0];
        _onSiteRemark.text = packagePoItemDetalDetail.onSiteTestRemark!;
      });
    }
  }

  void handleOnSiteDesc() async {
    List<GeneralModel> newMasterList =
        await GeneralMasterHandler.getGeneralList(
      FEnumerations.onsiteOverallResultStatusGenId,
    );

    List<OnSiteModal> onSiteList = await POItemDtlHandler.getOnSiteList();

    List<GeneralModel> overAllResultStatusList =
        await GeneralMasterHandler.getGeneralList(
      FEnumerations.onsiteOverallResultStatusGenId,
    );

    if (overAllResultStatusList.isNotEmpty) {
      List<String?> list =
          overAllResultStatusList.map((e) => e.mainDescr).toList();
      developer.log("list of data ${list}");

      int? selectedItem = await showDialog<int>(
        context: context,
        builder: (BuildContext dialogContext) {
          return SimpleDialog(
            title: Text('Select Inspection Level'),
            children: list
                .asMap()
                .entries
                .map(
                  (entry) => SimpleDialogOption(
                    child: Text(entry.value ?? ""),
                    onPressed: () {
                      Navigator.pop(dialogContext, entry.key);
                      setState(() {
                        rows.add({'purpose': entry.value ?? "", 'samples': 0});
                      });
                    },
                  ),
                )
                .toList(),
          );
        },
      );

      if (selectedItem == null) return;

      if (onSiteList.isNotEmpty) {
        for (var onSite in onSiteList) {
          overAllResultStatusList.removeWhere(
            (status) => status.pGenRowID == onSite.pRowID,
          );
        }

        print("newMasterList size = ${newMasterList.length}");
        print(
            "overAllResultStatusList size = ${overAllResultStatusList.length}");
        print(
            "selected master item pGenRowID = ${newMasterList[selectedItem].pGenRowID}");
        print(
            "selected master item LocID = ${newMasterList[selectedItem].locID}");

        if (overAllResultStatusList.isNotEmpty) {
          for (var status in overAllResultStatusList) {
            if (status.pGenRowID == newMasterList[selectedItem].pGenRowID) {
              OnSiteModal onSiteModal = OnSiteModal(
                pRowID: await ItemInspectionDetailHandler().generatePK(
                  FEnumerations.tableNameOnSiteTest,
                ),
                onSiteTestID: overAllResultStatusList[selectedItem].pGenRowID,

                // 👇 default selections
                inspectionLevelID: _inspectionLevels.first.pRowID,
                sampleSizeID: sampleModals.first.sampleCode,
                sampleSizeValue: sampleModals.first.sampleVal?.toString(),
                inspectionResultID: doverAllResultStatusList.first.pGenRowID,
              );

              await POItemDtlHandler.insertOnSite(
                  onSiteModal, widget.poItemDtl);
              // POItemDtlHandler.handleOnSiteTab();
              handleOnSiteTab(); // Refresh data after insertion
              break;
            }
          }
        }
      } else {
        OnSiteModal onSiteModal = OnSiteModal(
          pRowID: await ItemInspectionDetailHandler().generatePK(
            FEnumerations.tableNameOnSiteTest,
          ),
          onSiteTestID: overAllResultStatusList[selectedItem].pGenRowID,
          // 👇 default selections
          inspectionLevelID: _inspectionLevels.first.pRowID,
          sampleSizeID: sampleModals.first.sampleCode,
          sampleSizeValue: sampleModals.first.sampleVal?.toString(),
          inspectionResultID: doverAllResultStatusList.first.pGenRowID,
        );

        bool success =
            await POItemDtlHandler.insertOnSite(onSiteModal, widget.poItemDtl);
        // Show a SnackBar based on success/failure
        setState(() {
          handleOnSiteTab();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Sample inserted successfully.'
                  : 'Sample already exists in the database.',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        handleOnSiteTab(); // Refresh only if inserted
      }
    }
  }

  String getPurposeFromGenId(String? genId) {
    final match = overAllResultStatusList.firstWhere(
      (e) => e.pGenRowID == genId,
      orElse: () => GeneralModel(),
    );
    return match.mainDescr ?? '';
  }



  Future<void> saveChanges() async {
    handleOnSiteRemark();

    // Save to server (optional, but mimics Java method)
    // await ItemInspectionDetailHandler.updatePackagingFindingMeasurementList(poItemDtl);


    developer.log('onsite Remark saved: $_onSiteRemark');
  }

  Widget buildOverallResultDropdown() {
    return SOverAllDropdown(
      poItemDtl: widget.poItemDtl,
      selectInspectionResultId: poItemDtl.onSiteTestInspectionResultID ?? '',
      onChange: (newId) async {
        // Handle DB update here
        await ItemInspectionDetailHandler()
            .updatePackagingFindingMeasurementList(
          poItemDtl..onSiteTestInspectionResultID = newId,
        );
        print("Updated OverallInspectionResultID to $newId");
      },
    );
  }

  Future<void> handleSpinner() async {
    doverAllResultStatusList = await GeneralMasterHandler.getGeneralList(
        FEnumerations.overallResultStatusGenId);
    developer.log("overall result ID ${jsonEncode(doverAllResultStatusList)}");
    if (doverAllResultStatusList.isNotEmpty) {
      for (int i = 0; i < doverAllResultStatusList.length; i++) {
        statsList.add(doverAllResultStatusList[i].mainDescr ?? '');
        if (doverAllResultStatusList[i].pGenRowID ==
            onSiteListModal.inspectionResultID) {
          selectedResultPos = i;
        }
      }
      selectedResult = statsList[selectedResultPos];
    }
  }
}
