import 'package:flutter/material.dart';

import '../../utils/app_constants.dart';

class ChooseDataScreen extends StatefulWidget {
  final int viewType;
  final int syncViewType;
  final List<String>? listedSyncIds;

  ChooseDataScreen({
    required this.viewType,
    required this.syncViewType,
    this.listedSyncIds,
  });

  @override
  _ChooseDataScreenState createState() => _ChooseDataScreenState();
}

class _ChooseDataScreenState extends State<ChooseDataScreen> {
  bool chkGetInspectionData = false;
  bool chkGetMasterData = false;
  bool isDataSyncComplete = false;

  List<String> idsListForSync = [];
  List<String> syncDoneProcess = [];
  int totalIdsToSync = 0;
  int syncedImageCount = 0;

  bool showProgressDialog = false;

  @override
  void initState() {
    super.initState();

    if (widget.syncViewType == E_VIEW_TYPE_HOLOGRAM_STYLE) {
      handleHologramView();
      handleToCreateHologramDb();
    } else {
      handleView();
    }
  }

  void handleToCreateHologramDb() {
    // StyleHandler.checkAndCreateTable() logic here if needed
  }

  void handleHologramView() {
    if (widget.viewType == E_VIEW_ONLY_SEND) {
      if (widget.listedSyncIds != null && widget.listedSyncIds!.isNotEmpty) {
        idsListForSync = widget.listedSyncIds!.toSet().toList();
        handleListToSync();
        viewStatusListOfSyncOfStyleHologram();
        handleToSyncStyle();
      }
    }
  }

  void handleView() {
    if (widget.viewType == E_VIEW_ONLY_SYNC || widget.viewType == E_VIEW_SEND_AND_SYNC) {
      if (widget.listedSyncIds != null) {
        totalIdsToSync = widget.listedSyncIds!.length;
      }
      handleListToSync();
      handleToSendData();
    }
  }

  void handleListToSync() {
    // Implement sync list preparation logic here
  }

  void handleToSendData() {
    updateStatusUI();
    if (widget.listedSyncIds != null && widget.listedSyncIds!.isNotEmpty) {
      idsListForSync.add(widget.listedSyncIds![0]);
      viewStatusListOfSync();
      getDELToSync();
    }
  }

  void updateStatusUI() {
    // UI status update logic
  }

  void viewStatusListOfSync() {
    // Handle UI update for sync list
  }

  void viewStatusListOfSyncOfStyleHologram() {
    // Handle UI update for hologram sync list
  }

  void handleToSyncStyle() {
    // Logic to sync style data
  }

  void getDELToSync() {
    // handleToHeaderSync()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buyerease'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Company: [CompanyName]", style: TextStyle(fontSize: 16)),

            if (widget.syncViewType == E_VIEW_TYPE_HOLOGRAM_STYLE)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: handleToSyncStyle,
                    child: Text('Get Style Data'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Send style data logic
                    },
                    child: Text('Send Style Data'),
                  ),
                ],
              )
            else
              Column(
                children: [
                  CheckboxListTile(
                    title: Text("Get Inspection Data"),
                    value: chkGetInspectionData,
                    onChanged: (val) {
                      setState(() {
                        chkGetInspectionData = val!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text("Get Master Data"),
                    value: chkGetMasterData,
                    onChanged: (val) {
                      setState(() {
                        chkGetMasterData = val!;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle getDataSubmit
                    },
                    child: Text('Get Data'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle sendSubmit
                    },
                    child: Text('Send Data'),
                  ),
                ],
              ),

            SizedBox(height: 20),
            Text("Sync Count: $totalIdsToSync", style: TextStyle(fontSize: 16)),

            // Simulated sync progress
            if (showProgressDialog)
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}

// Constants (Replace with your enums or config values)
const int E_VIEW_TYPE_HOLOGRAM_STYLE = FEnumerations.syncPendingStatus;
const int E_VIEW_ONLY_SYNC = FEnumerations.syncInProcessStatus;
const int E_VIEW_SEND_AND_SYNC = FEnumerations.syncSuccessStatus;
const int E_VIEW_ONLY_SEND = FEnumerations.syncFailedStatus;
