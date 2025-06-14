import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../view/over_all_result/over_all_result.dart';

class CustomTable extends StatelessWidget {
  final List<Widget> rowData;
  final String? description;
  final bool isHeader;
  final bool isFirstCellClickable;

  final TextStyle headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp);
  final TextStyle normalStyle = TextStyle(fontSize: 10.sp);

  CustomTable({
    required this.rowData,
    this.description,
    this.isHeader = false,
    this.isFirstCellClickable = true,
  });

  Widget buildCell(Widget child, {double width = 80}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8.0),
      child: child,

    );
  }

  Widget buildRow(BuildContext context) {
    final widths = [70.0, 80.0, 85.0, 80.0, 75.0, 70.0, 70.0, 70.0];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (rowData.isNotEmpty)
          buildFirstCell(context, rowData[0], widths[0]),

        for (int i = 1; i < rowData.length && i < widths.length; i++)
          buildCell(rowData[i], width: widths[i]),
      ],
    );
  }

  Widget buildFirstCell(BuildContext context, Widget widget, double width) {
    if (isFirstCellClickable && !isHeader) {
      return InkWell(
        onTap: () {
          // Assuming the widget is a Text widget containing an ID
          if (widget is Text) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OverAllResult(id: widget.data ?? ''),
              ),
            );
          }
        },
        child: buildCell(widget, width: width),
      );
    } else {
      return buildCell(widget, width: width);
    }
  }

  Widget buildMergedDescription(String text) {
    return Container(
      width: 560,
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey.shade100,
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildRow(context),
        if (!isHeader && description != null && description!.isNotEmpty)
          buildMergedDescription(description!),
      ],
    );
  }
}
