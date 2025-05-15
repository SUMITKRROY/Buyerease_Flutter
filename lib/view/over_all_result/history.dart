import 'package:buyerease/database/database_helper.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Map<String, dynamic>> _itemList = [];
  bool loading = true;
  dynamic data;

  // Future<void> syncData() async {
  //   data = await SQLHelper.getTableData(16);
  //   _itemList = data;
  //   setState(() {
  //     if (data.isNotEmpty) {
  //       loading = false;
  //     } else {
  //       loading = false;
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 60, child: Text('Inspection No.')),
                    SizedBox(width: 60, child: Text('Inspection Date')),
                    SizedBox(width: 50, child: Text('Activity')),
                    SizedBox(width: 50, child: Text('QR')),
                    SizedBox(width: 50, child: Text('Inspector')),
                  ]),
            ),
            const Divider(thickness: 1),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: Colors.black),
                  color: Colors.white,
                ),
                height: MediaQuery.of(context).size.height * 0.4,
                child: loading == false
                    ? ListView.builder(
                        itemCount: _itemList.length,
                        itemBuilder: (e, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: 60,
                                      child: Text(
                                          _itemList[index]['InspectorID'])),
                                  SizedBox(
                                      width: 60,
                                      child: Text(
                                          _itemList[index]['InspectionDt'])),
                                  SizedBox(
                                      width: 50,
                                      child:
                                          Text(_itemList[index]['Activity'])),
                                  SizedBox(
                                      width: 50,
                                      child: Text(_itemList[index]['QR'])),
                                  SizedBox(
                                      width: 50,
                                      child:
                                          Text(_itemList[index]['Inspector'])),
                                ]),
                          );
                        })
                    : const Center(
                        child: Text('No Data Found'),
                      ))
          ],
        ),
      ),
    );
  }
}
