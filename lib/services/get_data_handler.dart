import 'dart:convert';

import 'package:buyerease/config/api_route.dart';
import 'package:buyerease/database/table/defect_master.dart';
import 'package:buyerease/database/table/user_master_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../database/database_helper.dart';
import '../utils/app_constants.dart';
import '../utils/device_info.dart';
import '../utils/fsl_log.dart';
import '../utils/gen_utils.dart';

typedef GetCallBackResult = void Function(dynamic result, dynamic error);

class GetDataHandler {
  static const String _tag = 'GetDataHandler';

  // Fetch Defect Master Data 1st api of the data
  static Future<void> getDefectMaster(
      BuildContext context,
      GetCallBackResult callback,
      ) async
  {
    UserMasterTable masterTable = UserMasterTable();
    String? userId = await masterTable.getFirstUserID(); // ✅ Await and use correct method

    if (userId == null || userId.isEmpty) {
      _showToast(context, 'Could not find valid user');
      callback(null, 'Invalid user');
      return;
    }

    String url = ApiRoute.defectMaster;
    Map<String, String> params = {'UserID': userId};

    FslLog.d(_tag, 'DefectMaster url: $url');
    FslLog.d(_tag, 'DefectMaster param: $params');

    try {
      final response = await _makePostRequest(url, params);
      final jsonObjectData = response['Data'] as List<dynamic>?;

      if (jsonObjectData != null && jsonObjectData.isNotEmpty) {
        final jsonObject = jsonObjectData[0] as Map<String, dynamic>;
        final dataArray = jsonObject['DefectMaster'] as List<dynamic>?;

        if (dataArray != null && dataArray.isNotEmpty) {
          await handleDefectMasterData(context, dataArray);
        } else {
          _showToast(context, 'Data not found');
        }
      } else {
        _showToast(context, 'Data not found');
      }
      callback(null, null);
    } catch (e) {
      FslLog.e(_tag, 'Error fetching DefectMaster: $e');
      callback(null, e);
    }
  }


  // Handle Defect Master Data
  static Future<void> handleDefectMasterData(
      BuildContext context, List<dynamic> jsonArray) async
  {
    if (jsonArray.isNotEmpty) {
      for (var json in jsonArray) {
        if (json != null) {
          await updateOrInsertDefectMaster(context, json);
        } else {
          FslLog.d(_tag, 'DefectMaster jsonObject IS NULL');
        }
      }
    }
  }

  // Update or Insert Defect Master
  static Future<int> updateOrInsertDefectMaster(
      BuildContext context, Map<String, dynamic> json) async
  {
    final dbHelper = DatabaseHelper();
    final database = await dbHelper.database;
    final contentValues = <String, dynamic>{};

    try {
      final cursor = await GenUtils.getColumnExistsInTable(
           DefectMaster.TABLE_NAME);
      for (var key in json.keys) {
        if (cursor.contains(key)) {
          contentValues[key] = json[key].toString();
        } else {
          FslLog.e(_tag, 'Column $key NOT EXIST in DefectMaster');
        }
      }

      int rows = await database.update(
        'DefectMaster',
        contentValues,
        where: 'pRowID = ?',
        whereArgs: [contentValues['pRowID']],
      );

      int mStatus = 0;
      if (rows == 0) {
        int status = await database.insert('DefectMaster', contentValues);
        if (status > 0) {
          mStatus = 2;
          FslLog.d(_tag, 'Insert DefectMaster successfully');
        }
      } else {
        mStatus = 1;
        FslLog.d(_tag, 'Update DefectMaster successfully');
      }
      return mStatus;
    } catch (e, stackTrace) {
      FslLog.e(_tag, 'Error in updateOrInsertDefectMaster: $e', stackTrace);
      return 0;
    }
  }

  // Handle Enclosures
  static Future<void> handleEnclosures(
     List<dynamic> jsonArray) async {
    if (jsonArray.isNotEmpty) {
      for (var json in jsonArray) {
        if (json != null) {
          await updateOrInsertEnclosures( json);
        } else {
          FslLog.d(_tag, 'Enclosures jsonObject IS NULL');
        }
      }
    }
  }

  // Update or Insert Enclosures
  static Future<int> updateOrInsertEnclosures(
      Map<String, dynamic> json) async
  {
    final dbHelper = DatabaseHelper();
    final database = await dbHelper.database;
    final contentValues = <String, dynamic>{};

    try {
      final cursor =
      await GenUtils.getColumnExistsInTable( 'Enclosures');
      for (var key in json.keys) {
        if (!cursor.contains(key)) {
          if (key.toLowerCase() == 'isimportant') {
            FslLog.e(_tag, 'Column $key not found, altering as INTEGER');
            await handleToAlterAsIn( 'Enclosures', key);
          } else {
            FslLog.e(_tag, 'Column $key not found, NEED TO alter as STRING');
          }
        }
        if (cursor.contains(key)) {
          if (key.toLowerCase() == 'isimportant') {
            contentValues[key] = json[key].toString().toLowerCase() == 'true' ? 1 : 0;
          } else {
            contentValues[key] = json[key].toString();
          }
        } else {
          FslLog.e(_tag, 'Column $key NOT EXIST in Enclosures');
        }
      }

      if (!cursor.contains('IsImportant')) {
        FslLog.e(_tag, 'Column IsImportant not found, altering as INTEGER');
        await handleToAlterAsIn( 'Enclosures', 'IsImportant');
      }
      if (!cursor.contains('IsRead')) {
        FslLog.e(_tag, 'Column IsRead not found, altering as INTEGER');
        await handleToAlterAsIn( 'Enclosures', 'IsRead');
      }

      int rows = await database.update(
        'Enclosures',
        contentValues,
        where:
        'EnclRowID = ? AND (IFNULL(QRPOItemHdrId, \'\') = ? OR IFNULL(QRPOItemHdrId, \'\') = \'\') AND QRHdrID = ?',
        whereArgs: [
          contentValues['EnclRowID'],
          contentValues['QRPOItemHdrID'] ?? '',
          contentValues['QRHdrID'],
        ],
      );

      int mStatus = 0;
      if (rows == 0) {
        int status = await database.insert('Enclosures', contentValues);
        if (status > 0) {
          mStatus = 2;
          FslLog.d(_tag, 'Insert Enclosures successfully');
        }
      } else {
        mStatus = 1;
        FslLog.d(_tag, 'Update Enclosures successfully');
      }
      return mStatus;
    } catch (e, stackTrace) {
      FslLog.e(_tag, 'Error in updateOrInsertEnclosures: $e', stackTrace);
      return 0;
    }
  }

  // Alter Table to Add Integer Column
  static Future<void> handleToAlterAsIn(
       String tableName, String columnName) async
  {
    final dbHelper = DatabaseHelper();
    final database = await dbHelper.database;

    String addColumn = 'ALTER TABLE $tableName ADD COLUMN $columnName INTEGER DEFAULT 0';
    try {
      await database.execute(addColumn);
    } catch (e) {
      FslLog.w(_tag, 'Altering $tableName: $e');
    }
  }

  // Alter Table to Add Real Column
  static Future<void> handleToAlterAsReal(
       String tableName, String columnName) async
  {
    final dbHelper = DatabaseHelper();
    final database = await dbHelper.database;

    String addColumn = 'ALTER TABLE $tableName ADD COLUMN $columnName REAL';
    try {
      await database.execute(addColumn);
    } catch (e) {
      FslLog.w(_tag, 'Altering $tableName: $e');
    }
  }

  // Get Last Sync Date
  static Future<String?> getLastGetSyncData(BuildContext context) async
  {
    final dbHelper = DatabaseHelper();
    final database = await dbHelper.database;

    String query = 'SELECT Last_Get_Dt FROM Sync_Info ORDER BY Last_Get_Dt DESC LIMIT 1';
    FslLog.d(_tag, 'Query for last sync date: $query');

    try {
      final result = await database.rawQuery(query);
      String? recDt;
      if (result.isNotEmpty) {
        recDt = result.first['Last_Get_Dt'] as String?;
      }
      FslLog.d(_tag, 'Last sync date: $recDt');
      return recDt;
    } catch (e) {
      FslLog.e(_tag, 'Error fetching last sync date: $e');
      return null;
    }
  }

  // Update Last Sync Date
  static Future<int> updateLastGetSyncDate(BuildContext context) async
  {
    final dbHelper = DatabaseHelper();
    final database = await dbHelper.database;

    final contentValues = {'Last_Get_Dt': ApiRoute.getCurrentDateOnly()};

    try {
      int rows = await database.update('Sync_Info', contentValues);
      if (rows == 0) {
        FslLog.d(_tag, 'COULD NOT update Sync_Info');
        return 0;
      } else {
        FslLog.d(_tag, 'Update Sync_Info');
        return 1;
      }
    } catch (e) {
      FslLog.e(_tag, 'Error updating Sync_Info: $e');
      return 0;
    }
  }

  // Helper: Make HTTP POST Request
  static Future<Map<String, dynamic>> _makePostRequest(
      String url, Map<String, String> params) async
  {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(params),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  // Helper: Show Toast
  static void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Placeholder methods for other handlers (to be implemented as needed)
  static Future<void> handleQRFeedBackHdr(
      BuildContext context, List<dynamic> jsonArray) async {
    // Implement similar to handleEnclosures
  }

  static Future<void> handleQRPOItemHdr(
      BuildContext context, List<dynamic> jsonArray) async {
    // Implement similar to handleEnclosures
  }

  static Future<void> handleQRPOItemDtl(
      BuildContext context, List<dynamic> jsonArray) async {
    // Implement similar to handleEnclosures
  }

  static Future<void> handleQRPOItemDtlImage(
      BuildContext context, List<dynamic> jsonArray) async {
    // Implement similar to handleEnclosures
  }

  static Future<void> handleQRPOIntimationDetails(
      BuildContext context, List<dynamic> jsonArray) async {
    // Implement similar to handleEnclosures
  }

  static Future<void> handleGenMst(
      BuildContext context, List<dynamic> jsonArray) async {
    // Implement similar to handleEnclosures
  }

  static Future<void> handleSysData22(
      BuildContext context, List<dynamic> jsonArray) async {
    // Implement similar to handleEnclosures
  }

  static Future<void> handleQualityLevel(
      BuildContext context, List<dynamic> jsonArray) async {
    // Implement similar to handleEnclosures
  }

  static Future<void> handleQualityLevelDtl(
      BuildContext context, List<dynamic> jsonArray) async {
    // Implement similar to handleEnclosures
  }

  static Future<void> handleInsplvlHdr(
      BuildContext context, List<dynamic> jsonArray) async {
    // Implement similar to handleEnclosures
  }

  static Future<void> handleInspLvlDtl(
      BuildContext context, List<dynamic> jsonArray) async {
    // Implement similar to handleEnclosures
  }

  static Future<void> handleQRInspectionHistory(
      BuildContext context, List<dynamic> jsonArray) async {
    // Implement similar to handleEnclosures
  }

  static Future<void> handleTestReport(
      BuildContext context, List<dynamic> jsonArray) async {
    // Implement similar to handleEnclosures
  }

  static Future<void> handleUpdateCriticalAllowed(
      BuildContext context, List<dynamic> jsonArray) async {
    // Implement similar to handleEnclosures
  }

  static Future<void> handleItemMeasurement(
      BuildContext context, List<dynamic> jsonArray) async {
    // Implement similar to handleEnclosures
  }

  static Future<void> handleAuditBatchDetails(
      BuildContext context, List<dynamic> jsonArray) async {
    // Implement similar to handleEnclosures
  }

  static Future<void> handleSizeQuantity(
      BuildContext context, List<dynamic> jsonArray) async {
    // Implement similar to handleEnclosures
  }

  static Future<void> handleGenQualityParameterProductMap(
      BuildContext context, List<dynamic> jsonArray) async {
    // Implement similar to handleEnclosures
  }
}
