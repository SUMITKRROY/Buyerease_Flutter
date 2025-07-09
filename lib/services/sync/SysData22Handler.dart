import 'package:sqflite/sqflite.dart';
import '../../database/database_helper.dart';
import '../../model/sync/SysData22Model.dart';


class SysData22Handler {
  static const String tableName = 'Sysdata22';

  // Insert or Update
  static Future<bool> insertSysData22Master(SysData22Model model) async {
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
  static Future<List<SysData22Model>> getListByGenAndMainID(String genId, String mainID) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      tableName,
      where: 'GenID = ? AND MainID = ?',
      whereArgs: [genId, mainID],
      orderBy: 'MainID',
    );
    return result.map((e) => SysData22Model.fromMap(e)).toList();
  }

  static Future<List<SysData22Model>> getSysData22List(String genId) async {
    final db = await DatabaseHelper().database;
    List<SysData22Model> list = [];

    try {
      final result = await db.query(
        'Sysdata22',
        where: 'GenID = ?',
        whereArgs: [genId],
        orderBy: 'MainID',
      );

      list = result.map((e) => SysData22Model.fromMap(e)).toList();
      print('Fetched ${list.length} entries from Sysdata22 with GenID: $genId');
    } catch (e) {
      print('Error in getSysData22List: $e');
    }

    return list;
  }

  // Get list by GenID
  static Future<List<SysData22Model>> getListByGenID(String genId) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      tableName,
      where: 'GenID = ?',
      whereArgs: [genId],
      orderBy: 'MainID',
    );
    return result.map((e) => SysData22Model.fromMap(e)).toList();
  }

  // Update DB with a list
  static Future<void> updateDatabase(List<SysData22Model> list) async {
    for (final item in list) {
      await insertSysData22Master(item);
    }
  }

  // Parse from JSON (assuming JSON array input)
  static List<SysData22Model> parseFromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SysData22Model.fromMap(json)).toList();
  }


  static Future<List<SysData22Model>> getDataAccordingToParticularList(
      String genId, String departmentId) async {
    final db = await DatabaseHelper().database;
    List<SysData22Model> list = [];

    try {
      final result = await db.query(
        'GenMst',
        where: 'GenID = ? AND pGenRowID = ?',
        whereArgs: [genId, departmentId],
      );

      list = result.map((e) => SysData22Model.fromMap(e)).toList();
      print('Fetched ${list.length} entries from GenMst with GenID: $genId and pGenRowID: $departmentId');
    } catch (e) {
      print('Error in getDataAccordingToParticularList: $e');
    }

    return list;
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


}
