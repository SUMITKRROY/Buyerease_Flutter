
import 'package:buyerease/view/po/po_item.dart';
import 'package:buyerease/view/po/quality_parameters.dart';
import 'package:buyerease/view/po/workmanship/po_workmanship.dart';
import 'package:flutter/material.dart';

import '../../config/theame_data.dart';
import '../over_all_result/workmanship.dart';
import 'carton.dart';
import 'enclosure.dart';
import 'more_details.dart';

class PoPage extends StatefulWidget {
  const PoPage({super.key, required this.id});

  final String id;

  @override
  State<PoPage> createState() => _PoPageState();
}

class _PoPageState extends State<PoPage> with SingleTickerProviderStateMixin {
  TabController? _controller;
  int _selectedIndex = 0;

  List<Widget> list = const [
    Tab(text: 'PO/ITEM'),
    Tab(text: 'WorkManShip'),
    Tab(text: 'Carton'),
    Tab(text: 'More Details'),
    Tab(text: 'Quality Parameters'),
    Tab(text: 'Enclosure'),
  ];

  @override
  void initState() {
    super.initState();
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
        centerTitle: false, // Correct casing: "centerTitle", not "CenterTile"
        leading: const BackButton(color: Colors.white),
        backgroundColor: ColorsData.primaryColor,
        title: Text( 'DEL0067128', style: TextStyle(color: Colors.white)),
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
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                tabs: list,
                controller: _controller,
                onTap: (index) {},
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.74,
                child: TabBarView(controller: _controller, children:   [
                  Center(child: PoItem()),
                  Center(child: PoWorkmanship()),
                  Center(child: Carton()),
                  Center(child: MoreDetails()),
                  Center(child: QualityParameters()),
                  Center(child: Enclosure()),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
