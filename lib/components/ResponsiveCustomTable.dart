import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:buyerease/database/table/qr_po_item_dtl_table.dart';
import 'package:buyerease/model/po_item_dtl_model.dart';
import '../../services/poitemlist/po_item_dtl_handler.dart';

class ResponsiveCustomTable extends StatelessWidget {
  final List<String> headers;
  final List<List<dynamic>> rows;
  final List<String>? descriptions;
  final List<POItemDtl>? poItems;
  final String? pRowId;
  final Function(int)? onRowTap;
  final Function(int)? onDelete;
  final bool showTotalRow;
  final List<String>? totalRowData;

  /// 🆕 Add special row index list
  final List<int>? specialRowIndexes;

  const ResponsiveCustomTable({
    Key? key,
    required this.headers,
    required this.rows,
    this.descriptions,
    this.poItems,
    this.pRowId,
    this.onRowTap,
    this.onDelete,
    this.showTotalRow = false,
    this.totalRowData,
    this.specialRowIndexes, // 🆕
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final shouldShowTotal = showTotalRow && totalRowData != null;

    return Container(
      child: ListView.builder(
        shrinkWrap: true, // 🟢 Important for layout
        physics: NeverScrollableScrollPhysics(), // 🟢 Prevents nested scrolling issues
        itemCount: rows.length + 1 + (shouldShowTotal ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHeaderRow();
          } else if (shouldShowTotal && index == rows.length + 1) {
            return _buildTotalRow();
          } else {
            return _buildDataRow(context, index - 1);
          }
        },
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: _buildRow(
        headers.map((header) => Text(
          header,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
          // maxLines: 3,
          overflow: TextOverflow.visible,
        )).toList(),
        isHeader: true,
      ),
    );
  }

  Widget _buildDataRow(BuildContext context, int index) {
    final rowData = rows[index];
    final hasDescription = descriptions != null &&
        index < descriptions!.length &&
        descriptions![index].isNotEmpty;

    final isSpecialRow = specialRowIndexes?.contains(index) ?? false; // 🆕

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isSpecialRow
                ? Colors.blue.shade50 // 🆕 match total row style
                : index % 2 == 0
                ? Colors.white
                : Colors.grey.shade50,
            border: Border.all(
              color: isSpecialRow ? Colors.grey.shade400 : Colors.grey.shade300,
            ),
          ),
          child: InkWell(
            onTap: onRowTap != null ? () => onRowTap!(index) : null,
            child: _buildRow(
              rowData.map((data) => data is Widget
                  ? data
                  : Text(
                data.toString(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: isSpecialRow ? FontWeight.bold : FontWeight.normal, // 🆕 bold
                  color: isSpecialRow ? Colors.blue.shade800 : Colors.black, // 🆕
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              )).toList(),
            ),
          ),
        ),
        if (hasDescription)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    descriptions![index],
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade700,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                    onPressed: () => onDelete!(index),
                    tooltip: 'Delete item',
                  ),
              ],
            ),
          ),
      ],
    );
  }


  Widget _buildTotalRow() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: _buildRow(
        totalRowData!.map((data) => Text(
          data,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        )).toList(),
        isTotal: true,
      ),
    );
  }

  Widget _buildRow(List<Widget> children, {bool isHeader = false, bool isTotal = false}) {
    return Row(
      children: children.asMap().entries.map((entry) {
        int index = entry.key;
        Widget child = entry.value;

        int flex = _getFlexValue(index);

        return Expanded(
          flex: flex,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            child: child,
          ),
        );
      }).toList(),
    );
  }

  int _getFlexValue(int columnIndex) {
    switch (columnIndex) {
      case 0: return 2; // PO
      case 1: return 2; // Item
      case 2: return 2; // Order
      case 3: return 2; // Inspected Till Date
      case 4: return 2; // Available
      case 5: return 2; // Accept
      case 6: return 2; // Short
      case 7: return 2; // Inspect Later
      default: return 1;
    }
  }
}
