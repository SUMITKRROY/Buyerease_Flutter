import 'dart:developer' as developer;

import 'package:buyerease/database/database_helper.dart';
import 'package:buyerease/routes/my_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theame_data.dart';
import '../../database/table/sysdata22_table.dart';
import '../../model/inspection_level_model.dart';
import '../../model/quality_level_model.dart';
import '../../model/inspection_model.dart';
import '../../model/po_item_dtl_model.dart';
import '../../routes/route_path.dart';
import '../../services/inspection_level_handler.dart';
import '../../services/inspection_list/InspectionListHandler.dart';
import '../../services/quality_level_handler.dart';
import '../../services/po_item_dtl_handler.dart';
import '../po/po_item.dart';
import '../po/po_page.dart';
import 'package:fluttertoast/fluttertoast.dart';


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
  List<Map<String, dynamic>> inspectionData = [];
  Set<String> selectedItems = {};
  bool isOpen = true; // Track open/closed state
  Set<String> syncedItems = {}; // Track synced items
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
  List<QualityLevelModel> _qualityLevels = [];
  String? _selectedQualityLevelMajor;
  String? _selectedQualityLevelMinor;
  List<String> statusList = [];

  DateTime? _selectedInspectionDate;

  @override
  void initState() {
    super.initState();
    developer.log("Inspection Detail Data: ${widget.data}");
    getList(context, widget.data['pRowID']);
    _loadInspectionLevels();
    _loadQualityLevels();
    fetchAndShowStatus();
    getLocalList(widget.data['pRowID']);
  }



  Future<void> getLocalList(String searchStr) async {
    setState(() {
      isLoading = true;
    });
    try {
      List<InspectionModal> localList = await InspectionListHandler.getInspectionList(searchStr);
      setState(() {
        inspectionList.clear();
        if (localList.isNotEmpty) {
          inspectionList.addAll(localList);
          final first = inspectionList.first;
          _selectedQualityLevelMajor = first.qlMajorDescr;
          _selectedQualityLevelMinor = first.qlMinorDescr;
          _selectedInspectionLevel = first.inspectionLevelDescr;
          _venderContact.text = first.vendorContact ?? '';
          _remarksController.text = first.comments ?? '';
          _arrivalTime = (first.arrivalTime != null && first.arrivalTime!.isNotEmpty) ? _parseTimeOfDay(first.arrivalTime!) : null;
          _startTime = (first.inspStartTime != null && first.inspStartTime!.isNotEmpty) ? _parseTimeOfDay(first.inspStartTime!) : null;
          _completeTime = (first.completeTime != null && first.completeTime!.isNotEmpty) ? _parseTimeOfDay(first.completeTime!) : null;
          _selectedInspectionDate = first.inspectionDt != null && first.inspectionDt!.isNotEmpty
            ? DateTime.parse(first.inspectionDt!)
            : DateTime.now();
          Fluttertoast.showToast(msg: ">>>${_venderContact.text}");
        } else {
          Fluttertoast.showToast(msg: "Inspection did not find");
        }
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching local list: $e");
      Fluttertoast.showToast(msg: "Failed to load inspections");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
    pOItemDtlList.addAll(await POItemDtlHandler.getItemList(context, pRowID));
  }

  Future<void> _selectTime(BuildContext context, bool isArrival, bool isStart, bool isComplete) async {
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
                    DateTime initialDate = _selectedInspectionDate ?? DateTime.now();
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: initialDate.isBefore(DateTime.now()) ? DateTime.now() : initialDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedInspectionDate = picked;
                        inspectionList.first.inspectionDt = picked.toIso8601String().split('T').first; // 'yyyy-MM-dd'
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
                              : 'Select Date',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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

    return WillPopScope(
      onWillPop: () async {
        await _saveChangesIfChanged();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          backgroundColor: ColorsData.primaryColor,
          title: Text(item.pRowID ?? '', style: TextStyle(color: Colors.white)),
          // title: Text(widget.data['pRowID'] ?? '', style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed:  _saveChanges ,
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
                _infoRowWithTextField('Vendor Representative', item.vendorContact ?? ''),

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
                        child: _dropdownField('Inspection Level', ['${item.inspectionLevelDescr}']),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _dropdownField('Quality Level Major', ['${item.qlMajorDescr}']),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _dropdownField('Quality Level Minor', ['${item.qlMinorDescr}']),
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=> PoPage(pRowId: widget.data['pRowID'],)));
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
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: TextStyle(color: Colors.grey))),
          Expanded(child: Text(value, style: TextStyle(fontWeight: FontWeight.w500))),
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
            child: Text(label, style: TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: TextFormField(
              controller: _venderContact,
              onChanged: (_) => _saveChangesIfChanged(),
              decoration: InputDecoration(
                hintText: hint,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                border: UnderlineInputBorder(), // <-- Only underline
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Customize color if needed
                ),
                focusedBorder: UnderlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
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
                color: _selectedLevel == label ? ColorsData.primaryColor : Colors.black,
                fontWeight: _selectedLevel == label ? FontWeight.bold : FontWeight.normal,
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
                onPressed: () => _selectTime(context, isArrival, isStart, isComplete),
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
    return
      (_selectedInspectionLevel != null && _selectedInspectionLevel != item.inspectionLevelDescr) ||
      (_selectedQualityLevelMajor != null && _selectedQualityLevelMajor != item.qlMajorDescr) ||
      (_selectedQualityLevelMinor != null && _selectedQualityLevelMinor != item.qlMinorDescr);
  }

  void _saveChanges() async {
    if (inspectionList.isEmpty) return;
    final item = inspectionList.first;

    // Update fields from UI
    item.vendorContact = _venderContact.text;
    item.inspectionLevelDescr = _selectedInspectionLevel ?? item.inspectionLevelDescr;
    item.qlMajorDescr = _selectedQualityLevelMajor ?? item.qlMajorDescr;
    item.qlMinorDescr = _selectedQualityLevelMinor ?? item.qlMinorDescr;
    item.comments = _remarksController.text;

    // Convert TimeOfDay to string (HH:mm) for DB
    item.arrivalTime = _arrivalTime != null ? _formatTimeOfDay(_arrivalTime!) : item.arrivalTime;
    item.inspStartTime = _startTime != null ? _formatTimeOfDay(_startTime!) : item.inspStartTime;
    item.completeTime = _completeTime != null ? _formatTimeOfDay(_completeTime!) : item.completeTime;

    // Get the database instance
    final db = await DatabaseHelper().database;

    // Call your update method
    item.inspectionDt = _selectedInspectionDate != null
      ? _selectedInspectionDate!.toIso8601String().split('T').first
      : item.inspectionDt;
    await InspectionListHandler.updatePOItemHdr(db, item);

    Fluttertoast.showToast(msg: "Changes saved!");

    setState(() {
      inspectionList[0] = item;
    });
  }

  Future<void> _saveChangesIfChanged() async {
    if (isChanged) {
      _saveChanges();
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
