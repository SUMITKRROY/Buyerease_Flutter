import 'package:buyerease/database/database_helper.dart';
import 'package:flutter/material.dart';

class QualityParameters extends StatefulWidget {
  const QualityParameters({super.key});

  @override
  State<QualityParameters> createState() => _QualityParametersState();
}

class _QualityParametersState extends State<QualityParameters> {
  bool value = false;
  bool loading = true;
  dynamic data;
  List<Map<String, dynamic>> _itemList = [];

  // Future<void> syncData() async {
  //   data = await SQLHelper.getTableData(4);
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
    // TODO: implement initState
    super.initState();
    // syncData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                child: ListView.builder(
                    itemCount: _itemList.length,
                    itemBuilder: (e, index) {
                      return Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    _itemList[index]['MainDescr'].toString()),
                                Column(children: [
                                  Checkbox(
                                      value: value,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          this.value = value!;
                                        });
                                      }),
                                  Text('Applicable'),
                                ]),
                              ],
                            ),
                          ),
                          const Divider(thickness: 2),
                        ],
                      );
                    }),
              )
            ],
          )),
    );
  }
}
