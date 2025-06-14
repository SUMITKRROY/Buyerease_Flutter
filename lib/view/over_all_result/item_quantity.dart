import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/custom_table.dart';
import '../../components/remarks.dart';
import '../../config/theame_data.dart';

class ItemQuantity extends StatefulWidget {
  const ItemQuantity({super.key});

  @override
  State<ItemQuantity> createState() => _ItemQuantityState();
}

class _ItemQuantityState extends State<ItemQuantity> {
  List<String> listData = <String>['One', 'Two', 'Three', 'Four'];
  String? _dropDownValue;
  String? remark;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 05.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomTable(
                rowData: [
                  'Latest\nDelivery\nDate',
                  'Ship Via',
                  'Order Quantity',
                  'Available Quantity',
                  'Accepted Quantity',
                ]  .map((data) => Text(data,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),))
                    .toList(),
                isHeader: true,isFirstCellClickable: false,
              ),
              CustomTable(
                rowData: ['11-Nov-2022', '12', '12', '0', '0', ].map((data) => Text(data,style: TextStyle(fontSize: 10.sp),)).toList(),isFirstCellClickable: false,
                // description:
                // '01412345 (CN1) - Holiday Poinsettia- 2.76 x 4" - Wax',
              ),
            ],
          ),
        ),


        // Remark
        Remarks()
      ],
    );
  }
}
