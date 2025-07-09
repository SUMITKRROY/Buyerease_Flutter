import 'package:buyerease/components/over_all_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/custom_table.dart';
import '../../components/remarks.dart';
import '../../config/theame_data.dart';
import '../../database/table/genmst.dart';
import '../../model/inspection_level_model.dart';
import '../../services/inspection_level_handler.dart';

class OnSite extends StatefulWidget {
  const OnSite({super.key});

  @override
  State<OnSite> createState() => _OnSiteState();
}

class _OnSiteState extends State<OnSite> {
  final List<Map<String, dynamic>> rows = [];
  String overallResult = 'PASS';
  final List<String> resultOptions = ['PASS', 'FAIL'];
  String? _selectedInspectionLevel;
  // Add inspection level state
  List<InspectionLevelModel> _inspectionLevels = [];
  List<String> _items = [];
  String? _selected;
  bool _loading = true;

  String? _dropDownValue;
  String? remark;
  final List<String> sampleSizes = [
    'A(5)',
    'B(3)',
    'C(5)',
    'D(8)',
    'E(13)',
    'F(20)',
    'G(32)',
    'H(50)',
    'J(80)',
    'K(125)',
    'L(200)',
    'M(315)',
    'N(500)',
    'Q(1250)',
    'P(800)',
  ];
  String selectedSample = 'A(5)';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadInspectionLevels();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Wrap the entire content with SingleChildScrollView
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Result Row
            OverAllDropdown(),
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
                    child: Text("Description",
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
            ListView.builder(
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
                          DropdownButton<String>(
                            isExpanded: false,
                            value: _selectedInspectionLevel,
                            items: _inspectionLevels.map((level) {
                              return DropdownMenuItem(
                                value: level.inspAbbrv,
                                child: Text('${level.inspAbbrv}',
                                    style: TextStyle(fontSize: 12.sp)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedInspectionLevel = value;
                              });
                            },
                          ),

                        // Sample Size Dropdown

                           DropdownButton<String>(
                            // isExpanded: true,
                            value: selectedSample,
                            underline: const SizedBox(),
                            onChanged: (value) {
                              // Optional: Handle change
                            },
                            items: sampleSizes.map((size) {
                              return DropdownMenuItem(
                                value: size,
                                child: Text(size,
                                    style: const TextStyle(fontSize: 12)),
                              );
                            }).toList(),
                          ),

                        DropdownButton(
                          hint: _dropDownValue == null
                              ? Text('Select',
                                  style: TextStyle(fontSize: 12.sp))
                              : Text(
                                  _dropDownValue!,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                          iconSize: 15.0,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12),
                          items: ['PASS', 'FAILED'].map(
                            (val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val,
                                    style: const TextStyle(fontSize: 12)),
                              );
                            },
                          ).toList(),
                          onChanged: (val) {
                            setState(
                              () {
                                _dropDownValue = val;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Remark
            Remarks()
          ],
        ),
      ),

      // Floating action button
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 20),
        child: FloatingActionButton(
          onPressed: _showInspectionDialog,
          child: const Icon(Icons.add_circle_outline),
        ),
      ),
    );
  }

  void _showInspectionDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Select Inspection Level',
            style: TextStyle(fontSize: 14),
          ),
          content: Container(
            width: double.maxFinite,
            child: _loading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          _items[index],
                          style: const TextStyle(fontSize: 12),
                        ),
                        onTap: () => Navigator.of(context).pop(_items[index]),
                      );
                    },
                  ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        rows.add({'purpose': result, 'samples': 0});
      });
    }
  }

  Widget _buildDialogOption(String title) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 12),
      ),
      onTap: () => Navigator.of(context).pop(title),
    );
  }
}
