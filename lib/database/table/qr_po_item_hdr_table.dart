import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class QRPOItemHdrTable {
  static const String TABLE_NAME = "QRPOItemHdr";

  static const String pRowID = "pRowID";
  static const String locID = "LocID";
  static const String qrHdrID = "QRHdrID";
  static const String itemID = "ItemID";
  static const String baseMaterialID = "BaseMaterialID";
  static const String baseMaterialAddOnInfo = "BaseMaterial_AddOnInfo";
  static const String colorID = "ColorID";
  static const String allowedInspectionQty = "AllowedInspectionQty";
  static const String inspectedQty = "InspectedQty";
  static const String shortStockQty = "ShortStockQty";
  static const String cartonsPacked = "CartonsPacked";
  static const String allowedCartonInspection = "AllowedCartonInspection";
  static const String cartonsInspected = "CartonsInspected";
  static const String defaultImageRowID = "DefaultImageRowID";
  static const String qtyRemark = "Qty_Remark";
  static const String pkgAppInspectionLevelID = "PKG_App_InspectionLevelID";
  static const String pkgAppInspectionResultID = "PKG_App_InspectionResultID";
  static const String pkgAppRemark = "PKG_App_Remark";
  static const String pkgAppPalletSampleSizeID = "PKG_App_Pallet_SampleSizeID";
  static const String pkgAppPalletSampleSizeValue =
      "PKG_App_Pallet_SampleSizeValue";
  static const String pkgAppPalletInspectionResultID =
      "PKG_App_Pallet_InspectionResultID";
  static const String pkgAppMasterSampleSizeID = "PKG_App_Master_SampleSizeID";
  static const String pkgAppMasterSampleSizeValue =
      "PKG_App_Master_SampleSizeValue";
  static const String pkgAppMasterInspectionResultID =
      "PKG_App_Master_InspectionResultID";
  static const String pkgAppInnerSampleSizeID = "PKG_App_Inner_SampleSizeID";
  static const String pkgAppInnerSampleSizeValue =
      "PKG_App_Inner_SampleSizeValue";
  static const String pkgAppUnitSampleSizeID = "PKG_App_Unit_SampleSizeID";
  static const String pkgAppUnitSampleSizeValue =
      "PKG_App_Unit_SampleSizeValue"; // Added the missing column
  static const String pkgAppUnitInspectionResultID =
      "PKG_App_Unit_InspectionResultID";
  static const String pkgAppShippingMarkSampleSizeID =
      "PKG_App_ShippingMark_SampleSizeID";
  static const String pkgAppShippingMarkSampleSizeValue =
      "PKG_App_ShippingMark_SampleSizeValue";
  static const String pkgAppShippingMarkInspectionResultID =
      "PKG_App_ShippingMark_InspectionResultID";
  static const String pkgAppInnerInspectionResultID =
      "PKG_App_Inner_InspectionResultID";

  // Missing columns from the API response

  static const String pkgMeInspectionLevelID = "PKG_Me_InspectionLevelID";
  static const String pkgMeInspectionResultID = "PKG_Me_InspectionResultID";
  static const String pkgMeRemark = "PKG_Me_Remark";
  static const String pkgMePalletSampleSizeID = "PKG_Me_Pallet_SampleSizeID";
  static const String pkgMePalletSampleSizeValue =
      "PKG_Me_Pallet_SampleSizeValue";
  static const String pkgMePalletFindingL = "PKG_Me_Pallet_FindingL";
  static const String pkgMePalletFindingB = "PKG_Me_Pallet_FindingB";
  static const String pkgMePalletFindingH = "PKG_Me_Pallet_FindingH";
  static const String pkgMePalletFindingWt = "PKG_Me_Pallet_FindingWt";
  static const String pkgMePalletFindingQty = "PKG_Me_Pallet_FindingQty";
  static const String pkgMePalletInspectionResultID =
      "PKG_Me_Pallet_InspectionResultID";
  static const String pkgMeMasterSampleSizeID = "PKG_Me_Master_SampleSizeID";
  static const String pkgMeMasterSampleSizeValue =
      "PKG_Me_Master_SampleSizeValue";
  static const String pkgMeMasterFindingL = "PKG_Me_Master_FindingL";
  static const String pkgMeMasterFindingB = "PKG_Me_Master_FindingB";
  static const String pkgMeMasterFindingH = "PKG_Me_Master_FindingH";
  static const String pkgMeMasterFindingWt = "PKG_Me_Master_FindingWt";
  static const String pkgMeMasterFindingQty = "PKG_Me_Master_FindingQty";
  static const String pkgMeMasterInspectionResultID =
      "PKG_Me_Master_InspectionResultID";
  static const String pkgMeInnerSampleSizeID = "PKG_Me_Inner_SampleSizeID";
  static const String pkgMeInnerSampleSizeValue =
      "PKG_Me_Inner_SampleSizeValue";
  static const String pkgMeInnerFindingL = "PKG_Me_Inner_FindingL";
  static const String pkgMeInnerFindingB = "PKG_Me_Inner_FindingB";
  static const String pkgMeInnerFindingH = "PKG_Me_Inner_FindingH";
  static const String pkgMeInnerFindingWt = "PKG_Me_Inner_FindingWt";
  static const String pkgMeInnerFindingQty = "PKG_Me_Inner_FindingQty";
  static const String pkgMeInnerInspectionResultID =
      "PKG_Me_Inner_InspectionResultID";
  static const String pkgMeUnitSampleSizeID = "PKG_Me_Unit_SampleSizeID";
  static const String pkgMeUnitSampleSizeValue = "PKG_Me_Unit_SampleSizeValue";
  static const String pkgMeUnitFindingL = "PKG_Me_Unit_FindingL";
  static const String pkgMeUnitFindingB = "PKG_Me_Unit_FindingB";
  static const String pkgMeUnitFindingH = "PKG_Me_Unit_FindingH";
  static const String pkgMeUnitFindingWt = "PKG_Me_Unit_FindingWt";
  static const String pkgMeUnitInspectionResultID =
      "PKG_Me_Unit_InspectionResultID";
  static const String pkgMePalletFindingCBM = "PKG_Me_Pallet_FindingCBM";
  static const String pkgMePalletDigitals = "PKG_Me_Pallet_Digitals";
  static const String pkgMeMasterDigitals = "PKG_Me_Master_Digitals";
  static const String pkgMeInnerDigitals = "PKG_Me_Inner_Digitals";
  static const String pkgMeUnitDigitals = "PKG_Me_Unit_Digitals";
  static const String pkgMeMasterFindingCBM = "PKG_Me_Master_FindingCBM";
  static const String pkgMeInnerFindingCBM = "PKG_Me_Inner_FindingCBM";
  static const String pkgMeUnitFindingCBM = "PKG_Me_Unit_FindingCBM";

  static const String barcodeInspectionLevelID = "Barcode_InspectionLevelID";
  static const String barcodeInspectionResultID = "Barcode_InspectionResultID";
  static const String barcodeRemark = "Barcode_Remark";
  static const String barcodePalletSampleSizeID = "Barcode_Pallet_SampleSizeID";
  static const String barcodePalletSampleSizeValue =
      "Barcode_Pallet_SampleSizeValue";
  static const String barcodePalletVisual = "Barcode_Pallet_Visual";
  static const String barcodePalletScan = "Barcode_Pallet_Scan";
  static const String barcodePalletInspectionResultID =
      "Barcode_Pallet_InspectionResultID";
  static const String barcodeMasterSampleSizeID = "Barcode_Master_SampleSizeID";
  static const String barcodeMasterSampleSizeValue =
      "Barcode_Master_SampleSizeValue";
  static const String barcodeMasterVisual = "Barcode_Master_Visual";
  static const String barcodeMasterScan = "Barcode_Master_Scan";
  static const String barcodeMasterInspectionResultID =
      "Barcode_Master_InspectionResultID";
  static const String barcodeInnerSampleSizeID = "Barcode_Inner_SampleSizeID";
  static const String barcodeInnerSampleSizeValue =
      "Barcode_Inner_SampleSizeValue";
  static const String barcodeInnerVisual = "Barcode_Inner_Visual";
  static const String barcodeInnerScan = "Barcode_Inner_Scan";
  static const String barcodeInnerInspectionResultID =
      "Barcode_Inner_InspectionResultID";
  static const String barcodeUnitSampleSizeID = "Barcode_Unit_SampleSizeID";
  static const String barcodeUnitSampleSizeValue =
      "Barcode_Unit_SampleSizeValue";
  static const String barcodeUnitVisual = "Barcode_Unit_Visual";
  static const String barcodeUnitScan = "Barcode_Unit_Scan";
  static const String barcodeUnitInspectionResultID =
      "Barcode_Unit_InspectionResultID";

  static const String onsiteTestInspectionResultID =
      "OnSiteTest_InspectionResultID";
  static const String onsiteTestRemark = "OnSiteTest_Remark";
  static const String onsiteTestIsApplicable = "OnSiteTest_IsApplicable";

  static const String workmanShipQRInspectionLevel =
      "WorkmanShip_QRInspectionLevel";
  static const String workmanShipSampleSizeID = "WorkmanShip_SampleSizeID";
  static const String workmanShipQLMajor = "WorkmanShip_QLMajor";
  static const String workmanShipQLMinor = "WorkmanShip_QLMinor";
  static const String workmanShipInspectionResultID =
      "WorkmanShip_InspectionResultID";
  static const String workmanShipRemark = "WorkmanShip_Remark";

  static const String overallInspectionResultID = "Overall_InspectionResultID";

  static const String recDirty = "recDirty";
  static const String recEnable = "recEnable";
  static const String recAddDt = "recAddDt";
  static const String recDt = "recDt";
  static const String recUser = "recUser";

  static const String sampleCodeID = "SampleCodeID";
  static const String itemMeasurementInspectionResultID =
      "ItemMeasurement_InspectionResultID";
  static const String itemMeasurementRemark = "ItemMeasurement_Remark";
  static const String productSpecificationInspectionResultID =
      "ProductSpecification_InspectionResultID";
  static const String productSpecificationRemark =
      "ProductSpecification_Remark";

  static const String fabricInspectionInspectionResultID =
      "FabricInspection_InspectionResultID";
  static const String fabricInspectionRemark = "FabricInspection_Remark";
  static const String fabricInspectionInHouseQty = "FabricInspectionInHouseQty";
  static const String fabricInspectionDt = "FabricInspectionDt";

  static const String testReportStatus = "TestReportStatus";
  static const String baseMatDescr = "BaseMatDescr";
  static const String hologramNo = "HologramNo";

  static const String criticalDefectsAllowed = "CriticalDefectsAllowed";
  static const String majorDefectsAllowed = "MajorDefectsAllowed";
  static const String minorDefectsAllowed = "MinorDefectsAllowed";
  static const String criticalDefect = "CriticalDefect";
  static const String majorDefect = "MajorDefect";
  static const String minorDefect = "MinorDefect";
  static const String criticalDefectPieces = "CriticalDefectPieces";
  static const String majorDefectPieces = "MajorDefectPieces";
  static const String minorDefectPieces = "MinorDefectPieces";

  static const String CREATE = '''
CREATE TABLE IF NOT EXISTS $TABLE_NAME (
  $pRowID TEXT PRIMARY KEY,
  $locID TEXT DEFAULT '',
  $qrHdrID TEXT DEFAULT '',
  $itemID TEXT DEFAULT '',
  $baseMaterialID TEXT DEFAULT '',
  $baseMaterialAddOnInfo VARCHAR,
  $colorID TEXT DEFAULT '',
  $allowedInspectionQty REAL DEFAULT 0,
  $inspectedQty REAL DEFAULT 0,
  $shortStockQty REAL DEFAULT 0,
  $cartonsPacked INTEGER DEFAULT 0,
  $allowedCartonInspection INTEGER DEFAULT 0,
  $cartonsInspected INTEGER DEFAULT 0,
  $defaultImageRowID TEXT DEFAULT '',
  $qtyRemark VARCHAR,
  $pkgAppInspectionLevelID TEXT DEFAULT '',
  $pkgAppInspectionResultID TEXT DEFAULT '',
  $pkgAppRemark VARCHAR,
  $pkgAppPalletSampleSizeID TEXT DEFAULT '',
  $pkgAppPalletSampleSizeValue INTEGER,
  $pkgAppPalletInspectionResultID TEXT DEFAULT '',
  $pkgAppMasterSampleSizeID TEXT DEFAULT '',
  $pkgAppMasterSampleSizeValue INTEGER,
  $pkgAppMasterInspectionResultID TEXT DEFAULT '',
  $pkgAppInnerSampleSizeID TEXT DEFAULT '',
  $pkgAppInnerSampleSizeValue INTEGER,
  $pkgAppUnitSampleSizeID TEXT DEFAULT '',
  $pkgAppUnitSampleSizeValue INTEGER,
  $pkgAppUnitInspectionResultID TEXT DEFAULT '',
  $pkgAppShippingMarkSampleSizeID TEXT DEFAULT '',
  $pkgAppShippingMarkSampleSizeValue INTEGER,
  $pkgAppShippingMarkInspectionResultID TEXT DEFAULT '',
  $pkgAppInnerInspectionResultID TEXT DEFAULT '',

 
  $pkgMeInspectionLevelID TEXT DEFAULT '',
  $pkgMeInspectionResultID TEXT DEFAULT '',
  $pkgMeRemark VARCHAR,
  $pkgMePalletSampleSizeID TEXT DEFAULT '',
  $pkgMePalletSampleSizeValue INTEGER,
  $pkgMePalletFindingL REAL DEFAULT 0,
  $pkgMePalletFindingB REAL DEFAULT 0,
  $pkgMePalletFindingH REAL DEFAULT 0,
  $pkgMePalletFindingWt REAL DEFAULT 0,
  $pkgMePalletFindingQty REAL DEFAULT 0,
  $pkgMePalletInspectionResultID TEXT DEFAULT '',
  $pkgMeMasterSampleSizeID TEXT DEFAULT '',
  $pkgMeMasterSampleSizeValue INTEGER,
  $pkgMeMasterFindingL REAL DEFAULT 0,
  $pkgMeMasterFindingB REAL DEFAULT 0,
  $pkgMeMasterFindingH REAL DEFAULT 0,
  $pkgMeMasterFindingWt REAL DEFAULT 0,
  $pkgMeMasterFindingQty REAL DEFAULT 0,
  $pkgMeMasterInspectionResultID TEXT DEFAULT '',
  $pkgMeInnerSampleSizeID TEXT DEFAULT '',
  $pkgMeInnerSampleSizeValue INTEGER,
  $pkgMeInnerFindingL REAL DEFAULT 0,
  $pkgMeInnerFindingB REAL DEFAULT 0,
  $pkgMeInnerFindingH REAL DEFAULT 0,
  $pkgMeInnerFindingWt REAL DEFAULT 0,
  $pkgMeInnerFindingQty REAL DEFAULT 0,
  $pkgMeInnerInspectionResultID TEXT DEFAULT '',
  $pkgMeUnitSampleSizeID TEXT DEFAULT '',
  $pkgMeUnitSampleSizeValue INTEGER,
  $pkgMeUnitFindingL REAL DEFAULT 0,
  $pkgMeUnitFindingB REAL DEFAULT 0,
  $pkgMeUnitFindingH REAL DEFAULT 0,
  $pkgMeUnitFindingWt REAL DEFAULT 0,
  $pkgMeUnitInspectionResultID TEXT DEFAULT '',
  $pkgMeMasterDigitals TEXT DEFAULT '',
  $pkgMePalletDigitals TEXT DEFAULT '',
  $pkgMeUnitDigitals TEXT DEFAULT '',
  $pkgMeInnerDigitals TEXT DEFAULT '',
  $pkgMePalletFindingCBM REAL DEFAULT 0,
  $pkgMeMasterFindingCBM REAL DEFAULT 0,
  $pkgMeInnerFindingCBM REAL DEFAULT 0,
  $pkgMeUnitFindingCBM REAL DEFAULT 0,

  $barcodeInspectionLevelID TEXT DEFAULT '',
  $barcodeInspectionResultID TEXT DEFAULT '',
  $barcodeRemark VARCHAR,
  $barcodePalletSampleSizeID TEXT DEFAULT '',
  $barcodePalletSampleSizeValue INTEGER,
  $barcodePalletVisual TEXT DEFAULT '',
  $barcodePalletScan TEXT DEFAULT '',
  $barcodePalletInspectionResultID TEXT DEFAULT '',
  $barcodeMasterSampleSizeID TEXT DEFAULT '',
  $barcodeMasterSampleSizeValue INTEGER,
  $barcodeMasterVisual TEXT DEFAULT '',
  $barcodeMasterScan TEXT DEFAULT '',
  $barcodeMasterInspectionResultID TEXT DEFAULT '',
  $barcodeInnerSampleSizeID TEXT DEFAULT '',
  $barcodeInnerSampleSizeValue INTEGER,
  $barcodeInnerVisual TEXT DEFAULT '',
  $barcodeInnerScan TEXT DEFAULT '',
  $barcodeInnerInspectionResultID TEXT DEFAULT '',
  $barcodeUnitSampleSizeID TEXT DEFAULT '',
  $barcodeUnitSampleSizeValue INTEGER,
  $barcodeUnitVisual TEXT DEFAULT '',
  $barcodeUnitScan TEXT DEFAULT '',
  $barcodeUnitInspectionResultID TEXT DEFAULT '',

  $onsiteTestInspectionResultID TEXT DEFAULT '',
  $onsiteTestRemark TEXT DEFAULT '',
  $onsiteTestIsApplicable INTEGER DEFAULT 0,

  $workmanShipQRInspectionLevel TEXT DEFAULT '',
  $workmanShipSampleSizeID TEXT DEFAULT '',
  $workmanShipQLMajor INTEGER DEFAULT 0,
  $workmanShipQLMinor INTEGER DEFAULT 0,
  $workmanShipInspectionResultID TEXT DEFAULT '',
  $workmanShipRemark TEXT DEFAULT '',

  $overallInspectionResultID TEXT DEFAULT '',

  $recDirty INTEGER DEFAULT 0,
  $recEnable INTEGER DEFAULT 0,
  $recAddDt TEXT DEFAULT '',
  $recDt TEXT DEFAULT '',
  $recUser TEXT DEFAULT '',

  $sampleCodeID TEXT DEFAULT '',
  $itemMeasurementInspectionResultID TEXT DEFAULT '',
  $itemMeasurementRemark TEXT DEFAULT '',
  $productSpecificationInspectionResultID TEXT DEFAULT '',
  $productSpecificationRemark TEXT DEFAULT '',

  $fabricInspectionInspectionResultID TEXT DEFAULT '',
  $fabricInspectionRemark TEXT DEFAULT '',
  $fabricInspectionInHouseQty REAL DEFAULT 0,
  $fabricInspectionDt TEXT DEFAULT '',

  $testReportStatus INTEGER DEFAULT 0,
  $baseMatDescr TEXT DEFAULT '',
  $hologramNo TEXT DEFAULT '',

  $criticalDefectsAllowed INTEGER DEFAULT 0,
  $majorDefectsAllowed INTEGER DEFAULT 0,
  $minorDefectsAllowed INTEGER DEFAULT 0,
  $criticalDefect INTEGER DEFAULT 0,
  $majorDefect INTEGER DEFAULT 0,
  $minorDefect INTEGER DEFAULT 0,
  $criticalDefectPieces INTEGER DEFAULT 0,
  $majorDefectPieces INTEGER DEFAULT 0,
  $minorDefectPieces INTEGER DEFAULT 0
)
''';

  // Insert a record
  Future<void> insert(Map<String, dynamic> map) async {
    final db = await DatabaseHelper().database;
    await db.insert(
      TABLE_NAME,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all records
  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await DatabaseHelper().database;
    return await db.query(TABLE_NAME);
  }

  // Delete all records
  Future<int> deleteAll() async {
    final db = await DatabaseHelper().database;
    return await db.delete(TABLE_NAME);
  }

  // Get by pRowID
  Future<List<Map<String, dynamic>>> getByPRowID(String id) async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$pRowID = ?',
      whereArgs: [id],
    );
  }

  // Update a record by pRowID
  Future<void> updateRecord(String rowID, Map<String, dynamic> values) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      values,
      where: '$pRowID = ?',
      whereArgs: [rowID],
    );
  }


  Future<void> updateRecordByItemId(String rowID, Map<String, dynamic> values) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      values,
      where: '$pRowID = ?',
      whereArgs: [rowID],
    );
  }
  // Delete a record by pRowID
  Future<int> deleteRecord(String rowID) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      TABLE_NAME,
      where: '$pRowID = ?',
      whereArgs: [rowID],
    );
  }

  Future<List<Map<String, dynamic>>> getByItemID(String itemID) async {
    final db = await DatabaseHelper().database;
    return await db.rawQuery('''
    SELECT $overallInspectionResultID, * 
    FROM $TABLE_NAME 
    WHERE $itemID = ?
  ''', [itemID]);
  }
// Update Overall_InspectionResultID by ItemID
  Future<void> updateOverallInspectionResultByItemID(
      String itemIDValue, String newValue) async {
    final db = await DatabaseHelper().database;
    await db.rawUpdate(
      '''
    UPDATE $TABLE_NAME
    SET $overallInspectionResultID = ?
    WHERE $itemID = ?
    ''',
      [newValue, itemIDValue],
    );
  }




}
