import 'dart:io';

import 'package:buyerease/components/add_image_icon.dart';
import 'package:buyerease/components/over_all_dropdown.dart';
import 'package:buyerease/utils/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/remarks.dart';
import '../../config/theame_data.dart';

class PackingMeasurement extends StatefulWidget {
  const PackingMeasurement({super.key});

  @override
  State<PackingMeasurement> createState() => _PackingMeasurementState();
}

class _PackingMeasurementState extends State<PackingMeasurement> {
  final List<Map<String, dynamic>> _itemList = [
    {
      'L': '10.0',
      'B': '14.0',
      'H': '6.0',
      'Wt': '0.0',
      'CBM': '9.0E-4',
      'Quantity': '0.0'
    }
  ];
  final ImagePickerService _imagePickerService = ImagePickerService();
  String imageName = '';
  final lController = TextEditingController();
  final bController = TextEditingController();
  final hController = TextEditingController();
  final wtController = TextEditingController();
  final cbmController = TextEditingController();
  final quantityController = TextEditingController();
  final remarkController = TextEditingController();
  String? _dropDownValue;
  String? remark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            // Over All Result Row
           OverAllDropdown(),
            const Divider(thickness: 1, color: ColorsData.primaryColor),

            // Measurement Card
            Card(
              color: Colors.grey.shade100,
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Item Dimension",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            const Text("In inch",
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        DropdownButton<String>(
                          value: "A(5)",
                          style: const TextStyle(fontSize: 12),
                          items: const [
                            DropdownMenuItem(
                                value: "A(5)",
                                child: Text("A(5)",
                                    style: TextStyle(fontSize: 12,color:ColorsData.primaryColor))),
                            DropdownMenuItem(
                                value: "B(2)",
                                child: Text("B(2)",
                                    style: TextStyle(fontSize: 12,color:ColorsData.primaryColor))),
                          ],
                          onChanged: (val) {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    /// Table Header
                    Row(
                      children: [
                        for (var col in ["L", "B", "H", "Wt.", "CRM", "Quantity"])
                          Expanded(
                            child: Text(
                              col,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    /// Table Data Row
                    Row(
                      children: [
                        for (var data in ["0.0", "0.0", "0.0", "0", "0.0555", ""])
                          Expanded(
                            child: Text(
                              data,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// Findings Row
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Findings",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    /// Result Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Result label and dropdown
                        Row(
                          children: [
                            const Text(
                              "Result",
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 10),
                            DropdownButton<String>(
                              value: "PASS",
                              style: const TextStyle(fontSize: 12),
                              items: const [
                                DropdownMenuItem(
                                    value: "PASS",
                                    child: Text("PASS",
                                        style: TextStyle(fontSize: 12,color: ColorsData.primaryColor))),
                                DropdownMenuItem(
                                    value: "FAIL",
                                    child: Text("FAIL",
                                        style: TextStyle(fontSize: 12,color:ColorsData.primaryColor))),
                              ],
                              onChanged: (val) {},
                            ),
                          ],
                        ),

                        // Camera icon and count
                        Row(
                          children: [
                            const Text(
                              "0",
                              style: TextStyle(
                                color: Colors.teal,
                                fontSize: 12,
                              ),
                            ),
                            AddImageIcon()
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Remark
            Remarks()
          ],
        ),
      ),
    );
  }
}
