import 'dart:convert';
import 'dart:developer' as developer;

import 'package:buyerease/config/api_route.dart';
import 'package:buyerease/database/table/user_master_table.dart';
import 'package:buyerease/model/sample_collection_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../model/defect_master_model.dart';
import '../model/on_site_modal.dart';
import '../model/po_item_dtl_model.dart';
import '../model/po_item_pkg_app_detail_model.dart';
import '../model/simple_model.dart';
import '../utils/fsl_log.dart';

import '../utils/gen_utils.dart'; // Placeholder: Define this

import 'inspection_list/ItemInspectionDetailHandler.dart'; // Placeholder: Define this

class POItemDtlHandler {
  static const String _tag = 'POItemDtlHandler';
  // Update POItemDtl in QRPOItemdtl table
  static Future<bool> updatePOItemDtl(POItemDtl poItemDtl) async {
    try {
      final db = await DatabaseHelper().database;
      final contentValues = {
        'SampleCodeID': poItemDtl.sampleCodeID,
        'AvailableQty': poItemDtl.availableQty,
        'AllowedinspectionQty': poItemDtl.allowedinspectionQty,
        'InspectedQty': poItemDtl.inspectedQty,
        'AcceptedQty': poItemDtl.acceptedQty,
        'FurtherInspectionReqd': poItemDtl.furtherInspectionReqd,
        'ShortStockQty': poItemDtl.shortStockQty,
        'recDirty': poItemDtl.recDirty,
        'recDt': ApiRoute.getCurrentDate(), // Ensure ApiRoute is defined
        'recEnable': 1,
      };

      final rows = await db.update(
        'QRPOItemdtl',
        contentValues,
        where: 'pRowID = ?',
        whereArgs: [poItemDtl.qrItemID],
      );

      if (rows == 0) {
        print('$_tag: QRPOItemdtl table NOT UPDATED...');
      } else {
        print('$_tag: QRPOItemdtl type update result: $rows');
      }
      return true;
    } catch (e) {
      print('$_tag: Exception updating QRPOItemdtl: $e');
      return false;
    }
  }

  // Update POItemDtl in QRPOItemDtl_PKG_App_Details table
  static Future<bool> updatePOItemDtlPKGAppDetails(
      POItemPkgAppDetail poItemDtl) async {
    try {
      String? userId = await UserMasterTable().getFirstUserID();
      final db = await DatabaseHelper().database;
      final contentValues = {
        'pRowID': poItemDtl.pRowID,
        'LocID': FClientConfig.locID, // Ensure FClientConfig is defined
        'DescrID': poItemDtl.descrID,
        'SampleSizeID': poItemDtl.sampleSizeID,
        'SampleSizeValue': poItemDtl.sampleSizeValue,
        'InspectionResultID': poItemDtl.inspectionResultID,
        'recDt': ApiRoute.getCurrentDate(),
        'recEnable': 1,
        'recUser': userId // Ensure LogInHandler is defined
      };

      final rows = await db.update(
        'QRPOItemDtl_PKG_App_Details',
        contentValues,
        where: 'pRowID = ?',
        whereArgs: [poItemDtl.pRowID],
      );

      if (rows == 0) {
        print('$_tag: QRPOItemDtl_PKG_App_Details table NOT UPDATED...');
      } else {
        print('$_tag: QRPOItemDtl_PKG_App_Details type update result: $rows');
      }
      return true;
    } catch (e) {
      print('$_tag: Exception updating QRPOItemDtl_PKG_App_Details: $e');
      return false;
    }
  }

  // Insert into QRPOItemDtl_PKG_App_Details table
  static Future<bool> insertPOItemDtlPKGAppDetails(
      POItemPkgAppDetail poItemDtl, POItemDtl poItemDtlItem) async {
    try {
      final db = await DatabaseHelper().database;
      final contentValues = {
        'pRowID': poItemDtl.pRowID,
    //    'LocID': FClientConfig.locID,
        'DescrID': poItemDtl.descrID,
        'SampleSizeID': poItemDtl.sampleSizeID,
        'SampleSizeValue': poItemDtl.sampleSizeValue,
        'InspectionResultID': poItemDtl.inspectionResultID,
        'recDt': ApiRoute.getCurrentDate(),
        'recEnable': 1,
      //  'recUser': LogInHandler.getUserId(),
        'QRHdrID': poItemDtlItem.qrHdrID,
        'QRPOItemHdrID': poItemDtlItem.qrpoItemHdrID,
        'QRPOItemDtlID': poItemDtlItem.pRowID,
      };

      final result =
          await db.insert('QRPOItemDtl_PKG_App_Details', contentValues);
      print('$_tag: QRPOItemDtl_PKG_App_Details table inserted: $result');
      return true;
    } catch (e) {
      print('$_tag: Exception inserting QRPOItemDtl_PKG_App_Details: $e');
      return false;
    }
  }

  // Update OnSiteModal in QRPOItemDtl_OnSite_Test table
  static Future<bool> updateOnSite(OnSIteModal onSiteModal) async {
    try {
      String? userId = await UserMasterTable().getFirstUserID();
      final db = await DatabaseHelper().database;
      final contentValues = {
        'pRowID': onSiteModal.pRowID,
        'LocID': FClientConfig.locID,
        'SampleSizeID': onSiteModal.sampleSizeID,
        'SampleSizeValue': onSiteModal.sampleSizeValue,
        'InspectionResultID': onSiteModal.inspectionResultID,
        'InspectionLevelID': onSiteModal.inspectionLevelID,
        'recDt': ApiRoute.getCurrentDate(),
        'recUser': userId
      };

      final rows = await db.update(
        'QRPOItemDtl_OnSite_Test',
        contentValues,
        where: 'pRowID = ?',
        whereArgs: [onSiteModal.pRowID],
      );

      if (rows == 0) {
        print('$_tag: QRPOItemDtl_OnSite_Test table NOT UPDATED...');
      } else {
        print('$_tag: QRPOItemDtl_OnSite_Test type update result: $rows');
      }
      return true;
    } catch (e) {
      print('$_tag: Exception updating QRPOItemDtl_OnSite_Test: $e');
      return false;
    }
  }

  // Insert into QRPOItemDtl_OnSite_Test table
  static Future<bool> insertOnSite(
      OnSIteModal onSiteModal, POItemDtl poItemDtl) async {
    try {
      final db = await DatabaseHelper().database;
      final contentValues = {
        'pRowID': onSiteModal.pRowID,
       // 'LocID': FClientConfig.locID,
        'SampleSizeID': onSiteModal.sampleSizeID,
        'OnSiteTestID': onSiteModal.onSiteTestID,
        'SampleSizeValue': onSiteModal.sampleSizeValue,
        'InspectionResultID': onSiteModal.inspectionResultID,
        'InspectionLevelID': onSiteModal.inspectionLevelID,
        'QRHdrID': poItemDtl.qrHdrID,
        'QRPOItemHdrID': poItemDtl.qrpoItemHdrID,
        'QRPOItemDtlID': poItemDtl.pRowID,
        'recDt': ApiRoute.getCurrentDate(),
        'recEnable': 1,
       // 'recUser': LogInHandler.getUserId(),
      };

      final result = await db.insert('QRPOItemDtl_OnSite_Test', contentValues);
      print('$_tag: QRPOItemDtl_OnSite_Test table insert result: $result');
      return true;
    } catch (e) {
      print('$_tag: Exception inserting QRPOItemDtl_OnSite_Test: $e');
      return false;
    }
  }

  // Delete from QRPOItemDtl_Sample_Purpose table
  static Future<bool> deleteSampleCollected(String prowId) async {
    try {
      final db = await DatabaseHelper().database;
      final rows = await db.delete(
        'QRPOItemDtl_Sample_Purpose',
        where: 'pRowID = ?',
        whereArgs: [prowId],
      );

      if (rows == 0) {
        print('$_tag: QRPOItemDtl_Sample_Purpose table NOT DELETED...');
      } else {
        print('$_tag: QRPOItemDtl_Sample_Purpose type deleted result: $rows');
      }
      return true;
    } catch (e) {
      print('$_tag: Exception deleting QRPOItemDtl_Sample_Purpose: $e');
      return false;
    }
  }

  // Update SampleCollectedModal in QRPOItemDtl_Sample_Purpose table
  static Future<bool> updateSampleCollected(
      SampleCollectedModel sampleCollectedModal) async {
    try {
      final db = await DatabaseHelper().database;
      final contentValues = {
        'pRowID': sampleCollectedModal.pRowID,
        'SamplePurposeID': sampleCollectedModal.samplePurposeID,
        'SampleNumber': sampleCollectedModal.sampleNumber,
        'recDt': ApiRoute.getCurrentDate(),
      };

      final rows = await db.update(
        'QRPOItemDtl_Sample_Purpose',
        contentValues,
        where: 'pRowID = ?',
        whereArgs: [sampleCollectedModal.pRowID],
      );

      if (rows == 0) {
        print('$_tag: QRPOItemDtl_Sample_Purpose table NOT UPDATED...');
      } else {
        print('$_tag: QRPOItemDtl_Sample_Purpose type update result: $rows');
      }
      return true;
    } catch (e) {
      print('$_tag: Exception updating QRPOItemDtl_Sample_Purpose: $e');
      return false;
    }
  }

  // Insert into QRPOItemDtl_Sample_Purpose table
  static Future<bool> insertSampleCollected(
      SampleCollectedModel sampleCollectedModal, POItemDtl poItemDtl) async {
    try {
      final db = await DatabaseHelper().database;
      final contentValues = {
        'pRowID': sampleCollectedModal.pRowID,
      //  'LocID': FClientConfig.locID,
        'SamplePurposeID': sampleCollectedModal.samplePurposeID,
        'SampleNumber': sampleCollectedModal.sampleNumber,
        'recDt': ApiRoute.getCurrentDate(),
        'QRHdrID': poItemDtl.qrHdrID,
        'QRPOItemHdrID': poItemDtl.qrpoItemHdrID,
        'QRPOItemDtlID': poItemDtl.pRowID,
        'recEnable': 1,
      //  'recUser': LogInHandler.getUserId(),
      };

      final result =
          await db.insert('QRPOItemDtl_Sample_Purpose', contentValues);
      print('$_tag: QRPOItemDtl_Sample_Purpose table insert result: $result');
      return true;
    } catch (e) {
      print('$_tag: Exception inserting QRPOItemDtl_Sample_Purpose: $e');
      return false;
    }
  }

  // Get list of SampleCollectedModal
  static Future<List<SampleCollectedModel>> getSampleCollectedList() async {
    final List<SampleCollectedModel> sampleList = [];
    try {
      final db = await DatabaseHelper().database;
      final query = 'SELECT * FROM QRPOItemDtl_Sample_Purpose';
      print('$_tag: Query for get closed sample list: $query');
      final result = await db.rawQuery(query);

      for (var row in result) {
        sampleList.add(_getSampleData(row));
      }
      print('$_tag: Count of founded sample list: ${sampleList.length}');
    } catch (e) {
      print('$_tag: Exception getting sample list: $e');
    }
    return sampleList;
  }

  static SampleCollectedModel _getSampleData(Map<String, dynamic> row) {
    return SampleCollectedModel(
      pRowID: row['pRowID'] as String?,
      locID: row['locID'] as String?, // <-- added this line
      samplePurposeID: row['SamplePurposeID'] as String?,
      sampleNumber: row['SampleNumber'] as int?,
      recDt: row['recDt'] as String?,
    );
  }


  // Get list of OnSIteModal
  static Future<List<OnSIteModal>> getOnSiteList() async {
    final List<OnSIteModal> onSiteList = [];
    try {
      final db = await DatabaseHelper().database;
      final query = 'SELECT * FROM QRPOItemDtl_OnSite_Test';
      print('$_tag: Query for get onsite list: $query');
      final result = await db.rawQuery(query);

      for (var row in result) {
        onSiteList.add(_getOnSiteData(row));
      }
      print('$_tag: Count of founded onsite list: ${onSiteList.length}');
    } catch (e) {
      print('$_tag: Exception getting onsite list: $e');
    }
    return onSiteList;
  }

  static OnSIteModal _getOnSiteData(Map<String, dynamic> row) {
    return OnSIteModal(
      pRowID: row['pRowID'] as String?,
      locID: row['LocID'] as String?,
      inspectionLevelID: row['InspectionLevelID'] as String?,
      inspectionResultID: row['InspectionResultID'] as String?,
      onSiteTestID: row['OnSiteTestID'] as String?,
      sampleSizeID: row['SampleSizeID'] as String?,
      sampleSizeValue: row['SampleSizeValue'] as String?,
      recEnable: row['recEnable'] as int?,
      recUser: row['recUser'] as String?,
      recDt: row['recDt'] as String?,
    );
  }

  // Get list of DefectMasterModel
  static Future<List<DefectMasterModel>> getDefectMasterList() async {
      final List<DefectMasterModel> defectList = [];
      try {
          final db = await DatabaseHelper().database;
          final query = 'SELECT * FROM DefectMaster';
          print('$_tag: Query for get defect master list: $query');
          final result = await db.rawQuery(query);

          for (var row in result) {
              defectList.add(_getDefectMasterData(row));
          }
          print('$_tag: Count of founded defect list: ${defectList.length}');
      } catch (e) {
          print('$_tag: Exception getting defect list: $e');
      }
      return defectList;
  }

  static DefectMasterModel _getDefectMasterData(Map<String, dynamic> row) {
      return DefectMasterModel(
          pRowID: row['pRowID'] as String?,
          defectName: row['DefectName'] as String?,
          code: row['Code'] as String?,
          dclTypeID: row['DCLTypeID'] as String?,
          recAddUser: row['recAddUser'] as String?,
          inspectionStage: row['InspectionStage'] as String?,
          chkCritical: row['chkCritical'] as int?,
          chkMajor: row['chkMajor'] as int?,
          chkMinor: row['chkMinor'] as int?,
      );
  }

  // Update POItemDtl for workmanship and carton
  static Future<bool> updatePOItemDtlOfWorkmanshipAndCarton(
      POItemDtl poItemDtl) async {
    try {
      final db = await DatabaseHelper().database;
      final contentValues = {
        'CartonsInspected': poItemDtl.cartonsInspected,
        'CartonsPacked': poItemDtl.cartonsPacked,
        'CartonsPacked2': poItemDtl.cartonsPacked2,
        'AllowedCartonInspection': poItemDtl.allowedCartonInspection,
        'recDirty': poItemDtl.recDirty,
        'recDt': ApiRoute.getCurrentDate(),
        'recEnable': 1,
      };

      final rows = await db.update(
        'QRPOItemdtl',
        contentValues,
        where: 'pRowID = ?',
        whereArgs: [poItemDtl.qrItemID],
      );

      if (rows == 0) {
        print('$_tag: QRPOItemdtl table NOT UPDATED...');
      } else {
        print('$_tag: QRPOItemdtl type update result: $rows');
      }
      return true;
    } catch (e) {
      print('$_tag: Exception updating QRPOItemdtl: $e');
      return false;
    }
  }

  // Update QRPOItemHdr for workmanship and carton
  static Future<bool> updatePOItemHdrOfWorkmanshipAndCarton(
      POItemDtl poItemDtl) async {
    try {
      final db = await DatabaseHelper().database;
      final contentValues = {
        'SampleCodeID': poItemDtl.sampleCodeID,
        'AllowedinspectionQty': poItemDtl.allowedinspectionQty,
        'InspectedQty': poItemDtl.inspectedQty,
        'CartonsInspected': poItemDtl.cartonsInspected,
        'CartonsPacked': poItemDtl.cartonsPacked,
        'AllowedCartonInspection': poItemDtl.allowedCartonInspection,
        'CriticalDefectsAllowed': poItemDtl.criticalDefectsAllowed,
        'MajorDefectsAllowed': poItemDtl.majorDefectsAllowed,
        'MinorDefectsAllowed': poItemDtl.minorDefectsAllowed,
        'recDirty': poItemDtl.recDirty,
        'recDt': ApiRoute.getCurrentDate(),
        'recEnable': 1,
      };

      final rows = await db.update(
        'QRPOItemHdr',
        contentValues,
        where: 'pRowID = ?',
        whereArgs: [poItemDtl.qrpoItemHdrID],
      );

      if (rows == 0) {
        print('$_tag: QRPOItemHdr table NOT UPDATED...');
        return false;
      } else {
        print('$_tag: QRPOItemHdr type update result: $rows');
      }
      return true;
    } catch (e) {
      print('$_tag: Exception updating QRPOItemHdr: $e');
      return false;
    }
  }

  // Update POItemDtl on inspection
  static Future<bool> updatePOItemDtlOnInspection(POItemDtl poItemDtl) async {
    try {
      final db = await DatabaseHelper().database;
      final contentValues = {
        'SampleCodeID': poItemDtl.sampleCodeID,
        'AvailableQty': poItemDtl.availableQty,
        'AllowedinspectionQty': poItemDtl.allowedinspectionQty,
        'InspectedQty': poItemDtl.inspectedQty,
        'AcceptedQty': poItemDtl.acceptedQty,
        'FurtherInspectionReqd': poItemDtl.furtherInspectionReqd,
        'ShortStockQty': poItemDtl.shortStockQty,
        'recDirty': poItemDtl.recDirty,
        'recDt': ApiRoute.getCurrentDate(),
        'recEnable': 1,
      };

      final rows = await db.update(
        'QRPOItemdtl',
        contentValues,
        where: 'pRowID = ?',
        whereArgs: [poItemDtl.qrItemID],
      );

      if (rows == 0) {
        print('$_tag: QRPOItemdtl table NOT UPDATED...');
      } else {
        print('$_tag: QRPOItemdtl type update result: $rows');
      }
      return true;
    } catch (e) {
      print('$_tag: Exception updating QRPOItemdtl: $e');
      return false;
    }
  }

  // Update QRPOItemHdr on inspection
  static Future<bool> updatePOItemHdrOnInspection(POItemDtl poItemDtl) async {
    try {
      final db = await DatabaseHelper().database;
      final contentValues = {
        'SampleCodeID': poItemDtl.sampleCodeID,
        'AllowedinspectionQty': poItemDtl.allowedinspectionQty,
        'InspectedQty': poItemDtl.inspectedQty,
        'CriticalDefectsAllowed': poItemDtl.criticalDefectsAllowed,
        'MajorDefectsAllowed': poItemDtl.majorDefectsAllowed,
        'MinorDefectsAllowed': poItemDtl.minorDefectsAllowed,
        'recDirty': poItemDtl.recDirty,
        'recDt': ApiRoute.getCurrentDate(),
        'recEnable': 1,
      };

      final rows = await db.update(
        'QRPOItemHdr',
        contentValues,
        where: 'pRowID = ?',
        whereArgs: [poItemDtl.qrpoItemHdrID],
      );

      if (rows == 0) {
        print('$_tag: QRPOItemHdr table NOT UPDATED...');
      } else {
        print('$_tag: QRPOItemHdr type update result: $rows');
      }
      return true;
    } catch (e) {
      print('$_tag: Exception updating QRPOItemHdr: $e');
      return false;
    }
  }

  // Get list of POItemDtl
  static Future<List<POItemDtl>> getItemList( BuildContext context ,String pInspectionID) async {
    final List<POItemDtl> itemList = [];
    try {
      // if (!await GenUtils.columnExistsInTable( table: 'QRPOItemdtl', columnToCheck: 'RetailPrice')) {
      //   print('$_tag: Column RetailPrice not found, altering to REAL.');
      //
      //   await GenUtils.handleToAlterAsReal('QRPOItemdtl', 'RetailPrice');
      // }

      final db = await DatabaseHelper().database;
      final query = '''
        SELECT QRItemHdr.pRowID, QRItem.RetailPrice, QRItem.pRowID QrItemID, QRItem.POItemDtlRowID, 
               QRItem.QRHdrID, QRItem.QRPOItemHdrID, QRItem.CustomerItemRef, 
               IFNULL(QRItem.ItemDescr,'') ItemDescr, IFNULL(QRItem.PONO,'') PONO, 
               QRItem.AvailableQty, IFNULL(QRItem.AcceptedQty,0) AcceptedQty, 
               QRItem.FurtherInspectionReqd, QRItem.ShortStockQty,
               IFNULL(QRItemHdr.SampleCodeID, '') as SampleCodeID, 
               IFNULL(SampleSize.MainDescr,'') as SampleSizeDescr, 
               QRItemHdr.ItemID, QRItemHdr.AllowedInspectionQty, 
               IFNULL(QRItemHdr.InspectedQty,0) InspectedQty, 
               IFNULL(QRItem.CartonsPacked2,0) CartonsPacked2, 
               IFNULL(QRItemHdr.CartonsPacked,0) CartonsPacked,
               QRItemHdr.AllowedCartonInspection, 
               IFNULL(QRItemHdr.CartonsInspected,0) CartonsInspected, 
               IFNULL(QRItemHdr.CriticalDefectsAllowed,0) CriticalDefectsAllowed, 
               IFNULL(QRItemHdr.MajorDefectsAllowed,0) MajorDefectsAllowed, 
               IFNULL(QRItem.OrderQty,0) OrderQty, 
               IFNULL(QRItemHdr.MinorDefectsAllowed,0) MinorDefectsAllowed,
               IFNULL(QRItemHdr.CriticalDefect,0) CriticalDefect, 
               IFNULL(QRItemHdr.MajorDefect,0) MajorDefect, 
               IFNULL(QRItemHdr.MinorDefect,0) MinorDefect, 
               IFNULL(QRItem.BaseMaterialID, '') As QRItemBaseMaterialID, 
               IFNULL(QRItem.BaseMaterial_AddOnInfo, '') As QRItemBaseMaterial_AddOnInfo,
               IFNULL(QRItem.EarlierInspected,0) EarlierInspected,
               IFNULL(gdResult_Barcode.MainDescr,'') As Barcode_InspectionResult, 
               IFNULL(gdResult_OnSiteTest.MainDescr,'') As OnSiteTest_InspectionResult,
               IFNULL(gdResult_Packaging.MainDescr,'') As PKG_Me_InspectionResult, 
               IFNULL(gdResult_ItemMeasurement.MainDescr,'') As ItemMeasurement_InspectionResult, 
               IFNULL(gdResult_WorkmanShip.MainDescr,'') As WorkmanShip_InspectionResult,
               IFNULL(gdResult_Overall.MainDescr,'') As Overall_InspectionResult, 
               0 As recDirty, 
               (SELECT COUNT(digitals.pRoWID) FROM QRPOItemDtl_Image digitals 
                WHERE digitals.recEnable=1 AND digitals.QrHdrID=QRItemHdr.QRHdrID 
                AND digitals.QrPOItemHdrID=QRItemHdr.pRowID) Digitals,
               IFNULL((SELECT COUNT(*) FROM Enclosures e 
                       WHERE e.QrpoItemHdrId = QRItemHdr.pRowID 
                       AND e.QrhdrID = QRHdr.pRowID 
                       AND 1 = (CASE WHEN (e.ContextType IN ('51','52') AND e.EnclType = '05') THEN 0 ELSE 1 END)),0) As EnclCount,
               1 As IsSelected, 0 As SizeBreakUP, 0 As ShipToBreakUP,
               IFNULL(QRItemHdr.testReportStatus,0) testReportStatus, 
               0 As DuplicateFlag,
               IFNULL(QRItem.HologramNo,'') As HologramNo, 
               QRItem.POMasterPackQty,
               (CASE WHEN DATE(IFNULL(QRItem.Hologram_ExpiryDt,'2010-01-01 00:00:00')) >= DATE('now','localtime') 
                     THEN 0 ELSE 1 END) As IsHologramExpired,
               QRItem.ItemRepeat
        FROM QRPOItemDtl QRItem
        INNER JOIN QRPOItemHdr QRItemHdr ON QRItemHdr.pRowID = QRItem.QRPOItemHdrID
        INNER JOIN QRFeedbackHdr QRHdr ON QRHdr.pRowID = QRItemHdr.QRHdrID
        LEFT JOIN GenMst gdResult_Overall ON gdResult_Overall.GenID = '530' 
            AND gdResult_Overall.pGenRowID = QRItemHdr.Overall_InspectionResultID
        LEFT JOIN GenMst gdResult_Barcode ON gdResult_Barcode.GenID = '530' 
            AND gdResult_Barcode.pGenRowID = QRItemHdr.Barcode_InspectionResultID
        LEFT JOIN GenMst gdResult_OnSiteTest ON gdResult_OnSiteTest.GenID = '530' 
            AND gdResult_OnSiteTest.pGenRowID = QRItemHdr.OnSiteTest_InspectionResultID
        LEFT JOIN GenMst gdResult_ItemMeasurement ON gdResult_ItemMeasurement.GenID = '530' 
            AND gdResult_ItemMeasurement.pGenRowID = QRItemHdr.ItemMeasurement_InspectionResultID
        LEFT JOIN GenMst gdResult_WorkmanShip ON gdResult_WorkmanShip.GenID = '530' 
            AND gdResult_WorkmanShip.pGenRowID = QRItemHdr.WorkmanShip_InspectionResultID
        LEFT JOIN GenMst gdResult_Packaging ON gdResult_Packaging.GenID = '530' 
            AND gdResult_Packaging.pGenRowID = QRItemHdr.PKG_Me_InspectionResultID
        LEFT JOIN GenMst SampleSize ON SampleSize.pGenRowID = QRItemHdr.SampleCodeID
        WHERE QRItem.QRHdrID = ? AND QRItem.recEnable=1
        ORDER BY QRItem.QRPOItemHdrID, QRItem.pRowID
      ''';

      final result = await db.rawQuery(query, [pInspectionID]);
      developer.log('query of get List: ${result}');
      for (var row in result) {
        final poItemDtl = POItemDtl(
          pRowID: row['QrItemID']?.toString(),
          qrHdrID: row['QRHdrID']?.toString(),
          qrpoItemHdrID: row['QRPOItemHdrID']?.toString(),
          poItemDtlRowID: row['POItemDtlRowID']?.toString(),
          sampleCodeID: row['SampleCodeID']?.toString(),
          availableQty: (row['AvailableQty'] as num?)?.toInt(),
          allowedinspectionQty: (row['AllowedInspectionQty'] as num?)?.toInt(),
          inspectedQty: (row['InspectedQty'] as num?)?.toInt(),
          acceptedQty: (row['AcceptedQty'] as num?)?.toInt(),
          furtherInspectionReqd: (row['FurtherInspectionReqd'] as num?)?.toInt(),
          shortStockQty: (row['ShortStockQty'] as num?)?.toInt(),
          cartonsInspected: (row['CartonsInspected'] as num?)?.toInt(),
          cartonsPacked: (row['CartonsPacked'] as num?)?.toInt(),
          cartonsPacked2: (row['CartonsPacked2'] as num?)?.toInt(),
          allowedCartonInspection: (row['AllowedCartonInspection'] as num?)?.toInt(),
          criticalDefectsAllowed: (row['CriticalDefectsAllowed'] as num?)?.toInt(),
          majorDefectsAllowed: (row['MajorDefectsAllowed'] as num?)?.toInt(),
          minorDefectsAllowed: (row['MinorDefectsAllowed'] as num?)?.toInt(),
          criticalDefect: (row['CriticalDefect'] as num?)?.toInt(),
          majorDefect: (row['MajorDefect'] as num?)?.toInt(),
          minorDefect: (row['MinorDefect'] as num?)?.toInt(),
          retailPrice: row['RetailPrice'] as double?,
          poMasterPackQty: (row['POMasterPackQty'] as num?)?.toInt(),
          recDirty: (row['recDirty'] as num?)?.toInt(),
          poNo: row['PONO']?.toString(),
          itemDescr: row['ItemDescr']?.toString(),
          orderQty: row['OrderQty']?.toString(),
          earlierInspected: (row['EarlierInspected'] as num?)?.toInt(),
          customerItemRef: row['CustomerItemRef']?.toString(),
          hologramNo: row['HologramNo']?.toString(),
          qrItemID: row['QrItemID']?.toString(),
          sampleSizeDescr: row['SampleSizeDescr']?.toString(),
          itemID: row['ItemID']?.toString(),
          qrItemBaseMaterialID: row['QRItemBaseMaterialID']?.toString(),
          qrItemBaseMaterialAddOnInfo: row['QRItemBaseMaterial_AddOnInfo']?.toString(),
          barcodeInspectionResult: row['Barcode_InspectionResult']?.toString(),
          onSiteTestInspectionResult: row['OnSiteTest_InspectionResult']?.toString(),
          itemMeasurementInspectionResult: row['ItemMeasurement_InspectionResult']?.toString(),
          workmanshipInspectionResult: row['WorkmanShip_InspectionResult']?.toString(),
          overallInspectionResult: row['Overall_InspectionResult']?.toString(),
          pkgMeInspectionResult: row['PKG_Me_InspectionResult']?.toString(),
          digitals: (row['Digitals'] as num?)?.toInt(),
          enclCount: (row['EnclCount'] as num?)?.toInt(),
          isSelected: (row['IsSelected'] as num?)?.toInt(),
          sizeBreakUP: (row['SizeBreakUP'] as num?)?.toInt(),
          shipToBreakUP: row['ShipToBreakUP']?.toString(),
          testReportStatus: (row['testReportStatus'] as num?)?.toInt(),
          duplicateFlag: (row['DuplicateFlag'] as num?)?.toInt(),
          isHologramExpired: (row['IsHologramExpired'] as num?)?.toInt(),
          itemRepeat: (row['ItemRepeat'] as num?)?.toInt(),
        );

        // final importantList = await ItemInspectionDetailHandler.isImportant(
        //     poItemDtl.qrHdrID ?? '', poItemDtl.qrpoItemHdrID ?? '',
        //     context: null, qrHdrId: '', qrPoItemHdrId: '');
        // if (importantList.isNotEmpty && importantList.contains(1)) {
        //   poItemDtl.isImportant = 1;
        // }

        itemList.add(poItemDtl);
      }
      print('$_tag: Count of founded poItemDtl: ${itemList.length}');
    } catch (e) {
      print('$_tag: Exception getting item list: $e');
    }
    return itemList;
  }

  // Get latest delivery date for POItemDtl
  static Future<String> getPOListItemLatestDelDate(
      String pInspectionID, POItemDtl poItemDtl) async
  {
    String latestDelDate = '';
    try {
      final db = await DatabaseHelper().database;
      final query = 'SELECT * FROM QRPOItemdtl WHERE QRHdrID = ?';
      print('$_tag: Query for get QRPOItemdtl list: $query');
      final result = await db.rawQuery(query, [pInspectionID]);

      for (var row in result) {
        if (poItemDtl.qrItemID == row['pRowID']) {
          latestDelDate = row['LatestDelDt'] as String? ?? '';
        }
      }
      developer.log('row[LatestDelDt]: ${jsonEncode(latestDelDate)}');
      if (result.isEmpty) {
        print('$_tag: Cursor count = 0 for LatestDelDt $result');
      }
    } catch (e) {
      print('$_tag: Exception getting latest delivery date: $e');
    }
    return latestDelDate;
  }

  // Get list of PONO
  static Future<List<String>> getPOList(String pInspectionID) async {
    final List<String> poList = [];
    try {
      final db = await DatabaseHelper().database;
      final query =
          'SELECT DISTINCT PONO FROM QRPOItemDtl WHERE QRHdrID = ? AND recEnable=1';
      print('$_tag: Query for get PO from QRPOItemdtl list: $query');
      final result = await db.rawQuery(query, [pInspectionID]);

      for (var row in result) {
        poList.add(row['PONO'] as String);
      }
      print('$_tag: Count of founded PO list: ${poList.length}');
    } catch (e) {
      print('$_tag: Exception getting PO list: $e');
    }
    return poList;
  }

  // Get list of CustomerItemRef
  static Future<List<String>> getItemIdList(String pInspectionID) async {
    final List<String> itemIdList = [];
    try {
      final db = await DatabaseHelper().database;
      final query =
          'SELECT DISTINCT CustomerItemRef FROM QRPOItemDtl WHERE QRHdrID = ? AND recEnable=1';
      print('$_tag: Query for get Item id from QRPOItemdtl list: $query');
      final result = await db.rawQuery(query, [pInspectionID]);

      for (var row in result) {
        itemIdList.add(row['CustomerItemRef'] as String);
      }
      print('$_tag: Count of founded item id list: ${itemIdList.length}');
    } catch (e) {
      print('$_tag: Exception getting item id list: $e');
    }
    return itemIdList;
  }

  // Get list of POItemPkgAppDetail
  static Future<List<POItemPkgAppDetail>> getPKGAPPList() async {
    final List<POItemPkgAppDetail> pkgAppList = [];
    try {
      final db = await DatabaseHelper().database;
      final query = 'SELECT * FROM QRPOItemDtl_PKG_App_Details';
      print('$_tag: Query for get PO from QRPOItemdtl list: $query');
      final result = await db.rawQuery(query);

      for (var row in result) {
        pkgAppList.add(POItemPkgAppDetail(
          pRowID: row['pRowID'] as String?,
          locID: row['LocID'] as String?,
          descrID: row['DescrID'] as String?,
          sampleSizeID: row['SampleSizeID'] as String?,
          sampleSizeValue: row['SampleSizeValue'] as String?,
          inspectionResultID: row['InspectionResultID'] as String?,
          recUser: row['recUser'] as String?,
        ));
      }
      print('$_tag: Count of founded pKGAppListItem: ${pkgAppList.length}');
    } catch (e) {
      print('$_tag: Exception getting PKG APP list: $e');
    }
    return pkgAppList;
  }

  // Get inspection details
  static Future<List<String>?> getToInspect(
      String pRowInspection, int availableQty) async
  {
    try {
      final db = await DatabaseHelper().database;
      final query = '''
        SELECT tbl.SampleCode as SampleSizeID, tbl.BatchSize, gd.MainDescr as SampleSizeDescr, 
               gd.numVal1 As SampleSizeQty
        FROM (
          SELECT SampleCode, BatchSize 
          FROM (
            SELECT SampleCode, BatchSize 
            FROM InspLvlDtl 
            WHERE InspHdrID = ? AND trim(SignDescr) = '<=' 
                  AND BatchSize >= ? 
            ORDER BY BatchSize ASC LIMIT 1
          ) v 
          UNION 
          SELECT SampleCode, BatchSize 
          FROM InspLvlDtl 
          WHERE InspHdrID = ? AND trim(SignDescr) = '>' 
          ORDER BY BatchSize ASC LIMIT 1
        ) tbl 
        INNER JOIN GenMst gd ON gd.GenID = '320' AND gd.pGenRowID = tbl.SampleCode 
        ORDER BY BatchSize ASC LIMIT 1
      ''';

      final result = await db
          .rawQuery(query, [pRowInspection, availableQty, pRowInspection]);

      if (result.isNotEmpty) {
        final row = result.first;
        final toInspArray = [
          row['SampleSizeID'] as String,
          row['SampleSizeDescr'] as String,
          row['SampleSizeQty'] as String,
        ];
        print(
            '$_tag: Samplecode: ${toInspArray[0]}, MainDescr: ${toInspArray[1]}, numVal: ${toInspArray[2]}');
        return toInspArray;
      } else {
        print('$_tag: Founded sample code and size is NULL');
      }
    } catch (e) {
      print('$_tag: Exception getting to inspect: $e');
    }
    return null;
  }

  // Get sample size list
  static Future<List<SampleModel>> getSampleSizeList() async {
    final List<SampleModel> sampleList = [];

    try {
      final db = await DatabaseHelper().database;
      final query =
          'SELECT DISTINCT Ins.SampleCode, GenSample.MainDescr, GenSample.numVal1 '
          'FROM InspLvlDtl Ins LEFT JOIN GenMst GenSample ON Ins.SampleCode=GenSample.pGenRowID';
      print('$_tag: Query for get sample size: $query');
      final result = await db.rawQuery(query);

      for (var row in result) {
        sampleList.add(SampleModel(
          sampleCode: row['SampleCode'] as String?,
          mainDescr: row['MainDescr'] as String?,
          sampleVal: row['numVal1'] as String?,
        ));
      }
      print('$_tag: Founded data count: ${sampleList.length}');
    } catch (e) {
      print('$_tag: Exception getting sample size list: $e');
    }
    return sampleList;
  }

  // Get defect accepted
  static Future<List<String>?> getDefectAccepted(
      String pRowIdOfQualityLevel, String sampleCode) async {
    try {
      final db = await DatabaseHelper().database;
      final query =
          'SELECT * FROM qualityLevelDtl WHERE QlHdrID = ? AND SampleCode = ?';
      print('$_tag: Query for get defect accepted: $query');
      final result =
          await db.rawQuery(query, [pRowIdOfQualityLevel, sampleCode]);

      if (result.isNotEmpty) {
        final row = result.first;
        final toInspArray = [
          row['SampleCode'] as String,
          row['Accepted'] as String,
        ];
        print(
            '$_tag: Samplecode: ${toInspArray[0]}, Accepted: ${toInspArray[1]}');
        return toInspArray;
      } else {
        print('$_tag: No result found for Sample code and accepted defect');
      }
    } catch (e) {
      print('$_tag: Exception getting defect accepted: $e');
    }
    return null;
  }

  // Update item to disable
  static Future<void> updateItemForDisable(POItemDtl poItemDtl) async {
    try {
      final db = await DatabaseHelper().database;
      final contentValues = {'recEnable': 0};

      final rows = await db.update(
        'QRPOItemDtl',
        contentValues,
        where: 'pRowID = ?',
        whereArgs: [poItemDtl.qrItemID],
      );

      if (rows == 0) {
        print('$_tag: QRPOItemDtl table NOT UPDATED...');
      } else {
        print('$_tag: QRPOItemDtl type update result: $rows');
      }
    } catch (e) {
      print('$_tag: Exception updating QRPOItemDtl: $e');
    }
  }

  // Update item quantities
  static Future<bool> updateItemForQty(POItemDtl poItemDtl) async {
    try {
      final db = await DatabaseHelper().database;
      final contentValues = {
        'AvailableQty': poItemDtl.availableQty,
        'AcceptedQty': poItemDtl.acceptedQty,
        'ShortStockQty': poItemDtl.shortStockQty,
      };

      print('$_tag: updateItemForQty pRowID: ${poItemDtl.pRowID}');
      print('$_tag: updateItemForQty AvailableQty: ${poItemDtl.availableQty}');
      print('$_tag: updateItemForQty AcceptedQty: ${poItemDtl.acceptedQty}');
      print(
          '$_tag: updateItemForQty ShortStockQty: ${poItemDtl.shortStockQty}');

      final rows = await db.update(
        'QRPOItemdtl',
        contentValues,
        where: 'pRowID = ? AND QRHdrID = ?',
        whereArgs: [poItemDtl.pRowID, poItemDtl.qrHdrID],
      );

      if (rows == 0) {
        print('$_tag: QRPOItemDtl table NOT UPDATED...');
        return false;
      } else {
        print('$_tag: QRPOItemDtl type update result: $rows');
      }
      return true;
    } catch (e) {
      print('$_tag: Exception updating QRPOItemDtl: $e');
      return false;
    }
  }

  // Update item quantities (alternative)
  static Future<bool> updateItemForQty1(POItemDtl poItemDtl) async {
    try {
      final db = await DatabaseHelper().database;
      final contentValues = {
        'AvailableQty': poItemDtl.availableQty,
        'AcceptedQty': poItemDtl.acceptedQty,
        'ShortStockQty': poItemDtl.shortStockQty,
      };

      print('$_tag: updateItemForQty1 pRowID: ${poItemDtl.pRowID}');
      print('$_tag: updateItemForQty1 AvailableQty: ${poItemDtl.availableQty}');
      print('$_tag: updateItemForQty1 AcceptedQty: ${poItemDtl.acceptedQty}');
      print(
          '$_tag: updateItemForQty1 ShortStockQty: ${poItemDtl.shortStockQty}');

      final rows = await db.update(
        'QRPOItemdtl',
        contentValues,
        where: 'pRowID = ?',
        whereArgs: [poItemDtl.pRowID],
      );

      if (rows == 0) {
        print('$_tag: QRPOItemDtl table NOT UPDATED...');
        return false;
      } else {
        print('$_tag: QRPOItemDtl type update result: $rows');
      }
      return true;
    } catch (e) {
      print('$_tag: Exception updating QRPOItemDtl: $e');
      return false;
    }
  }
}
