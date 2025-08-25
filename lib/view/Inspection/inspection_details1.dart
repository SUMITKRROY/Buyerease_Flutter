/*
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:buyerease/database/database_helper.dart';
import 'package:buyerease/model/simple_model.dart';
import 'package:buyerease/routes/my_routes.dart';
import 'package:buyerease/utils/app_constants.dart';
import 'package:buyerease/utils/multiple_image_handler.dart';
import 'package:buyerease/view/Inspection/intimation_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../config/theame_data.dart';
import '../../database/table/sysdata22_table.dart';
import '../../model/InsLvHdrModal.dart';
import '../../model/inspection_level_model.dart';
import '../../model/po_item_pkg_app_detail_model.dart';
import '../../model/quality_level_model.dart';
import '../../model/inspection_model.dart';
import '../../model/po_item_dtl_model.dart';
import '../../model/quality_modal/quality_level_modal.dart';
import '../../model/sync/SysData22Model.dart';
import '../../routes/route_path.dart';
import '../../services/InsLvHdrHandler.dart';
import '../../services/general/GeneralMasterHandler.dart';
import '../../services/general/GeneralModel.dart';
import '../../services/inspection_level_handler.dart';
import '../../services/inspection_list/InspectionListHandler.dart';
import '../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../services/quality_level_handler.dart';
import '../../services/poitemlist/po_item_dtl_handler.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../../services/sync/SysData22Handler.dart';
import '../po_level/po_level_tab.dart';

class InspectionDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  InspectionDetailScreen({required this.data});

  @override
  _InspectionDetailScreenState createState() => _InspectionDetailScreenState();
}

class _InspectionDetailScreenState extends State<InspectionDetailScreen> {
  bool _isFirstSectionExpanded = true;
  bool _isSecondSectionExpanded = true;

  bool isLoading = true;
  Set<String> selectedItems = {};
  bool isOpen = true; // Track open/closed state
  Set<String> syncedItems = {}; // Track synced items
  String? _selectedStatus;

  String searchQuery = ''; // Add search query state
  List<InspectionModal> inspectionList = [];

  TextEditingController _venderContact = TextEditingController();
  TextEditingController _remarksController = TextEditingController();

  // Add time state variables
  TimeOfDay? _arrivalTime;
  TimeOfDay? _startTime;
  TimeOfDay? _completeTime;

  // Add radio button state
  String _selectedLevel = 'Report Level'; // Default selection

  // Add inspection level state
  List<InspectionLevelModel> _inspectionLevels = [];
  String? _selectedInspectionLevel;

  // Add quality level state
  List<QualityLevelModal> _qualityLevels = [];
  String? _selectedQualityLevelMajor;
  String? _selectedQualityLevelMinor;



  int? availableQty;

  List<String> statusList = [];

  DateTime? _selectedInspectionDate;




  //first spinner
  TextEditingController txtInspectionLevel = TextEditingController();
  TextEditingController txtQualityLevel = TextEditingController();
  TextEditingController txtQualityLevelMinor = TextEditingController();
  TextEditingController txtStatus = TextEditingController();
  TextEditingController txtLocation = TextEditingController();
  TextEditingController txtArrivalTime = TextEditingController();
  TextEditingController txtStartTimeLevel = TextEditingController();
  TextEditingController txtCompleteTime = TextEditingController();

// Integer variables
  late int mArrivalTimeHour, mArrivalTimeMinute;
  late int mInspStartTimeHour, mInspStartTimeMinute;
  late int mCompleteTimeHour, mCompleteTimeMinute;

// Modal and IDs
  late InspectionModal inspectionModal;
  late String pRowIdOfInspectLevel, pRowIdOfQualityMajorLevel, pRowIdOfQualityMinorLevel, pRowIdOfStatus;


  @override
  void initState() {
    super.initState();
    developer.log("Inspection Detail Data: ${widget.data}");
    getList(context, widget.data['pRowID']);
    _loadInspectionLevels();
    _loadQualityLevels();
    fetchAndShowStatus();
    //  setFirstTimeValueInSpinnerAndTimer();
    getLocalList(widget.data['pRowID']);
    // handleSpinner();
  }

  Future<void> getLocalList(String searchStr) async {
    setState(() {
      isLoading = true;
    });
    try {
      int isSyncStatus = widget.data["isSync"];

      List<InspectionModal> localList = isSyncStatus.isEven
          ? await InspectionListHandler.getInspectionList(searchStr)
          : await InspectionListHandler.getSyncedInspectionList(searchStr);
      setState(() {
        inspectionList.clear();
        if (localList.isNotEmpty) {
          inspectionList.addAll(localList);
          final first = inspectionList.first;
          inspectionModal = first;
          _selectedQualityLevelMajor = first.qlMajorDescr;
          _selectedQualityLevelMinor = first.qlMinorDescr;
          _selectedInspectionLevel = first.inspectionLevelDescr;
          _venderContact.text = first.vendorContact ?? '';
          _remarksController.text = first.comments ?? '';
          availableQty = first.availableQty ?? 0;
          _selectedStatus = first
              .status; // <- Assuming 'status' is a field in InspectionModal

          _arrivalTime =
              (first.arrivalTime != null && first.arrivalTime!.isNotEmpty)
                  ? _parseTimeOfDay(first.arrivalTime!)
                  : null;
          _startTime =
              (first.inspStartTime != null && first.inspStartTime!.isNotEmpty)
                  ? _parseTimeOfDay(first.inspStartTime!)
                  : null;
          _completeTime =
              (first.completeTime != null && first.completeTime!.isNotEmpty)
                  ? _parseTimeOfDay(first.completeTime!)
                  : null;
          _selectedInspectionDate =
              first.inspectionDt != null && first.inspectionDt!.isNotEmpty
                  ? DateFormat('dd-MMM-yyyy').parse(first.inspectionDt!)
                  : DateTime.now();
          // Fluttertoast.showToast(msg: ">>>${_venderContact.text}");

        } else {
          //   Fluttertoast.showToast(msg: "Inspection did not find");
        }
        isLoading = false;
      });
      if (inspectionList.isNotEmpty) {
        _qualityParameter();
      }
    } catch (e) {
      debugPrint("Error fetching local list: $e");
      //  Fluttertoast.showToast(msg: "Failed to load inspections");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _qualityParameter() async {
    final first = inspectionList.first;
    // final listData = await ItemInspectionDetailHandler().getListQualityParameter(
    //
    //     inspectionModal: first,
    //     QRHdrID: first.qrHdrID ?? "",
    //     QRPOItemHdrID: first.qrID ?? '');
    // developer.log(" ListData ${jsonEncode(listData)}");
  }

  // Helper to parse HH:mm string to TimeOfDay
  TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  void fetchAndShowStatus() async {
    Sysdata22Table table = Sysdata22Table();
    statusList = await table.getAndPrintMainDescrWhereStatus();

    // You can use statusList here if needed
    print("Fetched ${statusList.length} status entries.");
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

  Future<void> _loadQualityLevels() async {
    final levels = await QualityLevelHandler.getQualityLevels();
    print("data>>>>>> $levels");
    setState(() {
      _qualityLevels = levels;
      if (levels.isNotEmpty) {
        _selectedQualityLevelMajor = levels.first.qualityLevel;
        _selectedQualityLevelMinor = levels.first.qualityLevel;
      }
    });
  }

  List<POItemDtl> pOItemDtlList = [];

  Future<void> getList(BuildContext context, String pRowID) async {
    pOItemDtlList.addAll(await POItemDtlHandler.getItemList(pRowID));
  }

  Future<void> _selectTime(BuildContext context, bool isArrival, bool isStart,
      bool isComplete) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorsData.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isArrival) _arrivalTime = picked;
        if (isStart) _startTime = picked;
        if (isComplete) _completeTime = picked;
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required List<Widget> children,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onToggle,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                title == "Inspection detail"
                    ? Text(title, style: TextStyle(fontSize: 18))
                    : InkWell(
                        onTap: () async {
                          DateTime initialDate =
                              _selectedInspectionDate ?? DateTime.now();
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: initialDate.isBefore(DateTime.now())
                                ? DateTime.now()
                                : initialDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedInspectionDate = picked;
                              inspectionList.first.inspectionDt = picked
                                  .toIso8601String()
                                  .split('T')
                                  .first; // 'yyyy-MM-dd'
                            });
                            await _saveChangesIfChanged();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Text(
                                _selectedInspectionDate != null
                                    ? "${_selectedInspectionDate!.year}-${_selectedInspectionDate!.month.toString().padLeft(2, '0')}-${_selectedInspectionDate!.day.toString().padLeft(2, '0')}"
                                    : title,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: ColorsData.primaryColor,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...children,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          backgroundColor: ColorsData.primaryColor,
          title: Text('Loading...', style: TextStyle(color: Colors.white)),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (inspectionList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          backgroundColor: ColorsData.primaryColor,
          title: Text('No Data', style: TextStyle(color: Colors.white)),
        ),
        body: Center(child: Text('No inspection data found.')),
      );
    }

    final item = inspectionList.first;
    item.aqlFormula == 0
        ? _selectedLevel = "Report Level"
        : _selectedLevel = "Material Level";

    return WillPopScope(
      onWillPop: () async {
        await _saveChangesIfChanged();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: const BackButton(color: Colors.white),
            backgroundColor: ColorsData.primaryColor,
            title:
                Text(item.pRowID ?? '', style: TextStyle(color: Colors.white)),
            // title: Text(widget.data['pRowID'] ?? '', style: TextStyle(color: Colors.white)),
            actions: [
              TextButton(
                onPressed: _saveChanges,
                // onPressed: isChanged ? _saveChanges : null,
                child: Text('SAVE', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          body: ListView(
            padding: EdgeInsets.all(16),
            children: [
              _buildExpandableSection(
                title: item.inspectionDt ?? '',
                isExpanded: _isFirstSectionExpanded,
                onToggle: () {
                  setState(() {
                    _isFirstSectionExpanded = !_isFirstSectionExpanded;
                  });
                },
                children: [
                  _infoRow('Customer', item.customer ?? ''),
                  _infoRow('Vendor', item.vendor ?? ''),
                  _infoRow('Inspector', item.inspector ?? ''),
                  _infoRow('Activity', item.activity ?? ''),
                  _infoRow('Location', item.vendorAddress ?? ''),
                  _infoRowWithTextField(
                      'Vendor Representative', item.vendorContact ?? ''),
                ],
              ),
              SizedBox(height: 16),
              _buildExpandableSection(
                title: 'Inspection detail',
                isExpanded: _isSecondSectionExpanded,
                onToggle: () {
                  setState(() {
                    _isSecondSectionExpanded = !_isSecondSectionExpanded;
                  });
                },
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _dropdownField('Inspection Level',
                              ['${item.inspectionLevelDescr}']),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _dropdownField(
                              'Quality Level Major', ['${item.qlMajorDescr}']),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _dropdownField(
                      'Quality Level Minor', ['${item.qlMinorDescr}']),
                  SizedBox(height: 16),
                  _dropdownField('Status', statusList),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: _radioOption('Report Level')),
                  SizedBox(width: 16),
                  Expanded(child: _radioOption('Material Level')),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _timeField('Arrival Time')),
                  Expanded(child: _timeField('Start Time')),
                  Expanded(child: _timeField('Complete Time')),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _remarksController,
                onChanged: (_) => _saveChangesIfChanged(),
                decoration: InputDecoration(
                  labelText: 'Remark',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 24),
              OutlinedButton(
                onPressed: () async {
                  await _saveChangesIfChanged();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PoLevelTab(
                                pRowId: widget.data['pRowID'],
                                inspectionModal: inspectionList.first,
                              )));
                },
                child: Text('GO TO  PO DETAILS'),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
              width: 120,
              child: Text(label,
                  style: TextStyle(color: Colors.grey, fontSize: 12))),
          Expanded(
              child: Text(value,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _infoRowWithTextField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child:
                Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          Expanded(
            child: TextFormField(
              controller: _venderContact,
              onChanged: (_) => _saveChangesIfChanged(),
              style: TextStyle(fontSize: 12), // <--- Add this line
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(fontSize: 12),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                border: UnderlineInputBorder(),
                // <-- Only underline
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.grey), // Customize color if needed
                ),
                focusedBorder: UnderlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  String? getValidDropdownValue(String? selectedValue, List<String> items) {
    if (selectedValue == null) return null;

    // Ensure it exists exactly once
    int count = items.where((item) => item == selectedValue).length;
    if (count == 1) return selectedValue;

    // Else: fallback
    return null; // or items.first;
  }


  Widget _dropdownField(String label, List<String> items) {
    if (label == 'Inspection Level') {

      return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(fontSize: 12.sp),
        ),
        value: _selectedInspectionLevel,
        items: _inspectionLevels.map((level) => DropdownMenuItem(
          value: level.inspAbbrv,
          child: Text('${level.inspAbbrv}', style: TextStyle(fontSize: 12.sp)),
        )).toList(),
        onChanged: (value) {
          setState(() {
            _selectedInspectionLevel = value;

          });
          _saveChangesIfChanged();
        },
      );
    } else if (label == 'Quality Level Major') {
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(fontSize: 12.sp),
        ),
        value: _selectedQualityLevelMajor,
        items: _qualityLevels.map((level) => DropdownMenuItem(
          value: level.qualityLevel!,
          child: Text(level.qualityLevel ?? '', style: TextStyle(fontSize: 12.sp)),
        )).toList(),
        onChanged: (value) {
          setState(() {
            _selectedQualityLevelMajor = value;
            // Find the selected QualityLevelModal and update pRowIdOfQualityMajorLevel
            final selected = _qualityLevels.firstWhere(
              (level) => level.qualityLevel == value,
            );
            pRowIdOfQualityMajorLevel = selected.pRowID!;
          });
          _saveChangesIfChanged();
        },
      );
    } else if (label == 'Quality Level Minor') {
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(fontSize: 12.sp),
        ),
        value: _selectedQualityLevelMinor,
        items: _qualityLevels.map((level) => DropdownMenuItem(
          value: level.qualityLevel!,
          child: Text('${level.qualityLevel ?? ''}', style: TextStyle(fontSize: 12.sp)),
        )).toList(),
        onChanged: (value) {
          setState(() {
            _selectedQualityLevelMinor = value;
            // Find the selected QualityLevelModal and update pRowIdOfQualityMinorLevel
            final selected = _qualityLevels.firstWhere(
              (level) => level.qualityLevel == value,
            );
            pRowIdOfQualityMinorLevel = selected.pRowID!;
          });
          _saveChangesIfChanged();
        },
      );
    } else if (label == 'Status') {
      final uniqueStatusList = statusList.toSet().toList(); // remove duplicates

      return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(fontSize: 12.sp),
        ),
        value: uniqueStatusList.contains(_selectedStatus)
            ? _selectedStatus
            : null, // 👈 Fix here
        items: uniqueStatusList.map((status) {
          return DropdownMenuItem<String>(
            value: status,
            child: Text(status, style: TextStyle(fontSize: 12.sp)),
          );
        }).toList(),
        onChanged: (val) {
          setState(() {
            _selectedStatus = val;
          });
          _saveChangesIfChanged();
        },
      );
    }

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        labelStyle: TextStyle(fontSize: 12.sp),
      ),
      items: items.map((e) => DropdownMenuItem(
        value: e,
        child: Text(e, style: TextStyle(fontSize: 12.sp))
      )).toList(),
      onChanged: (val) {},
    );
  }

  Widget _radioOption(String label) {
    return InkWell(
      // onTap: () {
      //   setState(() {
      //  //   _selectedLevel = label;
      //   });
      // },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: [
            Radio<String>(
              value: label,
              groupValue: _selectedLevel,
              onChanged: (value) {
                setState(() {
                  // _selectedLevel = value!;
                });
              },
              activeColor: ColorsData.primaryColor,
            ),
            Text(
              label,
              style: TextStyle(
                color: _selectedLevel == label
                    ? ColorsData.primaryColor
                    : Colors.black,
                fontWeight: _selectedLevel == label
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeField(String label) {
    TimeOfDay? selectedTime;
    bool isArrival = label == 'Arrival Time';
    bool isStart = label == 'Start Time';
    bool isComplete = label == 'Complete Time';

    if (isArrival) selectedTime = _arrivalTime;
    if (isStart) selectedTime = _startTime;
    if (isComplete) selectedTime = _completeTime;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: ColorsData.primaryColor)),
        InkWell(
          onTap: () => _selectTime(context, isArrival, isStart, isComplete),
          child: Row(
            children: [
              Text(
                selectedTime != null ? _formatTimeOfDay(selectedTime) : '00:00',
                style: TextStyle(
                  fontSize: 16,
                  color: selectedTime != null ? Colors.black : Colors.grey,
                ),
              ),
              IconButton(
                icon: Icon(Icons.access_time, color: ColorsData.primaryColor),
                onPressed: () =>
                    _selectTime(context, isArrival, isStart, isComplete),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool get isChanged {
    if (inspectionList.isEmpty) return false;
    final item = inspectionList.first;
    return (_selectedInspectionLevel != null &&
            _selectedInspectionLevel != item.inspectionLevelDescr) ||
        (_selectedQualityLevelMajor != null &&
            _selectedQualityLevelMajor != item.qlMajorDescr) ||
        (_selectedQualityLevelMinor != null &&
            _selectedQualityLevelMinor != item.qlMinorDescr);
  }

  void _saveChanges() async {
    if (inspectionList.isEmpty) return;
    final item = inspectionList.first;

    // Store the original status to check if it changed
    String? originalStatus = item.status;

    // ✅ Update fields from UI
    item.vendorContact = _venderContact.text;
    item.inspectionLevelDescr =
        _selectedInspectionLevel ?? item.inspectionLevelDescr;
    item.qlMajorDescr = _selectedQualityLevelMajor ?? item.qlMajorDescr;
    item.qlMinorDescr = _selectedQualityLevelMinor ?? item.qlMinorDescr;
    item.comments = _remarksController.text;
    item.status = _selectedStatus ?? item.status; // ✅ Add this line

    // ✅ Convert time fields
    item.arrivalTime = _arrivalTime != null
        ? _formatTimeOfDay(_arrivalTime!)
        : item.arrivalTime;
    item.inspStartTime =
        _startTime != null ? _formatTimeOfDay(_startTime!) : item.inspStartTime;
    item.completeTime = _completeTime != null
        ? _formatTimeOfDay(_completeTime!)
        : item.completeTime;

    final db = await DatabaseHelper().database;

    // ✅ Update inspection date
    final dateFormatter = DateFormat('dd-MMM-yyyy');
    item.inspectionDt = _selectedInspectionDate != null
        ? dateFormatter.format(_selectedInspectionDate!)
        : item.inspectionDt;

    // ✅ Update in DB
    await InspectionListHandler.updatePOItemHdr( item);
    // setFirstTimeValueInSpinnerAndTimer();
    Fluttertoast.showToast(msg: "Changes saved!");

    setState(() {
      inspectionList[0] = item;
    });

    // ✅ Auto-navigate to intimation details if status changed
    if (_selectedStatus != null && _selectedStatus != originalStatus) {
     Navigator.pushNamed(
        context,
        '/intimation-details',
        arguments: {
          'pRowID': widget.data['pRowID'],
          'inspectionData': item.toJson(),
        },
      );

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IntimationDetailsScreen(
                pRowId: widget.data['pRowID'],
                inspectionModal: inspectionList.first,)));
    }
  }
  int? aqlFormula; // represents inspectionModal.AQLFormula
  int selectedRadio = 0;
  Future<void> _saveChangesIfChanged() async {
    if (isChanged) {
      _saveChanges();
    }
  }
  void handleSpinner() {
    // Simulating radio group logic
    if (aqlFormula == 0) {
      selectedRadio = 0;
    } else {
      selectedRadio = 1;
    }

    setFirstTimeValueInSpinnerAndTimer();
    // handleArrivalTime();
    // handleStartTime();
    // handleCompleteTime();
  }


  Future<void> setFirstTimeValueInSpinnerAndTimer() async {
    txtInspectionLevel.text = "Select Inspection Level";
    txtQualityLevel.text = "Select Quality Level";
    txtStatus.text = "Select Status";
    txtLocation.text = inspectionModal.factory ?? "";

    // Inspection Level
    if (inspectionModal.inspectionLevel != null && inspectionModal.inspectionLevel != "null") {
      final List<InsLvHdrModal>  insLvHdrModals = await InsLvHdrHandler.getDataAccordingToParticularList( inspectionModal.inspectionLevel!);
      if (insLvHdrModals.isNotEmpty) {
        txtInspectionLevel.text = insLvHdrModals[0].inspAbbrv;
      }
      pRowIdOfInspectLevel = inspectionModal.inspectionLevel!;
    } else {
      final List<InsLvHdrModal> insLvHdrModals = await InsLvHdrHandler.getInsLvHdrList();
      if (insLvHdrModals.isNotEmpty) {
        txtInspectionLevel.text = insLvHdrModals[0].inspAbbrv;
        pRowIdOfInspectLevel = insLvHdrModals[0].pRowID;
        inspectionModal.inspectionLevel = pRowIdOfInspectLevel;
        inspectionModal.inspectionLevelDescr = insLvHdrModals[0].inspAbbrv;
      }
    }

    // Quality Level Major
    if (inspectionModal.qlMajor != null && inspectionModal.qlMajor != "null") {
      final List<QualityLevelModal> qualityMajorList = await QualityLevelHandler.getDataAccordingToParticularList( inspectionModal.qlMajor!);
      if (qualityMajorList.isNotEmpty) {
        txtQualityLevel.text = qualityMajorList[0].qualityLevel!;
      }
      pRowIdOfQualityMajorLevel = inspectionModal.qlMajor!;
    } else {
      final List<QualityLevelModal> qualityLevelList = await QualityLevelHandler.getQualityLevelList( );
      if (qualityLevelList.isNotEmpty) {
        txtQualityLevel.text = qualityLevelList[0].qualityLevel!;
        pRowIdOfQualityMajorLevel = qualityLevelList[0].pRowID!;
        inspectionModal.qlMajor = pRowIdOfQualityMajorLevel;
        inspectionModal.qlMajorDescr = qualityLevelList[0].qualityLevel;
      }
    }

    // Quality Level Minor
    if (inspectionModal.qlMinor != null && inspectionModal.qlMinor != "null") {
      final List<QualityLevelModal> qualityMinorList = await QualityLevelHandler.getDataAccordingToParticularList(  inspectionModal.qlMinor!);
      if (qualityMinorList.isNotEmpty) {
        txtQualityLevelMinor.text = qualityMinorList[0].qualityLevel!;
      }
      pRowIdOfQualityMinorLevel = inspectionModal.qlMinor!;
    } else {
      final List<QualityLevelModal> qualityLevelList = await QualityLevelHandler.getQualityLevelList( );
      if (qualityLevelList.isNotEmpty) {
        txtQualityLevelMinor.text = qualityLevelList[0].qualityLevel!;
        pRowIdOfQualityMinorLevel = qualityLevelList[0].pRowID!;
        inspectionModal.qlMinor = pRowIdOfQualityMinorLevel;
        inspectionModal.qlMinorDescr = qualityLevelList[0].qualityLevel;
      }
    }

    // Status
    if (inspectionModal.status != null && inspectionModal.status!.isNotEmpty) {
      final List<SysData22Modal>  statusList = await SysData22Handler.getSysData22ListAccToID( FEnumerations.statusGenId, inspectionModal.status!);
      if (statusList.isNotEmpty) {
        txtStatus.text = statusList[0].mainDescr;
      }
    } else {
      final List<SysData22Modal> statusList = await SysData22Handler.getSysData22List( FEnumerations.statusGenId);
      if (statusList.isNotEmpty) {
        txtStatus.text = statusList[0].mainDescr;
        pRowIdOfStatus = statusList[0].mainID;
        inspectionModal.status = pRowIdOfStatus;
      }
    }

    // Arrival Time
    if (inspectionModal.arrivalTime != null && inspectionModal.arrivalTime != "null") {
      final timeParts = inspectionModal.arrivalTime!.split(":");
      mArrivalTimeHour = int.parse(timeParts[0].trim());
      mArrivalTimeMinute = int.parse(timeParts[1].trim());
      txtArrivalTime.text = _formatTime(mArrivalTimeHour, mArrivalTimeMinute);
    }

    // Start Time
    if (inspectionModal.inspStartTime != null && inspectionModal.inspStartTime != "null") {
      final timeParts = inspectionModal.inspStartTime!.split(":");
      mInspStartTimeHour = int.parse(timeParts[0].trim());
      mInspStartTimeMinute = int.parse(timeParts[1].trim());
      txtStartTimeLevel.text = _formatTime(mInspStartTimeHour, mInspStartTimeMinute);
    }

    // Complete Time
    if (inspectionModal.completeTime != null && inspectionModal.completeTime != "null") {
      final timeParts = inspectionModal.completeTime!.split(":");
      mCompleteTimeHour = int.parse(timeParts[0].trim());
      mCompleteTimeMinute = int.parse(timeParts[1].trim());
      txtCompleteTime.text = _formatTime(mCompleteTimeHour, mCompleteTimeMinute);
    }
  }

  String _formatTime(int hour, int minute) {
    final time = TimeOfDay(hour: hour, minute: minute);
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dateTime); // e.g., 2:30 PM
  }


  Future<void> setFirstTimeValueInSpinnerAndTimer() async {
    String txtInspectionLevel = "Select Inspection Level";
    String? txtQualityLevel = "Select Quality Level";
    String? txtQualityLevelMinor = "Select Quality Level";
    String txtStatus = "Select Status";

    // Inspection Level
    if (inspectionModal.inspectionLevel != null &&
        inspectionModal.inspectionLevel != "null") {
      List<InsLvHdrModal> insLvHdrModals =
          await InsLvHdrHandler.getDataAccordingToParticularList(
              inspectionModal.inspectionLevel!);
      if (insLvHdrModals.isNotEmpty) {
        txtInspectionLevel = insLvHdrModals[0].inspAbbrv;
      }
      pRowIdOfInspectLevel = inspectionModal.inspectionLevel!;
    } else {
      List<InsLvHdrModal> insLvHdrModals =
          await InsLvHdrHandler.getInsLvHdrList();
      if (insLvHdrModals.isNotEmpty) {
        txtInspectionLevel = insLvHdrModals[0].inspAbbrv;
        pRowIdOfInspectLevel = insLvHdrModals[0].pRowID;
        inspectionModal.inspectionLevel = pRowIdOfInspectLevel;
        inspectionModal.inspectionLevelDescr = insLvHdrModals[0].inspAbbrv;
      }
    }

    // Quality Level Major
    if (inspectionModal.qlMajor != null && inspectionModal.qlMajor != "null") {
      List<QualityLevelModal> qualityMajorList =
          await QualityLevelHandler.getDataAccordingToParticularList(
              inspectionModal.pRowID!);
      if (qualityMajorList != null && qualityMajorList.isNotEmpty) {
        txtQualityLevel = qualityMajorList[0].qualityLevel;
      }
      pRowIdOfQualityMajorLevel = inspectionModal.qlMajor!;
    } else {
      List<QualityLevelModal> qualityLevelList =
          await QualityLevelHandler.getQualityLevelList();
      if (qualityLevelList != null && qualityLevelList.isNotEmpty) {
        txtQualityLevel = qualityLevelList[0].qualityLevel;
        pRowIdOfQualityMajorLevel = qualityLevelList[0].pRowID;
        inspectionModal.qlMajor = pRowIdOfQualityMajorLevel;
        inspectionModal.qlMajorDescr = qualityLevelList[0].qualityLevel;
      }
    }

    // Quality Level Minor
    if (inspectionModal.qlMinor != null && inspectionModal.qlMinor != "null") {
      List<QualityLevelModal> qualityMinorList =
          await QualityLevelHandler.getDataAccordingToParticularList(
              inspectionModal.qlMinor!);
      if (qualityMinorList != null && qualityMinorList.isNotEmpty) {
        txtQualityLevelMinor = qualityMinorList[0].qualityLevel;
      }
      pRowIdOfQualityMinorLevel = inspectionModal.qlMinor!;
    } else {
      List<QualityLevelModal> qualityLevelList =
          await QualityLevelHandler.getQualityLevelList();
      if (qualityLevelList != null && qualityLevelList.isNotEmpty) {
        txtQualityLevelMinor = qualityLevelList[0].qualityLevel;
        pRowIdOfQualityMinorLevel = qualityLevelList[0].pRowID;
        inspectionModal.qlMinor = pRowIdOfQualityMinorLevel;
        inspectionModal.qlMinorDescr = qualityLevelList[0].qualityLevel;
      }
    }

    // Status
    if (inspectionModal.status != null && inspectionModal.status != "null") {
      List<SysData22Modal> statusList =
          await SysData22Handler.getSysData22ListAccToID(
              FEnumerations.statusGenId, inspectionModal.status!);
      if (statusList != null && statusList.isNotEmpty) {
        txtStatus = statusList[0].mainDescr;
      }
    } else {
      List<SysData22Modal> statusList =
          await SysData22Handler.getSysData22List(FEnumerations.statusGenId);
      if (statusList != null && statusList.isNotEmpty) {
        txtStatus = statusList[0].mainDescr;
        pRowIdOfStatus = statusList[0].mainID;
        inspectionModal.status = pRowIdOfStatus;
      }
    }
  }



  Future<void> onChangeInspectionLevel() async {
    print("onChangeInspectionLevel called!");
    print("_selectedInspectionLevel: $_selectedInspectionLevel");
    print("pRowIdOfInspectLevel: $pRowIdOfInspectLevel");
    print("availableQty: $availableQty");
    print("pRowIdOfQualityMinorLevel: $pRowIdOfQualityMinorLevel");
    print("pRowIdOfQualityMajorLevel: $pRowIdOfQualityMajorLevel");
    print("inspectionModal.qlMinor: ${inspectionModal.qlMinor}");
    print("inspectionModal.qlMajor: ${inspectionModal.qlMajor}");
    print("inspectionModal.activityID: ${inspectionModal.activityID}");
    print("pOItemDtlList:");
    for (var item in pOItemDtlList) {
      print("  POItemDtl: ${item.toString()}");
      // Or print specific fields, e.g.:
      // print("  availableQty: ${item.availableQty}, sampleSizeInspection: ${item.sampleSizeInspection}, inspectedQty: ${item.inspectedQty}");
    }
    if (pRowIdOfInspectLevel != null) {
      for (var i = 0; i < pOItemDtlList.length; i++) {
        var item = pOItemDtlList[i];

        if (inspectionModal.qlMinor == "DEL0000013" ||
            inspectionModal.qlMajor == "DEL0000013" ||
            inspectionModal.activityID == "SYS0000001") {
          List<String>? toInspDtl = await POItemDtlHandler.getToInspect(
              pRowIdOfInspectLevel!, item.availableQty ?? 0);

          if (toInspDtl != null) {
            item.sampleSizeInspection = null; // Previously commented concat
            item.inspectedQty = 0;
            item.allowedinspectionQty = 0;
            String sampleCode = toInspDtl[0];

            // Minor and major defects hard set to 0
            item.minorDefectsAllowed = 0;
            item.majorDefectsAllowed = 0;
          }
        } else {
          List<String>? toInspDtl = await POItemDtlHandler.getToInspect(
              pRowIdOfInspectLevel!, availableQty!);

          if (toInspDtl != null) {
            item.sampleSizeInspection = toInspDtl[1];
            item.inspectedQty = int.parse(toInspDtl[2]);
            item.allowedinspectionQty = int.parse(toInspDtl[2]);
            String sampleCode = toInspDtl[0];

            List<String>? minorDefect =
                await POItemDtlHandler.getDefectAccepted(
                    pRowIdOfQualityMinorLevel!, sampleCode);
            if (minorDefect != null && minorDefect.isNotEmpty) {
              item.minorDefectsAllowed = int.parse(minorDefect[1]);
            } else {
              item.minorDefectsAllowed = 0;
            }

            List<String>? majorDefect =
                await POItemDtlHandler.getDefectAccepted(
                    pRowIdOfQualityMajorLevel!, sampleCode);
            if (majorDefect != null && majorDefect.isNotEmpty) {
              item.majorDefectsAllowed = int.parse(majorDefect[1]);
            } else {
              item.majorDefectsAllowed = 0;
            }
          }
        }
      }
    }
  }


  Future<void> onChangeInspectionLevel() async {
    if (pRowIdOfInspectLevel != null) {
      for (int i = 0; i < pOItemDtlList.length; i++) {
        final item = pOItemDtlList[i];

        if (inspectionModal.qlMinor == "DEL0000013" ||
            inspectionModal.qlMajor == "DEL0000013" ||
            inspectionModal.activityID == "SYS0000001") {

          List<String>? toInspDtl = await POItemDtlHandler.getToInspect(

             pRowIdOfInspectLevel,
             item.availableQty ?? 0,
          );

          if (toInspDtl != null) {
            item.sampleSizeInspection = null;
            item.inspectedQty = 0;
            item.allowedinspectionQty = 0;

            // String sampleCode = toInspDtl[0]; // Not used here

            item.minorDefectsAllowed = 0;
            item.majorDefectsAllowed = 0;
          }

        } else {
          List<String>? toInspDtl = await POItemDtlHandler.getToInspect(
             pRowIdOfInspectLevel,
            item.availableQty ?? 0,
          );

          if (toInspDtl != null) {
            item.sampleSizeInspection = toInspDtl[1];
            item.inspectedQty = int.tryParse(toInspDtl[2]) ?? 0;
            item.allowedinspectionQty = int.tryParse(toInspDtl[2]) ?? 0;

            String sampleCode = toInspDtl[0];

            List<String>? minorDefect = await POItemDtlHandler.getDefectAccepted(

           pRowIdOfQualityMinorLevel,
               sampleCode,
            );

            item.minorDefectsAllowed = (minorDefect != null && minorDefect.length > 1)
                ? int.tryParse(minorDefect[1]) ?? 0
                : 0;

            List<String>? majorDefect = await POItemDtlHandler.getDefectAccepted(

         pRowIdOfQualityMajorLevel,
              sampleCode,
            );

            item.majorDefectsAllowed = (majorDefect != null && majorDefect.length > 1)
                ? int.tryParse(majorDefect[1]) ?? 0
                : 0;
          }
        }
      }
    }
  }





  @override
  void dispose() {
    _saveChangesIfChanged();
    _venderContact.dispose();
    _remarksController.dispose();
    super.dispose();
  }
}
*/
