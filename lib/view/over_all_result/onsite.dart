import 'package:buyerease/components/over_all_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/custom_table.dart';
import '../../components/remarks.dart';
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
  String? _dropDownValue;
  String? remark;
  final List<String> sampleSizes = [
    'A(5)', 'B(3)', 'C(5)', 'D(8)', 'E(13)',
    'F(20)', 'G(32)', 'H(50)', 'J(80)', 'K(125)',
    'L(200)', 'M(315)', 'N(500)', 'Q(1250)', 'P(800)',
  ];
  String selectedSample = 'A(5)';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadInspectionLevels();
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
      body: SingleChildScrollView(  // Wrap the entire content with SingleChildScrollView
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
                Expanded(    flex: 3,child: Text("Description", style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(    flex: 3,child: Text("Sample Size", style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(    flex: 2,child: Text("Result", style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            SizedBox(height: 20),

            // Displaying the selected rows
            ListView.builder(
              shrinkWrap: true,  // This makes the ListView take only the space it needs
              physics: NeverScrollableScrollPhysics(),  // Disable scrolling for the list
              itemCount: rows.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: Text(rows[index]['purpose'],style: TextStyle(fontSize: 12))),
                        Expanded(
                          flex: 1,
                          child: DropdownButton<String>(

                            value: _selectedInspectionLevel,
                            items: _inspectionLevels.map((level) {
                              return DropdownMenuItem(
                                value: level.inspAbbrv,
                                child: Text('${level.inspAbbrv}', style: TextStyle(fontSize: 12.sp)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedInspectionLevel = value;
                              });
                            },

                          ),
                        )
,
                        // Sample Size Dropdown
                        Expanded(
                          flex: 1,
                          child: DropdownButton<String>(
                            // isExpanded: true,
                            value: selectedSample,
                            underline: const SizedBox(),
                            onChanged: (value) {
                              // Optional: Handle change
                            },
                            items: sampleSizes.map((size) {
                              return DropdownMenuItem(
                                value: size,
                                child: Text(size, style: const TextStyle(fontSize: 12)),
                              );
                            }).toList(),
                          ),
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogOption('ON SITE TEST TO BE CHECKED'),
              _buildDialogOption('FIT SAMPLE'),
              _buildDialogOption('TEST'),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        // Add the selected data (inspection type) to the rows
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
