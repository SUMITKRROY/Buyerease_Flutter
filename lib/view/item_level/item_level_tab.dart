import 'dart:developer' as developer;

import 'package:buyerease/view/item_level/onsite/widget/handleOnSiteOverAllResult.dart';
import 'package:buyerease/view/item_level/packing_measurement.dart';
import 'package:buyerease/view/item_level/packing_appearance.dart';
import 'package:buyerease/view/item_level/quality_parameters_result.dart';
import 'package:buyerease/view/item_level/sample_collected.dart';
import 'package:buyerease/view/item_level/test_reports.dart';
import 'package:buyerease/view/item_level/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theame_data.dart';
import '../../model/inspection_model.dart';
import '../../model/po_item_dtl_model.dart';

import '../../utils/toast.dart' as Fluttertoast;
import 'item_enclosure.dart';
import 'workmanship/over_all_workmanship.dart';
import '../barcode/barcode.dart';
import 'digital_upload/digital_uploaded.dart';
import 'history.dart';
import 'item_measurement/item_measurement.dart';
import 'item_quantity.dart';
import 'onsite.dart';
import 'package:buyerease/components/over_all_dropdown.dart';
import 'package:buyerease/model/simple_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/custom_table.dart';
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

class ItemLevelTab extends StatefulWidget {
  const ItemLevelTab(
      {super.key,
      required this.id,
      required this.pRowId,
      required this.poItemDtl,
      required this.inspectionModal});
  final String id;
  final InspectionModal inspectionModal;
  final POItemDtl poItemDtl;
  final String pRowId;

  @override
  State<ItemLevelTab> createState() => _ItemLevelTabState();
}

class _ItemLevelTabState extends State<ItemLevelTab>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  int _selectedIndex = 0;
  String? _dropDownValue;

  bool _hasUnsavedChanges = false; // NEW
  bool _isSaving = false; // NEW
  late POItemDtl poItemDtl;
  final GlobalKey<State<ItemQuantity>> _itemQuantityKey =
      GlobalKey<State<ItemQuantity>>(); // NEW
  final GlobalKey<State<PackingAppearance>> _packingAppearanceKey =
      GlobalKey(); // NEW
  final GlobalKey<State<PackingMeasurement>> _packingMeasurementKey =
      GlobalKey(); // NEW
  final GlobalKey<State<BarCode>> _barcodeKey = GlobalKey(); // NEW
  final GlobalKey<State<OnSite>> _onsiteKey = GlobalKey(); // NEW
  final GlobalKey<State<WorkManShip>> _workmanshipKey = GlobalKey(); // NEW
  final GlobalKey<State<SampleCollected>> _sampleCollected = GlobalKey(); // NEW
  final GlobalKey<State<QualityParametersResult>> _qualityParametersResultKey =
      GlobalKey(); // NEW
  final GlobalKey<State<DigitalUploaded>> _digitalUploadedKey =
      GlobalKey(); // NEW
  final GlobalKey<State<TestReports>> _testReportsKey = GlobalKey(); // NEW
  final GlobalKey<State<ItemMeasurement>> _itemMeasurement = GlobalKey(); // NEW

  List<Widget> list = const [
    Tab(text: 'Item/Quantity'),
    Tab(text: 'Packing Appearance'),
    Tab(text: 'Packing Measurement'),
    Tab(text: 'Barcode'),
    Tab(text: 'OnSite'),
    Tab(text: 'Workmanship'),
    Tab(text: 'Sample Collected'),
    Tab(text: 'Item Measurement'),
    Tab(text: 'Enclosure(S)'),
    Tab(text: 'History'),
    Tab(text: 'Quality Parameters'),
    // Tab(text: 'Internal Test'),
    Tab(text: 'Digital Uploaded'),
    Tab(text: 'Test Reports'),
  ];

  @override
  void initState() {
    super.initState();
    poItemDtl = widget.poItemDtl;
    _controller = TabController(length: list.length, vsync: this);
    handleOnSiteTab();
    developer.log("podetail data >>> ${widget.poItemDtl.orderQty}");

    _controller?.addListener(() {
      setState(() {
        _selectedIndex = _controller!.index;
      });
    });
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isSaving = true;
    });

    try {
      switch (_selectedIndex) {
        case 0:
          await (_itemQuantityKey.currentState as dynamic)?.saveChanges();
          break;
        case 1:
          await (_packingAppearanceKey.currentState as dynamic)?.saveChanges();
          break;
        case 2:
          await (_packingMeasurementKey.currentState as dynamic)?.saveChanges();
          break;
        case 3:
          await (_barcodeKey.currentState as dynamic)?.saveChanges();
          break;        case 4:
          await (_onsiteKey.currentState as dynamic)?.saveChanges();
          break;
        case 5:
          await (_workmanshipKey.currentState as dynamic)?.saveChanges();
          break;
        case 6:
          await (_sampleCollected.currentState as dynamic)?.saveChanges();
          break;
          case 7:
          await (_itemMeasurement.currentState as dynamic)?.saveChanges();
          break;
        case 9:
          await (_qualityParametersResultKey.currentState as dynamic)
              ?.saveChanges();
          break;
        case 11:
          await (_digitalUploadedKey.currentState as dynamic)?.saveChanges();
          break;
        case 12:
          await (_testReportsKey.currentState as dynamic)?.saveChanges();
          break;
      }

      setState(() {
        _hasUnsavedChanges = false;
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully')),
      );
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
      print('Save failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: ColorsData.primaryColor,
        title: ListTile(
          title: Text("Item detail",
              style: TextStyle(color: Colors.white, fontSize: 18.sp)),
          subtitle: Text("Item no.(${widget.id})",
              style: TextStyle(color: Colors.white, fontSize: 12.sp)),
        ),
        actions: [
          TextButton(
            // onPressed: (_hasUnsavedChanges && !_isSaving) ? _saveChanges : null,
            onPressed: _saveChanges,
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : Text(
                    'SAVE',
                    style: TextStyle(color: Colors.white
                        // color: _hasUnsavedChanges ? Colors.white : Colors.grey,
                        ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              OverAllDropdown(poItemDtl: poItemDtl,),
              TabBar(

                tabAlignment: TabAlignment.start, // or center / fill
                unselectedLabelColor: Colors.grey,
                isScrollable: true,
                tabs: list,
                controller: _controller,
                onTap: (index) {
                  if (_hasUnsavedChanges) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Unsaved Changes'),
                        content: const Text(
                            'Please save changes before switching tabs.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    _controller!.index = index;
                  }
                },
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.75,
                child: TabBarView(
                  controller: _controller,
                  children: [
                    ItemQuantity(
                      key: _itemQuantityKey,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                      pRowId: widget.pRowId,
                      poItemDtl: poItemDtl,
                      inspectionModal: widget.inspectionModal,
                    ),
                    PackingAppearance(
                      key: _packingAppearanceKey,
                      id: widget.id,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                      poItemDtl: widget.poItemDtl,
                    ),
                    PackingMeasurement(
                      key: _packingMeasurementKey,
                      id: widget.id,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                      pRowId: widget.pRowId,
                      poItemDtl: widget.poItemDtl,
                    ),
                    BarCode(
                      key: _barcodeKey,
                      id: widget.id,
                      poItemDtl: widget.poItemDtl,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                    ),
                    OnSite(
                      key: _onsiteKey,
                      // onSiteList: onSiteList,
                      poItemDtl: widget.poItemDtl,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                    ),
                    WorkManShip(
                      key: _workmanshipKey,
                      id: widget.id,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                      pRowId: widget.pRowId,
                      poItemDtl: widget.poItemDtl,
                      inspectionModal: widget.inspectionModal,
                    ),
                    SampleCollected(
                      key: _sampleCollected,
                      poItemDtl: widget.poItemDtl,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                    ),
                    ItemMeasurement(
                      key: _itemMeasurement,
                      inspectionModal: widget.inspectionModal,
                      id: widget.id,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                      poItemDtl: widget.poItemDtl,
                    ),
                    EnclosureTable(
                      inspectionModal: widget.inspectionModal,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                      poItemDtl: widget.poItemDtl,
                    ),
                    History(
                      id: widget.id,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                      pRowId: widget.pRowId,
                      poItemDtl: widget.poItemDtl,
                    ),
                    QualityParametersResult(
                      key: _qualityParametersResultKey,
                      id: widget.id,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                      poItemDtl: widget.poItemDtl,
                      pRowId: widget.pRowId,
                      inspectionModal: widget.inspectionModal,
                    ),
                    // const InternalTest(),
                    DigitalUploaded(
                      key: _digitalUploadedKey,
                      id: widget.id,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                      pRowId: widget.pRowId,
                      poItemDtl: widget.poItemDtl,
                    ),
                    TestReports(
                      key: _testReportsKey,
                      id: widget.id,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                      poItemDtl: widget.poItemDtl,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<OnSiteModal> onSiteList = [];
  List<GeneralModel> overAllResultStatusList = [];

  List<bool> onSiteVisibilityFlags = List.filled(10, false);
  List<String?> onSiteDescriptions = List.filled(10, null);
  List<String?> statusList = [];
  String? selectedOverAllResultId;

  List<InsLvHdrModal> insLvHdrModals = [];
  List<String> insAbbrvList = [];
  bool spinnerTouched = false;
  POItemDtl packagePoItemDetalDetail = POItemDtl();
  String? _selected;
  bool _loading = true;
  TextEditingController _onSiteRemark = TextEditingController();
  List<String?> selectedInspectionLevels = [];

  Future<void> loadInspectionHeaders() async {
    insLvHdrModals = await InsLvHdrHandler.getInsLvHdrList();
    insAbbrvList = insLvHdrModals.map((m) => m.inspAbbrv).toList();
  }

  void initSelectedInspection(List<OnSiteModal> onSiteList) {
    selectedInspectionLevels = List.filled(onSiteList.length, null);
    for (int i = 0; i < onSiteList.length; i++) {
      final lvlId = onSiteList[i].inspectionLevelID;
      if (lvlId != null) {
        final match = insLvHdrModals.firstWhere(
          (m) => m.pRowID == lvlId,
        );
        if (match != null) selectedInspectionLevels[i] = match.inspAbbrv;
      }
    }
  }

  Widget buildDescriptionSpinners(List<OnSiteModal> onSiteList) {
    return Column(
      children: List.generate(onSiteList.length, (idx) {
        return DropdownButton<String>(
          isExpanded: true,
          value: selectedInspectionLevels[idx],
          hint: Text('Select level'),
          items: insAbbrvList.map((abbrv) {
            return DropdownMenuItem(value: abbrv, child: Text(abbrv));
          }).toList(),
          onTap: () {
            spinnerTouched = true;
          },
          onChanged: (String? newValue) {
            if (!spinnerTouched) return;
            spinnerTouched = false;

            final modal = onSiteList[idx];
            final selectedIdx = insAbbrvList.indexOf(newValue!);
            final chosenModal = insLvHdrModals[selectedIdx];

            modal.inspectionLevelID = chosenModal.pRowID;
            updateOnSite(modal);

            setState(() {
              selectedInspectionLevels[idx] = newValue;
            });
          },
        );
      }),
    );
  }

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
    // Simulate fetch from backend or local service
    overAllResultStatusList = await GeneralMasterHandler.getGeneralList(
      FEnumerations.overallResultStatusGenId,
    );

    if (overAllResultStatusList.isNotEmpty) {
      int selectedIndex = 0;

      statusList = overAllResultStatusList.map((e) => e.mainDescr).toList();

      for (int i = 0; i < overAllResultStatusList.length; i++) {
        if (packagePoItemDetalDetail.onSiteTestInspectionResultID ==
            overAllResultStatusList[i].pGenRowID) {
          selectedIndex = i;
          break;
        }
      }

      setState(() {
        selectedOverAllResultId =
            overAllResultStatusList[selectedIndex].pGenRowID;
      });
    }
  }

  Future<void> handleOnSiteTab() async {
    setState(() {
      spinnerTouched = false;
    });

    // // Assign onPressed callback
    // addOnSiteDescIvOnPressed = () {
    //   handleOnSiteDesc();
    // };

    // Call other handlers
    handlePackaging();
    updateOverAllResultOnsite();

    onSiteList = await POItemDtlHandler.getOnSiteList();
    // handleDescriptionSpinner(onSiteList);
    // handleSampleSizeSpinners(onSiteList);
    // handleOnSiteOverAllResult(onSiteList);

    overAllResultStatusList = await GeneralMasterHandler.getGeneralList(
      FEnumerations.onsiteOverallResultStatusGenId,
    );

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
        poItemDtl = packagePoItemDetalDetail;
      });
    }
  }

  void handleOnSiteDesc(BuildContext context) async {
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
                inspectionLevelID: null,
                inspectionResultID: null,
                onSiteTestID: status.pGenRowID,
                sampleSizeID: null,
                sampleSizeValue: null,
              );

              await POItemDtlHandler.insertOnSite(
                  onSiteModal, widget.poItemDtl);
              // POItemDtlHandler.handleOnSiteTab();
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
        );

        // await insertOnSite( onSiteModal);
        // handleOnSiteTab(context);
      }
    }
  }

  // void handleToSaved(bool temp) {
  //   if (temp) {
  //     _showProgressDialog("Waiting...");
  //
  //     Future.delayed(Duration(seconds: 1), () {
  //       handlePacking();
  //
  //       handleWorkmanship();
  //       handleItemMeasurement();
  //       // handleSaveQualityParameter();
  //       // handleSaveFitness();
  //       updatePackingUI();
  //
  //       // added by shekhar
  //       updatePkgAppearance(pOItemPkgAppDetail);
  //       // updateOnSite(onSIteModal);
  //       updateSampleCollectedTab();
  //       handleOnSiteRemark();
  //       handlePkgAppearance();
  //       handleItemQtyRemark();
  //       updateBarCodeRemark();
  //       ///////////
  //
  //       _showToast("Saved successfully");
  //
  //       _hideDialog();
  //     });
  //   } else {
  //     handlePacking();
  //     handleWorkmanship();
  //     handleItemMeasurement();
  //     // handleSaveQualityParameter();
  //     // handleSaveFitness();
  //     updatePackingUI();
  //     // _hideDialog();
  //   }
  // }

  void _showProgressDialog(String message) {
    // Example: show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text(message),
          ],
        ),
      ),
    );
  }

  void _hideDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _showToast(String message) {
    // Use fluttertoast or similar package
    Fluttertoast.showToast(message, true);
  }
}
