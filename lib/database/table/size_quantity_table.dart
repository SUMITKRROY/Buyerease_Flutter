import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_helper.dart';

class SizeQuantityTable {
  static const String TABLE_NAME = "SizeQuantity";

  static const String acceptedQty = "AcceptedQty";
  static const String availableQty = "AvailableQty";
  static const String earlierInspected = "EarlierInspected";
  static const String orderQty = "OrderQty";
  static const String poID = "POID";
  static const String qrPOItemDtlID = "QRPOItemDtlID";
  static const String qrPOItemHdrID = "QRPOItemHdrID";
  static const String sizeGroupDescr = "SizeGroupDescr";
  static const String sizeID = "SizeID";

  static const String CREATE = '''
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
      $acceptedQty INTEGER DEFAULT 0,
      $availableQty INTEGER DEFAULT 0,
      $earlierInspected INTEGER DEFAULT 0,
      $orderQty INTEGER DEFAULT 0,
      $poID TEXT DEFAULT '',
      $qrPOItemDtlID TEXT DEFAULT '',
      $qrPOItemHdrID TEXT DEFAULT '',
      $sizeGroupDescr TEXT DEFAULT '',
      $sizeID TEXT DEFAULT ''
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

  // Get record by POID
  Future<List<Map<String, dynamic>>> getByPOID(String poid) async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$poID = ?',
      whereArgs: [poid],
    );
  }

  // Update record by POID
  Future<void> update(String poid, Map<String, dynamic> map) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      map,
      where: '$poID = ?',
      whereArgs: [poid],
    );
  }

  // Delete record by POID
  Future<int> delete(String poid) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      TABLE_NAME,
      where: '$poID = ?',
      whereArgs: [poid],
    );
  }

  // Delete all records
  Future<int> deleteAll() async {
    final db = await DatabaseHelper().database;
    return await db.delete(TABLE_NAME);
  }
}
