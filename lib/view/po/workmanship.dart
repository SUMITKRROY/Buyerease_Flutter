import 'package:buyerease/database/database_helper.dart';
import 'package:buyerease/utils/loading.dart';
import 'package:flutter/material.dart';

class WorkManShip extends StatefulWidget {
  const WorkManShip({super.key});

  @override
  State<WorkManShip> createState() => _WorkManShipState();
}

class _WorkManShipState extends State<WorkManShip> {
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
        body: loading == true
            ? const Center(child: Loading())
            : Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                child: SingleChildScrollView(
                  child: noData == true
                      ? const Center(child: Text('No Record Found'))
                      : DataTable(
                          columnSpacing: MediaQuery.of(context).size.width * 0.01,
                          border: TableBorder.all(color: Colors.black),
                          columns: const [
                            DataColumn(label: Center( child: Text('PO'))),
                            DataColumn(label: Center( child: Text('Item'))),
                            DataColumn(label: Center( child: Text('To Inspection'))),
                            DataColumn(label: Center( child: Text('Inspected'))),
                            DataColumn(label: Center( child: Text('Critical'))),
                            DataColumn(label: Center( child: Text('Major'))),
                            DataColumn(label: Center( child: Text('Minor'))),
                          ],
                          rows: _itemList.map<DataRow>((item) {
                            return DataRow(cells: [
                              DataCell(Center(child: SizedBox(width: 30, child: Text(item['PONO'].toString())))),
                              DataCell(Center(child: SizedBox(width: 40, child: Text(item['CustomerItemRef'].toString())))),
                              DataCell(Center(child: Text(item['OrderQty'].toString()))),
                              DataCell(Center(child: Text(item['IPQty'].toString()))),
                              DataCell(Center(child: Text(item['CriticalDefect'].toString()))),
                              DataCell(Center(child: Text(item['MajorDefect'].toString()))),
                              DataCell(Center(child: Text(item['MinorDefect'].toString()))),
                            ]);
                          }).toList(),
                        ),
                ),
              ));
  }
}
