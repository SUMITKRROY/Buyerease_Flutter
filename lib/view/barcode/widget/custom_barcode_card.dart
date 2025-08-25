import 'package:flutter/material.dart';

import '../../../components/add_image_icon.dart';
import '../../../model/po_item_dtl_model.dart';
import '../../../model/simple_model.dart';
import '../../../services/general/GeneralModel.dart';

class BarcodeCard extends StatelessWidget {
  final String title;
  final String imageTitle;

  final List<String> sampleDropdownItems;
  final List<SampleModel> sampleDropdownModals;
  final int selectedSampleIndex;
  final ValueChanged<int> onSampleChanged;

  final TextEditingController specController;
  final TextEditingController visualController;
  final TextEditingController scanController;
  final ValueChanged<String> onVisualChanged;
  final ValueChanged<String> onScanChanged;

  final List<String> resultDropdownItems;
  final List<GeneralModel> resultModels;
  final int selectedResultIndex;
  final ValueChanged<int> onResultChanged;

  final String barcodeId;
  final POItemDtl poItemDtl;
  final int attachmentCount;
  final VoidCallback onImageAdded;

  const BarcodeCard({
    super.key,
    required this.title,
    required this.imageTitle,
    required this.sampleDropdownItems,
    required this.sampleDropdownModals,
    required this.selectedSampleIndex,
    required this.onSampleChanged,
    required this.specController,
    required this.visualController,
    required this.scanController,
    required this.resultDropdownItems,
    required this.resultModels,
    required this.selectedResultIndex,
    required this.onResultChanged,
    required this.barcodeId,
    required this.poItemDtl,
    required this.attachmentCount,
    required this.onImageAdded,
    required this.onVisualChanged,
    required this.onScanChanged,
  });

  InputDecoration _input(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        border: const OutlineInputBorder(),
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + dropdown + count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: selectedSampleIndex,
                      items: List.generate(sampleDropdownItems.length, (index) {
                        return DropdownMenuItem(
                          value: index,
                          child: Text(sampleDropdownItems[index]),
                        );
                      }),
                      onChanged: (int? index) {
                        if (index != null) {
                          onSampleChanged(index);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Specification & Visual
            Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: specController,
                        readOnly: true,
                        decoration: _input("Specification"))),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: visualController,
                    decoration: _input("Visual"),
                    onChanged: onVisualChanged,
                  ),
                ),

              ],
            ),

            const SizedBox(height: 16),

            /// Scan + Result
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: TextField(
                    controller: scanController,
                    decoration: _input("Scan"),
                    onChanged: onScanChanged,
                  ),
                ),

                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: DropdownButton<int>(
                    value: selectedResultIndex,
                    items: List.generate(resultDropdownItems.length, (index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(resultDropdownItems[index]),
                      );
                    }),
                    onChanged: (int? index) {
                      if (index != null) {
                        onResultChanged(index);
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: AddImageIcon(
                title: imageTitle,
                id: barcodeId,
                onImageAdded: onImageAdded,
                pRowId: '',
                poItemDtl: poItemDtl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
