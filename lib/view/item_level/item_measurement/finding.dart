import 'package:flutter/material.dart';
import 'package:buyerease/model/po_item_dtl_model.dart';
import '../../../model/item_measurement_modal.dart';

class ItemMeasurementFindingScreen extends StatefulWidget {
  final ItemMeasurementModal detail;
  final POItemDtl poItemDtl;
  final int pos;

  const ItemMeasurementFindingScreen({
    super.key,
    required this.detail,
    required this.pos,
    required this.poItemDtl,
  });

  @override
  State<ItemMeasurementFindingScreen> createState() =>
      _ItemMeasurementFindingScreenState();
}

class _ItemMeasurementFindingScreenState
    extends State<ItemMeasurementFindingScreen> {
  List<ItemMeasurementModal> itemMeasurementModalList = [];

  @override
  void initState() {
    super.initState();
    initializeMeasurements();
  }

  void initializeMeasurements() {
    final sampleSize = int.tryParse(widget.detail.sampleSizeValue ?? '') ?? 0;

    for (int i = 0; i < sampleSize; i++) {
      itemMeasurementModalList.add(widget.detail.copyWith());
    }
  }

  void onSubmit() {
    if (itemMeasurementModalList.isEmpty) return;

    final minLength = itemMeasurementModalList
        .reduce((a, b) =>
    (a.dimLength ?? 0) < (b.dimLength ?? 0) ? a : b)
        .dimLength;
    final maxLength = itemMeasurementModalList
        .reduce((a, b) =>
    (a.dimLength ?? 0) > (b.dimLength ?? 0) ? a : b)
        .dimLength;

    final minHeight = itemMeasurementModalList
        .reduce((a, b) =>
    (a.dimHeight ?? 0) < (b.dimHeight ?? 0) ? a : b)
        .dimHeight;
    final maxHeight = itemMeasurementModalList
        .reduce((a, b) =>
    (a.dimHeight ?? 0) > (b.dimHeight ?? 0) ? a : b)
        .dimHeight;

    final minWidth = itemMeasurementModalList
        .reduce((a, b) =>
    (a.dimWidth ?? 0) < (b.dimWidth ?? 0) ? a : b)
        .dimWidth;
    final maxWidth = itemMeasurementModalList
        .reduce((a, b) =>
    (a.dimWidth ?? 0) > (b.dimWidth ?? 0) ? a : b)
        .dimWidth;

    final tolerance = "${widget.detail.dimLength}($minLength-$maxLength), "
        "${widget.detail.dimHeight}($minHeight-$maxHeight), "
        "${widget.detail.dimWidth}($minWidth-$maxWidth)";

    setState(() {
      widget.detail.toleranceRange = tolerance;
    });

    Navigator.pop(context, {
      "pos": widget.pos,
      "detail": widget.detail,
    });
  }

  Widget buildItemCard(int index) {
    final item = itemMeasurementModalList[index];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sample ${index + 1}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                        labelText: 'Length',
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(
                        text: item.dimLength?.toString() ?? ''),
                    onChanged: (val) {
                      itemMeasurementModalList[index] =
                          item.copyWith(dimLength: double.tryParse(val));
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                        labelText: 'Height',
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(
                        text: item.dimHeight?.toString() ?? ''),
                    onChanged: (val) {
                      itemMeasurementModalList[index] =
                          item.copyWith(dimHeight: double.tryParse(val));
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                        labelText: 'Width',
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(
                        text: item.dimWidth?.toString() ?? ''),
                    onChanged: (val) {
                      itemMeasurementModalList[index] =
                          item.copyWith(dimWidth: double.tryParse(val));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finding Details"),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: itemMeasurementModalList.length,
              itemBuilder: (context, index) => buildItemCard(index),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
