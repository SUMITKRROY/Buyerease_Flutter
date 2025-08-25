import 'package:flutter/material.dart';

import '../model/SizeQtyModel.dart';


class SizeQtyAdapter extends StatefulWidget {
  final List<SizeQtyModel> itemList;
  final void Function(int position)? onItemClick;
  final void Function(int position)? onItemAcceptedClick;

  const SizeQtyAdapter({
    Key? key,
    required this.itemList,
    this.onItemClick,
    this.onItemAcceptedClick,
  }) : super(key: key);

  @override
  State<SizeQtyAdapter> createState() => _SizeQtyAdapterState();
}

class _SizeQtyAdapterState extends State<SizeQtyAdapter> {
  final List<TextEditingController> availableControllers = [];
  final List<TextEditingController> acceptedControllers = [];

  @override
  void initState() {
    super.initState();
    for (var item in widget.itemList) {
      availableControllers.add(TextEditingController(text: item.availableQty?.toString() ?? '0'));
      acceptedControllers.add(TextEditingController(text: item.acceptedQty.toString()));
    }
  }

  @override
  void dispose() {
    for (var controller in availableControllers) {
      controller.dispose();
    }
    for (var controller in acceptedControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.itemList.length,
      itemBuilder: (context, index) {
        final item = widget.itemList[index];

        int shortQty = (item.orderQty ?? 0) - ((item.earlierInspected ?? 0) + (item.acceptedQty ?? 0));
        if (shortQty < 0) shortQty = 0;

        final availableController = availableControllers[index];
        final acceptedController = acceptedControllers[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Size: ${item.sizeGroupDescr}"),
                Text("Order Qty: ${item.orderQty}"),
                Text("Inspected: ${item.earlierInspected}"),
                Text("Short Stock Qty: $shortQty"),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: availableController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Available Qty'),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            final parsed = int.tryParse(value) ?? 0;
                            setState(() {
                              item.availableQty = parsed;
                              item.acceptedQty = parsed;
                              acceptedController.text = parsed.toString();
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: acceptedController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Accepted Qty'),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            final parsed = int.tryParse(value) ?? 0;
                            if (item.availableQty != null && parsed <= item.availableQty!) {
                              setState(() {
                                item.acceptedQty = parsed;
                              });
                            } else {
                              // Exceeded availableQty
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("You cannot enter a value greater than the available quantity."),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (widget.onItemClick != null) {
                          widget.onItemClick!(index);
                        }
                      },
                      child: const Text("Confirm Available"),
                    ),
                    TextButton(
                      onPressed: () {
                        if (widget.onItemAcceptedClick != null) {
                          widget.onItemAcceptedClick!(index);
                        }
                      },
                      child: const Text("Confirm Accepted"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
