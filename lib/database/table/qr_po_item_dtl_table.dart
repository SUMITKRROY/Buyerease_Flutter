import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../../model/po_item_dtl_model.dart';

class QRPOItemDtlTable {
  static const String TABLE_NAME = 'QRPOItemdtl';

  // Column names
  static const String colPRowID = 'pRowID';
  static const String colLocID = 'LocID';
  static const String colQRHdrID = 'QRHdrID';
  static const String colPOItemDtlRowID = 'POItemDtlRowID';
  static const String colSampleRqstHdrlRowID = 'SampleRqstHdrlRowID';
  static const String colQualityDefectHdrID = 'QualityDefectHdrID';
  static const String colPOTnARowID = 'POTnARowID';
  static const String colSampleCodeID = 'SampleCodeID';
  static const String colAvailableQty = 'AvailableQty';
  static const String colAllowedinspectionQty = 'AllowedinspectionQty';
  static const String colInspectedQty = 'InspectedQty';
  static const String colAcceptedQty = 'AcceptedQty';
  static const String colFurtherInspectionReqd = 'FurtherInspectionReqd';
  static const String colCartonsPacked = 'CartonsPacked';
  static const String colAllowedCartonInspection = 'AllowedCartonInspection';
  static const String colCartonsInspected = 'CartonsInspected';
  static const String colCriticalDefectsAllowed = 'CriticalDefectsAllowed';
  static const String colMajorDefectsAllowed = 'MajorDefectsAllowed';
  static const String colMinorDefectsAllowed = 'MinorDefectsAllowed';
  static const String colCriticalDefect = 'CriticalDefect';
  static const String colMajorDefect = 'MajorDefect';
  static const String colMinorDefect = 'MinorDefect';
  static const String colRecAddUser = 'recAddUser';
  static const String colRecAddDt = 'recAddDt';
  static const String colRecEnable = 'recEnable';
  static const String colRecDirty = 'recDirty';
  static const String colRecUser = 'recUser';
  static const String colRecDt = 'recDt';
  static const String colEdiDt = 'ediDt';
  static const String colQRPOItemHdrID = 'QRPOItemHdrID';
  static const String colPalletPackedQty = 'PalletPackedQty';
  static const String colMasterPackedQty = 'MasterPackedQty';
  static const String colInnerPackedQty = 'InnerPackedQty';
  static const String colPackedQty = 'PackedQty';
  static const String colUnpackedQty = 'UnpackedQty';
  static const String colUnfinishedQty = 'UnfinishedQty';
  static const String colShortStockQty = 'ShortStockQty';
  static const String colCartonsPacked2 = 'CartonsPacked2';
  static const String colBaseMaterialID = 'BaseMaterialID';
  static const String colBaseMaterial_AddOnInfo = 'BaseMaterial_AddOnInfo';
  static const String colPONO = 'PONO';
  static const String colBuyerPODt = 'BuyerPODt';
  static const String colOrderQty = 'OrderQty';
  static const String colItemDescr = 'ItemDescr';
  static const String colEarlierInspected = 'EarlierInspected';
  static const String colPOMasterPackQty = 'POMasterPackQty';
  static const String colLR = 'LR';
  static const String colMR = 'MR';
  static const String colCustomerDepartment = 'CustomerDepartment';
  static const String colCustomerItemRef = 'CustomerItemRef';
  static const String colLatestDelDt = 'LatestDelDt';
  static const String colHologramNo = 'HologramNo';
  static const String colHologram_ExpiryDt = 'Hologram_ExpiryDt';
  static const String colIDimn = 'IDimn';
  static const String colWeight = 'Weight';
  static const String colCBM = 'CBM';
  static const String colIPDimn = 'IPDimn';
  static const String colIPWt = 'IPWt';
  static const String colIPCBM = 'IPCBM';
  static const String colIPQty = 'IPQty';
  static const String colOPDescr = 'OPDescr';
  static const String colOPWt = 'OPWt';
  static const String colOPCBM = 'OPCBM';
  static const String colOPQty = 'OPQty';
  static const String colPalletDimn = 'PalletDimn';
  static const String colPalletWt = 'PalletWt';
  static const String colPalletCBM = 'PalletCBM';
  static const String colPalletQty = 'PalletQty';
  static const String colRetailPrice = 'RetailPrice';
  static const String colItemRepeat = 'ItemRepeat';
  static const String colProductID = 'ProductID';

  static const String CREATE = '''
  CREATE TABLE IF NOT EXISTS $TABLE_NAME (
    $colPRowID TEXT,
    $colLocID TEXT,
    $colQRHdrID TEXT,
    $colPOItemDtlRowID TEXT,
    $colSampleRqstHdrlRowID TEXT,
    $colQualityDefectHdrID TEXT,
    $colPOTnARowID TEXT,
    $colSampleCodeID TEXT,
    $colAvailableQty REAL,
    $colAllowedinspectionQty REAL,
    $colInspectedQty REAL,
    $colAcceptedQty REAL,
    $colFurtherInspectionReqd INTEGER DEFAULT 0,
    $colCartonsPacked INTEGER DEFAULT 0,
    $colAllowedCartonInspection INTEGER DEFAULT 0,
    $colCartonsInspected INTEGER DEFAULT 0,
    $colCriticalDefectsAllowed INTEGER DEFAULT 0,
    $colMajorDefectsAllowed INTEGER DEFAULT 0,
    $colMinorDefectsAllowed INTEGER DEFAULT 0,
    $colCriticalDefect INTEGER DEFAULT 0,
    $colMajorDefect INTEGER DEFAULT 0,
    $colMinorDefect INTEGER DEFAULT 0,
    $colRecAddUser TEXT,
    $colRecAddDt TEXT,
    $colRecEnable INTEGER DEFAULT 1,
    $colRecDirty INTEGER DEFAULT 1,
    $colRecUser TEXT,
    $colRecDt TEXT,
    $colEdiDt TEXT,
    $colQRPOItemHdrID TEXT,
    $colPalletPackedQty INTEGER DEFAULT 0,
    $colMasterPackedQty INTEGER DEFAULT 0,
    $colInnerPackedQty INTEGER DEFAULT 0,
    $colPackedQty REAL,
    $colUnpackedQty REAL,
    $colUnfinishedQty REAL,
    $colShortStockQty REAL,
    $colCartonsPacked2 INTEGER DEFAULT 0,
    $colBaseMaterialID TEXT,
    $colBaseMaterial_AddOnInfo TEXT,
    $colPONO TEXT,
    $colBuyerPODt TEXT,
    $colOrderQty REAL,
    $colItemDescr TEXT,
    $colEarlierInspected REAL,
    $colPOMasterPackQty INTEGER DEFAULT 0,
    $colLR TEXT,
    $colMR TEXT,
    $colCustomerDepartment TEXT,
    $colCustomerItemRef TEXT,
    $colLatestDelDt TEXT,
    $colHologramNo TEXT,
    $colHologram_ExpiryDt TEXT,
    $colIDimn TEXT,
    $colWeight REAL,
    $colCBM REAL,
    $colIPDimn TEXT,
    $colIPWt REAL,
    $colIPCBM REAL,
    $colIPQty INTEGER DEFAULT 0,
    $colOPDescr TEXT,
    $colOPWt REAL,
    $colOPCBM REAL,
    $colOPQty INTEGER DEFAULT 0,
    $colPalletDimn TEXT,
    $colPalletWt REAL,
    $colPalletCBM REAL,
    $colPalletQty INTEGER DEFAULT 0,
    $colRetailPrice REAL,
    $colItemRepeat INTEGER DEFAULT 0,
    $colProductID TEXT,
    PRIMARY KEY($colPRowID)
  )
  ''';

  Future<void> insert(Map<String, dynamic> map) async {
    final db = await DatabaseHelper().database;
    await db.insert(
      TABLE_NAME,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await DatabaseHelper().database;
    return await db.query(TABLE_NAME);
  }

  Future<List<Map<String, dynamic>>> getByQRHdrID(String qrHdrId) async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$colQRHdrID = ?',
      whereArgs: [qrHdrId],
    );
  }

  Future<void> updateRecord(String rowID, Map<String, dynamic> values) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      values,
      where: '$colPRowID = ?',
      whereArgs: [rowID],
    );
  }
  Future<void> updateRecordByItemId(String rowID, Map<String, dynamic> values) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      values,
      where: '$colPRowID = ?',
      whereArgs: [rowID],
    );
  }

  Future<void> reSetRecord(String rowID, Map<String, dynamic> values) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      values,
      where: '$colQRHdrID = ?',
      whereArgs: [rowID],
    );
  }
  Future<int> deleteRecord(String rowID) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      TABLE_NAME,
      where: '$colPRowID = ?',
      whereArgs: [rowID],
    );
  }

  Future<int> deleteAll() async {
    final db = await DatabaseHelper().database;
    return await db.delete(TABLE_NAME);
  }

  Future<List<Map<String, dynamic>>> getEnabledRecords() async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$colRecEnable = ?',
      whereArgs: [1],
    );
  }


  Future<String?> getCustomerItemRefByPRowID(String pRowID) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      TABLE_NAME,
      columns: [colCustomerItemRef],
      where: '$colPRowID = ? AND $colRecEnable = ?',
      whereArgs: [pRowID, 1],
    );

    if (result.isNotEmpty) {
      return result.first[colCustomerItemRef] as String?;
    }
    return null;
  }

  Future<List<POItemDtl>> getByCustomerItemRefAndEnabled(String customerItemRef) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      TABLE_NAME,
      where: '$colCustomerItemRef = ? AND $colRecEnable = ?',
      whereArgs: [customerItemRef, 1],
    );

    return List.generate(maps.length, (i) {
      return POItemDtl.fromJson(maps[i]);
    });
  }

}
