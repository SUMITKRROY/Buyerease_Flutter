import '../../utils/app_constants.dart';
import '../../utils/fsl_log.dart';
import '../../database/database_helper.dart';

/**
 * created by Roy on 24/06/2025.
 */

class SyncDataHandler {
  static String TAG = "SyncDataHandler";

  List<String> getTablesToSyncList() {
    List<String> tableList = [];

    tableList.add(FEnumerations.syncHeaderTable);
    tableList.add(FEnumerations.syncSizeQuantityTable);
    tableList.add(FEnumerations.syncImagesTable);
    tableList.add(FEnumerations.syncWorkmanshipTable);
    tableList.add(FEnumerations.syncItemMeasurementTable);
    tableList.add(FEnumerations.syncFindingTable);
    tableList.add(FEnumerations.syncQualityParameterTable);
    tableList.add(FEnumerations.syncFitnessCheckTable);
    tableList.add(FEnumerations.syncProductionStatusTable);
    tableList.add(FEnumerations.syncIntimationTable);
    tableList.add(FEnumerations.syncEnclosureTable);
    tableList.add(FEnumerations.syncDigitalUploadTable);
    tableList.add(FEnumerations.syncPkgAppearance);
    tableList.add(FEnumerations.syncOnSite);
    tableList.add(FEnumerations.syncSampleCollected);

    return tableList;
  }

  List<String> getTablesToSyncListWithoutPkgApp() {
    List<String> tableList = [];
    
    tableList.add(FEnumerations.syncHeaderTable);
    tableList.add(FEnumerations.syncSizeQuantityTable);
    tableList.add(FEnumerations.syncImagesTable);
    tableList.add(FEnumerations.syncWorkmanshipTable);
    tableList.add(FEnumerations.syncItemMeasurementTable);
    tableList.add(FEnumerations.syncFindingTable);
    tableList.add(FEnumerations.syncQualityParameterTable);
    tableList.add(FEnumerations.syncFitnessCheckTable);
    tableList.add(FEnumerations.syncProductionStatusTable);
    tableList.add(FEnumerations.syncIntimationTable);
    tableList.add(FEnumerations.syncEnclosureTable);
    tableList.add(FEnumerations.syncDigitalUploadTable);
    // tableList.add(FEnumerations.syncPkgAppearance);
    tableList.add(FEnumerations.syncOnSite);
    tableList.add(FEnumerations.syncSampleCollected);
    
    return tableList;
  }

  List<String> getTablesToSyncStyleList() {
    List<String> tableList = [];
    
    tableList.add(FEnumerations.syncStyle);
    tableList.add(FEnumerations.syncImagesTable);
    tableList.add(FEnumerations.syncFinalizeTable);
    
    return tableList;
  }

  Future<List<String>> getTablesToDelete() async {
    List<String> tableList = [];

    try {
      final dbHelper = DatabaseHelper();
      final database = await dbHelper.database;

      String query = "SELECT name FROM sqlite_master WHERE type='table' AND name!='android_metadata' order by name";
      FslLog.d(TAG, " query for table list $query");

      final List<Map<String, dynamic>> tables = await database.rawQuery(query);
      for (var table in tables) {
        tableList.add(table['name'] as String);
      }
      
      FslLog.d(TAG, " count of found tables ${tableList.length}");
    } catch (e) {
      print(e);
    }
    return tableList;
  }

  Future<void> deleteRecordFromAllTable(String tableName) async {
    try {
      final dbHelper = DatabaseHelper();
      final database = await dbHelper.database;
      
      await database.execute("delete from $tableName");
      FslLog.d(TAG, " delete all records from $tableName");
      
    } catch (e) {
      print(e);
    }
  }
}
