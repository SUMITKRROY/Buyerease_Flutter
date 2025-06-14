import 'package:buyerease/components/custom_table.dart';
import 'package:buyerease/database/database_helper.dart';
import 'package:buyerease/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Carton extends StatelessWidget {


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
              rowData: ['PO', 'Item', 'Packed', 'Available', 'To \nInspected']
                  .map((data) => Text(data,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),))
                  .toList(),
              isHeader: true,
            ),
            CustomTable(
              rowData: ['1010', '01412345', '0', '0', '1']
                  .map((data) => Text(data,style: TextStyle(fontSize: 10.sp),)).toList(),
            ),
            CustomTable(
              rowData: ['1010', '', '0', '0', '1']
                  .map((data) => Text(data,style: TextStyle(fontSize: 10.sp),)).toList(),
            ),
            const SizedBox(
              width: 390,
              child: Divider(thickness: 1, color: Colors.black12),
            ),
            CustomTable(
              rowData: ['Total', '', '0', '0', '2']
                  .map((data) => Text(data,style: TextStyle(fontSize: 10.sp),)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

