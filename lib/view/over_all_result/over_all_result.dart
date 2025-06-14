
import 'package:buyerease/view/over_all_result/packing_appearance.dart';
import 'package:buyerease/view/over_all_result/packing_measurement.dart';
import 'package:buyerease/view/over_all_result/quality_parameters_result.dart';
import 'package:buyerease/view/over_all_result/sample_collected.dart';
import 'package:buyerease/view/over_all_result/test_reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theame_data.dart';
import '../po/workmanship.dart';
import 'barcode.dart';
import 'digital_uploaded.dart';
import 'history.dart';
import 'internal_test.dart';
import 'item_measurement.dart';
import 'item_quantity.dart';
import 'onsite.dart';


class OverAllResult extends StatefulWidget {
  const OverAllResult({super.key, required this.id});

  final String id;

  @override
  State<OverAllResult> createState() => _OverAllResultState();
}

class _OverAllResultState extends State<OverAllResult>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  int _selectedIndex = 0;
  String? _dropDownValue;

  List<Widget> list = const [
    Tab(text: 'Item/Quantity'),
    Tab(text: 'Packing Appearance'),
    Tab(text: 'Packing Measurement'),
    Tab(text: 'Barcode'),
    Tab(text: 'OnSite'),
    Tab(text: 'Workmanship'),
    Tab(text: 'Sample Collected'),
    Tab(text: 'Item Measurement'),
    Tab(text: 'History'),
    Tab(text: 'Quality Parameters'),
    Tab(text: 'Internal Test'),
    Tab(text: 'Digital Uploaded'),
    Tab(text: 'Test Reports'),
  ];

  @override
  void initState() {
    super.initState();
    // Create TabController for getting the index of current tab
    _controller = TabController(length: list.length, vsync: this);

    _controller?.addListener(() {
      setState(() {
        _selectedIndex = _controller!.index;
      });
      debugPrint("Selected Index: ${_controller!.index}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: ColorsData.primaryColor,
        title: ListTile(title: Text("Item detail" ,style: TextStyle(color: Colors.white,fontSize: 18.sp),),
        subtitle: Text(
          "Item no.(${widget.id})",
          style:  TextStyle(color: Colors.white,fontSize: 12.sp),
        ),
        ),
          actions: [
          TextButton(
          onPressed: () {},
      child: Text('UNDO', style: TextStyle(color: Colors.white)),
    ),
    TextButton(
    onPressed: () {},
    child: Text('SAVE', style: TextStyle(color: Colors.white)),
    ),
    ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Over All Result'),
                  Container(
                      height: 35,
                      width: MediaQuery.of(context).size.width * 0.5,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: Colors.black, width: 1),
                        color: Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: _dropDownValue == null
                              ? const Text('Select')
                              : Text(_dropDownValue!, style: const TextStyle(color: ColorsData.primaryColor)),
                          isExpanded: true,
                          iconSize: 30.0,
                          style: const TextStyle(color: ColorsData.primaryColor),
                          items: ['PASS', 'FAILED'].map((val) {return DropdownMenuItem<String>(value: val, child: Text(val));}).toList(),
                          onChanged: (val) {setState(() {_dropDownValue = val;});
                          },
                        ),
                      )),
                ],
              ),
              TabBar(
                unselectedLabelColor: Colors.grey,
                isScrollable: true,
                tabs: list,
                controller: _controller,
                onTap: (index) {
                  // Should not used it as it only called when tab options are clicked,
                  // not when user swapped
                },
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                child: TabBarView(controller: _controller, children:   [
                  Center(child: ItemQuantity()),
                  Center(child: PackingAppearance()),
                  Center(child: PackingMeasurement()),
                  Center(child: BarCode()),
                  Center(child: OnSite()),
                  Center(child: WorkManShip()),
                  Center(child: SampleCollected()),
                  Center(child: ItemMeasurement()),
                  Center(child: History()),
                  Center(child: QualityParametersResult()),
                  Center(child: InternalTest()),
                  Center(child: DigitalUploaded()),
                  Center(child: TestReports()),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
