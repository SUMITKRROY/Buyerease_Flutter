import 'dart:convert';
import 'dart:developer' as developer;

import 'package:buyerease/model/po_item_dtl_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/sample_collection_model.dart';
import '../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../services/general/GeneralMasterHandler.dart';
import '../../services/general/GeneralModel.dart';
import '../../services/poitemlist/po_item_dtl_handler.dart';
import '../../utils/app_constants.dart';

class SampleCollected extends StatefulWidget {
  final POItemDtl poItemDtl;
  final VoidCallback onChanged;
  const SampleCollected(
      {super.key, required this.poItemDtl, required this.onChanged});

  @override
  State<SampleCollected> createState() => _SampleCollectedState();
}

class _SampleCollectedState extends State<SampleCollected> {
  List<GeneralModel> rows = [];
  List<TextEditingController> sampleControllers = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleSampleCollectedTab();
    });
  }

  Widget _buildHeaderRow() {
    return Row(
      children: const [
        Expanded(
          flex: 3,
          child: Text('Purpose',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ),
        Expanded(
          flex: 3,
          child: Text('Number of\nSamples',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ),
        Expanded(
          flex: 2,
          child: Text('Remove',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget _buildDataRow(int index) {
    final row = rows[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(row.mainDescr ?? '', style: TextStyle(fontSize: 12))),
          Expanded(
            flex: 3,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: sampleControllers[index],
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextButton(
              onPressed: () => _removeRow(index),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  int _getSampleNumberForIndex(int index) {
    if (index < sampleControllers.length) {
      return int.tryParse(sampleControllers[index].text) ?? 0;
    }
    return 0;
  }

  void _removeRow(int index) async {
    final pRowID = rows[index].pGenRowID;
    await POItemDtlHandler.deleteSampleCollected(pRowID!);
    setState(() {
      rows.removeAt(index);
      sampleControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // SOverAllDropdown(poItemDtl: poItemDtl),
              IconButton(
                onPressed: handleSampleCollectedMaster,
                icon:   Icon(Icons.add_circle_outline,size: 28.h,),
              )
            ],
          ),
          // Other content
          const SizedBox(height: 8),
          _buildHeaderRow(),
          const SizedBox(height: 8),
          ...List.generate(rows.length, (index) => _buildDataRow(index)),
        ],
      ),
    );
  }

  void handleSampleCollectedMaster() async {
    List<GeneralModel> newMasterList =
        await GeneralMasterHandler.getGeneralList(
            FEnumerations.sampleCollectedOverallResultStatusGenId);

    List<SampleCollectedModal> sampleCollectedList =
        await POItemDtlHandler.getSampleCollectedList();

    List<GeneralModel> overAllResultStatusList =
        await GeneralMasterHandler.getGeneralList(
            FEnumerations.sampleCollectedOverallResultStatusGenId);

    if (overAllResultStatusList != null && overAllResultStatusList.isNotEmpty) {
      List<String?> list =
          overAllResultStatusList.map((item) => item.mainDescr).toList();

      int? selectedItem = await showDialog<int>(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text("Select Inspection Level"),
          children: List.generate(list.length, (index) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(context, index),
              child: Text(list[index]!),
            );
          }),
        ),
      );

      if (selectedItem == null) return;

      if (sampleCollectedList.isNotEmpty) {
        // Remove already selected statuses
        for (var sample in sampleCollectedList) {
          overAllResultStatusList
              .removeWhere((status) => status.pGenRowID == sample.pRowID);
        }

        debugPrint("newMasterList size = ${newMasterList.length}");
        debugPrint(
            "overAllResultStatusList size = ${overAllResultStatusList.length}");
        debugPrint(
            "sample selected master item = ${newMasterList[selectedItem].pGenRowID}");

        if (overAllResultStatusList.isNotEmpty) {
          for (var status in overAllResultStatusList) {
            if (status.pGenRowID == newMasterList[selectedItem].pGenRowID) {
              var sampleCollectedModal = SampleCollectedModal(
                pRowID: await ItemInspectionDetailHandler()
                    .generatePK(FEnumerations.tableNameSamplePurpose),
                samplePurposeID: newMasterList[selectedItem].pGenRowID,
                sampleNumber: 0,
              );
              await insertSampleCollected(sampleCollectedModal);
              handleSampleCollectedTab();
              break;
            }
          }
        }
      } else {
        var sampleCollectedModal = SampleCollectedModal(
          pRowID: await ItemInspectionDetailHandler()
              .generatePK(FEnumerations.tableNameSamplePurpose),
          samplePurposeID: overAllResultStatusList[selectedItem].pGenRowID,
          sampleNumber: 0,
        );
        await insertSampleCollected(sampleCollectedModal);
        handleSampleCollectedTab();
      }
    }
  }

  Future<void> insertSampleCollected(
      SampleCollectedModal sampleCollectedModal) async {
    bool success = await POItemDtlHandler.insertSampleCollected(
      sampleCollectedModal,
      widget.poItemDtl,
    );

    // Show a SnackBar based on success/failure
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Sample inserted successfully.'
              : 'Sample already exists in the database.',
        ),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> handleSampleCollectedTab() async {
    List<SampleCollectedModal> sampleCollectedList =
        await POItemDtlHandler.getSampleCollectedList();
    List<GeneralModel> masterSampleCollectedList =
        await GeneralMasterHandler.getGeneralList(
      FEnumerations.sampleCollectedOverallResultStatusGenId,
    );

    sampleControllers.clear();
    rows.clear();

    if (sampleCollectedList.isNotEmpty) {
      for (int i = 0; i < sampleCollectedList.length && i < 5; i++) {
        final sample = sampleCollectedList[i];
        final match = masterSampleCollectedList.firstWhere(
          (item) => item.pGenRowID == sample.samplePurposeID,
        );
        developer.log("developr ${jsonEncode(match)}");
        if (match != null) {
          // Check if this match is already in rows (avoid duplicates)
          bool alreadyExists =
              rows.any((row) => row.pGenRowID == match.pGenRowID);
          if (!alreadyExists) {
            developer.log("developer ${jsonEncode(match)}");
            rows.add(match);
            sampleControllers.add(
                TextEditingController(text: sample.sampleNumber.toString()));
          }
        }
      }

      setState(() {}); // Rebuild UI after loading data
    }
  }

  bool _hasUnsavedChanges = false;

  Future<void> saveChanges() async {
    updateSampleCollectedTab();
    setState(() {
      _hasUnsavedChanges = false;
    });
  }

  Future<void> updateSampleCollectedTab() async {
    final List<SampleCollectedModal> sampleCollectedList =
        await POItemDtlHandler.getSampleCollectedList();
    if (sampleCollectedList != null && sampleCollectedList.isNotEmpty) {
      for (int i = 0; i < sampleCollectedList.length && i <= 4; i++) {
        final SampleCollectedModal modal = sampleCollectedList[i];
        final updatedModal = SampleCollectedModal(
          pRowID: modal.pRowID,
          samplePurposeID: modal.samplePurposeID,
          sampleNumber: _getSampleNumberForIndex(i),
        );
        await POItemDtlHandler.updateSampleCollected(updatedModal);
      }
    }
  }
}
