import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/custom_table.dart';

class MoreDetails extends StatelessWidget {
  const MoreDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:   [
          CustomTable(
            rowData: [
              'PO',
              'Item',
              'packaging Measurement',
              'Digitals Uploaded',
              'Test Report',
              'Measurements',
              'Over All Inspection Result',
              'HologramNo',
            ].map((data) => Text(data,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),)).toList(),
            isHeader: true,
          ),
          CustomTable(
            rowData: [
              '1010',
              '01412345',
              '',
              '1',
              'Pending',
              '',
              'PASS',
              '6565',
            ].map((data) => Text(data,style: TextStyle(fontSize: 10.sp),)).toList(),
          ),
          CustomTable(
            rowData: [
              '1010',
              '0',
              '',
              '0',
              'Pending',
              '',
              '',
              '1222',
            ].map((data) => Text(data,style: TextStyle(fontSize: 10.sp),)).toList(),
          ),
        ],
      ),
    );
  }
}
