import 'dart:developer' as developer;

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
import '../../services/quality_level_handler.dart';
import '../../services/po_item_dtl_handler.dart';
import '../po/po_item.dart';
import '../po/po_page.dart';

class InspectionDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  InspectionDetailScreen({required this.data});

  @override
  _InspectionDetailScreenState createState() => _InspectionDetailScreenState();
}

class _InspectionDetailScreenState extends State<InspectionDetailScreen> {
  bool _isFirstSectionExpanded = true;
  bool _isSecondSectionExpanded = true;
  
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

  @override
  void initState() {
    super.initState();
    developer.log("Inspection Detail Data: ${widget.data}");
    getList(context, widget.data['pRowID']);
    _loadInspectionLevels();
    _loadQualityLevels();
    fetchAndShowStatus();
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
                Text(title, style: TextStyle(fontSize: 18)),
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
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: ColorsData.primaryColor,
        title: Text(widget.data['pRowID'] ?? '', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('SAVE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildExpandableSection(
            title: widget.data['inspectionDt'] ?? '',
            isExpanded: _isFirstSectionExpanded,
            onToggle: () {
              setState(() {
                _isFirstSectionExpanded = !_isFirstSectionExpanded;
              });
            },
            children: [
              _infoRow('Customer', widget.data['customer'] ?? ''),
              _infoRow('Vendor', widget.data['vendor'] ?? ''),
              _infoRow('Inspector', widget.data['inspector'] ?? ''),
              _infoRow('Activity', widget.data['activity'] ?? ''),
              _infoRow('Location', widget.data['vendorAddress'] ?? ''),
              _infoRowWithTextField('Vendor Representative', widget.data['vendorContact'] ?? ''),
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
                      child: _dropdownField('Inspection Level', ['G-II']),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _dropdownField('Quality Level Major', ['AQL 2.5']),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _dropdownField('Quality Level Minor', ['AQL 2.5']),
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
            decoration: InputDecoration(
              labelText: 'Remark',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 24),
          OutlinedButton(
            onPressed: () {
              developer.log('Items fetched: ${widget.data['pRowID']}');
              String prowId = widget.data['pRowID'];
              // Navigator.of(context).pushNamed(RoutePath.po);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> PoPage(pRowId: prowId,)));
            },
            child: Text('GO TO  PO DETAILS'),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 48),
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
        ],
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
          value: level.qualityLevel,
          child: Text('${level.qualityLevel}', style: TextStyle(fontSize: 12.sp)),
        )).toList(),
        onChanged: (value) {
          setState(() {
            _selectedQualityLevelMajor = value;
          });
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
          value: level.qualityLevel,
          child: Text('${level.qualityLevel}', style: TextStyle(fontSize: 12.sp)),
        )).toList(),
        onChanged: (value) {
          setState(() {
            _selectedQualityLevelMinor = value;
          });
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
      onTap: () {
        setState(() {
          _selectedLevel = label;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: [
            Radio<String>(
              value: label,
              groupValue: _selectedLevel,
              onChanged: (value) {
                setState(() {
                  _selectedLevel = value!;
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
}
