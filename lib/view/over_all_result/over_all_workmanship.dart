import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/custom_table.dart';
import '../../components/over_all_dropdown.dart';
import '../../components/remarks.dart';
import '../../config/theame_data.dart';
import '../../database/table/qr_po_item_dtl_table.dart';
import '../../model/po_item_dtl_model.dart';
import '../po/add_workmanship.dart';

class WorkManShip extends StatefulWidget {
  final String id;
  const WorkManShip({super.key, required this.id});

  @override
  State<WorkManShip> createState() => _WorkManShipState();
}

class _WorkManShipState extends State<WorkManShip> {
  String overallResult = 'PASS';
  final List<String> resultOptions = ['PASS', 'FAIL'];
  bool loading = true;
  bool noData = false;
  List<POItemDtl> poItems = [];
  List<Map<String, dynamic>> _itemList = [];

  Future<void> syncData() async {
    try {
      final qrPoItemDtlTable = QRPOItemDtlTable();
      final items = await qrPoItemDtlTable.getByCustomerItemRefAndEnabled(widget.id);
      setState(() {
        poItems = items;
        if (items.isNotEmpty) {
          overallResult = items.first.workmanshipInspectionResult ?? 'PASS';
        }
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        noData = true;
      });
      print('Error loading data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    syncData();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (noData || poItems.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final item = poItems.first;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overall Result Row
          OverAllDropdown(),
          SizedBox(height: 20.h),

          // First Table - Item List
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTable(
                  rowData: [
                    'Code',
                    'Critical',
                    'Major',
                    'Minor',
                    'Total',
                    '',
                  ].map((data) => Text(
                        data,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      )).toList(),
                  isHeader: true,
                  isFirstCellClickable: false,
                ),
                ..._itemList.map((item) => CustomTable(
                  rowData: [
                    item['code'].toString(),
                    item['critical'].toString(),
                    item['major'].toString(),
                    item['minor'].toString(),
                    item['total'].toString(),
                    '',
                  ].map((data) => Text(
                        data,
                        style: TextStyle(fontSize: 10.sp),
                      )).toList(),
                  isFirstCellClickable: false,
                )).toList(),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Find Button
          ElevatedButton(
            onPressed: () {
              // Find logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
            child: const Text("Find"),
          ),
          SizedBox(height: 20.h),

          // Second Table - Summary
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTable(
                  rowData: [
                    '',
                    'Critical',
                    'Major',
                    'Minor',
                  ].map((data) => Text(
                        data,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      )).toList(),
                  isHeader: true,
                  isFirstCellClickable: false,
                ),
                CustomTable(
                  rowData: [
                    'Total',
                    item.criticalDefect?.toString() ?? '0',
                    item.majorDefect?.toString() ?? '0',
                    item.minorDefect?.toString() ?? '0',
                  ].map((data) => Text(
                        data,
                        style: TextStyle(fontSize: 10.sp),
                      )).toList(),
                  isFirstCellClickable: false,
                ),
                CustomTable(
                  rowData: [
                    'Permissible Defect',
                    item.criticalDefectsAllowed?.toString() ?? '0',
                    item.majorDefectsAllowed?.toString() ?? '0',
                    item.minorDefectsAllowed?.toString() ?? '0',
                  ].map((data) => Text(
                        data,
                        style: TextStyle(fontSize: 10.sp),
                      )).toList(),
                  isFirstCellClickable: false,
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Remark
          Remarks(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 20),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddWorkManShip()),
            );
            if (result != null) {
              setState(() {
                _itemList.add(result);
              });
            }
          },
          child: const Icon(Icons.add_circle_outline),
        ),
      ),
    );
  }
}
