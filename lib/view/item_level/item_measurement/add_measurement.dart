import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/add_image_icon.dart';
import '../../../model/digitals_upload_model.dart';
import '../../../model/item_measurement_modal.dart';
import '../../../model/po_item_dtl_model.dart';
import '../../../model/simple_model.dart';
import '../../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../../services/general/GeneralMasterHandler.dart';
import '../../../services/general/GeneralModel.dart';
import '../../../services/poitemlist/po_item_dtl_handler.dart';
import '../../../utils/app_constants.dart';
import 'finding.dart';

class AddItemMeasurement extends StatefulWidget {
  final ItemMeasurementModal? existingMeasurement;
  final int? type;
  final POItemDtl poItemDtl;

  const AddItemMeasurement({
    Key? key,

    this.type,
    required this.poItemDtl, this.existingMeasurement,
  }) : super(key: key);

  @override
  State<AddItemMeasurement> createState() => _AddItemMeasurementState();
}

class _AddItemMeasurementState extends State<AddItemMeasurement> {
  final _formKey = GlobalKey<FormState>();
  final _lengthController = TextEditingController();
  final _heightController = TextEditingController();
  final _widthController = TextEditingController();
  final _descriptionController = TextEditingController();

  String selectedSample = "";
  String selectedResult = '';
  List<String> statsList = [];
  int selectedResultPos = 0;
  List<String> sampleList = [];
  int selectedSamplePos = 0;
  List<SampleModel> sampleModals = [];
  List<GeneralModel> overAllResultStatusList = [];
  final ImagePicker _picker = ImagePicker();

  String? selectedSampleSize;
  String? selectedResultStatus;

  ItemMeasurementModal itemMeasurementModal = ItemMeasurementModal();

  bool _isLoading = true;
  @override
  void initState() {
    super.initState();

    if (widget.existingMeasurement != null) {
      itemMeasurementModal = widget.existingMeasurement!;
      _lengthController.text = itemMeasurementModal.dimLength?.toString() ?? '';
      _heightController.text = itemMeasurementModal.dimHeight?.toString() ?? '';
      _widthController.text = itemMeasurementModal.dimWidth?.toString() ?? '';
      _descriptionController.text = itemMeasurementModal.itemMeasurementDescr ?? '';
      selectedSampleSize = itemMeasurementModal.sampleSizeValue;
      selectedResultStatus = itemMeasurementModal.inspectionResultID;
    }

    handleSpinner().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

/*  @override
  void initState() {
    super.initState();
    selectedSampleSize = "Small (5)";
    selectedResultStatus = "Pass";
    _initializeFromDetail();

    handleSpinner().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _initializeFromDetail() {
    if (widget.detail != null) {
      try {
        final decoded = ItemMeasurementModal.fromJson(widget.detail as Map<String, dynamic>);
        setState(() {
          itemMeasurementModal = decoded;
          _lengthController.text = decoded.dimLength?.toString() ?? '';
          _heightController.text = decoded.dimHeight?.toString() ?? '';
          _widthController.text = decoded.dimWidth?.toString() ?? '';
          _descriptionController.text = decoded.itemMeasurementDescr ?? '';
          selectedSampleSize = decoded.sampleSizeValue ?? "Small (5)";
          selectedResultStatus = decoded.inspectionResultID ?? "Pass";
        });
      } catch (e) {
        debugPrint('Failed to parse existing detail: $e');
      }
    }
  }*/

  Future<void> handleSpinner() async {
    overAllResultStatusList = await GeneralMasterHandler.getGeneralList(FEnumerations.overallResultStatusGenId);

    if (overAllResultStatusList.isNotEmpty) {
      for (int i = 0; i < overAllResultStatusList.length; i++) {
        statsList.add(overAllResultStatusList[i].mainDescr ?? '');
        if (overAllResultStatusList[i].pGenRowID == itemMeasurementModal.inspectionResultID) {
          selectedResultPos = i;
        }
      }
      selectedResult = statsList[selectedResultPos];
    }

    sampleModals = await POItemDtlHandler.getSampleSizeList();
    if (sampleModals.isNotEmpty) {
      for (int i = 0; i < sampleModals.length; i++) {
        final sampleDescription = "${sampleModals[i].mainDescr} (${sampleModals[i].sampleVal})";
        sampleList.add(sampleDescription);

        if (sampleModals[i].sampleCode == itemMeasurementModal.sampleSizeID) {
          selectedSamplePos = i;
        }
      }
      selectedSample = sampleList[selectedSamplePos];
      if (selectedSamplePos == 0) {
        itemMeasurementModal.sampleSizeID = sampleModals[0].sampleCode;
        itemMeasurementModal.sampleSizeValue = sampleModals[0].sampleVal?.toString();
      }
    }
  }

  void _save({bool isFinding = false}) {
    if (!_formKey.currentState!.validate()) return;
    onUpdateHandler();
    onSubmit();
    handleToUpdateItemMeasurement();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Insert successfully'), duration: Duration(seconds: 2)),
    );
  }

  void onUpdateHandler() {
    String _l = _lengthController.text;
    String _h = _heightController.text;
    String _w = _widthController.text;
    String _description = _descriptionController.text;

    if (_l.isNotEmpty) {
      double value = double.tryParse(_l) ?? 0.0;
      itemMeasurementModal.dimLength = value;
      itemMeasurementModal.oldLength = value;
    }

    if (_h.isNotEmpty) {
      double value = double.tryParse(_h) ?? 0.0;
      itemMeasurementModal.dimHeight = value;
      itemMeasurementModal.oldHeight = value;
    }

    if (_w.isNotEmpty) {
      double value = double.tryParse(_w) ?? 0.0;
      itemMeasurementModal.dimWidth = value;
      itemMeasurementModal.oldWidth = value;
    }

    itemMeasurementModal.itemMeasurementDescr = _description;
  }

  void onSubmit() {
    itemMeasurementModal.dimLength = double.tryParse(_lengthController.text) ?? 0.0;
    itemMeasurementModal.dimHeight = double.tryParse(_heightController.text) ?? 0.0;
    itemMeasurementModal.dimWidth = double.tryParse(_widthController.text) ?? 0.0;
    itemMeasurementModal.itemMeasurementDescr = _descriptionController.text;
  }

  Future<void> handleToUpdateItemMeasurement() async {
    if (itemMeasurementModal.pRowID == null ||
        itemMeasurementModal.pRowID!.isEmpty ||
        itemMeasurementModal.pRowID!.toLowerCase() == 'null') {
      itemMeasurementModal.pRowID = await ItemInspectionDetailHandler().generatePK(
        FEnumerations.tableNameItemMeasurement,
      );
    }

    String returnPRowID = await ItemInspectionDetailHandler().updateItemMeasurement(
      itemMeasurementModal,
      widget.poItemDtl,
    );
    itemMeasurementModal.pRowID = returnPRowID;
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))],
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  @override
  void dispose() {
    _lengthController.dispose();
    _heightController.dispose();
    _widthController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Measurement'),
        actions: [
          TextButton(
            onPressed: () => _save(),
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Length", _lengthController),
              _buildTextField("Height", _heightController),
              _buildTextField("Width", _widthController),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedSample,
                decoration: const InputDecoration(
                  labelText: 'Sample Size',
                  border: OutlineInputBorder(),
                ),
                items: sampleList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedSample = newValue;
                      int index = sampleList.indexOf(newValue);
                      itemMeasurementModal.sampleSizeID =
                          sampleModals[index].sampleCode;
                      itemMeasurementModal.sampleSizeValue =
                          sampleModals[index].sampleVal?.toString();
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedResult,
                decoration: const InputDecoration(
                  labelText: 'Overall Result',
                  border: OutlineInputBorder(),
                ),
                items: statsList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedResult = newValue;
                      int index = statsList.indexOf(newValue);
                      itemMeasurementModal.inspectionResultID =
                          overAllResultStatusList[index].pGenRowID;
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              AddImageIcon(
                title: _descriptionController.text,
                id: widget.poItemDtl.customerItemRef ?? "",
                pRowId: widget.poItemDtl.pRowID ?? "",
                poItemDtl: widget.poItemDtl,
                onImageAdded: () {},
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.teal),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    onUpdateHandler();
                    onSubmit();
                    await handleToUpdateItemMeasurement();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved successfully'), duration: Duration(seconds: 1)),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemMeasurementFindingScreen(
                          detail: itemMeasurementModal,
                          pos: 1,
                          poItemDtl: widget.poItemDtl,
                        ),
                      ),
                    );
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Finding',
                      style: TextStyle(color: Colors.black),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
                  ],
                ),
              ),

              // Center(
              //   child: ElevatedButton(
              //     onPressed: () async {
              //       if (_formKey.currentState!.validate()) {
              //         onUpdateHandler();
              //         onSubmit();
              //         await handleToUpdateItemMeasurement();
              //
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           const SnackBar(content: Text('Saved successfully'), duration: Duration(seconds: 1)),
              //         );
              //
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => ItemMeasurementFindingScreen(
              //               detail: itemMeasurementModal,
              //               pos: 1,
              //               poItemDtl: widget.poItemDtl,
              //             ),
              //           ),
              //         );
              //       }
              //     },
              //
              //     child: const Text('Finding'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
