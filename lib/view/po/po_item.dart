import 'package:buyerease/database/database_helper.dart';
import 'package:buyerease/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/custom_table.dart';
import '../over_all_result/over_all_result.dart';

class PoItem extends StatelessWidget {
  const PoItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTable(
              rowData: [
                'Po',
                'Item',
                'order',
                'inspested\ntill date',
                'available',
                'Accept',
                'Short',
                'inspect later'
              ].map((data) => Text(data,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),)).toList(),
              isHeader: true,
            ),
            CustomTable(
              rowData: ['1010', '1412345', '12', '12', '0', '0', '0', ''].map((data) => Text(data,style: TextStyle(fontSize: 10.sp),)).toList(),
              description:
                  '01412345 (CN1) - Holiday Poinsettia- 2.76 x 4" - Wax',
            ),
            CustomTable(
              rowData: ['1010', '124563', '75', '75', '0', '0', '0', ''].map((data) => Text(data,style: TextStyle(fontSize: 10.sp),)).toList(),
              description:
                  '01412345 (CN1) - Holiday Poinsettia- 2.76 x 4" - Wax',
            ),
        SizedBox(width:390,child: const Divider(thickness: 1, color: Colors.black12)),
        CustomTable (rowData:['Total', '', '87', '', '0', '0', ].map((data) => Text(data,style: TextStyle(fontSize: 10.sp),)).toList(),),

          ],
        ),
      ),
    );
  }
}
