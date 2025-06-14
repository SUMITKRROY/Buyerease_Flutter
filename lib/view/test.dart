import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: PoInspectionMergedPage()));
}

class PoInspectionMergedPage extends StatelessWidget {
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
    return Scaffold(
      appBar: AppBar(title: const Text("PO Inspection Table")),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildRow([
              'Po', 'Item', 'order', 'inspested till date',
              'available', 'Accept', 'Short', 'inspect later'
            ], isHeader: true),

            buildRow(['1010', '1412345', '12', '12', '0', '0', '0', '']),
            buildMergedDescription(
              '01412345 (CN1) - Holiday Poinsettia- 2.76 x 4" - Wax',
            ),

            buildRow(['1010', '124563', '75', '75', '0', '0', '0', '']),
            buildRow(List.filled(8, '')), // Blank row
            buildMergedDescription(
              '01412345 (CN1) - Holiday Poinsettia- 2.76 x 4" - Wax',
            ),

            const SizedBox(height: 10),
            buildRow(['Total', '', '87', '', '0', '0', '', '']),
          ],
        ),
      ),
    );
  }
}
