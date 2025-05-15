
import 'package:buyerease/database/database_helper.dart';
import 'package:buyerease/utils/loading.dart';
import 'package:flutter/material.dart';

import '../over_all_result/over_all_result.dart';

class PoItem extends StatefulWidget {
  const PoItem({super.key});

  @override
  State<PoItem> createState() => _PoItemState();
}

class _PoItemState extends State<PoItem> {
  bool value = false;
  bool loading = true;
  dynamic data;
  List dataDeleteId = [];
  List<Map<String, dynamic>> _itemList = [];

  // Future<void> syncData() async {
  //   data = await SQLHelper.getTableData(1);
  //   debugPrint('getData $data');
  //   _itemList = data;
  //   setState(() {
  //     if (data.isNotEmpty) {
  //       loading = false;
  //       debugPrint('data $data');
  //     } else {
  //       debugPrint('data44 $data');
  //     }
  //   });
  // }

  Future<void> deleteData({required id}) async {
    // dataDeleteId = await SQLHelper.getTableDataRow(1, id);
    debugPrint('data $id 6,6 $dataDeleteId');
    // await SQLHelper.deleteRowFromTable(id,1);
  }

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
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Row(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              child: const Text('PO')),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              child: const Text('ITEM')),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              child: const Text('order')),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              child: const Text('Inspected Till Date')),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              child: const Text('Available')),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              child: const Text('Accepted')),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              child: const Text('Short')),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              child: const Text('Inspect Later')),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: ListView.builder(
                          itemCount: _itemList.length,
                          itemBuilder: (e, index) {
                            return Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.11,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1)),
                              child: Column(
                                children: [
                                  IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            alignment: Alignment.center,
                                            width: 28,
                                            height: 30,
                                            child: Text(_itemList[index]['PONO']
                                                .toString())),
                                        const VerticalDivider(thickness: 2),
                                        Container(
                                            alignment: Alignment.center,
                                            width: 25,
                                            height: 30,
                                            child: Text(_itemList[index]
                                                    ['CustomerItemRef']
                                                .toString())),
                                        const VerticalDivider(thickness: 2),
                                        Container(
                                            alignment: Alignment.center,
                                            width: 25,
                                            height: 30,
                                            child: Text(_itemList[index]
                                                    ['OrderQty']
                                                .toString())),
                                        const VerticalDivider(thickness: 2),
                                        Container(
                                            alignment: Alignment.center,
                                            width: 25,
                                            height: 30,
                                            child: Text(_itemList[index]
                                                    ['EarlierInspected']
                                                .toString())),
                                        const VerticalDivider(thickness: 2),
                                        Container(
                                            alignment: Alignment.center,
                                            width: 25,
                                            height: 30,
                                            child: Text(_itemList[index]
                                                    ['AvailableQty']
                                                .toString())),
                                        const VerticalDivider(thickness: 2),
                                        Container(
                                            alignment: Alignment.center,
                                            width: 25,
                                            height: 30,
                                            child: Text(_itemList[index]
                                                    ['AcceptedQty']
                                                .toString())),
                                        const VerticalDivider(thickness: 2),
                                        Container(
                                            alignment: Alignment.center,
                                            width: 25,
                                            height: 30,
                                            child: Text(_itemList[index]
                                                    ['ShortStockQty']
                                                .toString())),
                                        const VerticalDivider(thickness: 2),
                                        Container(
                                            alignment: Alignment.center,
                                            width: 25,
                                            height: 30,
                                            child: Checkbox(
                                                value: value,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    this.value = value!;
                                                  });
                                                })),
                                      ],
                                    ),
                                  ),
                                  const Divider(thickness: 1),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => OverAllResult(
                                                      id: _itemList[index]
                                                          ['pRowID']),
                                                ));
                                          },
                                          child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              child: Text(_itemList[index]
                                                  ['ItemDescr'])),
                                        ),
                                        Row(
                                          children: [
                                            Text('[New]',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                            SizedBox(width: 10),
                                            GestureDetector(
                                                onTap: () {
                                                  deleteData(id: _itemList[index]['id']);
                                                },
                                                child: const Icon(Icons.delete))
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
