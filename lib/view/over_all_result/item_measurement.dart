import 'package:buyerease/components/remarks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/custom_table.dart';
import '../../main.dart';
import 'add_measurement.dart';

class ItemMeasurement extends StatefulWidget {
  const ItemMeasurement({super.key});

  @override
  State<ItemMeasurement> createState() => _ItemMeasurementState();
}

class _ItemMeasurementState extends State<ItemMeasurement> {
  String overallResult = 'PASS';
  final List<String> resultOptions = ['PASS', 'FAIL'];
  String? _dropDownValue;
  String? remark;
  String? toleranceRange;
  String? description;
  
  // List to store measurements
  List<Map<String, dynamic>> measurements = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Over All Result + Add Item Row
            Row(
              children: [
                const Text(
                  "Overall Result",
                  style: TextStyle( fontSize: 14),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: overallResult,
                  items: resultOptions.map((value) {
                    return DropdownMenuItem(value: value, child: Text(value, style: TextStyle( fontSize: 14),));
                  }).toList(),
                  onChanged: (val) => setState(() => overallResult = val!),
                ),

              ],
            ),
            const SizedBox(height: 10),

            // Table Header and Data
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  CustomTable(
                    rowData: [
                      'Length',
                      'Height',
                      'Width',
                      'Sample Size',
                      'Action',
                    ].map((data) => Text(data, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp)))
                        .toList(),
                    isHeader: true,
                    isFirstCellClickable: false,
                  ),

                  // Data Rows
                  ...measurements.map((measurement) => Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: CustomTable(
                      rowData: [
                        Text(measurement['length'] ?? ''),
                        Text(measurement['height'] ?? ''),
                        Text(measurement['width'] ?? ''),
                        Text(measurement[' '] ?? ''),
                        Text(measurement[''] ?? ''),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text('Are you sure you want to delete this measurement?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          measurements.remove(measurement);
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                      isHeader: false,
                      isFirstCellClickable: false,
                    ),
                  )).toList(),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Remark
            Remarks()
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 20),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddMeasurement()),
            );
            
            if (result != null && result is Map<String, dynamic>) {
              setState(() {
                measurements.add(result);
              });
            }
          },
          child: const Icon(Icons.add_circle_outline),
        ),
      ),
    );
  }
}
