import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_helper.dart';

class SyncInfoTable {
  static const String TABLE_NAME = "Sync_Info";

  static const String lastSyncCompleteDt = "Last_Sync_Complete_Dt";
  static const String lastSyncAttemptDt = "Last_Sync_Attempt_Dt";
  static const String lastGetDt = "Last_Get_Dt";
  static const String imageLastSyncCompleteDt = "Image_Last_Sync_Complete_Dt";
  static const String imageLastSyncAttemptDt = "Image_Last_Sync_Attempt_Dt";
  static const String imLastSyncCompleteDt = "IM_Last_Sync_Complete_Dt";
  static const String imLastSyncAttemptDt = "IM_Last_Sync_Attempt_Dt";
  static const String fndLastSyncCompleteDt = "Fnd_Last_Sync_Complete_Dt";
  static const String fndLastSyncAttemptDt = "Fnd_Last_Sync_Attempt_Dt";
  static const String wLastSyncCompleteDt = "W_Last_Sync_Complete_Dt";
  static const String wLastSyncAttemptDt = "W_Last_Sync_Attempt_Dt";
  static const String paramLastSyncCompleteDt = "Param_Last_Sync_Complete_Dt";
  static const String paramLastSyncAttemptDt = "Param_Last_Sync_Attempt_Dt";
  static const String encLastSyncCompleteDt = "Enc_Last_Sync_Complete_Dt";
  static const String encLastSyncAttemptDt = "Enc_Last_Sync_Attempt_Dt";
  static const String intLastSyncCompleteDt = "Int_Last_Sync_Complete_Dt";
  static const String intLastSyncAttemptDt = "Int_Last_Sync_Attempt_Dt";

  static const String CREATE = '''
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
      $lastSyncCompleteDt TEXT DEFAULT '2010-01-01 00:00:00',
      $lastSyncAttemptDt TEXT DEFAULT '2010-01-01 00:00:00',
      $lastGetDt TEXT DEFAULT '2010-01-01 00:00:00',
      $imageLastSyncCompleteDt TEXT DEFAULT '2010-01-01 00:00:00',
      $imageLastSyncAttemptDt TEXT DEFAULT '2010-01-01 00:00:00',
      $imLastSyncCompleteDt TEXT DEFAULT '2010-01-01 00:00:00',
      $imLastSyncAttemptDt TEXT DEFAULT '2010-01-01 00:00:00',
      $fndLastSyncCompleteDt TEXT DEFAULT '2010-01-01 00:00:00',
      $fndLastSyncAttemptDt TEXT DEFAULT '2010-01-01 00:00:00',
      $wLastSyncCompleteDt TEXT DEFAULT '2010-01-01 00:00:00',
      $wLastSyncAttemptDt TEXT DEFAULT '2010-01-01 00:00:00',
      $paramLastSyncCompleteDt TEXT DEFAULT '2010-01-01 00:00:00',
      $paramLastSyncAttemptDt TEXT DEFAULT '2010-01-01 00:00:00',
      $encLastSyncCompleteDt TEXT DEFAULT '2010-01-01 00:00:00',
      $encLastSyncAttemptDt TEXT DEFAULT '2010-01-01 00:00:00',
      $intLastSyncCompleteDt TEXT DEFAULT '2010-01-01 00:00:00',
      $intLastSyncAttemptDt TEXT DEFAULT '2010-01-01 00:00:00'
    )
  ''';

  // Insert a record
  Future<void> insert(Map<String, dynamic> map) async {
    final db = await DatabaseHelper().database;
    await db.insert(TABLE_NAME, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get all records
  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await DatabaseHelper().database;
    return await db.query(TABLE_NAME);
  }

  // Get record by a specific field (e.g., LastSyncCompleteDt)
  Future<List<Map<String, dynamic>>> getByField(String field, String value) async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$field = ?',
      whereArgs: [value],
    );
  }

  // Update a record by the specific field (e.g., LastSyncCompleteDt)
  Future<void> update(String field, String value, Map<String, dynamic> map) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      map,
      where: '$field = ?',
      whereArgs: [value],
    );
  }

  // Delete all records
  Future<int> deleteAll() async {
    final db = await DatabaseHelper().database;
    return await db.delete(TABLE_NAME);
  }
}
