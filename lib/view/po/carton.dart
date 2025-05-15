import 'package:buyerease/database/database_helper.dart';
import 'package:buyerease/utils/loading.dart';
import 'package:flutter/material.dart';

class Carton extends StatefulWidget {
  const Carton({super.key});

  @override
  State<Carton> createState() => _CartonState();
}

class _CartonState extends State<Carton> {
  List<Map<String, dynamic>> _itemList = [];
  bool loading = true;
  dynamic data;

  // Future<void> syncData() async {
  //   data = await SQLHelper.getTableData(1);
  //   _itemList = data;
  //   setState(() {
  //     if (data != []) {
  //       loading = false;
  //     } else {
  //       debugPrint('data44 $data');
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // syncData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loading == true
            ? const Center(child: Loading())
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: SingleChildScrollView(
                  child: DataTable(
                    columnSpacing: MediaQuery.of(context).size.width * 0.02,
                    border: TableBorder.all(color: Colors.black),
                    columns: const [
                      DataColumn(label: Expanded(child: Center(child: Text('PO')))),
                      DataColumn(label: Expanded(child: Center(child: Text('item')))),
                      DataColumn(label: Expanded(child: Center(child: Text('Packed')))),
                      DataColumn(label: Expanded(child: Center(child: Text('Available')))),
                      DataColumn(label: Expanded(child: Center(child: Text('To Inspected')))),
                    ],
                    rows: _itemList.map<DataRow>((item) {
                      return DataRow(cells: [
                        DataCell(Center(child: Text(item['PONO'].toString()))),
                        DataCell(Center(child: Text(item['CustomerItemRef'].toString()))),
                        DataCell(Center(child: Text(item['PackedQty'].toString()))),
                        DataCell(Center(child: Text(item['CartonsPacked2'].toString()))),
                        DataCell(Center(child: Text(item['CartonsPacked2'].toString()))),
                      ]);
                    }).toList(),
                  ),
                ),
              ));
  }
}
