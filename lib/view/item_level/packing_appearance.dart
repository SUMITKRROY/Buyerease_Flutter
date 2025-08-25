import 'dart:convert';
import 'dart:developer' as developer;

import 'package:buyerease/components/add_image_icon.dart';
import 'package:buyerease/components/over_all_dropdown_section_wise.dart';
import 'package:buyerease/model/digitals_upload_model.dart';
import 'package:buyerease/model/on_site_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/sample_size_dropdown.dart';
import '../../database/table/genmst.dart';
import '../../components/over_all_dropdown.dart';
import '../../components/remarks.dart';
import '../../model/inspection_model.dart';
import '../../model/po_item_dtl_model.dart';
import '../../model/po_item_pkg_app_detail_model.dart';
import '../../model/sample_collection_model.dart';
import '../../model/simple_model.dart';
import '../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../services/general/GeneralMasterHandler.dart';
import '../../services/general/GeneralModel.dart';
import '../../services/poitemlist/po_item_dtl_handler.dart';
import '../../utils/app_constants.dart';

class PackingAppearance extends StatefulWidget {
  final String id;
  final POItemDtl poItemDtl;
  final VoidCallback onChanged;

  const PackingAppearance({
    super.key,
    required this.id,
    required this.onChanged,
    required this.poItemDtl,
  });

  @override
  _PackingAppearanceState createState() => _PackingAppearanceState();
}

class _PackingAppearanceState extends State<PackingAppearance> {
  final List<String> results = ['PASS', 'FAIL'];
  List<GeneralModel> appearanceDescriptions = [];
  List<GeneralModel> overAllResultStatusList = [];
  String? selectedOverallInspectionResult;
  List<String> selectedSamples = [];
  List<String> selectedResults = [];

  late POItemDtl poItemDtl;
  TextEditingController editPackingAppearRemarkController = TextEditingController();

  List<SampleModel> sampleModals = [];
  String selectedResult = '';
  String selectedResultId = '';
  String selectedSample = "";
  List<String> statusList = [];
  List<String> statsList = [];
  int selectedResultPos = 0;
  List<String> sampleList = [];
  int selectedSamplePos = 0;


    List<POItemPkgAppDetail> pkgAppList = [];

  List<int?> selectedIndices = List.generate(9, (_) => null);
  List<int?> selectedSampleIndices = List.generate(9, (_) => null);
  bool spinnerTouched = false;

  String? selectedMasterResult;
  String? selectedInnerResult;
  String? selectedUnitResult;
  String? selectedPalletResult;
  String? selectedShippingResult;

  String? selectedMasterSample;
  String? selectedInnerSample;
  String? selectedUnitSample;
  String? selectedPalletSample;
  String? selectedShippingSample;

  late InspectionModal inspectionModal;
  POItemDtl packagePoItemDetalDetail = POItemDtl();
  OnSiteModal onSIteModal = new OnSiteModal();
  SampleCollectedModal sampleCollectedModal = new SampleCollectedModal();
  POItemPkgAppDetail pOItemPkgAppDetail = new POItemPkgAppDetail();

  bool isLoading = false;
  // Attachments by title
  Map<String, List<String>> attachmentMap = {
    "Unit pack appearance": [],
    "Shipping pack appearance": [],
    "Inner pack appearance": [],
    "Master pack appearance": [],
    "Pallet pack appearance": [],
  };

  // Qty checks
  int innerPackQty = 0;
  int masterPackQty = 0;
  int palletPackQty = 0;

  @override
  void initState() {
    super.initState();
    poItemDtl = widget.poItemDtl;

    // Load quantities from poItemDtl
    innerPackQty = poItemDtl.ipQty ?? 0;
    masterPackQty = poItemDtl.opQty ?? 0;
    palletPackQty = poItemDtl.palletQty ?? 0;
    handleToInitiatePackagingAppearance();
    handlePackaging();
  }
  void _initializeSelections() {
    for (int i = 0; i <  pkgAppList.length && i < 9; i++) {
      final detail =  pkgAppList[i];
      
      // Initialize appearance result selections
      final resultIndex =  overAllResultStatusList.indexWhere(
            (item) => item.pGenRowID == detail.inspectionResultID,
      );
      if (resultIndex != -1) {
        selectedIndices[i] = resultIndex;
      }
      
      // Initialize sample size selections
      final sampleIndex = sampleModals.indexWhere(
            (sample) => sample.sampleCode == detail.sampleSizeID,
      );
      if (sampleIndex != -1) {
        selectedSampleIndices[i] = sampleIndex;
      }
    }
  }

  void _onDropdownChanged(int dropdownIndex, int selectedIndex) {
    final detail =  pkgAppList[dropdownIndex];
    final selectedModel =  overAllResultStatusList[selectedIndex];

    setState(() {
      selectedIndices[dropdownIndex] = selectedIndex;
    });

    detail.pRowID = detail.pRowID; // Already set
    detail.inspectionResultID = selectedModel.pGenRowID;

    updatePkgAppearance(detail); // Your function
  }

  void _onSampleDropdownChanged(int dropdownIndex, int selectedIndex) {
    final detail = pkgAppList[dropdownIndex];
    final selectedSample = sampleModals[selectedIndex];

    setState(() {
      selectedSampleIndices[dropdownIndex] = selectedIndex;
    });

    detail.pRowID = detail.pRowID; // Already set
    detail.sampleSizeID = selectedSample.sampleCode;
    detail.sampleSizeValue = selectedSample.sampleVal?.toString();

    updatePkgAppearance(detail);
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildOverallResultDropdown(),
      
          _buildCardSection("Unit Packing"),
          _buildCardSection("Shipping Mark"),
          if (innerPackQty > 0) _buildCardSection("Inner Packing"),
          if (masterPackQty > 0) _buildCardSection("Master Packing"),
          if (palletPackQty > 0) _buildCardSection("Pallet Packing"),
          _buildTableHeader(),
          _buildDataList(),
          Remarks(
            controller: editPackingAppearRemarkController,
            onChanged: (_) {
              widget.onChanged();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardSection(String title) {
    String selectedResult = 'PASS';

    String getAppearanceTitle() {
      switch (title) {
        case "Unit Packing":
          return "Unit pack appearance";
        case "Shipping Mark":
          return "Shipping pack appearance";
        case "Inner Packing":
          return "Inner pack appearance";
        case "Master Packing":
          return "Master pack appearance";
        case "Pallet Packing":
          return "Pallet pack appearance";
        default:
          return title;
      }
    }

    final appearanceTitle = getAppearanceTitle();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Expanded(flex: 2, child: SampleSizeDropdown()),
                Expanded(
                  flex: 2,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedResult,
                    underline: const SizedBox(),
                    onChanged: (value) {},
                    items: results.map((result) {
                      return DropdownMenuItem(
                        value: result,
                        child:
                            Text(result, style: const TextStyle(fontSize: 12)),
                      );
                    }).toList(),

                  ),

                ),
              ],
            ),
            AddImageIcon(
              title: appearanceTitle,
              id: widget.id,
              pRowId: '',
              poItemDtl: poItemDtl,
              onImageAdded: () {
                saveChanges();

              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        children: const [
          Expanded(
            flex: 3,
            child: Text("Description",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          Expanded(
            flex: 2,
            child: Text("SampleSize",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          Text("Result",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
  Widget _buildDataList() {
    return Column(

      children: appearanceDescriptions.map((currentDescription) {
        final index = appearanceDescriptions.indexOf(currentDescription);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  currentDescription.mainDescr ?? '',
                  style: const TextStyle(fontSize: 12),
                ),
              ),

              Expanded(
                flex: 2,
                child: DropdownButton<int>(
                  value: selectedSampleIndices[index],
                  items: List.generate(sampleModals.length, (i) {
                    final sample = sampleModals[i];
                    return DropdownMenuItem<int>(
                      value: i,
                      child: Text("${sample.mainDescr} (${sample.sampleVal})",style: TextStyle(fontSize: 12.sp),),
                    );
                  }),
                  onChanged: (val) {
                    if (val != null) {
                      _onSampleDropdownChanged(index, val);
                    }
                  },
                ),
              ),
              DropdownButton<int>(
                value: selectedIndices[index],
                items: List.generate(statusList.length, (i) {
                  return DropdownMenuItem<int>(
                    value: i,
                    child: Text(statusList[i],style: TextStyle(fontSize: 12.sp),),
                  );
                }),
                onChanged: (val) {
                  if (val != null) {
                    _onDropdownChanged(index, val);
                  }
                },
              ),

            ],
          ),
        );
      }).toList(),
    );
  }
/*  Widget _buildDataList() {
    return ListView.builder(
      itemCount: appearanceDescriptions.length,
      itemBuilder: (context, index) {
        final currentDescription = appearanceDescriptions[index];
        final sampleSize = selectedSamples[index];
        final result = selectedResults[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  currentDescription.mainDescr ?? '',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<int>(
                 // decoration: InputDecoration(labelText: 'Sample Size $index'),
                  value: selectedSampleIndices[index],
                  items: List.generate(sampleModals.length, (i) {
                    final sample = sampleModals[i];
                    return DropdownMenuItem<int>(
                      value: i,
                      child: Text("${sample.mainDescr} (${sample.sampleVal})"),
                    );
                  }),
                  onChanged: (val) {
                    if (val != null) {
                      _onSampleDropdownChanged(index, val);
                    }
                  },
                ),
              ),

              Expanded(
                flex: 2,
                child:DropdownButtonFormField<int>(
                  //decoration: InputDecoration(labelText: 'Appearance $index'),
                  value: selectedIndices[index],
                  items: List.generate(statusList.length, (i) {
                    return DropdownMenuItem<int>(
                      value: i,
                      child: Text(statusList[i]),
                    );
                  }),
                  onChanged: (val) {
                    if (val != null) {
                      _onDropdownChanged(index, val);
                    }
                  },)
  _dropdown(
                  results,
                  selectedResults[index],
                      (val) async {
                    selectedResults[index] = val!;

                    // Map "PASS"/"FAIL" to their corresponding GenID
                    final resultGenModel = overAllResultStatusList.firstWhere(
                          (element) => element.mainDescr == val,
                      orElse: () => GeneralModel(),
                    );

                    final detail = POItemPkgAppDetail()
                      ..inspectionResultID = resultGenModel.pGenRowID
                      ..descrID = appearanceDescriptions[index].pGenRowID;

                    await POItemDtlHandler.updatePOItemDtlPKGAppDetails(detail);
                    widget.onChanged();
                    setState(() {});
                  },
                ),
              ),


            ],
          ),
        );
      },
    );
  }*/


  Widget _dropdown(List<String> items, String selectedValue,
      void Function(String?)? onChanged) {
    return DropdownButton<String>(
      isExpanded: true,
      value: selectedValue,
      icon: const Icon(Icons.arrow_drop_down),
      underline: Container(height: 1, color: Colors.grey),
      onChanged: (val) {
        onChanged?.call(val);
        updatePkgAppearance(pOItemPkgAppDetail);
        widget.onChanged(); // <-- THIS WILL TRIGGER SAVE BUTTON
      },
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis),
        );
      }).toList(),
    );
  }
/*  Widget _dropdown(List<String> items, String selectedValue,

      void Function(String?)? onChanged) {
    return DropdownButton<String>(
      isExpanded: true,
      value: selectedValue,
      icon: const Icon(Icons.arrow_drop_down),
      underline: Container(height: 1, color: Colors.grey),
      onChanged: (val) {
        onChanged?.call(val);
        updatePkgAppearance(pOItemPkgAppDetail);
        widget.onChanged(); // <-- THIS WILL TRIGGER SAVE BUTTON
      },
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis),
        );
      }).toList(),
    );
  }*/

  void handlePackagingAppearanceUpload(
      List<DigitalsUploadModel> digitalsUploadModals) {
    attachmentMap.forEach((key, _) => attachmentMap[key] = []);

    for (var modal in digitalsUploadModals) {
      if (modal.title != null && modal.selectedPicPath != null) {
        if (attachmentMap.containsKey(modal.title)) {
          attachmentMap[modal.title]!.add(modal.selectedPicPath!);
        }
      }
    }

    setState(() {}); // Refresh the UI
  }

  Future<void> handleSpinner() async {
    overAllResultStatusList = await GeneralMasterHandler.getGeneralList(FEnumerations.overallResultStatusGenId);

    if (overAllResultStatusList.isNotEmpty) {
      for (int i = 0; i < overAllResultStatusList.length; i++) {
        statsList.add(overAllResultStatusList[i].mainDescr ?? '');
        if (overAllResultStatusList[i].pGenRowID == pOItemPkgAppDetail.inspectionResultID) {
          selectedResultPos = i;
        }
      }
      selectedResult = statsList[selectedResultPos];
    }

    sampleModals = await POItemDtlHandler.getSampleSizeList();
    if (sampleModals.isNotEmpty) {
      for (int i = 0; i < sampleModals.length; i++) {
        final sampleDescription = "${sampleModals[i].mainDescr} (${sampleModals[i].sampleVal})";
        sampleList.add(sampleDescription);

        if (sampleModals[i].sampleCode == pOItemPkgAppDetail.sampleSizeID) {
          selectedSamplePos = i;
        }
      }
      selectedSample = sampleList[selectedSamplePos];
      if (selectedSamplePos == 0) {
        pOItemPkgAppDetail.sampleSizeID = sampleModals[0].sampleCode;
        pOItemPkgAppDetail.sampleSizeValue = sampleModals[0].sampleVal?.toString();
      }
    }
  }

  Future<void> handlePackagingAppearanceSimpleOverAllResultDescSpinner() async {
    // Fetch all required lists
   pkgAppList = await POItemDtlHandler.getPKGAPPList();

    final List<GeneralModel> overAllResultStatusLists =
    await GeneralMasterHandler.getGeneralList(
      FEnumerations.packageAppearanceOverallResultStatusGenId,
    );

    final List<GeneralModel> overAllResultStatusListPkgAppGenMstList =
    await GeneralMasterHandler.getGeneralList(
      FEnumerations.overallResultStatusGenId,
    );

    sampleModals = await POItemDtlHandler.getSampleSizeList();
    overAllResultStatusList = overAllResultStatusListPkgAppGenMstList;

    // Log current list
    developer.log("Status List: ${jsonEncode(pkgAppList)}");

    // Update UI state
    setState(() {
      appearanceDescriptions = overAllResultStatusLists;
        developer.log("List data appearanceDescriptions ${jsonEncode(appearanceDescriptions)}");
      selectedSamples = List.generate(
        overAllResultStatusLists.length,
            (_) => sampleModals.isNotEmpty ? (sampleModals[0].sampleCode ?? '') : '',
      );

      selectedResults = List.generate(
        overAllResultStatusLists.length,
            (_) => overAllResultStatusListPkgAppGenMstList.isNotEmpty ? 'PASS' : '',
      );
    });

    // Insert missing entries
    for (int i = 0; i < overAllResultStatusLists.length; i++) {
      final GeneralModel currentStatus = overAllResultStatusLists[i];

      // ✅ Correct comparison: prevent duplicate insertion
      final bool alreadyExists = pkgAppList.any(
            (pkg) => pkg.inspectionResultID == currentStatus.pGenRowID,
      );

      if (!alreadyExists) {
        final POItemPkgAppDetail detail = POItemPkgAppDetail();

        detail.pRowID = await ItemInspectionDetailHandler().generatePK(
          FEnumerations.tableNamePkgAppDetails,
        );

        // Set sample size
        if (sampleModals.isNotEmpty) {
          detail.sampleSizeID = sampleModals[0].sampleCode;
          detail.sampleSizeValue = sampleModals[0].sampleVal?.toString();
        }

        // Set inspection result
        detail.inspectionResultID = currentStatus.pGenRowID;

        // Insert into database
        await POItemDtlHandler.insertPOItemDtlPKGAppDetails(detail, poItemDtl);
      }
    }

    // Initialize selections after data is loaded
    _initializeSelections();
  }

/*
  Future<void> handlePackagingAppearanceSimpleOverAllResultDescSpinner() async {
    // Mocked data loading functions
    overAllResultStatusList = await GeneralMasterHandler.getGeneralList(
        FEnumerations.overallResultStatusGenId);
    sampleModals = await POItemDtlHandler.getSampleSizeList();

    if (overAllResultStatusList.isNotEmpty) {
      setState(() {
        // Default selected values (replace with values from packagePoItemDetalDetail)
        selectedMasterResult = overAllResultStatusList.first.pGenRowID;
        selectedInnerResult = overAllResultStatusList.first.pGenRowID;
        selectedUnitResult = overAllResultStatusList.first.pGenRowID;
        selectedPalletResult = overAllResultStatusList.first.pGenRowID;
        selectedShippingResult = overAllResultStatusList.first.pGenRowID;

        selectedMasterSample = sampleModals.first.sampleCode;
        selectedInnerSample = sampleModals.first.sampleCode;
        selectedUnitSample = sampleModals.first.sampleCode;
        selectedPalletSample = sampleModals.first.sampleCode;
        selectedShippingSample = sampleModals.first.sampleCode;
      });
    }
  }
*/

  Future<void> handlePkgAppearance() async {
    String pkgAppRemark = editPackingAppearRemarkController.text;
    poItemDtl.pkgAppRemark = pkgAppRemark;

    await ItemInspectionDetailHandler().updatePackagingFindingMeasurementList(
      poItemDtl,
    );
  }

  Future<void> updatePkgAppearance(
      POItemPkgAppDetail pOItemPkgAppDetail) async {
    final List<POItemPkgAppDetail> pkgAppList =
        await POItemDtlHandler.getPKGAPPList();

    for (var i = 0; i < pkgAppList.length; i++) {

      if (pkgAppList[i].pRowID == pOItemPkgAppDetail.pRowID) {
        POItemDtlHandler.updatePOItemDtlPKGAppDetails(pOItemPkgAppDetail);
      }
    }
  }

  Future<void> saveChanges() async {
    try {
      setState(() {
        isLoading = true;
      });

      handlePkgAppearance();
      updatePKGRemark();
      updatePkgAppearance(pOItemPkgAppDetail);
      setState(() {
        isLoading = false;
      });

      widget.onChanged();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void updatePKGRemark() {
    poItemDtl.pkgAppRemark = editPackingAppearRemarkController.text;

    developer
        .log("packagePoItemDetalDetail jsonEncode ${jsonEncode(poItemDtl)}");
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
developer.log('Test packList${jsonEncode(packList)}');
developer.log('Test packList${packList.first.pkgAppInspectionResultID}');

    if (packList.isNotEmpty) {
      final detail = packList[0];

      setState(() {
        packagePoItemDetalDetail = detail;
        editPackingAppearRemarkController.text = detail.pkgAppRemark ?? '';
        selectedResultId = detail.pkgAppInspectionResultID ?? '';
        developer.log('Test packList selectedResultId ${selectedResultId}');
      });
    }
  }

  void handleToInitiatePackagingAppearance() {
    handlePackaging();

    handlePackagingAppearanceOverAllResult();

    handlePackagingAppearanceSimpleOverAllResultDescSpinner();

    updateOverResultPackagingAppearance();

    // updatePackagingAppearanceUI();
  }

  Future<void> handlePackagingAppearanceOverAllResult() async {
    overAllResultStatusList = await GeneralMasterHandler.getGeneralList(
        FEnumerations.overallResultStatusGenId);
    sampleModals = await POItemDtlHandler.getSampleSizeList();

    statusList = overAllResultStatusList
        .map((e) => e.mainDescr)
        .whereType<String>()
        .toList();

    selectedMasterResult =
        packagePoItemDetalDetail.pkgMeMasterInspectionResultID;
    selectedInnerResult = packagePoItemDetalDetail.pkgMeInnerInspectionResultID;
    selectedUnitResult = packagePoItemDetalDetail.pkgMeUnitInspectionResultID;
    selectedPalletResult =
        packagePoItemDetalDetail.pkgMePalletInspectionResultID;
    selectedShippingResult =
        packagePoItemDetalDetail.pkgMeShippingInspectionResultID;

    sampleList =
        sampleModals.map((e) => "${e.mainDescr} (${e.sampleVal})").toList();

    selectedMasterSample = packagePoItemDetalDetail.pkgAppMasterSampleSizeID;
    selectedInnerSample = packagePoItemDetalDetail.pkgAppInnerSampleSizeID;
    selectedUnitSample = packagePoItemDetalDetail.pkgAppUnitSampleSizeID;
    selectedPalletSample = packagePoItemDetalDetail.pkgAppPalletSampleSizeID;
    selectedShippingSample =
        packagePoItemDetalDetail.pkgAppShippingMarkSampleSizeId;

    setState(() {});
    
    // Initialize selections after data is loaded
    _initializeSelections();
  }

  Future<void> updateOverResultPackagingAppearance() async {
    final List<GeneralModel> resultList =
        await GeneralMasterHandler.getGeneralList(
            FEnumerations.overallResultStatusGenId);

    if (resultList.isNotEmpty) {
      setState(() {
        overAllResultStatusList = resultList;

        // Set the selected value based on PKG_App_InspectionResultID
        selectedOverallInspectionResult =
            packagePoItemDetalDetail.pkgAppInspectionResultID ??
                resultList.first.pGenRowID;
      });
    }
  }

  Widget buildOverallResultDropdown() {
    return     SOverAllDropdown(
      poItemDtl: widget.poItemDtl,
      selectInspectionResultId: selectedResultId,
      onChange: (newId) async {
        // Handle DB update here
        await ItemInspectionDetailHandler().updatePackagingFindingMeasurementList(
          packagePoItemDetalDetail..pkgAppInspectionResultID = newId,
        );
        print("Updated OverallInspectionResultID to $newId");
      },
    );
  }
}
