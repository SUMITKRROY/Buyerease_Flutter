import 'package:flutter/material.dart';
import '../../model/defect_master_model.dart';
import '../../services/po_item_dtl_handler.dart';

class AddWorkManShip extends StatefulWidget {
  const AddWorkManShip({super.key});

  @override
  State<AddWorkManShip> createState() => _AddWorkManShipState();
}

class _AddWorkManShipState extends State<AddWorkManShip> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _criticalController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _minorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  List<DefectMasterModel> defectMasterModalArrayList = [];
  List<String> defectMasterModalArrayListStr = [];
  List<String> defectMasterModalArrayListCodeStr = [];

  Future<void> getDefectMasterList() async {
    final defectList = await POItemDtlHandler.getDefectMasterList();
    setState(() {
      print(">>>>>${defectList.first.code}");
      defectMasterModalArrayList = defectList;
      if (defectMasterModalArrayList.isNotEmpty) {
        updateAutoComplete();
        updateAutoCompleteCode();
      }
    });
  }

  void updateAutoComplete() {
    defectMasterModalArrayListStr = defectMasterModalArrayList
        .map((defect) => defect.defectName ?? '')
        .toList();
  }

  void updateAutoCompleteCode() {
    defectMasterModalArrayListCodeStr = defectMasterModalArrayList
        .map((defect) => defect.code ?? '')
        .toList();
  }

  void onDescriptionSelected(String selectedItem) {
    final defect = defectMasterModalArrayList.firstWhere(
      (defect) => defect.defectName == selectedItem,
      orElse: () => DefectMasterModel(),
    );
    if (defect.code != null) {
      _codeController.text = defect.code!;
    }
  }

  void onCodeSelected(String selectedItem) {
    final defect = defectMasterModalArrayList.firstWhere(
      (defect) => defect.code == selectedItem,
      orElse: () => DefectMasterModel(),
    );
    if (defect.defectName != null) {
      _descriptionController.text = defect.defectName!;
    }
  }

  @override
  void initState() {
    super.initState();
    getDefectMasterList();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _criticalController.dispose();
    _majorController.dispose();
    _minorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Workmanship Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return defectMasterModalArrayListStr;
                }
                return defectMasterModalArrayListStr.where((String option) {
                  return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                }).toList();
              },
              onSelected: onDescriptionSelected,
              fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: "Description"),
                );
              },
            ),
            const SizedBox(height: 10),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return defectMasterModalArrayListCodeStr;
                }
                return defectMasterModalArrayListCodeStr.where((String option) {
                  return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                }).toList();
              },
              onSelected: onCodeSelected,
              fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: "Code"),
                  keyboardType: TextInputType.number,
                );
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _criticalController,
              decoration: const InputDecoration(labelText: "Critical"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _majorController,
              decoration: const InputDecoration(labelText: "Major"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _minorController,
              decoration: const InputDecoration(labelText: "Minor"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final Map<String, dynamic> newItem = {
                  'code': int.tryParse(_codeController.text) ?? 0,
                  'critical': int.tryParse(_criticalController.text) ?? 0,
                  'major': int.tryParse(_majorController.text) ?? 0,
                  'minor': int.tryParse(_minorController.text) ?? 0,
                  'total': (int.tryParse(_criticalController.text) ?? 0) +
                      (int.tryParse(_majorController.text) ?? 0) +
                      (int.tryParse(_minorController.text) ?? 0),
                  'description': _descriptionController.text,
                };
                Navigator.of(context).pop(newItem);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
} 