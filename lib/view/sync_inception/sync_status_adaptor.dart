import 'dart:developer' as Developer;
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buyerease/database/table/user_master_table.dart';
import 'package:buyerease/utils/app_constants.dart';

import '../../model/status_modal.dart';
import '../../provider/sync_to_server/sync_to_server_cubit.dart';
import '../../services/inspection_list/ItemInspectionDetailHandler.dart';
import '../../services/sync/SendDataHandler.dart';
import '../../services/sync/SyncDataHandler.dart';

class SyncStatusPage extends StatefulWidget {
  final List<String> idsListForSync;

  SyncStatusPage({required this.idsListForSync});

  @override
  _SyncStatusPageState createState() => _SyncStatusPageState();
}

class _SyncStatusPageState extends State<SyncStatusPage> {
  List<StatusModel> statusModalList = [];
  List<String> listedSyncIds = [];
  List<String> idsListForSync = [];
  List<String> syncDoneProcess = [];
  List<String> tableList = [];
  int _currentSyncStep = 0;

  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    idsListForSync = widget.idsListForSync;
    viewStatusListOfSync(); // Populate statusModalList for UI

  }

  void viewStatusListOfSync() {
    setState(() {
      statusModalList.clear();

      tableList = SyncDataHandler().getTablesToSyncList();
      developer.log("this is my list >>> ${tableList}");
      for (var tableName in tableList) {
        statusModalList.add(StatusModel(
            tableName: tableName.trim(),
            status: FEnumerations.syncInProcessStatus,
            title: ''));
      }
      if (tableList.isNotEmpty) {
        startSyncStep();
      }
    });
  }

  void startSyncStep() {
    if (_currentSyncStep < tableList.length) {
      String tableName = tableList[_currentSyncStep];
      developer.log("Starting sync for: $tableName");

      switch (tableName) {
        case 'HEADER':
          handleToHeaderSync(idsListForSync: idsListForSync, context: context);
          break;
        case 'SIZE QUANTITY':
          handleToSizeQtySync(idsListForSync: idsListForSync);
          break;
        case 'IMAGE':
          handleToImageSync(idsListForSync: idsListForSync);
          break;
        case 'WORKMANSHIP':
          handleToWorkmanShipSync(idsListForSync: idsListForSync);
          break;
        case 'ITEM MEASUREMENT':
          handleToItemMeasurementSync(idsListForSync: idsListForSync);
          break;
        case 'FINDING':
          handleToFindingSync(idsListForSync: idsListForSync);
          break;
        case 'QUALITY PARAMETER':
          handleToQualityParameterSync(idsListForSync: idsListForSync);
          break;
        case 'FITNESS CHECK':
          handleToFitnessCheckSync(idsListForSync: idsListForSync);
          break;
        case 'PRODUCTION STATUS':
          handleToProductionStatusSync(idsListForSync: idsListForSync);
          break;
        case 'INTIMATION':
          handleToIntimationSync(idsListForSync: idsListForSync);
          break;
        case 'ENCLOSURE':
          handleToEnclosureSync(idsListForSync: idsListForSync);
          break;
        case 'DIGITAL':
          handleToDigitalsMultipleSync(idsListForSync: idsListForSync);
          break;
        case 'PACKAGING APPEARANCE':
          handleToPkgAppearanceSync(idsListForSync: idsListForSync);
          break;
        case 'ON SITE':
          handleToOnSiteBarcodeSync(idsListForSync: idsListForSync);
          break;
        case 'SAMPLE COLLECTED':
          handleToSampleCollectedSync(idsListForSync: idsListForSync);
          break;
        default:
          handleToFinalizeSync(idsListForSync: idsListForSync);
          updateSyncList(tableName, FEnumerations.syncFailedStatus);
          updateSyncTitleList(tableName, "No sync handler found");
          moveToNextStep();
          break;
      }
    }
  }

  void moveToNextStep() {
    _currentSyncStep++;
    startSyncStep();
  }

  void updateSyncList(String tableName, int status) {
    setState(() {
      final index = statusModalList.indexWhere((e) => e.tableName == tableName);
      if (index != -1) {
        statusModalList[index].status = status; // ✅ Use the passed-in status
      }
    });
  }

  void updateSyncTitleList(String tableName, String title) {
    setState(() {
      final index = statusModalList.indexWhere((e) => e.tableName == tableName);
      if (index != -1) {
        statusModalList[index].title = title;
      }
    });
  }

  void handleToHeaderSync(
      {required BuildContext context,
      required List<String> idsListForSync}) async {
    String currentTable = "HEADER";
    updateSyncList(
        currentTable, FEnumerations.syncInProcessStatus); // ✅ show loader

    try {
      final hdrTables = await SendDataHandler().getHdrTableData(idsListForSync);

      if (hdrTables.isNotEmpty) {
        String? userId = await UserMasterTable().getFirstUserID();

        final inspectionData = {
          "UserID": userId,
          "InspectionData": {
            "ImageFiles": "",
            "Message": "",
            "EnclosureFiles": "",
            "Data": hdrTables,
            "TestReportFiles": "",
            "Result": true,
            "MsgDetail": ""
          }
        };

        await context.read<SyncToServerCubit>().sendInspection(inspectionData);
      } else {
        updateSyncList(currentTable, FEnumerations.syncFailedStatus);
        updateSyncTitleList(currentTable, "No header data found.");
        moveToNextStep();
      }
    } catch (e) {
      updateSyncList(currentTable, FEnumerations.syncFailedStatus);
      updateSyncTitleList(currentTable, e.toString());
      moveToNextStep();
    }
  }

  void handleToSizeQtySync({required List<String> idsListForSync}) async {
    try {
      final hdrTables = await SendDataHandler().getSizeQtyData(idsListForSync);

      if (hdrTables.isNotEmpty) {
        String? userId = await UserMasterTable().getFirstUserID();

        final inspectionData = {
          "UserID": userId,
          "InspectionData": {
            "ImageFiles": "",
            "Message": "",
            "EnclosureFiles": "",
            "Data": hdrTables,
            "TestReportFiles": "",
            "Result": true,
            "MsgDetail": ""
          }
        };
        developer.log("inspectionData : $inspectionData");
        context.read<SyncToServerCubit>().sendInspection(inspectionData);
      } else {
        updateSyncList("SIZE QUANTITY", FEnumerations.syncFailedStatus);
        updateSyncTitleList("SIZE QUANTITY", "No size qty data found.");
        moveToNextStep();
      }
    } catch (e) {
      updateSyncList("SIZE QUANTITY", FEnumerations.syncFailedStatus);
      updateSyncTitleList("SIZE QUANTITY", e.toString());
      moveToNextStep();
    }
  }

  void handleToImageSync({required List<String> idsListForSync}) async {
    try {
      final imgTables =
          await SendDataHandler().getImagesTableData(idsListForSync);

      if (imgTables.isNotEmpty) {
        String? userId = await UserMasterTable().getFirstUserID();
        final inspectionData = {
          "UserID": userId,
          "InspectionData": {
            "ImageFiles": "",
            "Message": "",
            "EnclosureFiles": "",
            "Data": imgTables,
            "TestReportFiles": "",
            "Result": true,
            "MsgDetail": ""
          }
        };

        await context.read<SyncToServerCubit>().sendInspection(inspectionData);
      } else {
        updateSyncList("IMAGE", FEnumerations.syncFailedStatus);
        updateSyncTitleList("IMAGE", "No image data found.");
        moveToNextStep();
      }
    } catch (e) {
      updateSyncList("IMAGE", FEnumerations.syncFailedStatus);
      updateSyncTitleList("IMAGE", e.toString());
      moveToNextStep();
    }
  }

  void handleToWorkmanShipSync({required List<String> idsListForSync}) async {
    if (idsListForSync.isNotEmpty) {
      Map<String, dynamic>? workTables =
          await SendDataHandler().getWorkmanShipData(idsListForSync);

      if (workTables.isNotEmpty) {
        String? userId = await UserMasterTable().getFirstUserID();
        final inspectionData = {
          "UserID": userId,
          "InspectionData": {
            "ImageFiles": "",
            "Message": "",
            "EnclosureFiles": "",
            "Data": workTables,
            "TestReportFiles": "",
            "Result": true,
            "MsgDetail": ""
          }
        };

        debugPrint(
            "WORKMANSHIP sync .........................................\n\n");

        await context.read<SyncToServerCubit>().sendInspection(inspectionData);
      }
    }
  }

  void handleToItemMeasurementSync(
      {required List<String> idsListForSync}) async {
    if (idsListForSync.isNotEmpty) {
      Map<String, dynamic>? itemTables =
          await SendDataHandler().getItemMeasurementData(idsListForSync);

      if (itemTables != null && itemTables.isNotEmpty) {
        String? userId = await UserMasterTable().getFirstUserID();

        final inspectionData = {
          "UserID": userId,
          "InspectionData": {
            "Data": itemTables,
            "ImageFiles": "",
            "EnclosureFiles": "",
            "TestReportFiles": "",
            "Result": true,
            "Message": "",
            "MsgDetail": ""
          }
        };

        debugPrint(
            "ITEM MEASUREMENT sync .........................................\n\n");

        await context.read<SyncToServerCubit>().sendInspection(inspectionData);
      }
    }
  }

  Future<void> handleToFindingSync(
      {required List<String> idsListForSync}) async {
    if (idsListForSync.isNotEmpty) {
      final findingTables =
          await SendDataHandler().getFindingData(idsListForSync);

      if (findingTables != null && findingTables.isNotEmpty) {
        String? userId = await UserMasterTable().getFirstUserID();

        final inspectionData = {
          "UserID": userId,
          "InspectionData": {
            "Data": findingTables,
            "ImageFiles": "",
            "EnclosureFiles": "",
            "TestReportFiles": "",
            "Result": true,
            "Message": "",
            "MsgDetail": ""
          }
        };

        debugPrint(
            "FINDING sync .........................................\n\n");
        await context.read<SyncToServerCubit>().sendInspection(inspectionData);
      }
    }
  }

  Future<void> handleToQualityParameterSync(
      {required List<String> idsListForSync}) async {
    if (idsListForSync.isNotEmpty) {
      final qualityTables =
          await SendDataHandler().getQualityParameterData(idsListForSync);

      if (qualityTables != null && qualityTables.isNotEmpty) {
        String? userId = await UserMasterTable().getFirstUserID();

        final inspectionData = {
          "UserID": userId,
          "InspectionData": {
            "Data": qualityTables,
            "ImageFiles": "",
            "EnclosureFiles": "",
            "TestReportFiles": "",
            "Result": true,
            "Message": "",
            "MsgDetail": ""
          }
        };

        debugPrint(
            "QUALITY PARAMETER sync .........................................\n\n");
        await context.read<SyncToServerCubit>().sendInspection(inspectionData);
      }
    }
  }

  Future<void> handleToFitnessCheckSync(
      {required List<String> idsListForSync}) async {
    if (idsListForSync.isNotEmpty) {
      final fitnessTables =
          await SendDataHandler().getFitnessCheckData(idsListForSync);

      if (fitnessTables != null && fitnessTables.isNotEmpty) {
        String? userId = await UserMasterTable().getFirstUserID();

        final inspectionData = {
          "UserID": userId,
          "InspectionData": {
            "Data": fitnessTables,
            "ImageFiles": "",
            "EnclosureFiles": "",
            "TestReportFiles": "",
            "Result": true,
            "Message": "",
            "MsgDetail": ""
          }
        };

        debugPrint(
            "FITNESS CHECK sync .........................................\n\n");

        await context.read<SyncToServerCubit>().sendInspection(inspectionData);
      }
    }
  }

  Future<void> handleToProductionStatusSync(
      {required List<String> idsListForSync}) async {
    if (idsListForSync.isNotEmpty) {
      final prodTables =
          await SendDataHandler().getProductionStatusData(idsListForSync);

      if (prodTables != null && prodTables.isNotEmpty) {
        String? userId = await UserMasterTable().getFirstUserID();

        final inspectionData = {
          "UserID": userId,
          "InspectionData": {
            "Data": prodTables,
            "ImageFiles": "",
            "EnclosureFiles": "",
            "TestReportFiles": "",
            "Result": true,
            "Message": "",
            "MsgDetail": ""
          }
        };

        debugPrint(
            "PRODUCTION STATUS sync .........................................\n\n");

        await context.read<SyncToServerCubit>().sendInspection(inspectionData);
      }
    }
  }

  Future<void> handleToIntimationSync({
    required List<String> idsListForSync,
  }) async {
    if (idsListForSync.isNotEmpty) {
      final intimationTables =
          await SendDataHandler().getIntimationData(idsListForSync);

      if (intimationTables != null && intimationTables.isNotEmpty) {
        String? userId = await UserMasterTable().getFirstUserID();

        final inspectionData = {
          "UserID": userId,
          "InspectionData": {
            "Data": intimationTables,
            "ImageFiles": "",
            "EnclosureFiles": "",
            "TestReportFiles": "",
            "Result": true,
            "Message": "",
            "MsgDetail": ""
          }
        };

        debugPrint(
            "INTIMATION sync .........................................\n\n");

        await context.read<SyncToServerCubit>().sendInspection(inspectionData);
      }
    }
  }

  Future<void> handleToEnclosureSync({
    required List<String> idsListForSync,
  }) async {
    if (idsListForSync.isNotEmpty) {
      final enclosureTables =
          await SendDataHandler().getQREnclosureData(idsListForSync);

      if (enclosureTables != null && enclosureTables.isNotEmpty) {
        String? userId = await UserMasterTable().getFirstUserID();

        final inspectionData = {
          "UserID": userId,
          "InspectionData": {
            "Data": enclosureTables,
            "ImageFiles": "",
            "EnclosureFiles": "", // Can be updated with real data if needed
            "TestReportFiles": "",
            "Result": true,
            "Message": "",
            "MsgDetail": ""
          }
        };

        debugPrint(
            "ENCLOSURE sync .........................................\n\n");

        await context.read<SyncToServerCubit>().sendInspection(inspectionData);
      }
    }
  }

  Future<void> handleToDigitalsMultipleSync(
      {required List<String> idsListForSync}) async {
    if (idsListForSync.isNotEmpty) {
      final digiTables = await SendDataHandler()
          .getDigitalsColumnFromMultipleData(idsListForSync);

      if (digiTables != null && digiTables.isNotEmpty) {
        final userId = await UserMasterTable().getFirstUserID();

        final inspectionData = {
          "UserID": userId,
          "InspectionData": {
            "Data": digiTables,
            "ImageFiles": "",
            "EnclosureFiles": "",
            "TestReportFiles": "",
            "Result": true,
            "Message": "",
            "MsgDetail": ""
          }
        };

        debugPrint(
            "DIGITAL sync .........................................\n\n");
        bool success = await context.read<SyncToServerCubit>().sendInspection(inspectionData);
        debugPrint(
            "DIGITAL sync .........................................$success\n\n");
        if(success){
          for (String id in idsListForSync) {
            await ItemInspectionDetailHandler().updateFinalSync(id);
          }}

      }
    }
  }

  Future<void> handleToFinalizeSync(
      {required List<String> idsListForSync}) async {
    if (idsListForSync.isNotEmpty) {
      final fiTables = await SendDataHandler()
          .getSelectedInspectionIdsData(context, idsListForSync);

      if (fiTables != null && fiTables.isNotEmpty) {
        final userId = await UserMasterTable().getFirstUserID();

        final inspectionData = {
          "UserID": userId,
          "InspectionData": {
            "Data": fiTables,
            "ImageFiles": "",
            "EnclosureFiles": "",
            "TestReportFiles": "",
            "Result": true,
            "Message": "",
            "MsgDetail": ""
          }
        };

        debugPrint(
            "FINALIZE sync .........................................\n\n");

       bool success = await context.read<SyncToServerCubit>().sendInspection(inspectionData);
if(success){
  for (String id in idsListForSync) {
    await ItemInspectionDetailHandler().updateFinalSync(id);
  }
}

      }
    }
  }

  Future<void> handleToPkgAppearanceSync(
      {required List<String> idsListForSync}) async {
    if (idsListForSync.isNotEmpty) {
      final pkgTables =
          await SendDataHandler().getPkgAppearanceData(idsListForSync);

      if (pkgTables != null && pkgTables.isNotEmpty) {
        final userId = await UserMasterTable().getFirstUserID();

        final inspectionData = {
          "UserID": userId,
          "InspectionData": {
            "Data": pkgTables,
            "ImageFiles": "",
            "EnclosureFiles": "",
            "TestReportFiles": "",
            "Result": true,
            "Message": "",
            "MsgDetail": ""
          }
        };

        debugPrint(
            "PACKAGING APPEARANCE sync .........................................\n\n");

        await context.read<SyncToServerCubit>().sendInspection(inspectionData);
      } else {}
    }
  }

  Future<void> handleToOnSiteBarcodeSync(
      {required List<String> idsListForSync}) async {
    if (idsListForSync.isNotEmpty) {
      final digiTables =
          await SendDataHandler().getOnSiteDataData(idsListForSync);

      if (digiTables != null && digiTables.isNotEmpty) {
        final userId = await UserMasterTable().getFirstUserID();

        final inspectionData = {
          "UserID": userId,
          "InspectionData": {
            "Data": digiTables,
            "ImageFiles": "",
            "EnclosureFiles": "",
            "TestReportFiles": "",
            "Result": true,
            "Message": "",
            "MsgDetail": ""
          }
        };

        debugPrint(
            "ON SITE sync .........................................\n\n");
        await context.read<SyncToServerCubit>().sendInspection(inspectionData);
      }
    }
  }

  Future<void> handleToSampleCollectedSync(
      {required List<String> idsListForSync}) async {
    if (idsListForSync.isNotEmpty) {
      final digiTables =
          await SendDataHandler().getSampleCollectedData(idsListForSync);

      if (digiTables != null && digiTables.isNotEmpty) {
        final userId = await UserMasterTable().getFirstUserID();

        final inspectionData = {
          "UserID": userId,
          "InspectionData": {
            "Data": digiTables,
            "ImageFiles": "",
            "EnclosureFiles": "",
            "TestReportFiles": "",
            "Result": true,
            "Message": "",
            "MsgDetail": ""
          }
        };

        debugPrint(
            "SAMPLE COLLECTED sync .........................................\n\n");
        await context.read<SyncToServerCubit>().sendInspection(inspectionData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SyncToServerCubit, SyncToServerState>(
      listener: (context, state) {
        String currentTable = tableList[_currentSyncStep];
        developer.log("Current table Name $currentTable");

        if (state is SyncToServerSuccess) {
          updateSyncList(currentTable, FEnumerations.syncSuccessStatus);
          moveToNextStep();
        } else if (state is SyncToServerFailure) {
          updateSyncList(currentTable, FEnumerations.syncFailedStatus);
          updateSyncTitleList(currentTable, state.error);
          // moveToNextStep(); // optional
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: Text('Buyerease'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(child: SyncStatusList(modelList: statusModalList)),
            ],
          ),
        ),
      ),
    );
  }
}

class SyncStatusList extends StatelessWidget {
  final List<StatusModel> modelList;

  const SyncStatusList({super.key, required this.modelList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: modelList.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        return SyncStatusItem(item: modelList[index]);
      },
    );
  }
}

class SyncStatusItem extends StatelessWidget {
  final StatusModel item;

  const SyncStatusItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;
    bool showProgress = false;

    switch (item.status) {
      case FEnumerations.syncInProcessStatus:
        showProgress = true;
        iconData = Icons.sync;
        iconColor = Colors.transparent;
        break;
      case FEnumerations.syncSuccessStatus:
        iconData = Icons.done;
        iconColor = Colors.teal;
        break;
      case FEnumerations.syncFailedStatus:
        iconData = Icons.cancel;
        iconColor = Colors.red;
        break;
      default:
        iconData = Icons.help_outline;
        iconColor = Colors.grey;
        break;
    }

    return ListTile(
      leading: showProgress
          ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(iconData, color: iconColor),
      title: Text(
        item.tableName,
        style: TextStyle(fontSize: 14),
      ),
      subtitle: item.title.isNotEmpty
          ? Text(
              item.title,
              style: TextStyle(fontSize: 10),
            )
          : null,
    );
  }
}
