import 'dart:io';

import 'package:buyerease/components/add_image_icon.dart';
import 'package:buyerease/utils/camera.dart';
import 'package:flutter/material.dart';

import '../../components/over_all_dropdown.dart';
import '../../components/remarks.dart';
import '../../config/theame_data.dart';

class BarCode extends StatefulWidget {
  final String id;

    BarCode({super.key,required this.id});

  @override
  State<BarCode> createState() => _BarCodeState();
}

class _BarCodeState extends State<BarCode> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  final specificationController = TextEditingController();
  final visualController = TextEditingController();
  String? _dropDownValue;
  String? remark;
  List dataBarCode = ['Unit Packing', 'Master Packing'];
  List<String> base64string = [];
  String? imageType;
  String imageName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              OverAllDropdown(),
              /// Card layout
              Card(
                margin: const EdgeInsets.all(12),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title + dropdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Unit Packing",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                              fontSize: 14, // Font size 14
                            ),
                          ),
                          DropdownButton<String>(
                            value: "A(5)",
                            items: const [
                              DropdownMenuItem(value: "A(5)", child: Text("A(5)", style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: "B(2)", child: Text("B(2)", style: TextStyle(fontSize: 12))),
                            ],
                            onChanged: (val) {},
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      /// Specification & Visual fields
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: "Specification",
                                labelStyle: TextStyle(fontSize: 12), // Font size 12
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: "Visual",
                                labelStyle: TextStyle(fontSize: 12), // Font size 12
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      /// Scan + Result + Camera
                      /// Scan + Result Dropdown + Camera in one row
                      Row(
                        children: [
                          /// Scan field
                          Expanded(
                            flex: 4,
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: "Scan",
                                labelStyle: TextStyle(fontSize: 12), // Font size 12
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          /// Result dropdown
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              value: "PASS",
                              items: const [
                                DropdownMenuItem(value: "PASS", child: Text("PASS", style: TextStyle(fontSize: 12))),
                                DropdownMenuItem(value: "FAIL", child: Text("FAIL", style: TextStyle(fontSize: 12))),
                              ],
                              onChanged: (val) {},
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      /// Camera icon
                      Align(
                        alignment: Alignment.centerRight,
                        child: AddImageIcon(title: "Unit Barcode", id: widget.id,)
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
      ),
    );
  }
}
