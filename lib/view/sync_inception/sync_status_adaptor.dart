import 'package:buyerease/utils/app_constants.dart';
import 'package:flutter/material.dart';
import '../../model/status_modal.dart';

class SyncStatusAdapter extends StatelessWidget {
  final List<StatusModel> modelList;

  const SyncStatusAdapter({Key? key, required this.modelList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.builder(
        itemCount: modelList.length,
        itemBuilder: (context, index) {
          final item = modelList[index];
          return ListTile(
            title: Text(item.tableName),
            subtitle: item.title != null && item.title!.isNotEmpty
                ? Text(item.title!)
                : null,
            leading: _buildIconOrProgress(item.status, context),
          );
        },
      ),
    );
  }

  Widget _buildIconOrProgress(int status, BuildContext context) {
    switch (status) {
      case SyncStatus.inProcess:
        return SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case SyncStatus.success:
        return Icon(Icons.check_circle, color: Colors.teal);
      case SyncStatus.failed:
        return Icon(Icons.cancel, color: Colors.red);
      case SyncStatus.pending:
        return Icon(Icons.cancel, color: Theme.of(context).primaryColor);
      default:
        return Icon(Icons.help_outline);
    }
  }
}

class SyncStatus {
  static const int inProcess = 0;
  static const int success = 1;
  static const int failed = 2;
  static const int pending = 3;
}

class SyncStatusPage extends StatefulWidget {
  @override
  _SyncStatusPageState createState() => _SyncStatusPageState();
}

class _SyncStatusPageState extends State<SyncStatusPage> {
  List<StatusModel> statusModalList = [];

  @override
  void initState() {
    super.initState();
   
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sync Status')),
      body: SyncStatusAdapter(modelList: statusModalList),
    );
  }
}

class SysData22Modal {
  final String genID;
  final String masterName;
  final String mainID;
  final String mainDescr;
  final String subID;
  final String subDescr;
  final String numVal1;
  final String numVal2;
  final String addonInfo;
  final String moreInfo;
  final String priviledge;
  final String a;
  final String moduleAccess;
  final String moduleID;

  SysData22Modal({
    required this.genID,
    required this.masterName,
    required this.mainID,
    required this.mainDescr,
    required this.subID,
    required this.subDescr,
    required this.numVal1,
    required this.numVal2,
    required this.addonInfo,
    required this.moreInfo,
    required this.priviledge,
    required this.a,
    required this.moduleAccess,
    required this.moduleID,
  });
}
