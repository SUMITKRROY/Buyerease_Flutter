import 'package:buyerease/database/database_helper.dart';
import 'package:buyerease/utils/loading.dart';
import 'package:flutter/material.dart';

class MoreDetails extends StatefulWidget {
  const MoreDetails({super.key});

  @override
  State<MoreDetails> createState() => _MoreDetailsState();
}

class _MoreDetailsState extends State<MoreDetails> {
  bool loading = true;
  dynamic data;
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
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                child: SingleChildScrollView(
                  child:
                      // DataTable(
                      //   columnSpacing: MediaQuery.of(context).size.width * 0.01,
                      //   border: TableBorder.all(color: Colors.black),
                      //   columns: const [
                      //     DataColumn(label: Expanded(child: Center(child: Text('PO')))),
                      //     DataColumn(label: Expanded(child: Center(child: Text('item')))),
                      //     DataColumn(label: Expanded(child: Center(child: Text('To Inspection')))),
                      //     DataColumn(label: Expanded(child: Center(child: Text('Inspected')))),
                      //     DataColumn(label: Expanded(child: Center(child: Text('Critical')))),
                      //     DataColumn(label: Expanded(child: Center(child: Text('Major')))),
                      //     DataColumn(label: Expanded(child: Center(child: Text('Hologram No')),)),
                      //     // DataColumn(label: Text('Delete')),
                      //   ],
                      //   rows: _itemList.map<DataRow>((item) {
                      //     return DataRow(cells: [
                      //       DataCell(SizedBox(
                      //           width: 30, child: Text(item['PONO'].toString()))),
                      //       DataCell(Center(child: SizedBox(width: 30, child:
                      //                   Text(item['CustomerItemRef'].toString())))),
                      //       // DataCell(Center(child: Text(item['ItemDescr'] as String))),
                      //       DataCell(
                      //           Center(child: Text(item['OrderQty'].toString()))),
                      //       DataCell(Center(child: Text(item['IPQty'].toString()))),
                      //       DataCell(Center(
                      //           child: Text(item['CriticalDefect'].toString()))),
                      //       DataCell(Center(
                      //           child: Text(item['MajorDefect'].toString()))),
                      //       DataCell(
                      //           Center(child: Text(item['HologramNo'].toString()))),
                      //       // DataCell(Center(
                      //       //     child: IconButton(
                      //       //         icon: const Icon(Icons.delete),
                      //       //         onPressed: () {
                      //       //           showToast("Product Deleted", true);
                      //       //         })))
                      //     ]);
                      //   }).toList(),
                      // ),
                      Column(
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
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                child: const Text('PO')),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.12,
                                height: MediaQuery.of(context).size.height,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                child: const Text('ITEM')),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.12,
                                height: MediaQuery.of(context).size.height,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                child: const Text('order')),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.12,
                                height: MediaQuery.of(context).size.height,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                child: const Text('Inspected Till Date')),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.12,
                                height: MediaQuery.of(context).size.height,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                child: const Text('Available')),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.12,
                                height: MediaQuery.of(context).size.height,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                child: const Text('Accepted')),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.12,
                                height: MediaQuery.of(context).size.height,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                child: const Text('Short')),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.12,
                                height: MediaQuery.of(context).size.height,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                child: const Text('Inspect Later')),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.94,
                        height: MediaQuery.of(context).size.height * 0.72,
                        child: ListView.builder(
                            itemCount: _itemList.length,
                            itemBuilder: (e, index) {
                              return Container(
                                // width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
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
                                              child: Text(_itemList[index]
                                                      ['PONO']
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
                                          // Container(alignment: Alignment.center, width: 25, height: 30, child: Checkbox(value: value,
                                          //   onChanged: (bool? value) {
                                          //     setState(() {
                                          //       this.value = value!;
                                          //     });
                                          //   },
                                          // ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                    // const Divider(thickness: 1),
                                    // Container(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       horizontal: 5),
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    //     children: [
                                    //       GestureDetector(
                                    //         onTap: () {
                                    //           // Navigator.push(
                                    //           //     context,
                                    //           //     MaterialPageRoute(
                                    //           //       builder: (_) => OverAllResult(
                                    //           //           id: _itemList[index]
                                    //           //           ['pRowID']),
                                    //           //     ));
                                    //         },
                                    //         child: SizedBox(
                                    //             width: MediaQuery.of(context)
                                    //                 .size
                                    //                 .width *
                                    //                 0.7,
                                    //             height: MediaQuery.of(context)
                                    //                 .size
                                    //                 .height *
                                    //                 0.05,
                                    //             child: Text(_itemList[index]
                                    //             ['ItemDescr'])),
                                    //       ),
                                    //       const Row(
                                    //         children: [
                                    //           Text('[New]',
                                    //               style: TextStyle(
                                    //                   color: Colors.red)),
                                    //           SizedBox(width: 10),
                                    //           Icon(Icons.delete)
                                    //         ],
                                    //       ),
                                    //     ],
                                    //   ),
                                    // )
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
