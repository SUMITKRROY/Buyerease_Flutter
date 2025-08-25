import 'dart:developer' as developer;

import 'package:sqflite/sqflite.dart';
import '../../database/database_helper.dart';
import '../../model/sync/SysData22Model.dart';


class SysData22Handler {
  static const String tableName = 'Sysdata22';

  // Insert or Update
  static Future<bool> insertSysData22Master(SysData22Modal model) async {
    final db = await DatabaseHelper().database;

    final data = model.toMap();
    final existing = await db.query(
      tableName,
      where: 'MainID = ?',
      whereArgs: [model.mainID],
    );

    if (existing.isEmpty) {
      await db.insert(tableName, data);
    } else {
      await db.update(tableName, data, where: 'MainID = ?', whereArgs: [model.mainID]);
    }
    return true;
  }

  // Get list by GenID and MainID
  static Future<List<SysData22Modal>> getListByGenAndMainID(String genId, String mainID) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      tableName,
      where: 'GenID = ? AND MainID = ?',
      whereArgs: [genId, mainID],
      orderBy: 'MainID',
    );
    return result.map((e) => SysData22Modal.fromMap(e)).toList();
  }

  static Future<List<SysData22Modal>> getSysData22List(String genId) async {
    final db = await DatabaseHelper().database;
    List<SysData22Modal> list = [];

    try {
      final result = await db.query(
        'Sysdata22',
        where: 'GenID = ?',
        whereArgs: [genId],
        orderBy: 'MainID',
      );

      list = result.map((e) => SysData22Modal.fromMap(e)).toList();
      print('Fetched ${list.length} entries from Sysdata22 with GenID: $genId');
    } catch (e) {
      print('Error in getSysData22List: $e');
    }

    return list;
  }

  // Get list by GenID
  static Future<List<SysData22Modal>> getListByGenID(String genId) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      tableName,
      where: 'GenID = ?',
      whereArgs: [genId],
      orderBy: 'MainID',
    );
    return result.map((e) => SysData22Modal.fromMap(e)).toList();
  }

  // Update DB with a list
  static Future<void> updateDatabase(List<SysData22Modal> list) async {
    for (final item in list) {
      await insertSysData22Master(item);
    }
  }

  // Parse from JSON (assuming JSON array input)
  static List<SysData22Modal> parseFromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SysData22Modal.fromMap(json)).toList();
  }


  static Future<List<SysData22Modal>> getDataAccordingToParticularList(
      String genId, String departmentId) async {
    final db = await DatabaseHelper().database;
    List<SysData22Modal> list = [];

    try {
      final result = await db.query(
        'GenMst',
        where: 'GenID = ? AND pGenRowID = ?',
        whereArgs: [genId, departmentId],
      );

      list = result.map((e) => SysData22Modal.fromMap(e)).toList();
      print('Fetched ${list.length} entries from GenMst with GenID: $genId and pGenRowID: $departmentId');
    } catch (e) {
      print('Error in getDataAccordingToParticularList: $e');
    }

    return list;
  }
  static Future<String?> getDataAccordingId(Database db, String pGenRowID) async {
    String? mainDescr;

    try {
      String query = '''
      SELECT MainDescr 
      FROM GenMst 
      WHERE pGenRowID = ?
    ''';

      final List<Map<String, dynamic>> result =
      await db.rawQuery(query, [pGenRowID]);

      if (result.isNotEmpty) {
        mainDescr = result.first['MainDescr']?.toString();
      }
    } catch (e) {
      print("Error in getDataAccordingId: $e");
    }

    return mainDescr;
  }


  static Future<String?> getMainDescrById(String pGenRowID) async {
    final db = await DatabaseHelper().database;
    String? mainDescr;

    try {
      final result = await db.query(
        'GenMst',
        columns: ['MainDescr'],
        where: 'pGenRowID = ?',
        whereArgs: [pGenRowID],
      );

      if (result.isNotEmpty) {
        mainDescr = result.first['MainDescr'] as String?;
      }

      print('Fetched MainDescr for pGenRowID $pGenRowID: $mainDescr');
    } catch (e) {
      print('Error in getMainDescrById: $e');
    }

    return mainDescr;
  }
  static Future<List<SysData22Modal>> getSysData22ListAccToID(String genId, String mainID) async {
    final List<SysData22Modal> resultList = [];

    try {
      final db = await DatabaseHelper().database;

      final String query = '''
      SELECT * FROM Sysdata22
      WHERE GenID = ? AND MainID = ?
      ORDER BY MainID
    ''';

      final List<Map<String, dynamic>> result = await db.rawQuery(query, [genId, mainID]);
      developer.log("sysdata22Modal result ${(query)}");
      // Log the query with parameters
      developer.log("sysdata22Modal query: $query | genId: $genId | mainID: $mainID");
      developer.log("sysdata22Modal result ${(result)}");
      for (var row in result) {
        resultList.add(SysData22Modal.fromMap(row));
      }
    } catch (e) {
      print('Error in getSysData22ListAccToID: $e');
    }

    return resultList;
  }

  static SysData22Modal getData(Map<String, dynamic> row) {
    return SysData22Modal(
      genID: row['GenID']!.toString(),
      mainID: row['MainID']!.toString(),
      subID: row['SubID']!.toString(),
      masterName: row['MasterName']!.toString(),
      mainDescr: row['MainDescr']!.toString(),
      subDescr: row['SubDescr']!.toString(),
      numVal1: row['numVal1']!.toString(),
      numVal2: row['numVal2']!.toString(),
      addonInfo: row['AddonInfo']!.toString(),
      moreInfo: row['MoreInfo']!.toString(),
      priviledge: row['Priviledge']!.toString(),
      a: row['a']!.toString(),
      moduleAccess: row['ModuleAccess']!.toString(),
      moduleID: row['ModuleID']!.toString(),
    );
  }

}
