import 'package:buyerease/components/size_adapter.dart';
import 'package:flutter/material.dart';

// Import your model and adapter
import '../model/SizeQtyModel.dart';
import '../model/po_item_dtl_model.dart';
import '../services/SizeQtyModelHandler.dart';
import '../services/poitemlist/po_item_dtl_handler.dart';
    // DB/service for POItemDtl

class SizeQtyPage extends StatefulWidget {
  final List<SizeQtyModel> sizeQtyList;
  final POItemDtl item;

  const SizeQtyPage({
    Key? key,
    required this.sizeQtyList,
    required this.item,
  }) : super(key: key);

  @override
  State<SizeQtyPage> createState() => _SizeQtyPageState();
}

class _SizeQtyPageState extends State<SizeQtyPage> {
  late List<SizeQtyModel> sizeQtyModelList;
  int totalAvailableQty = 0;
  int totalAcceptedQty = 0;
  int shortQty = 0;

  @override
  void initState() {
    super.initState();
    sizeQtyModelList = List.from(widget.sizeQtyList);
    calculateTotals();
  }

  void calculateTotals() {
    totalAvailableQty = 0;
    totalAcceptedQty = 0;
    shortQty = 0;

    for (var item in sizeQtyModelList) {
      totalAvailableQty += item.availableQty ?? 0;
      totalAcceptedQty += item.acceptedQty!;
      shortQty += (item.orderQty ?? 0) - ((item.earlierInspected ?? 0) + (item.acceptedQty ?? 0));

    }

    if (shortQty < 0) shortQty = 0;
  }

  void onSaveClick() {
    int updatedAvailableQty = 0;
    int updatedAcceptedQty = 0;
    int updatedShortQty = 0;

    for (var item in sizeQtyModelList) {
      updatedAvailableQty += item.availableQty ?? 0;
      updatedAcceptedQty += item.acceptedQty!;
      updatedShortQty += (item.orderQty ?? 0) - ((item.earlierInspected ?? 0) + (item.acceptedQty ?? 0));

      SizeQtyModelHandler.insertSizeQty( item); // Local save
    }

    if (updatedShortQty < 0) updatedShortQty = 0;

    // Update UI
    setState(() {
      totalAvailableQty = updatedAvailableQty;
      totalAcceptedQty = updatedAcceptedQty;
      shortQty = updatedShortQty;
    });

    // Update item (POItemDtl)
    widget.item.acceptedQty = updatedAcceptedQty;
    widget.item.shortStockQty = int.parse(widget.item.orderQty ?? '0') - updatedAcceptedQty;

    widget.item.availableQty = updatedAvailableQty;

    final status = POItemDtlHandler.updateItemForQty( widget.item);
    debugPrint("POItemDtlHandler status: $status");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Quantity Updated Successfully")),
    );

    // Refresh list if needed
    setState(() async {
      sizeQtyModelList = await SizeQtyModelHandler().getSizeQtyList( widget.item.pRowID ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Size Quantity'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Totals
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildStatTile("Available", totalAvailableQty.toString()),
                buildStatTile("Accepted", totalAcceptedQty.toString()),
                buildStatTile("Short Qty", shortQty.toString()),
              ],
            ),
          ),

          const Divider(),

          // List
          Expanded(
            child: SizeQtyAdapter(
              itemList: sizeQtyModelList,
              onItemClick: (index) {
                final item = sizeQtyModelList[index];
                SizeQtyModelHandler.insertSizeQty( item);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Quantity Updated: ${item.sizeGroupDescr}")
                ));
              },
              onItemAcceptedClick: (index) {
                final item = sizeQtyModelList[index];
                if (item.acceptedQty! <= (item.availableQty ?? 0)) {
                  SizeQtyModelHandler.insertSizeQty( item);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Quantity Accepted: ${item.sizeGroupDescr}")
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("You cannot enter more than available quantity")));
                }
              },
            ),
          ),

          // Save Button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: onSaveClick,
              child: const Text("Save Quantities"),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatTile(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18)),
      ],
    );
  }
}
