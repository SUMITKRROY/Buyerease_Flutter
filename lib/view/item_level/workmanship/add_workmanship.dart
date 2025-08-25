import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../../../model/defect_master_model.dart';
import '../../../components/add_image_icon.dart';
import '../../../model/po_item_dtl_model.dart';
import '../../../model/workmanship_model.dart';
import '../../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../../services/poitemlist/po_item_dtl_handler.dart';

class AddWorkManShip extends StatefulWidget {
  final POItemDtl poItemDtl;
  final WorkManShipModel? existingModel;
  const AddWorkManShip({super.key, required this.poItemDtl, this.existingModel});

  @override
  State<AddWorkManShip> createState() => _AddWorkManShipState();
}

class _AddWorkManShipState extends State<AddWorkManShip> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _criticalController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _minorController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<DefectMasterModel> defectMasterModalArrayList = [];
  List<String> defectMasterModalArrayListStr = [];
  List<String> defectMasterModalArrayListCodeStr = [];
  WorkManShipModel workManShipModel =   WorkManShipModel();
  late POItemDtl poItemDtl;

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
      _descriptionController.text = defect.defectName!;
    }
  }

  void onCodeSelected(String selectedItem) {
    final defect = defectMasterModalArrayList.firstWhere(
          (defect) => defect.code == selectedItem,
      orElse: () => DefectMasterModel(),
    );
    if (defect.defectName != null) {
      _codeController.text = defect.code!;
      _descriptionController.text = defect.defectName!;
    }
  }

  @override
  void initState() {
    super.initState();
    poItemDtl = widget.poItemDtl;

    if (widget.existingModel != null) {
      workManShipModel = widget.existingModel!;
      _descriptionController.text = workManShipModel.description ?? '';
      _codeController.text = workManShipModel.code ?? '';
      _criticalController.text = workManShipModel.critical?.toString() ?? '';
      _majorController.text = workManShipModel.major?.toString() ?? '';
      _minorController.text = workManShipModel.minor?.toString() ?? '';
      _commentController.text = workManShipModel.comments ?? '';
    }

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
                  return defectMasterModalArrayListCodeStr;
                }
                return defectMasterModalArrayListCodeStr.where((String option) {
                  return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                }).toList();
              },
              onSelected: onCodeSelected,
              fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                return TextField(
                  inputFormatters: [    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),],
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: "Code"),
                  keyboardType: TextInputType.number,
                );
              },
            ),
            const SizedBox(height: 10),
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
              fieldViewBuilder: (context, _, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: _descriptionController, // use shared controller
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: "Description"),
                );
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _criticalController,
              decoration: const InputDecoration(labelText: "Critical"),
              keyboardType: TextInputType.number,
              inputFormatters: [    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),],
            ),
            TextField(
              inputFormatters: [    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),],
              controller: _majorController,
              decoration: const InputDecoration(labelText: "Major"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              inputFormatters: [    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),],
              controller: _minorController,
              decoration: const InputDecoration(labelText: "Minor"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(labelText: "Comment"),
              keyboardType: TextInputType.text,
            ),
            // Camera icon and count
            AddImageIcon(
              title: _descriptionController.text,
              id: widget.poItemDtl.customerItemRef ?? "",
              pRowId: widget.poItemDtl.pRowID ?? "",
              poItemDtl: poItemDtl,
              onImageAdded: () {},
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

                final Map<String, dynamic> newItem = {
                  // 'code': int.tryParse(_codeController.text) ?? 0,
                  'code': _codeController.text,
                  'critical': int.tryParse(_criticalController.text) ?? 0,
                  'major': int.tryParse(_majorController.text) ?? 0,
                  'minor': int.tryParse(_minorController.text) ?? 0,
                  'total': (int.tryParse(_criticalController.text) ?? 0) +
                      (int.tryParse(_majorController.text) ?? 0) +
                      (int.tryParse(_minorController.text) ?? 0),
                  'description': _descriptionController.text,
                };
                final WorkManShipModel newData = WorkManShipModel(
                  code: newItem['code'],
                  critical: newItem['critical'],
                  major: newItem['major'],
                  minor: newItem['minor'],
                  //total: newItem['total'],
                  description: newItem['description'],
                );
                handleSaveToGenerateId();
                // Navigator.of(context).pop(newData);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
  Future<bool> handleSaveToGenerateId( ) async {
    String description = _descriptionController.text.trim();

    if (description.isEmpty) {
      // Show error using a validator pattern or UI message
      // For example, using a form field: validator can handle this
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Description is required")),
      );
      return false;
    }

    workManShipModel.description = _descriptionController.text;
    workManShipModel.major = int.tryParse(_majorController.text);
    workManShipModel.minor = int.tryParse(_minorController.text);
    workManShipModel.critical = int.tryParse(_criticalController.text);

    workManShipModel.code = _codeController.text;
    workManShipModel.comments = _commentController.text;
    developer.log("_codeController ${jsonEncode(workManShipModel)}");
    developer.log("_codeController $_codeController");



    String? returnPRowID = await ItemInspectionDetailHandler().updateWorkmanShip(
      qrHdrID: poItemDtl.qrHdrID ?? '',
      qrPOItemHdrID: poItemDtl.qrpoItemHdrID ?? '',
      pItemID: poItemDtl.qrItemID ?? '',
      workManShipModel: workManShipModel,
    );

    Navigator.pop(context, workManShipModel);
    workManShipModel.pRowID = returnPRowID;

    return true;
  }
} 