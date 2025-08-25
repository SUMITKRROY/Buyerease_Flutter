import 'dart:developer' as developer;

import 'package:buyerease/config/api_route.dart';
import 'package:buyerease/model/digitals_upload_model.dart';
import 'package:buyerease/utils/fsl_log.dart';
import 'package:flutter/cupertino.dart';


import '../../database/database_helper.dart';
import '../../database/table/qr_po_item_dtl_image_table.dart';
import '../../database/table/user_master_table.dart';
import '../../model/IntimationModal.dart';
import '../../model/enclosure_modal.dart';
import '../../model/inspection_model.dart';
import '../../model/item_measurement_modal.dart';
import '../../model/po_item_dtl_model.dart';
import '../../model/quality_parameter_model.dart';
import '../../model/workmanship_model.dart';
import '../../utils/FClientConfig.dart';
import '../../utils/app_constants.dart';
import '../../utils/gen_utils.dart';

import '../get_data_handler.dart';
import '../inspection_list/InspectionListHandler.dart';

class ItemInspectionDetailHandler {
  static const String _tag = 'ItemInspectionDetailHandler';

  Future<String?> updateImage({
    required String qrHdrID,
    required String qrPOItemHdrID,
    required DigitalsUploadModel digitalsUploadModal,
  }) async {
    final db = await DatabaseHelper().database;
    String? userId = await UserMasterTable().getFirstUserID();
    // Prepare data to update/insert
    Map<String, dynamic> contentValues = {
      'Title': digitalsUploadModal.title,
      'ImageName': 'ImName${FClientConfig.locID}',
      'ImageExtn': digitalsUploadModal.imageExtn,
      'ImageSymbol': ' ',
      'ImageSqn': 1,
      'fileContent': digitalsUploadModal.fileContent,
      'ImagePathID': digitalsUploadModal.selectedPicPath,
      'recEnable': 1,
      'recUser': userId,
      'recAddDt': AppConfig.getCurrentDate(),
      'recDt': AppConfig.getCurrentDate(),
    };

    int rowsUpdated = await db.update(
      'QRPOItemDtl_Image',
      contentValues,
      where: 'pRowID = ?',
      whereArgs: [digitalsUploadModal.pRowID],
    );

    if (rowsUpdated == 0) {
      // If not updated, insert new row
      contentValues.addAll({
        'pRowID': digitalsUploadModal.pRowID,
        'LocID': FClientConfig.locID,
        'QRHdrID': qrHdrID,
        'QRPOItemHdrID': qrPOItemHdrID,
      });

      await db.insert('QRPOItemDtl_Image', contentValues);
      print("Inserted new QRPOItemDtl_Image row.");
      return digitalsUploadModal.pRowID;
    } else {
      print("Updated existing QRPOItemDtl_Image row.");
      return null;
    }
  }

  Future<String?> updateImageFromQualityParameter({
    required String qrHdrID,
    required String qrPOItemHdrID,
    required String itemID,
    required DigitalsUploadModel digitalsUploadModal,
  }) async {
    final db = await DatabaseHelper().database;
    String? userId = await UserMasterTable().getFirstUserID();
    // Prepare data for update or insert
    Map<String, dynamic> contentValues = {
      'Title': digitalsUploadModal.title,
      'ImageName': 'ImName${FClientConfig.locID}',
      'ImageExtn': digitalsUploadModal.imageExtn,
      'ImageSymbol': ' ',
      'ImageSqn': 1,
      'fileContent': digitalsUploadModal.selectedPicPath,
      'recEnable': 1,
      'recUser': userId,
      'recAddDt': AppConfig.getCurrentDate(),
      'recDt': AppConfig.getCurrentDate(),
    };

    int rowsUpdated = await db.update(
      'QRPOItemDtl_Image',
      contentValues,
      where: 'pRowID = ?',
      whereArgs: [digitalsUploadModal.pRowID],
    );

    if (rowsUpdated == 0) {
      contentValues.addAll({
        'pRowID': digitalsUploadModal.pRowID,
        'LocID': FClientConfig.locID,
        'QRHdrID': qrHdrID,
        'QRPOItemHdrID': qrPOItemHdrID,
        'ItemID': itemID,
      });

      await db.insert('QRPOItemDtl_Image', contentValues);
      print("Inserted new QRPOItemDtl_Image row from quality parameter.");
      return digitalsUploadModal.pRowID;
    } else {
      print("Updated existing QRPOItemDtl_Image row from quality parameter.");
      return null;
    }
  }

  Future<void> updateImageToSync(String pRowID) async {
    final db = await DatabaseHelper().database;

    Map<String, dynamic> contentValues = {
      'FileSent': 1,
    };

    print("Set content images $contentValues");

    int rowsUpdated = await db.update(
      'QRPOItemDtl_Image',
      contentValues,
      where: 'pRowID = ?',
      whereArgs: [pRowID],
    );

    if (rowsUpdated > 0) {
      print("Updated QRPOItemDtl_Image after sync for pRowID: $pRowID");
    }
  }

  Future<void> updateImageTitle(String title, String pRowID) async {
    final db = await DatabaseHelper().database;

    Map<String, dynamic> contentValues = {
      'Title': title,
    };

    print("Set content images: $contentValues");

    int rowsUpdated = await db.update(
      'QRPOItemDtl_Image',
      contentValues,
      where: 'pRowID = ?',
      whereArgs: [pRowID],
    );

    if (rowsUpdated > 0) {
      print("Updated title in QRPOItemDtl_Image for pRowID: $pRowID");
    }
  }

  static Future<List<int>> isImportant({
    required String qrHdrId,
    required String? qrPoItemHdrId,
  }) async {
    List<int> importantList = [];

    try {
      // Check and alter table for IsImportant column
      if (!await GenUtils.columnExistsInTable(
        table: 'Enclosures',
        columnToCheck: 'IsImportant',
      )) {
        FslLog.e(_tag,
            'Column IsImportant not found in Enclosures table, altering table');
        await GetDataHandler.handleToAlterAsIn('Enclosures', 'IsImportant');
      }

      // Check and alter table for IsRead column
      if (!await GenUtils.columnExistsInTable(
          table: 'Enclosures', columnToCheck: 'IsRead')) {
        FslLog.e(_tag,
            'Column IsRead not found in Enclosures table, altering table');
        await GetDataHandler.handleToAlterAsIn('Enclosures', 'IsRead');
      }

      final dbHelper = DatabaseHelper();
      final database = await dbHelper.database;

      String query;
      if (qrPoItemHdrId != null && qrPoItemHdrId.toLowerCase() != 'null') {
        query = '''
          SELECT DISTINCT IsImportant 
          FROM Enclosures 
          WHERE (IFNULL(QRPOItemHdrId, '') = ? OR IFNULL(QRPOItemHdrId, '') = '') 
          AND QRHdrID = ? 
          AND IsRead = 0
        ''';
      } else {
        query = '''
          SELECT DISTINCT IsImportant 
          FROM Enclosures 
          WHERE QRHdrID = ? 
          AND IsRead = 0
        ''';
      }

      FslLog.d(_tag, 'Executing query: $query');

      final cursor = await database.rawQuery(
        query,
        qrPoItemHdrId != null && qrPoItemHdrId.toLowerCase() != 'null'
            ? [qrPoItemHdrId, qrHdrId]
            : [qrHdrId],
      );

      for (var row in cursor) {
        importantList.add(row['IsImportant'] as int);
      }

      // No need to close database in sqflite, managed by DatabaseHelper
    } catch (e, stackTrace) {
      FslLog.e(_tag, 'Error executing isImportant: $e', stackTrace);
    }

    return importantList;
  }

  static Future<void> updateImageToMakeAgainNotSync(String qrHdrID) async {
    try {
      final db = await DatabaseHelper().database;
      final contentValues = {
        QrPoItemDtlImageTable.fileSent: 0,
      };
      await db.update(
        QrPoItemDtlImageTable.TABLE_NAME,
        contentValues,
        where: '${QrPoItemDtlImageTable.qrHdrID} = ?',
        whereArgs: [qrHdrID],
      );
      print('Updated QRPOItemDtl_Image FileSent=0 for QRHdrID: $qrHdrID');
    } catch (e) {
      print('Error updating QRPOItemDtl_Image to make again not sync: $e');
      rethrow;
    }
  }

  Future<void> updateQREnClosureToSync(String pRowID) async {
    final db = await DatabaseHelper().database;

    Map<String, dynamic> contentValues = {
      'FileSent': 1,
    };

    print("Set content QREnclosure: $contentValues");

    int rowsUpdated = await db.update(
      'QREnclosure',
      contentValues,
      where: 'pRowID = ?',
      whereArgs: [pRowID],
    );

    if (rowsUpdated > 0) {
      print("Updated QREnclosure for pRowID: $pRowID");
    }
  }

  Future<List<POItemDtl>> getPackagingMeasurementList(
      String QRHDrID, String QRPOItemHdrID) async
  {
    List<POItemDtl> itemArrayList = [];
    final db = await DatabaseHelper().database;
    try {
      String query = '''
    SELECT dtl.pRowID, dtl.QRPOItemHdrID, hdr.PKG_Me_Pallet_Digitals, 
    hdr.PKG_Me_Master_Digitals, hdr.PKG_Me_Inner_Digitals, hdr.PKG_Me_Unit_Digitals, 
    IFNULL(OPDescr,'') AS OPDescr, IFNULL(OPWt,0) AS OPWt, IFNULL(OPCBM,0) AS OPCBM, IFNULL(OPQty,0) AS OPQty, 
    IFNULL(IPDimn,'') AS IPDimn, IFNULL(IPWt,0) AS IPWt, IFNULL(IPCBM,0) AS IPCBM, IFNULL(IPQty,0) AS IPQty, 
    IFNULL(PalletDimn,'') AS PalletDimn, IFNULL(PalletWt,0) AS PalletWt, IFNULL(PalletCBM,0) AS PalletCBM, IFNULL(PalletQty,0) AS PalletQty, 
    IFNULL(IDimn,'') AS IDimn, IFNULL(Weight,0) AS Weight, IFNULL(CBM,0) AS CBM
    FROM QRPOItemDtl dtl
    INNER JOIN QRPOItemHdr hdr ON hdr.pRowID = dtl.QRPOItemHdrID
    WHERE dtl.QRHDrID = ? AND dtl.QRPOItemHdrID = ? AND dtl.recEnable = 1
    ''';

      final List<Map<String, dynamic>> result =
          await db.rawQuery(query, [QRHDrID, QRPOItemHdrID]);
developer.log("finding result getPackagingMeasurementList: $query");
developer.log("finding result getPackagingMeasurementList: $result");
      for (final row in result) {
        final poItemDtl = POItemDtl();

        poItemDtl.pRowID = row['pRowID'];
        poItemDtl.qrpoItemHdrID = row['QRPOItemHdrID'];
        poItemDtl.opDescr = row['OPDescr'];

        if (poItemDtl.opDescr != null &&
            poItemDtl.opDescr != "null" &&
            poItemDtl.
            opDescr!.contains("x")) {
          final spStr = poItemDtl.opDescr!.split("x");
          if (spStr.length >= 4) {
            poItemDtl.mapCountMaster = int.tryParse(spStr[0]);
            poItemDtl.opL = double.tryParse(spStr[1]);
            poItemDtl.opW = double.tryParse(spStr[2]);
            poItemDtl.opH = double.tryParse(spStr[3]);
          }
        }

        poItemDtl.opWt = row['OPWt']?.toDouble();
        poItemDtl.opCBM = row['OPCBM']?.toDouble();
        poItemDtl.opQty = row['OPQty'];

        poItemDtl.ipDimn = row['IPDimn'];
        if (poItemDtl.ipDimn != null &&
            poItemDtl.ipDimn != "null" &&
            poItemDtl.ipDimn!.contains("x")) {
          final spStr = poItemDtl.ipDimn!.split("x");
          if (spStr.length >= 4) {
            poItemDtl.mapCountInner = int.tryParse(spStr[0]);
            poItemDtl.ipL = double.tryParse(spStr[1]);
            poItemDtl.ipW = double.tryParse(spStr[2]);
            poItemDtl.ipH = double.tryParse(spStr[3]);
          }
        }

        poItemDtl.ipWt = row['IPWt']?.toDouble();
        poItemDtl.ipCBM = row['IPCBM']?.toDouble();
        poItemDtl.ipQty = row['IPQty'];

        poItemDtl.palletDimn = row['palletDimn'];
        if (poItemDtl.palletDimn != null &&
            poItemDtl.palletDimn != "null" &&
            poItemDtl.palletDimn!.contains("x")) {
          final spStr = poItemDtl.palletDimn!.split("x");
          if (spStr.length >= 4) {
            poItemDtl.mapCountPallet = int.tryParse(spStr[0]);
            poItemDtl.palletL = double.tryParse(spStr[1]);
            poItemDtl.palletW = double.tryParse(spStr[2]);
            poItemDtl.palletH = double.tryParse(spStr[3]);
          }
        }

        poItemDtl.palletWt = row['PalletWt'];
        poItemDtl.palletCBM = row['PalletCBM'];
        poItemDtl.palletQty = row['PalletQty'];

        poItemDtl.iDimn = row['IDimn'];
        if (poItemDtl.iDimn != null &&
            poItemDtl.iDimn != "null" &&
            poItemDtl.iDimn!.contains("x")) {
          final spStr = poItemDtl.iDimn!.split("x");
          if (spStr.length >= 4) {
            poItemDtl.mapCountUnit = int.tryParse(spStr[0]);
            poItemDtl.unitL = double.tryParse(spStr[1]);
            poItemDtl.unitW = double.tryParse(spStr[2]);
            poItemDtl.unitH = double.tryParse(spStr[3]);
          }
        }

        poItemDtl.weight = (row['Weight'] as num?)?.toInt();

        poItemDtl.cbm = row['CBM']?.toDouble();

        poItemDtl.pkgMePalletDigitals = row['PKG_Me_Pallet_Digitals'];
        poItemDtl.pkgMeMasterDigitals = row['PKG_Me_Master_Digitals'];
        poItemDtl.pkgMeInnerDigitals = row['PKG_Me_Inner_Digitals'];
        poItemDtl.pkgMeUnitDigitals = row['PKG_Me_Unit_Digitals'];

        itemArrayList.add(poItemDtl);
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    return itemArrayList;
  }
/*  Future<List<POItemDtl>> getPackagingFindingMeasurementList(
      {required String itemId, required String qrpoItemHdrID}) async
  {
    final db = await DatabaseHelper().database;
    List<POItemDtl> itemList = [];

    try {
      String query = '''
      SELECT * FROM QRPOItemHdr 
      WHERE pRowID = ? AND ItemID = ?
    ''';

      List<Map<String, dynamic>> results = await db.rawQuery(query, [qrpoItemHdrID, itemId]);
developer.log("resul: $results");
      for (var row in results) {
        POItemDtl item = POItemDtl(
          pRowID: row['pRowID'],
          pkgMeInspectionResultID: row['PKG_Me_InspectionResultID'],
          pkgMeMasterInspectionResultID: row['PKG_Me_Master_InspectionResultID'],
          pkgMePalletInspectionResultID: row['PKG_Me_Pallet_InspectionResultID'],
          pkgMeUnitInspectionResultID: row['PKG_Me_Unit_InspectionResultID'],
          pkgMeInnerInspectionResultID: row['PKG_Me_Inner_InspectionResultID'],
          pkgAppShippingMarkInspectionResultID: row['PKG_App_ShippingMark_InspectionResultID'],
          pkgAppRemark: row['PKG_App_Remark'],
          pkgAppInspectionResultID: row['PKG_App_InspectionResultID'],
          pkgAppInspectionLevelID: row['PKG_App_InspectionLevelID'],
          pkgAppPalletInspectionResultID: row['PKG_App_Pallet_InspectionResultID'],
          pkgAppPalletSampleSizeID: row['PKG_App_Pallet_SampleSizeID'],
          pkgAppPalletSampleSizeValue: row['PKG_App_Pallet_SampleSizeValue'],
          pkgAppMasterSampleSizeID: row['PKG_App_Master_SampleSizeID'],
          pkgAppMasterSampleSizeValue: row['PKG_App_Master_SampleSizeValue'],
          pkgAppMasterInspectionResultID: row['PKG_App_Master_InspectionResultID'],
          pkgAppInnerSampleSizeID: row['PKG_App_Inner_SampleSizeID'],
          pkgAppInnerSampleSizeValue: row['PKG_App_Inner_SampleSizeValue'],
          pkgAppUnitSampleSizeID: row['PKG_App_Unit_SampleSizeID'],
          pkgAppUnitInspectionResultID: row['PKG_App_Unit_InspectionResultID'],
          onSiteTestRemark: row['OnSiteTest_Remark'],
          qtyRemark: row['Qty_Remark'],
          onSiteTestInspectionResult: row['OnSiteTest_InspectionResultID'],
          barcodeInspectionLevelID: row['Barcode_InspectionLevelID'],
          barcodeInspectionResultID: row['Barcode_InspectionResultID'],
          barcodeRemark: row['Barcode_Remark'],
          barcodePalletSampleSizeID: row['Barcode_Pallet_SampleSizeID'],
          barcodePalletSampleSizeValue: row['Barcode_Pallet_SampleSizeValue'],
          barcodePalletVisual: row['Barcode_Pallet_Visual'],
          barcodePalletScan: row['Barcode_Pallet_Scan'],
          barcodePalletInspectionResultID: row['Barcode_Pallet_InspectionResultID'],
          barcodeMasterSampleSizeID: row['Barcode_Master_SampleSizeID'],
          barcodeMasterSampleSizeValue: row['Barcode_Master_SampleSizeValue'],
          barcodeMasterVisual: row['Barcode_Master_Visual'],
          barcodeMasterScan: row['Barcode_Master_Scan'],
          barcodeInnerSampleSizeID: row['Barcode_Inner_SampleSizeID'],
          barcodeMasterInspectionResultID: row['Barcode_Master_InspectionResultID'],
          barcodeInnerSampleSizeValue: row['Barcode_Inner_SampleSizeValue'],
          barcodeInnerVisual: row['Barcode_Inner_Visual'],
          barcodeInnerScan: row['Barcode_Inner_Scan'],
          barcodeInnerInspectionResultID: row['Barcode_Inner_InspectionResultID'],
          barcodeUnitSampleSizeID: row['Barcode_Unit_SampleSizeID'],
          barcodeUnitSampleSizeValue: row['Barcode_Unit_SampleSizeValue'],
          barcodeUnitVisual: row['Barcode_Unit_Visual'],
          barcodeUnitScan: row['Barcode_Unit_Scan'],
          barcodeUnitInspectionResultID: row['Barcode_Unit_InspectionResultID'],
          pkgMeRemark: row['PKG_Me_Remark'],
          overallInspectionResultID: row['Overall_InspectionResultID'],
          workmanshipInspectionResultID: row['WorkmanShip_InspectionResultID'],
          workmanshipRemark: row['WorkmanShip_Remark'],
          itemMeasurementInspectionResultID: row['ItemMeasurement_InspectionResultID'],
          itemMeasurementRemark: row['ItemMeasurement_Remark'],
          pkgMePalletFindingL: row['PKG_Me_Pallet_FindingL'],
          pkgMePalletFindingB: row['PKG_Me_Pallet_FindingB'],
          pkgMePalletFindingH: row['PKG_Me_Pallet_FindingH'],
          pkgMePalletFindingWt: row['PKG_Me_Pallet_FindingWt'],
          pkgMePalletFindingCBM: row['PKG_Me_Pallet_FindingCBM'],
          pkgMePalletFindingQty: row['PKG_Me_Pallet_FindingQty'],
          pkgMeMasterFindingL: row['PKG_Me_Master_FindingL'],
          pkgMeMasterFindingB: row['PKG_Me_Master_FindingB'],
          pkgMeMasterFindingH: row['PKG_Me_Master_FindingH'],
          pkgMeMasterFindingWt: row['PKG_Me_Master_FindingWt'],
          pkgMeMasterFindingCBM: row['PKG_Me_Master_FindingCBM'],
          pkgMeMasterFindingQty: row['PKG_Me_Master_FindingQty'],
          pkgMeInnerFindingL: row['PKG_Me_Inner_FindingL'],
          pkgMeInnerFindingB: row['PKG_Me_Inner_FindingB'],
          pkgMeInnerFindingH: row['PKG_Me_Inner_FindingH'],
          pkgMeInnerFindingWt: row['PKG_Me_Inner_FindingWt'],
          pkgMeInnerFindingCBM: row['PKG_Me_Inner_FindingCBM'],
          pkgMeInnerFindingQty: row['PKG_Me_Inner_FindingQty'],
          pkgMeUnitFindingL: row['PKG_Me_Unit_FindingL'],
          pkgMeUnitFindingB: row['PKG_Me_Unit_FindingB'],
          pkgMeUnitFindingH: row['PKG_Me_Unit_FindingH'],
          pkgMeUnitFindingWt: row['PKG_Me_Unit_FindingWt'],
          pkgMeUnitFindingCBM: row['PKG_Me_Unit_FindingCBM'],
          pkgMeInnerSampleSizeID: row['PKG_Me_Inner_SampleSizeID'],
          pkgMeUnitSampleSizeID: row['PKG_Me_Unit_SampleSizeID'],
          pkgMePalletSampleSizeID: row['PKG_Me_Pallet_SampleSizeID'],
          pkgMeMasterSampleSizeID: row['PKG_Me_Master_SampleSizeID'],
          pkgAppShippingMarkSampleSizeId: row['PKG_App_shippingMark_SampleSizeId'],
        );

        itemList.add(item);
      }


      print("Found ${itemList.length} packaging measurement records.");
    } catch (e) {
      print("Error fetching packaging measurements: $e");
    }

    return itemList;
  }*/

  Future<List<POItemDtl>> getPackagingFindingMeasurementList(
      {required String itemId, required String qrpoItemHdrID}) async {
    List<POItemDtl> itemList = [];
    final db = await DatabaseHelper().database;

    try {
      String query = '''
      SELECT * FROM QRPOItemHdr
      WHERE pRowID = ? AND ItemID = ?
    ''';

      List<Map<String, dynamic>> result =
          await db.rawQuery(query, [qrpoItemHdrID, itemId]);
      developer.log("finding result : $result");
      for (var row in result) {
        itemList.add(POItemDtl.fromJson(row));
      }

      print('Packaging list count: ${itemList.length}');
    } catch (e) {
      print('Error: $e');
    }

    return itemList;
  }

  Future<List<POItemDtl>> getDigitalsPackagingMeasurement(
      String qrhDrID, String qrpoItemHdrID) async {
    final db = await DatabaseHelper().database; // <- your request

    List<POItemDtl> itemList = [];

    try {
      String query = '''
      SELECT pRowID, 
             PKG_Me_Pallet_Digitals, 
             PKG_Me_Master_Digitals, 
             PKG_Me_Inner_Digitals, 
             PKG_Me_Unit_Digitals 
      FROM QRPOItemHdr 
      WHERE pRowID = ? AND QRHDrID = ?
    ''';

      List<Map<String, dynamic>> result =
          await db.rawQuery(query, [qrpoItemHdrID, qrhDrID]);

      for (var row in result) {
        POItemDtl item = POItemDtl()
          ..pRowID = row['pRowID']
          ..pkgMePalletDigitals = row['PKG_Me_Pallet_Digitals']
          ..pkgMeMasterDigitals = row['PKG_Me_Master_Digitals']
          ..pkgMeInnerDigitals = row['PKG_Me_Inner_Digitals']
          ..pkgMeUnitDigitals = row['PKG_Me_Unit_Digitals'];

        itemList.add(item);
      }

      print('Found ${itemList.length} digital packaging measurements');
    } catch (e) {
      print('Error retrieving digital packaging measurements: $e');
    }

    return itemList;
  }

  Future<int> updateDigitalsUnitPackagingMeasurement(
      POItemDtl poItemDtl) async {
    final db = await DatabaseHelper().database;
    int status = 0;

    try {
      final Map<String, dynamic> values = {
        'PKG_Me_Unit_Digitals': poItemDtl.pkgMeUnitDigitals,
        'recDt': AppConfig.getCurrentDate(), // You must define this method
      };

      int rowsUpdated = await db.update(
        'QRPOItemHdr',
        values,
        where: 'pRowID = ?',
        whereArgs: [poItemDtl.pRowID],
      );

      if (rowsUpdated > 0) {
        status = 1;
        print('✅ Unit packaging measurement updated');
      } else {
        print('⚠️ Unit packaging measurement not updated');
      }
    } catch (e) {
      print('❌ Error updating Unit packaging measurement: $e');
    }

    return status;
  }

  Future<int> updateDigitalsInnerPackagingMeasurement(
      POItemDtl poItemDtl) async {
    final db = await DatabaseHelper().database;
    int status = 0;

    try {
      final Map<String, dynamic> values = {
        'PKG_Me_Inner_Digitals': poItemDtl.pkgMeInnerDigitals,
        'recDt': AppConfig.getCurrentDate(), // You must define this method
      };

      int rowsUpdated = await db.update(
        'QRPOItemHdr',
        values,
        where: 'pRowID = ?',
        whereArgs: [poItemDtl.pRowID],
      );

      if (rowsUpdated > 0) {
        status = 1;
        print('✅ Inner packaging measurement updated');
      } else {
        print('⚠️ Inner packaging measurement not updated');
      }
    } catch (e) {
      print('❌ Error updating Inner packaging measurement: $e');
    }

    return status;
  }

  Future<int> updateDigitalsMasterPackagingMeasurement(
      POItemDtl poItemDtl) async {
    final db = await DatabaseHelper().database;
    int status = 0;

    try {
      Map<String, dynamic> values = {
        'PKG_Me_Master_Digitals': poItemDtl.pkgMeMasterDigitals,
        'recDt': AppConfig.getCurrentDate(),
      };

      int rowsUpdated = await db.update(
        'QRPOItemHdr',
        values,
        where: 'pRowID = ?',
        whereArgs: [poItemDtl.pRowID],
      );

      if (rowsUpdated > 0) {
        status = 1;
        print('✅ Master packaging digitals updated');
      } else {
        print('⚠️ Master packaging digitals not updated');
      }
    } catch (e) {
      print('❌ Error updating master packaging digitals: $e');
    }

    return status;
  }

  Future<int> updateDigitalsPalletPackagingMeasurement(
      POItemDtl poItemDtl) async {
    final db = await DatabaseHelper().database;
    int status = 0;

    try {
      Map<String, dynamic> values = {
        'PKG_Me_Pallet_Digitals': poItemDtl.pkgMePalletDigitals,
        'recDt': AppConfig.getCurrentDate(),
      };

      int rowsUpdated = await db.update(
        'QRPOItemHdr',
        values,
        where: 'pRowID = ?',
        whereArgs: [poItemDtl.pRowID],
      );

      if (rowsUpdated > 0) {
        status = 1;
        print('✅ Pallet packaging digitals updated');
      } else {
        print('⚠️ Pallet packaging digitals not updated');
      }
    } catch (e) {
      print('❌ Error updating pallet packaging digitals: $e');
    }

    return status;
  }

  Future<int> updateDigitalsQualityMeasurement(
      QualityParameter qualityParameter) async {
    final db = await DatabaseHelper().database;
    int status = 0;

    try {
      final Map<String, dynamic> values = {
        'Digitals': qualityParameter.digitals,
        'recDt': AppConfig.getCurrentDate(), // You must define this
      };

      int rowsUpdated = await db.update(
        'QRQualiltyParameterFields',
        values,
        where: 'pRowID = ?',
        whereArgs: [qualityParameter.pRowID],
      );

      if (rowsUpdated > 0) {
        status = 1;
        print('✅ Updated QRQualiltyParameterFields');
      } else {
        print('⚠️ NOT UPDATED QRQualiltyParameterFields');
      }
    } catch (e) {
      print('❌ Error updating QRQualiltyParameterFields: $e');
    }

    return status;
  }

  Future<int> updateBarcode(Map<String, dynamic> poItemDtl) async {
    int status = 0;

    try {
      final db = await DatabaseHelper().database;

      // Add current date-time
      poItemDtl['recDt'] = DateTime.now().toIso8601String();

      // Extract primary key (assumed to be QRPOItemHdrID)
      var qrPOItemHdrID = poItemDtl['QRPOItemHdrID'];

      // Check if record exists
      final List<Map<String, dynamic>> existing = await db.query(
        'QRPOItemHdr',
        where: 'pRowID = ?',
        whereArgs: [qrPOItemHdrID],
      );

      if (existing.isEmpty) {
        // Insert new record
        status = await db.insert('QRPOItemHdr', poItemDtl);
        print("Inserted packagingMeasurement");
      } else {
        // Update existing record
        int rows = await db.update(
          'QRPOItemHdr',
          poItemDtl,
          where: 'pRowID = ?',
          whereArgs: [qrPOItemHdrID],
        );
        status = rows > 0 ? 1 : 0;
        print("Updated packagingMeasurement");
      }
    } catch (e) {
      print('Error in updateBarcode: $e');
    }

    return status;
  }

  // List Quality Parameter
  Future<DigitalsUploadModel?> getImageQuality(
    String qrHdrID,
    String qrpoItemHdrID,
    String pRowID,
    String? itemID,
  ) async {
    final db = await DatabaseHelper().database;
    DigitalsUploadModel? digitalsUploadModal;

    try {
      String query = '''
      SELECT * FROM QRPOItemDtl_Image 
      WHERE pRowID = ? AND QRHdrID = ? AND QRPOItemHdrID = ?
    ''';

      List<dynamic> args = [pRowID.trim(), qrHdrID, qrpoItemHdrID];

      if (itemID != null &&
          itemID.toLowerCase() != 'null' &&
          itemID.isNotEmpty) {
        query += ' AND ItemID = ?';
        args.add(itemID);
      }

      final List<Map<String, dynamic>> result = await db.rawQuery(query, args);

      if (result.isNotEmpty) {
        // You're returning only the *last* record in Java, this does the same.
        final row = result.last;

        digitalsUploadModal = DigitalsUploadModel(
          pRowID: row['pRowID'],
          selectedPicPath: row['fileContent'],
          imageName: row['ImageName'],
          title: row['Title'],
          imageExtn: row['ImageExtn'],
        );
      }
    } catch (e) {
      print("Error in getImageQuality: $e");
    }

    return digitalsUploadModal;
  }

  Future<List<QualityParameter>> getListQualityParameter({
    required InspectionModal inspectionModal,
    required String QRHdrID,
    required String QRPOItemHdrID,
  }) async
  {
    final db = await DatabaseHelper().database;
    List<QualityParameter> qualityParameters = [];

    try {
      String strWhere = " AND gm.numVal2 < 5 ";
      if (inspectionModal.activityID!.isNotEmpty) {
        List<String>? spStr = inspectionModal.activityID?.split("SYS");
        if (spStr!.length > 1) {
          String afterSplit = spStr[1];
          if (afterSplit.isNotEmpty) {
            int iVal = int.tryParse(afterSplit.trim()) ?? 0;
            print("this the split data ${inspectionModal.activityID!}");
            if (iVal > 0) {
              strWhere = " AND gm.numVal${iVal + 2} > 0 ";
              print("this the split data $strWhere");
            }
          }
        }
      }

      bool isMapTableEmpty = true;
      List<Map<String, dynamic>> mapCursor = await db.rawQuery(
          "SELECT COUNT(*) AS count FROM GenQualityParameterProductMap");
      print("this the count of the $mapCursor");
      if (mapCursor.isNotEmpty && mapCursor[0]['count'] > 0) {
        isMapTableEmpty = false;
      }

      String query;

      if (!isMapTableEmpty) {
        query = '''
        SELECT IFNULL(QRParam.pRowID,'') AS pRowID, QRParam.QualityParameterID AS QualityParameterID,
               IFNULL(gm.MainDescr,'') AS MainDescr, IFNULL(gm.Abbrv,'') AS Abbrv,
               IFNULL(gm.chrVal2,'') AS OptionValue, IFNULL(gm.numVal1,0) AS PromptType,
               IFNULL(gm.numVal2,0) AS Position, IFNULL(QRParam.IsApplicable,0) AS IsApplicable,
               IFNULL(QRParam.OptionSelected,0) AS OptionSelected, IFNULL(QRParam.Remarks,'') AS Remarks,
               0 AS recDirty, IFNULL(CAST(gm.chrVal3 AS INTEGER),0) AS ImageRequired, IFNULL(Digitals,'') AS Digitals
        FROM GenMst gm
        INNER JOIN QRQualiltyParameterFields QRParam ON QRParam.QualityParameterID = gm.pGenRowID
        WHERE gm.GenId = '555' AND QRParam.QRHdrID = '$QRHdrID' AND IFNULL(QRParam.QRPOItemHdrID,'') = '$QRPOItemHdrID'
              AND gm.numVal2 > 5 $strWhere

        UNION

        SELECT '' AS pRowID, gm.pGenRowID AS QualityParameterID, IFNULL(gm.MainDescr,'') AS MainDescr,
               IFNULL(gm.Abbrv,'') AS Abbrv, IFNULL(gm.chrVal2,'') AS OptionValue,
               IFNULL(gm.numVal1,0) AS PromptType, IFNULL(gm.numVal2,0) AS Position,
               0 AS IsApplicable, 0 AS OptionSelected, '' AS Remarks, 0 AS recDirty,
               IFNULL(CAST(gm.chrVal3 AS INTEGER),0) AS ImageRequired, '' AS Digitals
        FROM GenMst gm
        WHERE gm.GenId = '555' AND gm.recEnable = 1 AND gm.numVal2 > 5 $strWhere
          AND gm.pGenRowID NOT IN (
            SELECT QRParam.QualityParameterID
            FROM QRQualiltyParameterFields QRParam
            WHERE QRParam.QualityParameterID = gm.pGenRowID AND QRParam.QRHdrID = '$QRHdrID'
              AND IFNULL(QRParam.QRPOItemHdrID,'') = '$QRPOItemHdrID' AND gm.numVal2 > 5 $strWhere
          )
          AND gm.pGenRowID IN (
            SELECT QPP.GenRowID
            FROM GenQualityParameterProductMap QPP
            LEFT JOIN QRPOItemdtl QRDtl ON QPP.ProductID = QRDtl.ProductID
            WHERE QRDtl.QRHDRID = '$QRHdrID' AND QRDtl.QRPOItemHdrID = '$QRPOItemHdrID'
          )
        ORDER BY Position DESC, Abbrv, QualityParameterID
      ''';
      }
      else {
        query = '''
        SELECT IFNULL(QRParam.pRowID,'') AS pRowID, QRParam.QualityParameterID AS QualityParameterID,
               IFNULL(gm.MainDescr,'') AS MainDescr, IFNULL(gm.Abbrv,'') AS Abbrv,
               IFNULL(gm.chrVal2,'') AS OptionValue, IFNULL(gm.numVal1,0) AS PromptType,
               IFNULL(gm.numVal2,0) AS Position, IFNULL(QRParam.IsApplicable,0) AS IsApplicable,
               IFNULL(QRParam.OptionSelected,0) AS OptionSelected, IFNULL(QRParam.Remarks,'') AS Remarks,
               0 AS recDirty, IFNULL(CAST(gm.chrVal3 AS INTEGER),0) AS ImageRequired, IFNULL(Digitals,'') AS Digitals
        FROM GenMst gm
        INNER JOIN QRQualiltyParameterFields QRParam ON QRParam.QualityParameterID = gm.pGenRowID
        WHERE gm.GenId = '555' AND QRParam.QRHdrID = '$QRHdrID' AND IFNULL(QRParam.QRPOItemHdrID,'') = '$QRPOItemHdrID'
              AND gm.numVal2 > 5 $strWhere

        UNION

        SELECT '' AS pRowID, gm.pGenRowID AS QualityParameterID, IFNULL(gm.MainDescr,'') AS MainDescr,
               IFNULL(gm.Abbrv,'') AS Abbrv, IFNULL(gm.chrVal2,'') AS OptionValue,
               IFNULL(gm.numVal1,0) AS PromptType, IFNULL(gm.numVal2,0) AS Position,
               0 AS IsApplicable, 0 AS OptionSelected, '' AS Remarks, 0 AS recDirty,
               IFNULL(CAST(gm.chrVal3 AS INTEGER),0) AS ImageRequired, '' AS Digitals
        FROM GenMst gm
        WHERE gm.GenId = '555' AND gm.recEnable = 1 AND gm.numVal2 > 5 $strWhere
          AND gm.pGenRowID NOT IN (
            SELECT QRParam.QualityParameterID
            FROM QRQualiltyParameterFields QRParam
            WHERE QRParam.QualityParameterID = gm.pGenRowID AND QRParam.QRHdrID = '$QRHdrID'
              AND IFNULL(QRParam.QRPOItemHdrID,'') = '$QRPOItemHdrID' AND gm.numVal2 > 5 $strWhere
          )
        ORDER BY Position DESC, Abbrv, QualityParameterID
      ''';
      }

      developer.log("getListQualityParameter SQL query: $query");
      List<Map<String, dynamic>> results = await db.rawQuery(query);
      developer.log("getListQualityParameter SQL results: $results");

      for (var row in results) {
        var qp = QualityParameter(
          pRowID: row['pRowID'] ?? '',
          qualityParameterID: row['QualityParameterID'] ?? '',
          mainDescr: row['MainDescr'] ?? '',
          abbrv: row['Abbrv'] ?? '',
          optionValue: row['OptionValue'] ?? '',
          remarks: row['Remarks'] ?? '',
          digitals: row['Digitals'] ?? '',
          promptType: (row['PromptType'] as num?)?.toInt(),
          position: (row['Position'] as num?)?.toInt(),
          isApplicable: (row['IsApplicable'] as num?)?.toInt(),
          optionSelected: (row['OptionSelected'] as num?)?.toInt(),
          recDirty: (row['recDirty'] as num?)?.toInt(),
          imageRequired: (row['ImageRequired'] as num?)?.toInt(),
        );


        if (qp.digitals!.isNotEmpty && qp.digitals != "null") {
          List<String>? rowIds = qp.digitals?.split(",");
          for (String rowId in rowIds!) {
            if (rowId.isNotEmpty) {
              DigitalsUploadModel? digital = await getImageQuality(
                  QRHdrID, QRPOItemHdrID, rowId, qp.pRowID);
              if (digital != null) {
                qp.imageAttachmentList?.add(digital);
              }
            }
          }
        }

        qualityParameters.add(qp);
      }
    } catch (e) {
      print("Error in getListQualityParameter: $e");
    }

    return qualityParameters;
  }

  Future<List<QualityParameter>> getListQualityParameterAccordingRowId(
      String pRowID) async
  {
    final db = await DatabaseHelper().database; // ✅ Database initialization

    List<QualityParameter> qualityParameters = [];

    try {
      String query = "SELECT * FROM QRQualiltyParameterFields WHERE pRowID = ?";
      final List<Map<String, dynamic>> result =
          await db.rawQuery(query, [pRowID]);

      for (final row in result) {
        final qualityParameter = QualityParameter(
          pRowID: row['pRowID'] ?? '',
          digitals: row['Digitals'] ?? '',
        );

        qualityParameters.add(qualityParameter);
      }

      print("Size of QualityParameter is ${qualityParameters.length}");
    } catch (e) {
      print("Error in getListQualityParameterAccordingRowId: $e");
    }

    return qualityParameters;
  }

  Future<DigitalsUploadModel?> getImageQualityInspectionLevel({
    required String qrHdrID,
    required String pRowID,
    required String itemID,
  }) async
  {
    final db = await DatabaseHelper().database;
    DigitalsUploadModel? digitalsUploadModal;

    try {
      // Build WHERE clause with optional ItemID filter
      String query = '''
      SELECT * FROM QRPOItemDtl_Image 
      WHERE pRowID = ? AND QRHdrID = ?
    ''';

      List<String> args = [pRowID.trim(), qrHdrID];

      if (itemID.isNotEmpty && itemID.toLowerCase() != 'null') {
        query += " AND ItemID = ?";
        args.add(itemID);
      }

      final result = await db.rawQuery(query, args);

      if (result.isNotEmpty) {
        final row = result.first;
        digitalsUploadModal = DigitalsUploadModel(
          pRowID: row['pRowID'] as String,
          selectedPicPath: row['fileContent'] as String,
          imageName: row['ImageName'] as String,
          title: row['Title'] as String,
          imageExtn: row['ImageExtn'] as String,
        );
      }
    } catch (e) {
      print("Error in getImageQualityInspectionLevel: $e");
    }

    return digitalsUploadModal;
  }
/*
  Future<List<QualityParameter>> getListQualityParameterForItemLevel(
      InspectionModal inspectionModal,
      ) async
  {
    List<QualityParameter> qualityParameters = [];

    try {
      String strWhere = " AND gm.numVal2 < 5  ";

      if (inspectionModal.activityID != null && inspectionModal.activityID!.isNotEmpty) {
        List<String> spStr = inspectionModal.activityID!.split("SYS");

        if (spStr.length > 1) {
          String afterSplit = spStr[1];
          if (afterSplit.isNotEmpty) {
            int iVal = int.tryParse(afterSplit.trim()) ?? 0;
            if (iVal > 0) {
              String makedNum = " AND gm.numVal${iVal + 2} > 0  ";
              strWhere += makedNum;
            }
          }
        }
      }

      String query = """
    SELECT IfNULL(QRParam.pRowID,'') As pRowID, QRParam.QualityParameterID As QualityParameterID,
    IfNULL(gm.MainDescr,'') As MainDescr, IfNULL(gm.Abbrv,'') As Abbrv,
    IfNULL(gm.chrVal2,'') As OptionValue, IfNULL(gm.numVal1,0) As PromptType,
    IfNULL(gm.numVal2,0) As Position, IfNULL(QRParam.IsApplicable,0) As IsApplicable,
    IfNULL(QRParam.OptionSelected,0) As OptionSelected, IfNULL(QRParam.Remarks,'') As Remarks,
    0 As recDirty, IFNULL(Cast(gm.chrVal3 As Integer),0) As ImageRequired,
    IFNULL(QRParam.Digitals,'') As Digitals
    FROM GenMst gm
    INNER JOIN QRQualiltyParameterFields QRParam on QRParam.QualityParameterID = gm.pGenRowID
    WHERE gm.GenId = '555' AND QRParam.QRHdrID = '${inspectionModal.pRowID}'
    AND IFNULL(QRParam.QRPOItemHdrID,'') = '' AND gm.numVal2 < 5 AND gm.numVal5 > 0
    $strWhere

    UNION

    SELECT '' As pRowID, gm.pGenRowID As QualityParameterID,
    IfNULL(gm.MainDescr,'') As MainDescr, IfNULL(gm.Abbrv,'') As Abbrv,
    IfNULL(gm.chrVal2,'') As OptionValue, IfNULL(gm.numVal1,0) As PromptType,
    IfNULL(gm.numVal2,0) As Position, 0 As IsApplicable, 0 As OptionSelected,
    '' As Remarks, 0 As recDirty, IFNULL(Cast(gm.chrVal3 As Integer),0) As ImageRequired,
    '' As Digitals
    FROM GenMst gm
    WHERE gm.GenId = '555' AND gm.recEnable = 1 AND gm.numVal2 < 5 AND gm.numVal5 > 0
    $strWhere
    AND gm.pGenRowID NOT IN (
      SELECT QRParam.QualityParameterID FROM QRQualiltyParameterFields QRParam
      WHERE QRParam.QualityParameterID = gm.pGenRowID
      AND QRParam.QRHdrID = '${inspectionModal.pRowID}'
      $strWhere
      AND IFNULL(QRParam.QRPOItemHdrID,'') = ''
      AND gm.numVal2 < 5 AND gm.numVal5 > 0
    )
    ORDER BY Position DESC, Abbrv, QualityParameterID
    """;

      final db = await DatabaseHelper().database;
      List<Map<String, dynamic>> results = await db.rawQuery(query);

      for (var row in results) {
        QualityParameter param = QualityParameter(
          pRowID: row['pRowID'],
          qualityParameterID: row['QualityParameterID'],
          mainDescr: row['MainDescr'],
          abbrv: row['Abbrv'],
          optionValue: row['OptionValue'],
          promptType: row['PromptType'],
          position: row['Position'],
          isApplicable: row['IsApplicable'],
          optionSelected: row['OptionSelected'],
          remarks: row['Remarks'],
          recDirty: row['recDirty'],
          imageRequired: row['ImageRequired'],
          digitals: row['Digitals'],
          imageAttachmentList: [],
        );

        if (param.digitals != null && param.digitals!.isNotEmpty && param.digitals != 'null') {
          List<String> digitalIds = param.digitals!.split(',');
          for (String rowId in digitalIds) {
            if (rowId.trim().isNotEmpty) {
              DigitalsUploadModel? upload =
              await ItemInspectionDetailHandler().getImageQualityInspectionLevel(


               qrHdrID:        inspectionModal.pRowID!, pRowID:   param.pRowID ?? '', itemID:      rowId.trim(),
              );
              if (upload != null) {
                param.imageAttachmentList?.add(upload);
              }
            }
          }
        }

        qualityParameters.add(param);
      }
    } catch (e, stacktrace) {
      print("Error in getListQualityParameterForItemLevel: $e\n$stacktrace");
    }

    return qualityParameters;
  }*/

  Future<List<QualityParameter>> getListQualityParameterForItemLevel(
      InspectionModal inspectionModal) async
  {
    final db = await DatabaseHelper().database;
    List<QualityParameter> qualityParameters = [];

    try {
      String strWhere = "";
      if (inspectionModal.activityID?.isNotEmpty == true) {
        List<String> spStr = inspectionModal.activityID!.split("SYS");
        if (spStr.length > 1) {
          String afterSplit = spStr[1];
          if (afterSplit.isNotEmpty) {
            int iVal = int.tryParse(afterSplit.trim()) ?? 0;
            if (iVal > 0) {
              strWhere = " AND gm.numVal${iVal + 2} > 0";
            }
          }
        }
      }

      String query = "SELECT IfNULL(QRParam.pRowID,'') As pRowID,   QRParam.QualityParameterID As QualityParameterID, IfNULL(gm.MainDescr,'')   As MainDescr, " +
          " IfNULL(gm.Abbrv,'') As Abbrv, IfNULL(gm.chrVal2,'') As OptionValue,  IfNULL(gm.numVal1,0) As PromptType,   IfNULL(gm.numVal2,0) As Position, " +
          "  IfNULL(QRParam.IsApplicable,0) As IsApplicable, IfNULL(QRParam.OptionSelected,0)   As OptionSelected, " +
          " IfNULL(QRParam.Remarks,'') As Remarks, 0 As recDirty, IFNULL(Cast(gm.chrVal3 As Integer),0) As ImageRequired,  " +
          " IFNULL(QRParam.Digitals,'') As Digitals   FROM GenMst gm  INNER JOIN QRQualiltyParameterFields QRParam on QRParam.QualityParameterID = gm.pGenRowID  " +
          "   WHERE gm.GenId = '555' And QRParam.QRHdrID = '" + "${inspectionModal.pRowID}" + "' AND IfNULL(QRParam.QRPOItemHdrID,'') = '' " +
          "   AND gm.numVal2 < 5   AND gm.numVal5 > 0 " + strWhere + " UNION   SELECT '' As pRowID,  gm.pGenRowID As QRParamID," +
          " IfNULL(gm.MainDescr,'') As Name,    IfNULL(gm.Abbrv,'') As Caption, IfNULL(gm.chrVal2,'') As OptionValue, " +
          " IfNULL(gm.numVal1,0) As PromptType,   IfNULL(gm.numVal2,0) As Position,  0 As IsApplicable, 0 As OptionSelected, '' As Remarks, 0 As recDirty, " +
          "  IFNULL(Cast(gm.chrVal3 As Integer),0) As ImageRequired, '' As Digitals   FROM GenMst gm " +
          " WHERE gm.GenId = '555' AND gm.recEnable = 1  AND gm.numVal2 < 5   AND gm.numVal5 > 0  " + strWhere +
          " AND gm.pGenRowID NOT IN ( SELECT QRParam.QualityParameterID FROM QRQualiltyParameterFields QRParam  " +
          "  WHERE QRParam.QualityParameterID = gm.pGenRowID AND QRParam.QRHdrID = '" + "${inspectionModal.pRowID }"+ "' " + strWhere +
          "  AND IfNULL(QRParam.QRPOItemHdrID,'') = '' AND gm.numVal2 < 5   AND gm.numVal5 > 0) " +
          "  ORDER BY Position Desc, Caption, QRParamID";

      final result = await db.rawQuery(query);
      developer.log("Query executed: $query");
      print("Query result count: ${result.length}");

      for (final row in result) {
        int? toInt(dynamic value) {
          if (value is int) return value;
          if (value is double) return value.toInt();
          if (value is String) return int.tryParse(value);
          return null;
        }

        final qualityParameter = QualityParameter(
          pRowID: row['pRowID'] as String?,
          qualityParameterID: row['QualityParameterID'] as String?,
          mainDescr: row['MainDescr'] as String?,
          abbrv: row['Abbrv'] as String?,
          optionValue: row['OptionValue'] as String?,
          remarks: row['Remarks'] as String?,
          digitals: row['Digitals'] as String?,
          promptType: toInt(row['PromptType']),
          position: toInt(row['Position']),
          isApplicable: toInt(row['IsApplicable']),
          optionSelected: toInt(row['OptionSelected']),
          recDirty: toInt(row['recDirty']),
          imageRequired: toInt(row['ImageRequired']),
          imageAttachmentList: [],
        );

        if (qualityParameter.digitals != null &&
            qualityParameter.digitals!.isNotEmpty &&
            qualityParameter.digitals != 'null') {
          final digitalIDs = qualityParameter.digitals!.split(',');
          for (final id in digitalIDs) {
            if (id.trim().isNotEmpty) {
              final digital = await getImageQualityInspectionLevel(
                pRowID: id.trim(),
                qrHdrID: inspectionModal.pRowID ?? '',
                itemID: qualityParameter.pRowID ?? '',
              );
              if (digital != null) {
                qualityParameter.imageAttachmentList?.add(digital);
              }
            }
          }
        }

        qualityParameters.add(qualityParameter);
      }
    } catch (e, st) {
      print("Error loading quality parameters: $e");
      print(st);
    }

    print("Final quality parameter list size: ${qualityParameters.length}");
    return qualityParameters;
  }

  Future<String?> updateQualityParameter({
    required QualityParameter qualityParameter,
    required POItemDtl poItemDtl,
  }) async
  {
    String? returnId;
    try {
      final db = await DatabaseHelper().database;
      String userId = await UserMasterTable().getFirstUserID() ?? "";
      final String currentDate = ApiRoute.getCurrentDate();
      Map<String, dynamic> contentValues = {
        'IsApplicable': qualityParameter.isApplicable,
        'OptionSelected': qualityParameter.optionSelected,
        'Remarks': qualityParameter.remarks,
        'recEnable': 1,
        'recDirty': 1,
        'recAddDt': currentDate,
        'recDt': currentDate,
        'recAddUser': userId,
        'recUser': userId,
      };

      int rows = await db.update(
        'QRQualiltyParameterFields',
        contentValues,
        where: 'QRHdrID = ? AND QRPOItemHdrID = ? AND QualityParameterID = ?',
        whereArgs: [
          poItemDtl.qrHdrID,
          poItemDtl.qrpoItemHdrID,
          qualityParameter.qualityParameterID
        ],
      );

      if (rows == 0) {
        String newId = await generatePK('QRQualiltyParameterFields');
        returnId = newId;

        contentValues.addAll({
          'LocID': FClientConfig.locID,
          'pRowID': newId,
          'QRHdrID': poItemDtl.qrHdrID,
          'QRPOItemHdrID': poItemDtl.qrpoItemHdrID,
          'ItemID': poItemDtl.itemID,
          'QualityParameterID': qualityParameter.qualityParameterID,
        });

        await db.insert('QRQualiltyParameterFields', contentValues);
        print('Inserted QRQualiltyParameterFields');
      } else {
        List<Map<String, dynamic>> result = await db.query(
          'QRQualiltyParameterFields',
          columns: ['pRowID'],
          where: 'QRHdrID = ? AND QRPOItemHdrID = ? AND QualityParameterID = ?',
          whereArgs: [
            poItemDtl.qrHdrID,
            poItemDtl.qrpoItemHdrID,
            qualityParameter.qualityParameterID
          ],
        );

        if (result.isNotEmpty) {
          returnId = result.first['pRowID'] as String?;
        }

        print('Updated QRQualiltyParameterFields');
      }
    } catch (e) {
      print('Error in updateQualityParameter: $e');
    }

    print('Returned quality parameter ID: $returnId');
    return returnId;
  }

  Future<String?> updateQualityParameterForItemLevel(
      {
    required QualityParameter qualityParameter,
    required InspectionModal inspectionModal,
  }) async
  {
    String? returnId;
    final db = await DatabaseHelper().database;
    String userId = await UserMasterTable().getFirstUserID() ?? "";
    final String currentDate = ApiRoute.getCurrentDate();
    try {
      Map<String, dynamic> contentValues = {
        'IsApplicable': qualityParameter.isApplicable,
        'OptionSelected': qualityParameter.optionSelected,
        'Remarks': qualityParameter.remarks,
        'recEnable': 1,
        'recDirty': 1,
        'recAddDt': currentDate,
        'recDt': currentDate,
        'recAddUser': userId,
        'recUser': userId,
      };

      int rows = await db.update(
        'QRQualiltyParameterFields',
        contentValues,
        where: 'QRHdrID = ? AND QualityParameterID = ?',
        whereArgs: [
          inspectionModal.pRowID,
          qualityParameter.qualityParameterID
        ],
      );

      if (rows == 0) {
        returnId = await generatePK('QRQualiltyParameterFields');

        contentValues.addAll({
          'LocID': FClientConfig.locID,
          'pRowID': returnId,
          'QRHdrID': inspectionModal.pRowID,
          'QualityParameterID': qualityParameter.qualityParameterID,
        });

        await db.insert('QRQualiltyParameterFields', contentValues);
        print('Inserted into QRQualiltyParameterFields...');
      } else {
        List<Map<String, dynamic>> result = await db.query(
          'QRQualiltyParameterFields',
          columns: ['pRowID'],
          where: 'QRHdrID = ? AND QualityParameterID = ?',
          whereArgs: [
            inspectionModal.pRowID,
            qualityParameter.qualityParameterID
          ],
        );

        if (result.isNotEmpty) {
          returnId = result.first['pRowID'] as String?;
        }

        print('Updated QRQualiltyParameterFields...');
      }
    } catch (e) {
      print('Error updating QualityParameter: $e');
    }

    print('Return quality parameter ID: $returnId');
    return returnId;
  }

  Future<List<InspectionModal>> getHistoryList(
      String qrItemID, String qrPOItemHdrID) async
  {
    List<InspectionModal> itemList = [];
    final db = await DatabaseHelper().database;
    try {
      String query = '''
      SELECT 
        QRHdrID AS pRowID,
        IFNULL(InspectionDt, '') AS InspectionDt,
        IFNULL(StatusDs, '') AS StatusDs,
        IFNULL(ActivityDs, '') AS ActivityDs,
        IFNULL(QR, '') AS QR,
        IFNULL(Inspector, '') AS Inspector
      FROM QRInspectionHistory
      WHERE RefQRPOItemHdrID = ? AND RefQRHdrID = ?
    ''';

      List<Map<String, dynamic>> result =
          await db.rawQuery(query, [qrPOItemHdrID, qrItemID]);

      // Using traditional for loop to mimic Java-style processing
      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> row = result[i];

        // Create object from row
        InspectionModal inspection = InspectionModal(
          qrHdrID: row['pRowID'] ?? '',
          inspectionDt: row['InspectionDt'] ?? '',
          status: row['StatusDs'] ?? '',
          activity: row['ActivityDs'] ?? '',
          qr: row['QR'] ?? '',
          inspector: row['Inspector'] ?? '',
        );

        // You can do additional saving/processing here
        // Example: saveToAnotherTable(db, inspection);
        // or
        // await saveInspectionToLocalStorage(inspection);

        // Add to list
        itemList.add(inspection);
      }

      print('Total records processed: ${itemList.length}');
    } catch (e) {
      print('Error in getHistoryList: $e');
    }

    return itemList;
  }

  Future<int> updatePackagingFindingMeasurementList(POItemDtl poItemDtl) async {
    try {
      final db = await DatabaseHelper().database;
      Map<String, dynamic> contentValues = {
        'pRowID': poItemDtl.qrpoItemHdrID,
        'PKG_Me_InspectionResultID': poItemDtl.pkgMeInspectionResultID,
        'PKG_Me_Master_InspectionResultID': poItemDtl.pkgMeMasterInspectionResultID,
        'PKG_Me_Pallet_InspectionResultID': poItemDtl.pkgMePalletInspectionResultID,
        'PKG_Me_Unit_InspectionResultID': poItemDtl.pkgMeUnitInspectionResultID,
        'PKG_Me_Inner_InspectionResultID': poItemDtl.pkgMeInnerInspectionResultID,

        'PKG_App_ShippingMark_InspectionResultID': poItemDtl.pkgAppShippingMarkInspectionResultID,
        'PKG_App_Remark': poItemDtl.pkgAppRemark,
        'PKG_App_InspectionResultID': poItemDtl.pkgAppInspectionResultID,
        'PKG_App_InspectionLevelID': poItemDtl.pkgAppInspectionLevelID,
        'PKG_App_Pallet_InspectionResultID': poItemDtl.pkgAppPalletInspectionResultID,
        'PKG_App_Pallet_SampleSizeID': poItemDtl.pkgAppPalletSampleSizeID,
        'PKG_App_Pallet_SampleSizeValue': poItemDtl.pkgAppPalletSampleSizeValue,
        'PKG_App_Master_SampleSizeID': poItemDtl.pkgAppMasterSampleSizeID,
        'PKG_App_Master_SampleSizeValue': poItemDtl.pkgAppMasterSampleSizeValue,
        'PKG_App_Master_InspectionResultID': poItemDtl.pkgAppMasterInspectionResultID,
        'PKG_App_Inner_SampleSizeID': poItemDtl.pkgAppInnerSampleSizeID,
        'PKG_App_Inner_SampleSizeValue': poItemDtl.pkgAppInnerSampleSizeValue,
        'PKG_App_Unit_SampleSizeID': poItemDtl.pkgAppUnitSampleSizeID,
        'PKG_App_Unit_InspectionResultID': poItemDtl.pkgAppUnitInspectionResultID,
        'OnSiteTest_Remark': poItemDtl.onSiteTestRemark,
        'Qty_Remark': poItemDtl.qtyRemark,
        'OnSiteTest_InspectionResultID': poItemDtl.onSiteTestInspectionResultID,

        'Barcode_InspectionLevelID': poItemDtl.barcodeInspectionLevelID,
        'Barcode_InspectionResultID': poItemDtl.barcodeInspectionResultID,
        'Barcode_Remark': poItemDtl.barcodeRemark,
        'Barcode_Pallet_SampleSizeID': poItemDtl.barcodePalletSampleSizeID,
        'Barcode_Pallet_SampleSizeValue': poItemDtl.barcodePalletSampleSizeValue,
        'Barcode_Pallet_Visual': poItemDtl.barcodePalletVisual,
        'Barcode_Pallet_Scan': poItemDtl.barcodePalletScan,
        'Barcode_Pallet_InspectionResultID': poItemDtl.barcodePalletInspectionResultID,
        'Barcode_Master_SampleSizeID': poItemDtl.barcodeMasterSampleSizeID,
        'Barcode_Master_SampleSizeValue': poItemDtl.barcodeMasterSampleSizeValue,
        'Barcode_Master_Visual': poItemDtl.barcodeMasterVisual,
        'Barcode_Master_Scan': poItemDtl.barcodeMasterScan,
        'Barcode_Master_InspectionResultID': poItemDtl.barcodeMasterInspectionResultID,
        'Barcode_Inner_SampleSizeID': poItemDtl.barcodeInnerSampleSizeID,
        'Barcode_Inner_SampleSizeValue': poItemDtl.barcodeInnerSampleSizeValue,
        'Barcode_Inner_Visual': poItemDtl.barcodeInnerVisual,
        'Barcode_Inner_Scan': poItemDtl.barcodeInnerScan,
        'Barcode_Inner_InspectionResultID': poItemDtl.barcodeInnerInspectionResultID,
        'Barcode_Unit_SampleSizeID': poItemDtl.barcodeUnitSampleSizeID,
        'Barcode_Unit_SampleSizeValue': poItemDtl.barcodeUnitSampleSizeValue,
        'Barcode_Unit_Visual': poItemDtl.barcodeUnitVisual,
        'Barcode_Unit_Scan': poItemDtl.barcodeUnitScan,
        'Barcode_Unit_InspectionResultID': poItemDtl.barcodeUnitInspectionResultID,

        'PKG_Me_Remark': poItemDtl.pkgMeRemark,
        'PKG_Me_Pallet_FindingL': poItemDtl.pkgMePalletFindingL,
        'PKG_Me_Pallet_FindingB': poItemDtl.pkgMePalletFindingB,
        'PKG_Me_Pallet_FindingH': poItemDtl.pkgMePalletFindingH,
        'PKG_Me_Pallet_FindingWt': poItemDtl.pkgMePalletFindingWt,
        'PKG_Me_Pallet_FindingCBM': poItemDtl.pkgMePalletFindingCBM,
        'PKG_Me_Pallet_FindingQty': poItemDtl.pkgMePalletFindingQty,
        'PKG_Me_Master_FindingL': poItemDtl.pkgMeMasterFindingL,
        'PKG_Me_Master_FindingB': poItemDtl.pkgMeMasterFindingB,
        'PKG_Me_Master_FindingH': poItemDtl.pkgMeMasterFindingH,
        'PKG_Me_Master_FindingWt': poItemDtl.pkgMeMasterFindingWt,
        'PKG_Me_Master_FindingCBM': poItemDtl.pkgMeMasterFindingCBM,
        'PKG_Me_Master_FindingQty': poItemDtl.pkgMeMasterFindingQty,
        'PKG_Me_Inner_FindingL': poItemDtl.pkgMeInnerFindingL,
        'PKG_Me_Inner_FindingB': poItemDtl.pkgMeInnerFindingB,
        'PKG_Me_Inner_FindingH': poItemDtl.pkgMeInnerFindingH,
        'PKG_Me_Inner_FindingWt': poItemDtl.pkgMeInnerFindingWt,
        'PKG_Me_Inner_FindingCBM': poItemDtl.pkgMeInnerFindingCBM,
        'PKG_Me_Inner_FindingQty': poItemDtl.pkgMeInnerFindingQty,
        'PKG_Me_Unit_FindingL': poItemDtl.pkgMeUnitFindingL,
        'PKG_Me_Unit_FindingB': poItemDtl.pkgMeUnitFindingB,
        'PKG_Me_Unit_FindingH': poItemDtl.pkgMeUnitFindingH,
        'PKG_Me_Unit_FindingWt': poItemDtl.pkgMeUnitFindingWt,
        'PKG_Me_Unit_FindingCBM': poItemDtl.pkgMeUnitFindingCBM,
        'PKG_Me_Inner_SampleSizeID': poItemDtl.pkgMeInnerSampleSizeID,
        'PKG_Me_Unit_SampleSizeID': poItemDtl.pkgMeUnitSampleSizeID,
        'PKG_Me_Pallet_SampleSizeID': poItemDtl.pkgMePalletSampleSizeID,
        'PKG_Me_Master_SampleSizeID': poItemDtl.pkgMeMasterSampleSizeID,
        'PKG_App_shippingMark_SampleSizeId': poItemDtl.pkgAppShippingMarkSampleSizeId,
        'WorkmanShip_InspectionResultID': poItemDtl.workmanshipInspectionResultID,
        'recDt': AppConfig.getCurrentDate(),
      };

      developer.log('contentValues: $contentValues');
      developer.log('poItemDtl: ${poItemDtl.qrpoItemHdrID}');
      // Clean out nulls to avoid sqflite type issues
      contentValues.removeWhere((key, value) => value == null);

      final count = await db.update(
        'QRPOItemHdr',
        contentValues,
        where: "pRowID = ?",
        whereArgs: [poItemDtl.qrpoItemHdrID],
      );
      developer.log('poItemDtl: ${poItemDtl.qrpoItemHdrID}');
      
      if (count > 0) {
        print('✅ Update successful: Updated $count row(s) in QRPOItemHdr');
        return count;
      } else {
        // Try to insert if update failed
        final insertId = await db.insert('QRPOItemHdr', contentValues);
        if (insertId > 0) {
          print('✅ Insert successful: Inserted new record with ID $insertId in QRPOItemHdr');
          return insertId;
        } else {
          print('❌ Error: Failed to update or insert record in QRPOItemHdr');
          return 0;
        }
      }
    } catch (e) {
      print('❌ Error updating packaging finding measurement list: $e');
      return 0;
    }
  }


/*  Future<int> updatePackagingFindingMeasurementList(POItemDtl poItemDtl) async {
        int status = 0;

        try {
            final db = await DatabaseHelper().database;

            // Add current date to match Java's AppConfig.getCurrntDate()
           // poItemDtl. = DateTime.now().toIso8601String(); // Or use a custom format

            // Extract the primary key
            final id = poItemDtl.qrpoItemHdrID; // Assuming QRPOItemHdrID is used as pRowID

            // Check if the record exists
            final List<Map<String, dynamic>> existing = await db.query(
                'QRPOItemHdr',
                where: 'pRowID = ?',
                whereArgs: [id],
            );

            if (existing.isEmpty) {
                // Insert new record
                status = await db.insert('QRPOItemHdr', poItemDtl.toJson());
                print('Inserted packagingMeasurement');
            } else {
                // Update existing record
                int rows = await db.update(
                    'QRPOItemHdr',
                    poItemDtl.toJson(),
                    where: 'pRowID = ?',
                    whereArgs: [id],
                );
                status = rows > 0 ? 1 : 0;
                print('Updated packagingMeasurement');
            }
        } catch (e) {
            print('Error in updatePackagingFindingMeasurementList: $e');
        }

        return status;
    }*/


  Future<List<WorkManShipModel>> getWorkmanShip(
      String qrHdrID, String qrPoItemHdrID, String pItemID) async {

    List<WorkManShipModel> itemList = [];

    try {
      final db = await DatabaseHelper().database;

      String query = '''
      SELECT pRowID, LocID, QRHdrID, QRPOItemHdrID, ItemID, DefectID,
             DefectCode, DefectName, DCLTypeID, DefectComments,
             CriticalDefect, MajorDefect, MinorDefect, CriticalType, MajorType, MinorType,
             SampleRqstCriticalRowID, POItemHdrCriticalRowID, Digitals, recAddDt, recDt, recAddUser, recUser
      FROM QRAuditBatchDetails
      WHERE QRHdrID = ? AND QRPOItemHdrID = ?
    ''';

      final List<Map<String, dynamic>> results = await db.rawQuery(query, [qrHdrID, qrPoItemHdrID]);
      developer.log("workmanship modal list ${(results)}");
      for (var row in results) {
        WorkManShipModel model = WorkManShipModel(
          pRowID: row['pRowID'],
          code: row['DefectCode'],
          description: row['DefectName'],
          digitals: row['Digitals'],
          critical: row['CriticalDefect'],
          major: row['MajorDefect'],
          minor: row['MinorDefect'],
          comments: row['DefectComments'],
        );

        if (model.digitals != null && model.digitals != 'null') {
          List<String> digitalsList = model.digitals!.split(',');
          for (String rowId in digitalsList) {
            if (rowId.trim().isNotEmpty) {
              DigitalsUploadModel? digital = await ItemInspectionDetailHandler().getImageAccordingToItem(
                rowId.trim(),
                model.pRowID!,
              );
              if (digital != null) {
                model.listImages?.add(digital);
              }
            }
          }
        }

        itemList.add(model);
      }
    } catch (e) {
      print("Error fetching workmanship: $e");
    }

    print("Count of workmanship items: ${itemList.length}");
    return itemList;
  }


  Future<String?> updateWorkmanShip({
    required String qrHdrID,
    required String qrPOItemHdrID,
    required String pItemID,
    required WorkManShipModel workManShipModel,
  }) async {
    final db = await DatabaseHelper().database;
    String userId = await UserMasterTable().getFirstUserID() ?? "";
    final currentDate = AppConfig.getCurrentDate();

    Map<String, dynamic> contentValues = {
      "DefectID": "",
      "DefectCode": workManShipModel.code,
      "DefectName": workManShipModel.description,
      "DCLTypeID": 0,
      "DefectComments": workManShipModel.comments,
      "CriticalDefect": workManShipModel.critical,
      "MajorDefect": workManShipModel.major,
      "MinorDefect": workManShipModel.minor,
      "CriticalType": 1,
      "MajorType": 1,
      "MinorType": 1,
      "SampleRqstCriticalRowID": "",
      "POItemHdrCriticalRowID": "",
      "Digitals": workManShipModel.digitals,
      "recAddDt": currentDate,
      "recDt": currentDate,
      "recAddUser": userId,
      "recUser": userId,
      "LocID": "DEL",
    };
developer.log("contentValues $contentValues");
    int rows = await db.update(
      "QRAuditBatchDetails",
      contentValues,
      where: "pRowID = ?",
      whereArgs: [workManShipModel.pRowID],
    );

    if (rows == 0) {
      if (workManShipModel.pRowID == null || workManShipModel.pRowID?.toLowerCase() == 'null') {
        workManShipModel.pRowID = await generatePK(FEnumerations.tableNameAuditBatchDetails);
      }

      if (workManShipModel.pRowID != null && workManShipModel.pRowID?.toLowerCase() != 'null') {
        contentValues.addAll({
          "pRowID": workManShipModel.pRowID,
          "QRHdrID": qrHdrID,
          "QRPOItemHdrID": qrPOItemHdrID,
          "ItemID": pItemID,
        });

        int inserted = await db.insert("QRAuditBatchDetails", contentValues);
        debugPrint(inserted > 0
            ? "Inserted QRAuditBatchDetails successfully."
            : "Insert failed for QRAuditBatchDetails.");
      } else {
        debugPrint("pRowID is NULL. Cannot insert QRAuditBatchDetails.");
      }
    } else {
      debugPrint("Updated QRAuditBatchDetails successfully.");
    }

    debugPrint("Returning pRowID: ${workManShipModel.pRowID}");
    return workManShipModel.pRowID;
  }

  Future<bool> deleteWorkmanship(String pRowID) async {
    String userId = await UserMasterTable().getFirstUserID() ?? "";

    final db = await DatabaseHelper().database;

    int count = await db.delete(
      'QRAuditBatchDetails',
      where: 'pRowID = ?',
      whereArgs: [pRowID],
    );

    if (count > 0) {
      print('DELETED QRAuditBatchDetails');
    } else {
      print('No record found to delete.');
    }
    return true;
  }



  List<POItemDtl> copyFindingDataToSpecification(
      List<POItemDtl> packDetailList, List<POItemDtl> packFindingList) {
    print('capyFindingDataToSpecification packDetail size: ${packDetailList.length}');

    if (packDetailList.isNotEmpty && packFindingList.isNotEmpty) {
      for (int i = 0; i < packFindingList.length; i++) {
        if (i < packDetailList.length) {
          if (packDetailList[i].qrpoItemHdrID == packFindingList[i].pRowID) {
            final detail = packDetailList[i];
            final finding = packFindingList[i];

            // Example of mapping fields (a few shown, continue this for all others)
            detail.pkgMeInspectionResultID = finding.pkgMeInspectionResultID;
            detail.pkgMeMasterInspectionResultID = finding.pkgMeMasterInspectionResultID;
            detail.pkgMePalletInspectionResultID = finding.pkgMePalletInspectionResultID;
            detail.pkgMeUnitInspectionResultID = finding.pkgMeUnitInspectionResultID;
            detail.pkgMeInnerInspectionResultID = finding.pkgMeInnerInspectionResultID;

            // Added by Shekhar - Application-level fields
            detail.pkgAppShippingMarkInspectionResultID = finding.pkgAppShippingMarkInspectionResultID;
            detail.pkgAppRemark = finding.pkgAppRemark;
            detail.pkgAppInspectionResultID = finding.pkgAppInspectionResultID;
            detail.pkgAppInspectionLevelID = finding.pkgAppInspectionLevelID;
            detail.pkgAppPalletInspectionResultID = finding.pkgAppPalletInspectionResultID;
            detail.pkgAppPalletSampleSizeID = finding.pkgAppPalletSampleSizeID;
            detail.pkgAppPalletSampleSizeValue = finding.pkgAppPalletSampleSizeValue;
            detail.pkgAppMasterSampleSizeID = finding.pkgAppMasterSampleSizeID;
            detail.pkgAppMasterSampleSizeValue = finding.pkgAppMasterSampleSizeValue;
            detail.pkgAppMasterInspectionResultID = finding.pkgAppMasterInspectionResultID;
            detail.pkgAppInnerSampleSizeID = finding.pkgAppInnerSampleSizeID;
            detail.pkgAppInnerSampleSizeValue = finding.pkgAppInnerSampleSizeValue;
            detail.pkgAppUnitSampleSizeID = finding.pkgAppUnitSampleSizeID;
            detail.pkgAppUnitInspectionResultID = finding.pkgAppUnitInspectionResultID;

            detail.onSiteTestRemark = finding.onSiteTestRemark;
            detail.qtyRemark = finding.qtyRemark;
            detail.onSiteTestInspectionResultID = finding.onSiteTestInspectionResultID;

            // Barcode fields
            detail.barcodeInspectionLevelID = finding.barcodeInspectionLevelID;
            detail.barcodeInspectionResultID = finding.barcodeInspectionResultID;
            detail.barcodeRemark = finding.barcodeRemark;
            detail.barcodePalletSampleSizeID = finding.barcodePalletSampleSizeID;
            detail.barcodePalletSampleSizeValue = finding.barcodePalletSampleSizeValue;
            detail.barcodePalletVisual = finding.barcodePalletVisual;
            detail.barcodePalletScan = finding.barcodePalletScan;
            detail.barcodePalletInspectionResultID = finding.barcodePalletInspectionResultID;
            detail.barcodeMasterSampleSizeID = finding.barcodeMasterSampleSizeID;
            detail.barcodeMasterSampleSizeValue = finding.barcodeMasterSampleSizeValue;
            detail.barcodeMasterVisual = finding.barcodeMasterVisual;
            detail.barcodeMasterScan = finding.barcodeMasterScan;
            detail.barcodeInnerSampleSizeID = finding.barcodeInnerSampleSizeID;
            detail.barcodeInnerSampleSizeValue = finding.barcodeInnerSampleSizeValue;
            detail.barcodeInnerVisual = finding.barcodeInnerVisual;
            detail.barcodeInnerScan = finding.barcodeInnerScan;
            detail.barcodeInnerInspectionResultID = finding.barcodeInnerInspectionResultID;
            detail.barcodeUnitSampleSizeID = finding.barcodeUnitSampleSizeID;
            detail.barcodeUnitSampleSizeValue = finding.barcodeUnitSampleSizeValue;
            detail.barcodeUnitVisual = finding.barcodeUnitVisual;
            detail.barcodeUnitScan = finding.barcodeUnitScan;
            detail.barcodeUnitInspectionResultID = finding.barcodeUnitInspectionResultID;

            // Remarks & Additional Fields
            detail.pkgMeRemark = finding.pkgMeRemark;
            detail.workmanshipInspectionResultID = finding.workmanshipInspectionResultID;
            detail.workmanshipRemark = finding.workmanshipRemark;
            detail.itemMeasurementInspectionResultID = finding.itemMeasurementInspectionResultID;
            detail.overallInspectionResultID = finding.overallInspectionResultID;
            detail.itemMeasurementRemark = finding.itemMeasurementRemark;

            // Pallet Finding
            detail.pkgMePalletFindingL = finding.pkgMePalletFindingL;
            detail.pkgMePalletFindingB = finding.pkgMePalletFindingB;
            detail.pkgMePalletFindingH = finding.pkgMePalletFindingH;
            detail.pkgMePalletFindingWt = finding.pkgMePalletFindingWt;
            detail.pkgMePalletFindingCBM = finding.pkgMePalletFindingCBM;
            detail.pkgMePalletFindingQty = finding.pkgMePalletFindingQty;

            // Master Finding
            detail.pkgMeMasterFindingL = finding.pkgMeMasterFindingL;
            detail.pkgMeMasterFindingB = finding.pkgMeMasterFindingB;
            detail.pkgMeMasterFindingH = finding.pkgMeMasterFindingH;
            detail.pkgMeMasterFindingWt = finding.pkgMeMasterFindingWt;
            detail.pkgMeMasterFindingCBM = finding.pkgMeMasterFindingCBM;
            detail.pkgMeMasterFindingQty = finding.pkgMeMasterFindingQty;

            // Inner Finding
            detail.pkgMeInnerFindingL = finding.pkgMeInnerFindingL;
            detail.pkgMeInnerFindingB = finding.pkgMeInnerFindingB;
            detail.pkgMeInnerFindingH = finding.pkgMeInnerFindingH;
            detail.pkgMeInnerFindingWt = finding.pkgMeInnerFindingWt;
            detail.pkgMeInnerFindingCBM = finding.pkgMeInnerFindingCBM;
            detail.pkgMeInnerFindingQty = finding.pkgMeInnerFindingQty;

            // Unit Finding
            detail.pkgMeUnitFindingL = finding.pkgMeUnitFindingL;
            detail.pkgMeUnitFindingB = finding.pkgMeUnitFindingB;
            detail.pkgMeUnitFindingH = finding.pkgMeUnitFindingH;
            detail.pkgMeUnitFindingWt = finding.pkgMeUnitFindingWt;
            detail.pkgMeUnitFindingCBM = finding.pkgMeUnitFindingCBM;

            // Sample Size IDs
            detail.pkgMeInnerSampleSizeID = finding.pkgMeInnerSampleSizeID;
            detail.pkgMeUnitSampleSizeID = finding.pkgMeUnitSampleSizeID;
            detail.pkgMePalletSampleSizeID = finding.pkgMePalletSampleSizeID;
            detail.pkgMeMasterSampleSizeID = finding.pkgMeMasterSampleSizeID;
            detail.pkgAppShippingMarkSampleSizeId = finding.pkgAppShippingMarkSampleSizeId;
          }
        }
      }
    }

    return packDetailList;
  }

  Future<String> updateItemMeasurement(

      ItemMeasurementModal itemMeasurementModal,
      POItemDtl poItemDtl,
      ) async {
    int status = 0;

    try {
      final db = await DatabaseHelper().database;
      String userId = await UserMasterTable().getFirstUserID() ?? "";
      Map<String, dynamic> contentValues = {
        "ItemMeasurementDescr": itemMeasurementModal.itemMeasurementDescr,
        "Dim_Height": itemMeasurementModal.dimHeight,
        "Dim_Width": itemMeasurementModal.dimWidth,
        "Dim_length": itemMeasurementModal.dimLength,
        "SampleSizeValue": itemMeasurementModal.sampleSizeValue,
        "SampleSizeID": itemMeasurementModal.sampleSizeID,
        "InspectionResultID": itemMeasurementModal.inspectionResultID,
        "Tolerance_Range": itemMeasurementModal.toleranceRange,
        "Digitals": itemMeasurementModal.digitals,
        "recDt": AppConfig.getCurrentDate(), // You'll need to implement this
        "LocID": FClientConfig.locID,
        "recUser": userId,
      };

      if (itemMeasurementModal.pRowID == null ||
          itemMeasurementModal.pRowID!.isEmpty ||
          itemMeasurementModal.pRowID!.toLowerCase() == 'null') {
        itemMeasurementModal.pRowID = await generatePK(

          FEnumerations.tableItemMeasurement,
        );
      }

      if (itemMeasurementModal.pRowID != null &&
          itemMeasurementModal.pRowID!.length == 10) {
        int rowsUpdated = await db.update(
          'QRPOItemDtl_ItemMeasurement',
          contentValues,
          where: 'pRowID = ?',
          whereArgs: [itemMeasurementModal.pRowID],
        );

        if (rowsUpdated == 0) {
          contentValues["pRowID"] = itemMeasurementModal.pRowID;
          contentValues["QRHdrID"] = poItemDtl.qrHdrID;
          contentValues["QRPOItemHdrID"] = poItemDtl.qrpoItemHdrID;

          status = await db.insert('QRPOItemDtl_ItemMeasurement', contentValues);
          print("Insert QRPOItemDtl_ItemMeasurement");
        } else {
          status = 1;
          print("Update QRPOItemDtl_ItemMeasurement");
        }
      } else {
        print("Could not update QRPOItemDtl_ItemMeasurement because pRowID is NULL");
      }


    } catch (e) {
      print("Exception in updateItemMeasurement: $e");
    }

    print("Return ID from updating QRPOItemDtl_ItemMeasurement: ${itemMeasurementModal.pRowID}");
    return itemMeasurementModal.pRowID!;
  }


  Future<bool> deleteItemMeasurement(String pRowID) async {
    try {
      final db = await DatabaseHelper().database;
      final int count = await db.delete(
        'QRPOItemDtl_ItemMeasurement',
        where: 'pRowID = ?',
        whereArgs: [pRowID],
      );

      print('Deleted $count row(s) from QRPOItemDtl_ItemMeasurement');
      return true;
    } catch (e) {
      print('Error deleting item measurement: $e');
      return false;
    }
  }

  Future<bool> deleteFindingItemMeasurement(String pRowID) async {
    try {
      final db = await DatabaseHelper().database;
      int result = await db.delete(
        'QRFindings',
        where: 'pRowID = ?',
        whereArgs: [pRowID],
      );

      if (result > 0) {
        print('Deleted $result record(s) from QRFindings.');
      } else {
        print('No record found with pRowID = $pRowID');
      }

      return true;
    } catch (e) {
      print('Error deleting from QRFindings: $e');
      return false;
    }
  }

  Future<int> updateFindingItemMeasurement(
      ItemMeasurementModal itemMeasurementModal,
      POItemDtl poItemDtl,
      ) async {
    final db = await DatabaseHelper().database;
    String userId = await UserMasterTable().getFirstUserID() ?? "";
    int status = 0;

    String? findingRowId = itemMeasurementModal.pRowIDForFinding;

    if (findingRowId == null || findingRowId.toLowerCase() == 'null') {
      findingRowId = await generatePK("QRFindings"); // Implement this
      itemMeasurementModal.pRowIDForFinding = findingRowId;
    }

    final contentValues = <String, dynamic>{
      "Descr": itemMeasurementModal.itemMeasurementDescr,
      "New_Height": itemMeasurementModal.dimHeight ?? 0,
      "New_Width": itemMeasurementModal.dimWidth ?? 0,
      "New_Length": itemMeasurementModal.dimLength ?? 0,
      "OLD_Height": itemMeasurementModal.oldHeight ?? 0,
      "OLD_Width": itemMeasurementModal.oldWidth ?? 0,
      "OLD_Length": itemMeasurementModal.oldLength ?? 0,
      "SampleSizeID": itemMeasurementModal.sampleSizeID,
      "LocID": FClientConfig.locID,
      "recUser": userId,
      "recDt": AppConfig.getCurrentDate(), // Implement this
    };

    final rowsUpdated = await db.update(
      "QRFindings",
      contentValues,
      where: "pRowID = ?",
      whereArgs: [findingRowId],
    );

    if (rowsUpdated == 0) {
      if (findingRowId.isNotEmpty && findingRowId.toLowerCase() != 'null') {
        contentValues["pRowID"] = findingRowId;
        contentValues["MeasurementID"] = itemMeasurementModal.pRowID;
        contentValues["QrHdrID"] = poItemDtl.qrHdrID;
        contentValues["QRPOItemHdrID"] = poItemDtl.qrpoItemHdrID;

        status = await db.insert("QRFindings", contentValues);
        print("Inserted into QRFindings");
      } else {
        print("Cannot insert — pRowID is null");
      }
    } else {
      status = 1;
      print("Updated QRFindings");
    }

    return status;
  }

  Future<List<ItemMeasurementModal>> getFindingItemMeasurementList(
      ItemMeasurementModal itemMeasurementModal) async {
    final db = await DatabaseHelper().database;
    List<ItemMeasurementModal> findingsList = [];

    final result = await db.query(
      "QRFindings",
      where: "MeasurementID = ?",
      whereArgs: [itemMeasurementModal.pRowID],
    );

    for (final row in result) {
      final finding = ItemMeasurementModal()
        ..pRowIDForFinding = row["pRowID"] as String?
        ..qrHdrID = row["QrHdrID"] as String?
        ..qrpoItemHdrID = row["QRPOItemHdrID"] as String?
        ..itemMeasurementDescr = row["Descr"] as String?
        ..dimHeight = (row["New_Height"] as num?)?.toDouble() ?? 0.0
        ..dimWidth = (row["New_Width"] as num?)?.toDouble() ?? 0.0
        ..dimLength = (row["New_Length"] as num?)?.toDouble() ?? 0.0
        ..oldHeight = (row["OLD_Height"] as num?)?.toDouble() ?? 0.0
        ..oldWidth = (row["OLD_Width"] as num?)?.toDouble() ?? 0.0
        ..oldLength = (row["OLD_Length"] as num?)?.toDouble() ?? 0.0
        ..sampleSizeID = row["SampleSizeID"] as String?
        ..pRowID = row["MeasurementID"] as String?;


      findingsList.add(finding);
    }

    return findingsList;
  }


  Future<List<ItemMeasurementModal>> getItemMeasurementList(
        String pItemHdrID, String pInspectionID) async {
    List<ItemMeasurementModal> itemList = [];

    try {
      final db = await DatabaseHelper().database;
      String userId = await UserMasterTable().getFirstUserID() ?? "";

      String query = '''
      SELECT pRowID, LocID, ItemID, QRHdrID, QRPOItemHdrID,
        IFNULL(ItemMeasurementDescr, '') AS ItemMeasurementDescr,
        IFNULL(Dim_Height, 0) AS Dim_Height,
        IFNULL(Dim_Width, 0) AS Dim_Width,
        IFNULL(Dim_length, 0) AS Dim_length,
        IFNULL(SampleSizeID, '') AS SampleSizeID,
        IFNULL(SampleSizeValue, '') AS SampleSizeValue,
        IFNULL(Finding, '0') AS Finding,
        IFNULL(InspectionResultID, '') AS InspectionResultID,
        IFNULL(Tolerance_Range, '') AS Tolerance_Range,
        recEnable, recAddDt, recDt, recUser,
        IFNULL(Digitals, '') AS Digitals
      FROM QRPOItemDtl_ItemMeasurement
      WHERE QRHdrID = ? AND QRPOItemHdrID = ? AND recEnable = 1
    ''';

      final List<Map<String, dynamic>> results =
      await db.rawQuery(query, [pItemHdrID, pInspectionID]);
      developer.log("ItemMeasurementModal measurements ${(results)}");
      for (final row in results) {
        final item = ItemMeasurementModal(
          pRowID: row['pRowID'],
          qrHdrID: row['QRHdrID'],
          qrpoItemHdrID: row['QRPOItemHdrID'],
          itemMeasurementDescr: row['ItemMeasurementDescr'],
          dimHeight: (row['Dim_Height'] as num).toDouble(),
          dimWidth: (row['Dim_Width'] as num).toDouble(),
          dimLength: (row['Dim_length'] as num).toDouble(),
          oldHeight: (row['Dim_Height'] as num).toDouble(),
          oldWidth: (row['Dim_Width'] as num).toDouble(),
          oldLength: (row['Dim_length'] as num).toDouble(),
          sampleSizeValue: row['SampleSizeValue']?.toString(),
          sampleSizeID: row['SampleSizeID'],
          inspectionResultID: row['InspectionResultID'],
          toleranceRange: row['Tolerance_Range']?.toString(),
          digitals: row['Digitals'],
          // Optional fields below can be added based on additional data
          // pRowIDForFinding: '',
          // activity: '',
          // inspectionDate: '',
        );


        // Parse Digitals string to fetch image data
        if (item.digitals != null && item.digitals != 'null') {
          final imageIds = item.digitals!.split(',');
          for (final id in imageIds) {
            if (id.trim().isNotEmpty) {
              final image = await getImageAccordingToItem(id.trim(), item.pRowID ?? '');
              if (image != null) {
                item.listImages?.add(image);
              }
            }
          }
        }

        itemList.add(item);
      }

      debugPrint("Item list fetched: ${itemList.length}");
    } catch (e) {
      debugPrint("Error in getItemMeasurementList: $e");
    }

    return itemList;
  }


 
  Future<List<IntimationModal>> getIntimationList(  String qrHdrID) async {
    List<IntimationModal> intimationList = [];
    final db = await DatabaseHelper().database;
    try {
      String query = "SELECT * FROM QRPOIntimationDetails WHERE QRHdrID = ?";
      List<Map<String, dynamic>> result = await db.rawQuery(query, [qrHdrID]);

      for (var row in result) {
        intimationList.add(IntimationModal.fromMap(row));
      }

      print("Count of found intimation items: ${intimationList.length}");
    } catch (e) {
      print("Error in getIntimationList: $e");
    }

    return intimationList;
  }

  Future<int> updateOrInsertQRPOIntimationDetails(IntimationModal intimation) async {
    int status = 0;
    final db = await DatabaseHelper().database;

    try {
      String userId = await UserMasterTable().getFirstUserID() ?? "";
      final String currentDate = AppConfig.getCurrentDate();

      // Generate pRowID if it's null or empty
      if (intimation.pRowId == null || intimation.pRowId == 'null' || intimation.pRowId!.isEmpty) {
        intimation.pRowId = await generatePK('QRPOIntimationDetails');
        print('Generated new pRowID: ${intimation.pRowId}');
      }

      Map<String, dynamic> contentValues = {
        'pRowID': intimation.pRowId,
        'LocID': FClientConfig.locID,
        'QRHdrID': intimation.qrHdrId,
        'Name': intimation.name ?? '',
        'EmailID': intimation.emailId ?? '',
        'ID': intimation.id ?? '',
        'recAddUser': userId,
        'recAddDt': currentDate,
        'recUser': userId,
        'recDt': currentDate,
        'BE_pRowID': intimation.bePRowId ?? '',
        'IsLink': intimation.isLink ?? 0,
        'IsReport': intimation.isReport ?? 0,
        'recType': intimation.recType ?? 0,
        'recEnable': intimation.recEnable ?? 1,
        'IsHtmlLink': intimation.isHtmlLink ?? 0,
        'IsRcvApplicable': intimation.isRcvApplicable ?? 0,
        'IsSelected': intimation.isSelected ?? 0,
      };

      // Remove null values to avoid database errors
      contentValues.removeWhere((key, value) => value == null);

      print('Attempting to insert/update with pRowID: ${intimation.qrHdrId}');
      print('Content values: $contentValues');

      // First try to update existing record
      int rows = await db.update(
        'QRPOIntimationDetails',
        contentValues,
        where: 'pRowID = ?',
        whereArgs: [intimation.pRowId],
      );

      if (rows == 0) {
        // No existing record found, insert new one
        print('No existing record found, inserting new record');
        final insertResult = await db.insert('QRPOIntimationDetails', contentValues);
        if (insertResult > 0) {
          status = 2; // inserted
          print('✅ Insert into QRPOIntimationDetails successful with pRowID: ${intimation.pRowId}');
        } else {
          print('❌ Insert into QRPOIntimationDetails failed - insert returned: $insertResult');
          status = 0; // failed
        }
      } else {
        status = 1; // updated
        print('✅ Update QRPOIntimationDetails successful with pRowID: ${intimation.pRowId}');
      }
    } catch (e) {
      print('❌ Error in updateOrInsertQRPOIntimationDetails: $e');
      status = 0; // failed
    }

    return status;
  }




 static Future<int> updateItemMeasurementRemark(  POItemDtl poItemDtl) async {
    int status = 0;
    try {
      final db = await DatabaseHelper().database;
      String userId = await UserMasterTable().getFirstUserID() ?? "";
      final values = {
        'ItemMeasurement_Remark': poItemDtl.itemMeasurementRemark,
      };

      int rows = await db.update(
        'QRPOItemHdr',
        values,
        where: 'pRowID = ?',
        whereArgs: [poItemDtl.qrpoItemHdrID],
      );

      if (rows > 0) {
        status = 1;
        print("update item Measurement");
      } else {
        print("COULD NOT update item Measurement");
      }
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
    return status;
  }

 static Future<int> updateWorkmanshipRemark(  POItemDtl poItemDtl) async {
    int status = 0;
    try {
      final db = await DatabaseHelper().database;
      String userId = await UserMasterTable().getFirstUserID() ?? "";
      final values = {
        'WorkmanShip_Remark': poItemDtl.workmanshipRemark,
      };

      int rows = await db.update(
        'QRPOItemHdr',
        values,
        where: 'pRowID = ?',
        whereArgs: [poItemDtl.qrpoItemHdrID],
      );

      if (rows > 0) {
        status = 1;
        print("update workmanship");
      } else {
        print("COULD NOT update workmanship");
      }
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
    return status;
  }

  Future<int> updateWorkmanshipOverAllResult(  POItemDtl poItemDtl) async {
    int status = 0;
    try {
      final db = await DatabaseHelper().database;
      String userId = await UserMasterTable().getFirstUserID() ?? "";
      final values = {
        'WorkmanShip_InspectionResultID': poItemDtl.workmanshipInspectionResultID,
        'ItemMeasurement_InspectionResultID': poItemDtl.itemMeasurementInspectionResultID,
        'Overall_InspectionResultID': poItemDtl.overallInspectionResultID,
      };

      int rows = await db.update(
        'QRPOItemHdr',
        values,
        where: 'pRowID = ?',
        whereArgs: [poItemDtl.qrpoItemHdrID],
      );

      if (rows > 0) {
        status = 1;
        print("update InspectionResultID");
      } else {
        print("COULD NOT update WorkmanShip_InspectionResultID");
      }
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
    return status;
  }
  Future<int> updateOverAllResult(  POItemDtl poItemDtl) async {
    int status = 0;
    try {
      final db = await DatabaseHelper().database;
      String userId = await UserMasterTable().getFirstUserID() ?? "";
      String? OverAllId = poItemDtl.overallInspectionResultID;
      final values = {
        'Overall_InspectionResultID': OverAllId
      };

      int rows = await db.update(
        'QRPOItemHdr',
        values,
        where: 'pRowID = ?',
        whereArgs: [poItemDtl.qrpoItemHdrID],
      );

      if (rows > 0) {
        status = 1;
        print("update InspectionResultID $OverAllId");
      } else {
        print("COULD NOT update WorkmanShip_InspectionResultID");
      }
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
    return status;
  }

  Future<List<EnclosureModal>> getSyncEnclosureList(  String qrHdrID) async {
    List<EnclosureModal> itemArrayList = [];
    final db = await DatabaseHelper().database;
    try {


      final String query = '''
      SELECT DISTINCT EnclRowID AS pRowID,
             IFNULL(contextDs, '') AS contextDs,
             IFNULL(Encltype, '') AS Encltype,
             IFNULL(Title, '') AS Title,
             IFNULL(ImageName, '') AS ImageName,
             IFNULL(EnclFileType, '') AS EnclFileType,
             IFNULL(ImagePathID, '') AS ImagePathID,
             IFNULL(ContextDs2, '') AS ContextDs2,
             IFNULL(ContextDs3, '') AS ContextDs3,
             IsImportant,
             IsRead
      FROM Enclosures
      WHERE QRHdrID = ? AND IsRead = 0
    ''';

      final List<Map<String, dynamic>> result = await db.rawQuery(query, [qrHdrID]);
      developer.log("QR Header ID nqrHrid : $result ");
      for (var row in result) {
        final imageName = row['ImageName'] as String? ?? '';
        final extParts = imageName.split('.');
        String? fileExt = extParts.length > 1 ? '.${extParts.last}' : null;

        itemArrayList.add(EnclosureModal(
          enclRowId: row['pRowID'],
          contextDs: row['contextDs'],
          enclType: row['Encltype'],
          title: row['Title'],
          imageName: imageName,
          fileExt: fileExt,
          enclFileType: row['EnclFileType'],
          imagePathId: row['ImagePathID'],
          contextDs2: row['ContextDs2'],
          contextDs3: row['ContextDs3'],
          isImportant: row['IsImportant'] as int?,
          isRead: row['IsRead'] as int?,
        ));
      }

      print("Found ${itemArrayList.length} enclosures.");
    } catch (e) {
      print("Error in getSyncEnclosureList: $e");
    }

    return itemArrayList;
  }





  Future<bool> updateEnclosure(

      InspectionModal inspectionModal,
      EnclosureModal enclosureModal,
      ) async {
    try {
      final db = await DatabaseHelper().database;
      String userId = await UserMasterTable().getFirstUserID() ?? "";

      final Map<String, dynamic> contentValues = {
        "ContextID": inspectionModal.pRowID,
        "EnclType": enclosureModal.enclType,
        "ImageName": enclosureModal.imageName,
        "FileName": enclosureModal.fileName,
        "ImageExtn": enclosureModal.fileExt,
        "Title": enclosureModal.title,
        "fileContent": enclosureModal.fileContent,
        "numVal1": enclosureModal.numVal1,
        "recDirty": 1,
        "recEnable": 1,
        "recUser": userId,
        "recAddDt": AppConfig.getCurrentDate(),
        "recDt": AppConfig.getCurrentDate(),
      };

      final int rows = await db.update(
        "QREnclosure",
        contentValues,
        where: "pRowID = ?",
        whereArgs: [enclosureModal.pRowId],
      );

      if (rows == 0) {
        contentValues.addAll({
          "LocID": FClientConfig.locID,
          "pRowID": enclosureModal.pRowId,
        });

        final int status = await db.insert("QREnclosure", contentValues);
        if (status > 0) {
          FslLog.d("TAG", "insert QREnclosure $status");
        } else {
          FslLog.d("TAG", "NOT insert QREnclosure");
        }
      } else {
        FslLog.d("TAG", "update QREnclosure");
      }


      return true;
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

/*  Future<List<ItemMeasurementModal>> getItemMeasurementList(
      String pItemHdrID, String pInspectionID) async {
    final db = await DatabaseHelper().database;
    String userId = await UserMasterTable().getFirstUserID() ?? "";

    List<ItemMeasurementModal> itemList = [];

    final query = '''
    SELECT pRowID, LocID, ItemID, QRHdrID, QRPOItemHdrID,
      IFNULL(ItemMeasurementDescr,'') AS ItemMeasurementDescr,
      IFNULL(Dim_Height,0) AS Dim_Height, IFNULL(Dim_Width,0) AS Dim_Width, IFNULL(Dim_length,0) AS Dim_length,
      IFNULL(SampleSizeID,'') AS SampleSizeID, IFNULL(SampleSizeValue,'') AS SampleSizeValue,
      IFNULL(Finding,'0') AS Finding, IFNULL(InspectionResultID,'') AS InspectionResultID,
      IFNULL(Tolerance_Range,'') AS Tolerance_Range, recEnable, recAddDt, recDt, recUser,
      IFNULL(Digitals,'') AS Digitals
    FROM QRPOItemDtl_ItemMeasurement
    WHERE QRHdrID = ? AND QRPOItemHdrID = ? AND recEnable = 1
  ''';

    final result = await db.rawQuery(query, [pItemHdrID, pInspectionID]);
    for (final row in result) {
      final item = ItemMeasurementModal.fromJson(row);

      // Parse Digitals string to fetch image data
      if (item.digitals != null && item.digitals != 'null') {
        final imageIds = item.digitals!.split(',');
        for (final id in imageIds) {
          if (id.trim().isNotEmpty) {
            final image = await getImageAccordingToItem(id.trim(), item.pRowID ?? '');
            if (image != null) {
              item.listImages?.add(image);
            }
          }
        }
      }

      itemList.add(item);
    }

    return itemList;
  }*/

  Future<List<ItemMeasurementModal>> getItemMeasurementHistoryList(
      String pItemHdrID) async {
    final db = await DatabaseHelper().database;

    List<ItemMeasurementModal> itemList = [];

    final query = '''
    SELECT IFNULL(QrItem.QrhdrID,'') AS QrhdrID,
      IFNULL(QrHistory.ActivityDs,'') AS ActivityDs,
      QrHistory.RefQRHdrID,
      IFNULL(QrHistory.InspectionDt,'') AS InspectionDt,
      QrItem.pRowID, QrItem.LocID, QrItem.ItemID, QrItem.QRHdrID, QrItem.QRPOItemHdrID,
      IFNULL(QrItem.ItemMeasurementDescr,'') AS ItemMeasurementDescr,
      IFNULL(QrItem.Dim_Height,0) AS Dim_Height,
      IFNULL(QrItem.Dim_Width,0) AS Dim_Width,
      IFNULL(QrItem.Dim_length,0) AS Dim_length,
      IFNULL(QrItem.SampleSizeID,'') AS SampleSizeID,
      IFNULL(QrItem.SampleSizeValue,'') AS SampleSizeValue,
      IFNULL(QrItem.Finding,'0') AS Finding,
      IFNULL(QrItem.InspectionResultID,'') AS InspectionResultID,
      IFNULL(Tolerance_Range,'') AS Tolerance_Range
    FROM QRPOItemDtl_ItemMeasurement QrItem
    INNER JOIN qrinspectionHistory QrHistory
      ON QrHistory.QRPOItemHdrId = QrItem.QRPOItemHdrID
    WHERE QrItem.recEnable = 1 AND IFNULL(QrItem.BE_pRowID, '') <> ''
      AND QrItem.QRPOItemHdrID = (
        SELECT QRPOItemHdrID FROM QRInspectionHistory
        WHERE RefQRPOItemHdrID = ? ORDER BY QRPOItemHdrID DESC LIMIT 1
      )
  ''';

    final result = await db.rawQuery(query, [pItemHdrID]);
    developer.log("ItemMeasurementModal result ${(result)}");
    for (final row in result) {
      final item = ItemMeasurementModal.fromJson(row);
      itemList.add(item);
    }

    return itemList;
  }

  Future<DigitalsUploadModel?> getImageAccordingToItem(String pRowID, String itemID) async {
    final db = await DatabaseHelper().database;
    DigitalsUploadModel? digitalsUploadModal;

    // Trim the pRowID string
    final rowID = pRowID.trim();

    // Base query
    String query = '''
    SELECT * FROM QRPOItemDtl_Image WHERE pRowID = ?
  ''';

    List<dynamic> args = [rowID];

    // Append ItemID filter if valid
    if (itemID.isNotEmpty && itemID.toLowerCase() != 'null') {
      query += ' AND ItemID = ?';
      args.add(itemID);
    }

    final result = await db.rawQuery(query, args);

    if (result.isNotEmpty) {
      final row = result.first;
      digitalsUploadModal = DigitalsUploadModel.fromJson(row);
    }

    return digitalsUploadModal;
  }


  static Future<List<EnclosureModal>> getQREnclosureList( String pRowId) async {
  List<EnclosureModal> itemList = [];
  final db = await DatabaseHelper().database;
  try {
  String query = '''
        SELECT pRowID, ContextID, EnclType, Title, ImageName, ImageExtn, FileName, fileContent
        FROM QREnclosure
        WHERE ContextID = ?
      ''';

  List<Map<String, dynamic>> result = await db.rawQuery(query, [pRowId]);

  for (var row in result) {
  EnclosureModal enclosure = EnclosureModal();
  enclosure.pRowId = row['pRowID'];
  enclosure.contextId = row['ContextID'];
  enclosure.enclType = row['EnclType'];
  enclosure.title = row['Title'];
  enclosure.imageName = row['ImageName'];
  enclosure.fileExt = row['ImageExtn'];
  enclosure.fileName = row['FileName'];
  enclosure.fileContent = row['fileContent'];

  itemList.add(enclosure);
  }
  } catch (e) {
  print('Error in getQREnclosureList: $e');
  }

  return itemList;
  }

  static Future<bool> deleteEnclosure( String pRowID) async {
  try {
    final db = await DatabaseHelper().database;
  int count = await db.delete('QREnclosure', where: 'pRowID = ?', whereArgs: [pRowID]);
  return count > 0;
  } catch (e) {
  print('Error deleting enclosure: $e');
  return false;
  }
  }

    Future<List<EnclosureModal>> getEnclosureList(  String qrHdrID, String qrPOItemHdrID) async {
  List<EnclosureModal> itemList = [];
  final db = await DatabaseHelper().database;
  try {
  String query = '''
        SELECT DISTINCT EnclRowID AS pRowID,
          IFNULL(contextDs, '') AS contextDs,
          IFNULL(Encltype, '') AS Encltype,
          IFNULL(Title, '') AS Title,
          IFNULL(ImageName, '') AS ImageName,
          IFNULL(EnclFileType, '') AS EnclFileType,
          IFNULL(ImagePathID, '') AS ImagePathID,
          IFNULL(ContextDs2, '') AS ContextDs2,
          IFNULL(ContextDs3, '') AS ContextDs3,
          IsImportant,
          IsRead
        FROM Enclosures
        WHERE (IFNULL(QRPOItemHdrId, '') = ? OR IFNULL(QRPOItemHdrId, '') = '')
          AND QRHdrID = ?
      ''';

  List<Map<String, dynamic>> result = await db.rawQuery(query, [qrPOItemHdrID, qrHdrID]);
developer.log("getEnclosureList ImageName $result");
  for (var row in result) {
  EnclosureModal enclosure = EnclosureModal();
  enclosure.enclRowId = row['pRowID'];
  enclosure.contextDs = row['contextDs'];
  enclosure.enclType = row['Encltype'];
  enclosure.title = row['Title'];
  enclosure.imageName = row['ImageName'];

  if (enclosure.imageName != null && enclosure.imageName!.contains('.')) {
  enclosure.fileExt = '.' + enclosure.imageName!.split('.').last;
  }

  enclosure.enclRowId = row['EnclFileType'];
  enclosure.imagePathId = row['ImagePathID'];
  enclosure.contextDs2 = row['ContextDs2'];
  enclosure.contextDs3 = row['ContextDs3'];
  enclosure.isImportant = row['IsImportant'];
  enclosure.isRead = row['IsRead'];

  itemList.add(enclosure);
  }
  } catch (e) {
  print('Error in getEnclosureList: $e');
  }

  return itemList;
  }

  Future<List<String>> generatePKBatch(String tableName, int count) async {
    String locID = FClientConfig.locID;
    String startPRowID = await maxId(tableName);

    // Extract numeric part
    int baseNo = int.parse(startPRowID.substring(3, 10));
    List<String> ids = [];

    for (int i = 1; i <= count; i++) {
      int genNo = baseNo + i;
      String padded = genNo.toString().padLeft(7, '0');
      ids.add('$locID$padded');
    }

    return ids;
  }

  Future<String> generatePK(String tableName) async {
    // Assuming LOC_ID is a constant or can be accessed like this
    String locID = FClientConfig.locID;
    String oldPRowID = await maxId(tableName);

    // Extract numeric part and increment
    int genNo = int.parse(oldPRowID.substring(3, 10)) + 1;

    // Pad with leading zeros to maintain length
    String addNo = '0000000$genNo';
    String s = genNo.toString();
    String numbers = addNo.substring(s.length);

    String pRowID = locID + numbers;

    print('PK generated: $pRowID');
    FslLog.d('TAG', 'Generated pRowID ............ $pRowID');

    return pRowID;
  }

  Future<String> maxId(String tableName) async {
    String pRowID = '0000000000';

    try {
      final db = await DatabaseHelper().database;
      final List<Map<String, dynamic>> result = await db.rawQuery(
          "SELECT IFNULL(MAX(pRowID), '0000000000') AS pRowID FROM $tableName");

      if (result.isNotEmpty &&
          result[0]['pRowID'] != null &&
          result[0]['pRowID'] != 'null') {
        pRowID = result[0]['pRowID'];
      }

      print('Max pRowID from DB: $pRowID');
    } catch (e) {
      print('Error getting max pRowID: $e');
    }

    return pRowID;
  }

  Future<void> updateFinalSync(String pRowID) async {
    final db = await DatabaseHelper().database;

    final String currentDate = AppConfig.getCurrentDate();

    const String query = '''
    UPDATE QRFeedBackHdr
    SET Last_Sync_Dt = ?, IsSynced = 1
    WHERE pRowID = ?
  ''';

    await db.rawUpdate(query, [currentDate, pRowID]);

    print('✅ updateFinalSync: Record updated for pRowID = $pRowID');
  }

  Future<List<DigitalsUploadModel>> getImageTitle(
      String qrHdrID, String qrPOItemHdrID) async {
    List<DigitalsUploadModel> lDigitalsUploadModels = [];
    final db = await DatabaseHelper().database;
    try {
      String query = '''
      SELECT DISTINCT MIN(tbl.pRowID) AS pRowID, tbl.Title
      FROM (
        SELECT 0 AS Section, 'None' AS SectionDescr, '0_' AS pRowID, '[None]' AS Title
        UNION
        SELECT DISTINCT 1 AS Section, 'WorkManship' AS SectionDescr, '1_' || IFNULL(QRDtl.pRowID,'') AS pRowID, 
          IFNULL(DM.DefectName, IFNULL(QRDtl.DefectName,'')) AS Title
        FROM QRAuditBatchDetails QRDtl
        LEFT JOIN DefectMaster DM ON DM.pRowID = QRDtl.DefectID
        LEFT JOIN GenMst gdDCLType ON gdDCLType.pGenRowID = IFNULL(DM.DCLTypeID, QRDtl.DCLTypeID)
        WHERE QRDtl.QRPOItemHdrID = ?
          AND IFNULL(QRDtl.SampleRqstCriticalRowID,'') = ''
          AND IFNULL(QRDtl.POItemHdrCriticalRowID,'') = ''
          AND IFNULL(QRDtl.BE_pRowID,'') = ''
        UNION
        SELECT DISTINCT 2 AS Section, 'ItemMeasurement' AS SectionDescr, '2_' || pRowID, IFNULL(ItemMeasurementDescr,'') AS Title
        FROM QRPOItemDtl_ItemMeasurement
        WHERE QRHDrID = ? AND QRPOItemHdrID = ? AND recEnable = 1
        UNION
        SELECT DISTINCT 3 AS Section, 'Quality Parameter' AS SectionDescr, '3_' || IFNULL(QRParam.pRowID,'') AS pRowID,
          IFNULL(gm.MainDescr,'') AS Title
        FROM GenMst gm
        INNER JOIN QRQualiltyParameterFields QRParam ON QRParam.QualityParameterID = gm.pGenRowID
        WHERE gm.GenId = '555' AND QRParam.QRHdrID = ?
          AND IFNULL(QRParam.QRPOItemHdrID,'') = ?
          AND (gm.numVal2 > 5 OR gm.numVal2 < 5)
          AND gm.numVal5 > 0
          AND IFNULL(CAST(gm.chrVal3 AS INTEGER), 0) = 1
        UNION
        SELECT DISTINCT 4 AS Section, 'Image' AS SectionDescr, '4_' || IFNULL(img.pRowID,'') AS pRowID,
          IFNULL(img.Title,'') AS Title
        FROM QRPOItemDtl_Image img
        WHERE img.QRPOItemHdrID = ? AND IFNULL(img.Title,'') <> '' AND img.recEnable = 1
        UNION
        SELECT DISTINCT 6 AS Section, 'Fitness Check' AS SectionDescr, '6_' || IFNULL(QRFitness.pRowID,'') AS pRowID,
          IFNULL(gm.MainDescr,'') AS Title
        FROM GenMst gm
        INNER JOIN QRPOItemFitnessCheck QRFitness ON QRFitness.QRFitnessCheckID = gm.pGenRowID
        WHERE gm.GenId = '595' AND QRFitness.QRHdrID = ?
          AND IFNULL(QRFitness.QRPOItemHdrID,'') = ?
          AND IFNULL(CAST(gm.chrVal3 AS INTEGER), 0) = 1
      ) tbl
      GROUP BY tbl.Title
      ORDER BY tbl.Section
    ''';

      List<Map<String, dynamic>> result = await db.rawQuery(query, [
        qrPOItemHdrID.trim(), // for QRDtl.QRPOItemHdrID
        qrHdrID.trim(), // for QRPOItemDtl_ItemMeasurement.QRHDrID
        qrPOItemHdrID.trim(), // for QRPOItemDtl_ItemMeasurement.QRPOItemHdrID
        qrHdrID.trim(), // for QRQualiltyParameterFields.QRHdrID
        qrPOItemHdrID.trim(), // for QRQualiltyParameterFields.QRPOItemHdrID
        qrPOItemHdrID.trim(), // for QRPOItemDtl_Image.QRPOItemHdrID
        qrHdrID.trim(), // for QRPOItemFitnessCheck.QRHdrID
        qrPOItemHdrID.trim(), // for QRPOItemFitnessCheck.QRPOItemHdrID
      ]);

      for (var row in result) {
        lDigitalsUploadModels.add(DigitalsUploadModel(
          pRowID: row['pRowID'] ?? '',
          title: row['Title'] ?? '',
        ));
      }
    } catch (e) {
      print("Error in getImageTitle: $e");
    }

    return lDigitalsUploadModels;
  }



}
