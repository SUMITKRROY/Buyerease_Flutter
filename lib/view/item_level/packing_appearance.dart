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
  List<GeneralModel> appearanceDescriptions = [];
  List<GeneralModel> overAllResultStatusList = [];
  String? selectedOverallInspectionResult;
  List<String> selectedSamples = [];
  List<String> selectedResults = [];
  List<POItemDtl> pOItemDtlList = [];
// Inside your StatefulWidget class

  String? selectedSampleValue; // optional, to show selected value in dropdown

  late POItemDtl poItemDtl;
  TextEditingController editPackingAppearRemarkController =
      TextEditingController();

  List<SampleModel> sampleModals = [];

  String selectedResultId = '';

  List<String> statusList = [];

  List<String> sampleList = [];

  List<POItemPkgAppDetail> pkgAppList = [];

  List<int?> selectedIndices = List.generate(9, (_) => null);
  List<int?> selectedSampleIndices = List.generate(9, (_) => null);

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

  POItemDtl packagePoItemDetalDetail = POItemDtl();
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
    for (int i = 0; i < pkgAppList.length && i < 9; i++) {
      final detail = pkgAppList[i];

      // Initialize appearance result selections
      final resultIndex = overAllResultStatusList.indexWhere(
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
    final detail = pkgAppList[dropdownIndex];
    final selectedModel = overAllResultStatusList[selectedIndex];

    setState(() {
      selectedIndices[dropdownIndex] = selectedIndex;
    });
    developer.log("developer log of Status List ${selectedModel.pGenRowID}");
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
    return ListView(
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
    );
  }

  Widget _buildCardSection(String title) {
    // Map title → DB field
    String? getStoredResultId() {
      switch (title) {
        case "Unit Packing":
          return poItemDtl.pkgAppUnitInspectionResultID;
        case "Shipping Mark":
          return poItemDtl.pkgAppShippingMarkInspectionResultID;
        case "Inner Packing":
          return poItemDtl.pkgAppInnerSampleSizeID;
        case "Master Packing":
          return poItemDtl.pkgAppMasterInspectionResultID;
        case "Pallet Packing":
          return poItemDtl.pkgAppPalletInspectionResultID;
        default:
          return null;
      }
    }

    void setStoredResultId(String? id) {
      switch (title) {
        case "Unit Packing":
          poItemDtl.pkgAppUnitInspectionResultID = id;
          break;
        case "Shipping Mark":
          poItemDtl.pkgAppShippingMarkInspectionResultID = id;
          break;
        case "Inner Packing":
          poItemDtl.pkgAppInnerSampleSizeID = id;
          break;
        case "Master Packing":
          poItemDtl.pkgAppMasterInspectionResultID = id;
          break;
        case "Pallet Packing":
          poItemDtl.pkgAppPalletInspectionResultID = id;
          break;
      }
    }

    String? getStoredSampleId() {
      switch (title) {
        case "Unit Packing":
          return poItemDtl.pkgAppUnitSampleSizeID;
        case "Shipping Mark":
          return poItemDtl.pkgAppShippingMarkSampleSizeId;
        case "Inner Packing":
          return poItemDtl.pkgAppInnerSampleSizeID;
        case "Master Packing":
          return poItemDtl.pkgAppMasterSampleSizeID;
        case "Pallet Packing":
          return poItemDtl.pkgAppPalletSampleSizeID;
        default:
          return null;
      }
    }

    void setStoredSampleId(String? id) {
      switch (title) {
        case "Unit Packing":
          poItemDtl.pkgAppUnitSampleSizeID = id;
          break;
        case "Shipping Mark":
          poItemDtl.pkgAppShippingMarkSampleSizeId = id;
          break;
        case "Inner Packing":
          poItemDtl.pkgAppInnerSampleSizeID = id;
          break;
        case "Master Packing":
          poItemDtl.pkgAppMasterSampleSizeID = id;
          break;
        case "Pallet Packing":
          poItemDtl.pkgAppPalletSampleSizeID = id;
          break;
      }
    }

    // current stored ID
    final currentResultId = getStoredResultId();

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
                // const Expanded(flex: 2, child: SampleSizeDropdown()),
                Expanded(
                  flex: 2,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: sampleModals.isNotEmpty
                        ? (getStoredSampleId()?.isNotEmpty == true
                            ? getStoredSampleId()
                            : sampleModals.first.sampleCode)
                        : null,
                    items: sampleModals.map((e) {
                      return DropdownMenuItem<String>(
                        value: e.sampleCode,
                        child: Text("${e.mainDescr} (${e.sampleVal})"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        setStoredSampleId(value);

                        final matchedSample = sampleModals.firstWhere(
                          (element) => element.sampleCode == value,
                          orElse: () => sampleModals.first,
                        );

                        selectedSampleValue = matchedSample.mainDescr;
                      });

                      handleUpdateData();
                    },
                  ),
                ),

                // ✅ Dropdown stores ID but shows description
                Expanded(
                  flex: 2,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: currentResultId?.isNotEmpty == true
                        ? currentResultId
                        : overAllResultStatusList.isNotEmpty
                            ? overAllResultStatusList.first.pGenRowID
                            : null,
                    underline: const SizedBox(),
                    onChanged: (newId) async {
                      if (newId == null) return;

                      setState(() {
                        setStoredResultId(newId);
                      });

                      // update DB
                      updateOverResultPackagingAppearance();
                      handleUpdateData();
                    },
                    items: overAllResultStatusList.map((model) {
                      return DropdownMenuItem<String>(
                        value: model.pGenRowID,
                        child: Text(model.mainDescr ?? '',
                            style: const TextStyle(fontSize: 12)),
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

              // ✅ Sample Size Dropdown
              Expanded(
                flex: 2,
                child: DropdownButton<int>(
                  value: selectedSampleIndices[index] ??
                      0, // <-- default first item
                  items: List.generate(sampleModals.length, (i) {
                    final sample = sampleModals[i];
                    return DropdownMenuItem<int>(
                      value: i,
                      child: Text(
                        "${sample.mainDescr} (${sample.sampleVal})",
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    );
                  }),
                  onChanged: (val) {
                    if (val != null) {
                      _onSampleDropdownChanged(index, val);
                    }
                  },
                ),
              ),

              // ✅ Result Dropdown
              DropdownButton<int>(
                value: selectedIndices[index] ?? 0, // <-- default first item
                items: List.generate(statusList.length, (i) {
                  return DropdownMenuItem<int>(
                    value: i,
                    child: Text(
                      statusList[i],
                      style: TextStyle(fontSize: 12.sp),
                    ),
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
      developer.log(
          "List data appearanceDescriptions ${jsonEncode(appearanceDescriptions)}");
      selectedSamples = List.generate(
        overAllResultStatusLists.length,
        (_) =>
            sampleModals.isNotEmpty ? (sampleModals[0].sampleCode ?? '') : '',
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
    developer.log("developer log of Status List $statusList");
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
    developer.log("developer log of Status List $sampleList");
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
    return SOverAllDropdown(
      poItemDtl: widget.poItemDtl,
      selectInspectionResultId: selectedResultId,
      onChange: (newId) async {
        // Handle DB update here
        await ItemInspectionDetailHandler()
            .updatePackagingFindingMeasurementList(
          packagePoItemDetalDetail..pkgAppInspectionResultID = newId,
        );
        print("Updated OverallInspectionResultID to $newId");
      },
    );
  }

  Future<void> handleUpdateData() async {
    bool status = false;
    for (var i = 0; i < pOItemDtlList.length; i++) {
      status =
          await POItemDtlHandler.updatePOItemHdrOnInspection(pOItemDtlList[i]);
      status =
          await POItemDtlHandler.updatePOItemDtlOnInspection(pOItemDtlList[i]);
    }
  }
}
