import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_helper.dart';
import 'dart:convert';
import 'dart:typed_data';

class QrPoItemDtlImageTable {
  static const String TABLE_NAME = "QRPOItemDtl_Image";

  // Column names
  static const String pRowID = "pRowID";
  static const String locID = "LocID";
  static const String qrHdrID = "QRHdrID";
  static const String qrPoItemHdrID = "QRPOItemHdrID";
  static const String qrPoItemDtlID = "QRPOItemDtlID";
  static const String itemID = "ItemID";
  static const String colorID = "ColorID";
  static const String title = "Title";
  static const String imageName = "ImageName";
  static const String imageExtn = "ImageExtn";
  static const String imageSymbol = "ImageSymbol";
  static const String imageSqn = "ImageSqn";
  static const String recEnable = "recEnable";
  static const String recUser = "recUser";
  static const String recAddDt = "recAddDt";
  static const String recDt = "recDt";
  static const String bePRowID = "BE_pRowID";
  static const String fileSent = "FileSent";
  static const String fileContent = "fileContent";
  static const String imagePathID = "ImagePathID";

// SQL to create the table with DEFAULT values
  static const String CREATE = '''
  CREATE TABLE IF NOT EXISTS $TABLE_NAME (
    $pRowID TEXT PRIMARY KEY,
    $locID TEXT DEFAULT '',
    $qrHdrID TEXT DEFAULT '',
    $qrPoItemHdrID TEXT DEFAULT '',
    $qrPoItemDtlID TEXT DEFAULT '',
    $itemID TEXT DEFAULT '',
    $colorID TEXT DEFAULT '',
    $title TEXT DEFAULT '',
    $imageName TEXT DEFAULT '',
    $imageExtn TEXT DEFAULT '',
    $imageSymbol TEXT DEFAULT '',
    $imageSqn INTEGER DEFAULT 0,
    $recEnable INTEGER DEFAULT 1,
    $recUser TEXT DEFAULT '',
    $recAddDt TEXT DEFAULT '',
    $recDt TEXT DEFAULT '',
    $bePRowID TEXT DEFAULT '',
    $fileSent INTEGER DEFAULT 0,
    $fileContent BLOB,
    $imagePathID TEXT DEFAULT ''  -- Add the missing column here
  )
''';


  // Insert
  Future<void> insert(Map<String, dynamic> map) async {
    final db = await DatabaseHelper().database;
    await db.insert(TABLE_NAME, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get all
  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await DatabaseHelper().database;
    return await db.query(TABLE_NAME);
  }

  // Get by pRowID
  Future<Map<String, dynamic>?> getById(String id) async {
    final db = await DatabaseHelper().database;
    final res = await db.query(
      TABLE_NAME,
      where: '$qrHdrID = ?',
      whereArgs: [id],
    );
    return res.isNotEmpty ? res.first : null;
  }

  // Update by pRowID
  Future<void> update(String id, Map<String, dynamic> values) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      values,
      where: '$pRowID = ?',
      whereArgs: [id],
    );
  }

  // Delete by pRowID
  Future<int> delete(String id) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      TABLE_NAME,
      where: '$pRowID = ?',
      whereArgs: [id],
    );
  }

  // Delete all
  Future<int> deleteAll() async {
    final db = await DatabaseHelper().database;
    return await db.delete(TABLE_NAME);
  }


  // Update only fileContent by pRowID
  Future<void> updateFileContent(String id, Uint8List fileContentData) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      {
        fileContent: fileContentData,
      },
      where: '$pRowID = ?',
      whereArgs: [id],
    );
  }

  // Get by QRPOItemHdrID and Title
  Future<List<Map<String, dynamic>>> getByHdrIDAndTitle(String qrPoItemHdrIDValue, String titleValue) async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$qrPoItemHdrID = ? AND $title = ?',
      whereArgs: [qrPoItemHdrIDValue, titleValue],
    );
  }


  // Get by QRHdrID
  Future<List<Map<String, dynamic>>> getByQrPOItemHdrID(String qrPOItemHdrID) async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$qrPoItemHdrID = ?',
      whereArgs: [qrPOItemHdrID],
    );
  }

}
