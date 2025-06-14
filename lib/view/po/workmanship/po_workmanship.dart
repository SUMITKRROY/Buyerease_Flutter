
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/custom_table.dart';




class PoWorkmanship extends StatelessWidget {

  final TextStyle headerStyle = const TextStyle(fontWeight: FontWeight.bold);
  final TextStyle normalStyle = const TextStyle(fontSize: 14);

  Widget buildCell(String text, {double width = 80, bool isHeader = false}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: isHeader ? headerStyle : normalStyle,
      ),
    );
  }

  Widget buildRow(List<String> data, {bool isHeader = false}) {
    final widths = [50.0, 80.0, 60.0, 110.0, 60.0, 60.0, 60.0, 80.0];
    return Row(
      children: [
        for (int i = 0; i < data.length; i++)
          buildCell(data[i], width: widths[i], isHeader: isHeader),
      ],
    );
  }

  Widget buildMergedDescription(String text) {
    return Container(
      width: 560, // Sum of all cell widths above
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey.shade100,
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

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
                'Po', 'Item', 'To\nInspection', 'Inspected',
                'Critical', 'Major', 'Minor'
              ].map((data) => Text(data,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),)).toList(),
              isHeader: true,
            ),

            CustomTable(rowData:['1010', '1412345', '12', '12', '0', '0'].map((data) => Text(data,style: TextStyle(fontSize: 10.sp),)).toList(),),

            CustomTable(rowData:['1010', '124563', '75', '75', '0', '0', ].map((data) => Text(data,style: TextStyle(fontSize: 10.sp),)).toList(),),
            SizedBox(width:390,child: const Divider(thickness: 1, color: Colors.black12)),
            CustomTable (rowData:['Total', '', '87', '', '0', '0', ].map((data) => Text(data,style: TextStyle(fontSize: 10.sp),)).toList(),),
          ],
        ),
      ),
    );
  }


}


