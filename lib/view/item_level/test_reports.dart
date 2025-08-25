import 'package:flutter/material.dart';

import '../../model/po_item_dtl_model.dart';

class TestReports extends StatefulWidget {
  final String id;
  final POItemDtl poItemDtl;
  final VoidCallback onChanged;

  const TestReports({super.key, required this.id, required this.onChanged, required this.poItemDtl});

  @override
  State<TestReports> createState() => _TestReportsState();
}

class _TestReportsState extends State<TestReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 40,child: Text('Activity', style: TextStyle(fontSize: 12))),
                  SizedBox(width: 65,child: Text('Report Name', style: TextStyle(fontSize: 12))),
                  SizedBox(width: 60,child: Text('Test Date', style: TextStyle(fontSize: 12))),
                  SizedBox(width: 40,child: Text('Validity', style: TextStyle(fontSize: 12))),
                  SizedBox(width: 43,child: Text('Remark', style: TextStyle(fontSize: 12)))
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
