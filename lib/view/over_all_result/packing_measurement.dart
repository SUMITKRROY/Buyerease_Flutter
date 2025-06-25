import 'dart:io';

import 'package:buyerease/components/add_image_icon.dart';
import 'package:buyerease/components/over_all_dropdown.dart';
import 'package:buyerease/utils/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/remarks.dart';
import '../../config/theame_data.dart';
import '../../database/table/qr_po_item_dtl_table.dart';
import '../../model/po_item_dtl_model.dart';

class PackingMeasurement extends StatefulWidget {
  final String id;
  final VoidCallback onChanged; // ✅ Add this

  const PackingMeasurement({super.key, required this.id, required this.onChanged});

  @override
  State<PackingMeasurement> createState() => _PackingMeasurementState();
}

class _PackingMeasurementState extends State<PackingMeasurement> {
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
  List<POItemDtl> poItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final qrPoItemDtlTable = QRPOItemDtlTable();
      final items = await qrPoItemDtlTable.getByCustomerItemRefAndEnabled(widget.id);
      setState(() {
        poItems = items;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (poItems.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final item = poItems.first; // Get the first item for now

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
                        Expanded(child: Text(item.unitL?.toString() ?? '0.0', style: const TextStyle(fontSize: 12))),
                        Expanded(child: Text(item.unitW?.toString() ?? '0.0', style: const TextStyle(fontSize: 12))),
                        Expanded(child: Text(item.unitH?.toString() ?? '0.0', style: const TextStyle(fontSize: 12))),
                        Expanded(child: Text(item.weight?.toString() ?? '0', style: const TextStyle(fontSize: 12))),
                        Expanded(child: Text(item.cbm?.toString() ?? '0.0', style: const TextStyle(fontSize: 12))),
                        Expanded(child: Text(item.mapCountUnit?.toString() ?? '', style: const TextStyle(fontSize: 12))),
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
                              value: item.pkgMeInspectionResult ?? "PASS",
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
                        AddImageIcon(title: "Unit pack", id: widget.id,)
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
  Future<void> saveChanges() async {
    setState(() {});
    widget.onChanged.call();
  }
}
