import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_helper.dart';

class QrInspectionHistoryTable {
  static const String TABLE_NAME = "QRInspectionHistory";

  // Column constants
  static const String qrHdrID = "QRHdrID";
  static const String inspectionDt = "InspectionDt";
  static const String status = "Status";
  static const String statusDs = "StatusDs";
  static const String activityDs = "ActivityDs";
  static const String qr = "QR";
  static const String inspector = "Inspector";
  static const String qrPOItemHdrID = "QRPOItemHdrID";
  static const String refQRHdrID = "RefQRHdrID";
  static const String refQRPOItemHdrID = "RefQRPOItemHdrID";

  // SQL Create Table statement
  static const String CREATE = '''
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
      $qrHdrID TEXT,
      $inspectionDt TEXT,
      $status TEXT,
      $statusDs TEXT,
      $activityDs TEXT,
      $qr TEXT,
      $inspector TEXT,
      $qrPOItemHdrID TEXT,
      $refQRHdrID TEXT,
      $refQRPOItemHdrID TEXT
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

  // Get by QRHdrID
  Future<List<Map<String, dynamic>>> getByQRHdrID(String id) async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$qrHdrID = ?',
      whereArgs: [id],
    );
  }

  // Update a record (based on QRHdrID + InspectionDt as composite key)
  Future<void> updateRecord(String hdrID, String date, Map<String, dynamic> values) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      values,
      where: '$qrHdrID = ? AND $inspectionDt = ?',
      whereArgs: [hdrID, date],
    );
  }

  // Delete a record
  Future<int> deleteRecord(String hdrID, String date) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      TABLE_NAME,
      where: '$qrHdrID = ? AND $inspectionDt = ?',
      whereArgs: [hdrID, date],
    );
  }

  // Delete all records
  Future<int> deleteAll() async {
    final db = await DatabaseHelper().database;
    return await db.delete(TABLE_NAME);
  }
}

