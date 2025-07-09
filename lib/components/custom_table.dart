import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/po_item_dtl_model.dart';
import '../view/over_all_result/over_all_result.dart';

class CustomTable extends StatelessWidget {
final POItemDtl? poItemDtl;
  final List<Widget> rowData;
  final String? description;
  final bool isHeader;
  final bool isFirstCellClickable;
  final String? customerItemRef;
  final String? pRowId;
  final Function()? onDelete;

  final TextStyle headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp);
  final TextStyle normalStyle = TextStyle(fontSize: 10.sp);

  CustomTable({
    required this.rowData,
    this.description,
    this.isHeader = false,
    this.isFirstCellClickable = true,
    this.customerItemRef,
    this.onDelete, this.pRowId, this.poItemDtl,
  });

  Widget buildCell(Widget child, {double width = 80}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8.0),
      child: child,
    );
  }

  Widget buildFirstCell(BuildContext context, Widget widget, double width) {
    if (isFirstCellClickable && !isHeader) {
      return InkWell(
        onTap: () {
          developer.log("poItemdtl =${poItemDtl?.customerItemRef}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OverAllResult(id: customerItemRef ?? '', pRowId: pRowId ??'' ,poItemDtl: poItemDtl! ,),
            ),
          );
        },
        child: buildCell(widget, width: width),
      );
    } else {
      return buildCell(widget, width: width);
    }
  }

  Widget buildSecondCell(BuildContext context, Widget widget, double width) {
    if (isFirstCellClickable && !isHeader) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OverAllResult(id: customerItemRef ?? '', pRowId: pRowId ??'' ,poItemDtl: poItemDtl! ,),
            ),
          );
        },
        child: buildCell(widget, width: width),
      );
    } else {
      return buildCell(widget, width: width);
    }
  }

  Widget buildRow(BuildContext context) {
    final widths = [70.0, 80.0, 85.0, 80.0, 75.0, 70.0, 70.0, 70.0];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (rowData.isNotEmpty)
          buildFirstCell(context, rowData[0], widths[0]),
        if (rowData.length > 1)
          buildSecondCell(context, rowData[1], widths[1]),
        for (int i = 2; i < rowData.length && i < widths.length; i++)
          buildCell(rowData[i], width: widths[i]),
      ],
    );
  }

  Widget buildMergedDescription(String text) {
    return Container(
      width: 530.w,
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey.shade100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
              softWrap: true,
            ),
          ),
          if (onDelete != null && !isHeader)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Delete item',
            ),
        ],
      ),
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
  