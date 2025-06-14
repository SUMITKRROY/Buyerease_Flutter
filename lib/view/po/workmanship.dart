import 'package:buyerease/database/database_helper.dart';
import 'package:buyerease/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:buyerease/view/po/add_workmanship.dart';

import '../../components/over_all_dropdown.dart';
import '../../components/remarks.dart';

class WorkManShip extends StatefulWidget {
  const WorkManShip({super.key});

  @override
  State<WorkManShip> createState() => _WorkManShipState();
}

class _WorkManShipState extends State<WorkManShip> {
  String overallResult = 'PASS';
  final List<String> resultOptions = ['PASS', 'FAIL'];
  bool loading = true;
  bool noData = false;
  dynamic data;
  List<Map<String, dynamic>> _itemList = [];

  Future<void> syncData() async {
    // data = await SQLHelper.getTableData(1);
    setState(() {
      if (data != []) {
        _itemList = data;
        loading = false;
      } else {
        loading = false;
        noData = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    syncData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overall Result Row
        OverAllDropdown(),
        SizedBox(height: 20),

        // New Table for displaying _itemList
        Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(),
            2: FlexColumnWidth(),
            3: FlexColumnWidth(),
            4: FlexColumnWidth(),
            5: FlexColumnWidth(0.5), // For the delete icon column
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey.shade300),
              children: [
                tableCell("Code"),
                tableCell("Critical"),
                tableCell("Major"),
                tableCell("Minor"),
                tableCell("Total"),
                tableCell(""), // For delete icon
              ],
            ),
            ...
                _itemList.map((item) {
                  return TableRow(
                    children: [
                      tableCell(item['code'].toString()),
                      tableCell(item['critical'].toString()),
                      tableCell(item['major'].toString()),
                      tableCell(item['minor'].toString()),
                      tableCell(item['total'].toString()),
                      TableCell(
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _itemList.remove(item);
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ],
        ),
        SizedBox(height: 20),

        // Find Button
        ElevatedButton(
          onPressed: () {
            // Find logic
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
          ),
          child: Text("Find"),
        ),
        SizedBox(height: 20),

        // Original Table (below Find Button)
        Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(),
            2: FlexColumnWidth(),
            3: FlexColumnWidth(),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey.shade300),
              children: [
                tableCell(""),
                tableCell("Critical"),
                tableCell("Major"),
                tableCell("Minor"),
              ],
            ),
            TableRow(
              children: [
                tableCell("Total"),
                tableCell(_itemList.fold<int>(0, (sum, item) => sum + (item['critical'] as int)).toString()),
                tableCell(_itemList.fold<int>(0, (sum, item) => sum + (item['major'] as int)).toString()),
                tableCell(_itemList.fold<int>(0, (sum, item) => sum + (item['minor'] as int)).toString()),
              ],
            ),
            TableRow(
              children: [
                tableCell("Permissible Defect"),
                tableCell("0"),
                tableCell("0"),
                tableCell("0"),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),

        // Remark
        Remarks()
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

  Widget tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, textAlign: TextAlign.center),
    );
  }
}
