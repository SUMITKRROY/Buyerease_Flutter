import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../model/sync/ImageModal.dart';
import '../../provider/sync_to_server/sync_to_server_cubit.dart';
import '../../utils/app_constants.dart';
import '../../utils/device_info.dart';
import '../../utils/fsl_log.dart';
import '../../database/database_helper.dart';

/**
 * created by Roy on 24/06/2025.
 */

class SendDataHandler {
  static String TAG = "SyncDataHandler";

  Future<Map<String, dynamic>> getHdrTableData(List<String> hdrIdList) async {
    Map<String, dynamic> params = {};

    if (hdrIdList.isNotEmpty) {
      for (String hdrId in hdrIdList) {
        params['QRFeedbackhdr'] = await getQRFeedbackhdrJson(hdrId);
        params['QRPOItemHdr'] = await getQRPOItemHdrJson(hdrId);
        params['QRPOItemDtl'] = await getQRPOItemdtlJson(hdrId);
      }
    }
    return params;
  }

  Future<Map<String, dynamic>> getSizeQtyData(List<String> hdrIdList) async {
    Map<String, dynamic> params = {};

    if (hdrIdList.isNotEmpty) {
      for (var hdrId in hdrIdList) {
        params['SizeQuantity'] = await getSizeQtyJson(hdrId);
      }
    }

    return params;
  }

  Future<Map<String, dynamic>> getImagesTableData(
      List<String> hdrIdList) async {
    Map<String, dynamic> params = {};

    if (hdrIdList != null && hdrIdList.isNotEmpty) {
      for (var hdrId in hdrIdList) {
        // This will overwrite on every loop iteration (same as Java)
        params['QRPOItemDtl_Image'] = await getQRPOItemDtl_ImageJson(hdrId);
      }
    }

    return params;
  }

  Future<List<ImageModal>> getImagesFileArrayData(
      List<String> hdrIdList) async {
    List<ImageModal> imageList = [];

    if (hdrIdList.isNotEmpty) {
      for (String id in hdrIdList) {
        List<ImageModal> images = await SendDataHandler.getImageFilesJson(id);
        developer.log("json object imagesList >> ${jsonEncode(images)}");
        imageList.addAll(images);
      }
    }
    developer.log("json object imagesList >> ${jsonEncode(imageList)}");
    return imageList;
  }

  Future<List?> getEnclosureFileArrayData(List<String> hdrIdList) async {
    List<dynamic>? jsonArrays;

    if (hdrIdList.isNotEmpty) {
      for (int i = 0; i < hdrIdList.length; i++) {
        jsonArrays = await getFilesQREnclosureJson(hdrIdList[i]);
      }
    }

    return jsonArrays;
  }

  Future<Map<String, dynamic>> getWorkmanShipData(
      List<String> hdrIdList) async {
    Map<String, dynamic> params = {};

    if (hdrIdList.isNotEmpty) {
      params = {};
      for (int i = 0; i < hdrIdList.length; i++) {
        params['QRAuditBatchDetails'] =
            await getQRAuditBatchDetailOrWorkManShipsJson(hdrIdList[i]);
      }
    }

    return params;
  }

  Future<Map<String, dynamic>?> getItemMeasurementData(
      List<String> hdrIdList) async {
    Map<String, dynamic>? params;
    if (hdrIdList.isNotEmpty) {
      params = {};
      for (int i = 0; i < hdrIdList.length; i++) {
        params['QRPOItemDtl_ItemMeasurement'] =
            await getQRPOItemDtl_ItemMeasurementJson(hdrIdList[i]);
      }
    }
    return params;
  }

  Future<Map<String, dynamic>?> getFindingData(List<String> hdrIdList) async {
    Map<String, dynamic>? params;
    if (hdrIdList.isNotEmpty) {
      params = {};
      for (int i = 0; i < hdrIdList.length; i++) {
        params['QRFindings'] = await getQRFindingsJson(hdrIdList[i]);
      }
    }
    return params;
  }

  Future<Map<String, dynamic>?> getQualityParameterData(
      List<String> hdrIdList) async {
    Map<String, dynamic>? params;
    if (hdrIdList.isNotEmpty) {
      params = {};
      for (int i = 0; i < hdrIdList.length; i++) {
        params['QRQualiltyParameterFields'] =
            await getQRQualiltyParameterFields(hdrIdList[i]);
      }
    }
    return params;
  }

  Future<Map<String, dynamic>?> getFitnessCheckData(
      List<String> hdrIdList) async {
    Map<String, dynamic>? params;
    if (hdrIdList.isNotEmpty) {
      params = {};
      for (int i = 0; i < hdrIdList.length; i++) {
        params['QRPOItemFitnessCheck'] =
            await getQRPOItemFitnessCheckJson(hdrIdList[i]);
      }
    }
    return params;
  }

  Future<Map<String, dynamic>?> getProductionStatusData(
      List<String> hdrIdList) async {
    Map<String, dynamic>? params;
    if (hdrIdList.isNotEmpty) {
      params = {};
      for (int i = 0; i < hdrIdList.length; i++) {
        params['QRPOItemFitnessCheck'] =
            await getQRProductionStatusJson(hdrIdList[i]);
      }
    }
    return params;
  }

  Future<Map<String, dynamic>?> getIntimationData(
      List<String> hdrIdList) async {
    Map<String, dynamic>? params;
    if (hdrIdList.isNotEmpty) {
      params = {};
      for (int i = 0; i < hdrIdList.length; i++) {
        params['QRPOIntimationDetails'] =
            await getQRPOIntimationDetailsJson(hdrIdList[i]);
      }
    }
    return params;
  }

  Future<Map<String, dynamic>?> getQREnclosureData(
      List<String> hdrIdList) async {
    Map<String, dynamic>? params;
    if (hdrIdList.isNotEmpty) {
      params = {};
      for (var hdrId in hdrIdList) {
        params['QREnclosure'] = await getQREnclosureJson(hdrId);
      }
    }
    return params;
  }

  Future<Map<String, dynamic>?> getDigitalsColumnFromMultipleData(
      List<String> hdrIdList) async {
    Map<String, dynamic>? params;
    if (hdrIdList.isNotEmpty) {
      params = {};
      for (var hdrId in hdrIdList) {
        params['QRDigitals'] = await getDigitalsColumnFromMultipleJson(hdrId);
      }
    }
    return params;
  }

  Future<Map<String, dynamic>?> getOnSiteDataData(
      List<String> hdrIdList) async {
    Map<String, dynamic>? params;
    if (hdrIdList.isNotEmpty) {
      params = {};
      for (var hdrId in hdrIdList) {
        params['QRPOItemDtl_OnSite_Test'] = await getOnSiteJsonData(hdrId);
      }
    }
    return params;
  }

  Future<Map<String, dynamic>?> getSampleCollectedData(
      List<String> hdrIdList) async {
    Map<String, dynamic>? params;
    if (hdrIdList.isNotEmpty) {
      params = {};
      for (var hdrId in hdrIdList) {
        params['QRPOItemDtl_Sample_Purpose'] =
            await getSampleCollectedJsonData(hdrId);
      }
    }
    return params;
  }

  Future<Map<String, dynamic>?> getPkgAppearanceData(
      List<String> hdrIdList) async {
    Map<String, dynamic>? params;
    if (hdrIdList.isNotEmpty) {
      params = {};
      for (var hdrId in hdrIdList) {
        params['QRPOItemDtl_PKG_App_Details'] = await getPkgAppJsonData(hdrId);
      }
    }
    return params;
  }

  Future<Map<String, dynamic>?> getSelectedInspectionIdsData(
      BuildContext context, List<String>? hdrIdList) async {
    if (hdrIdList != null && hdrIdList.isNotEmpty) {
      final Map<String, dynamic> paramsIDs = {};

      // Constructing the IDs string: "'id1', 'id2', 'id3'"
      final String ids = hdrIdList.map((id) => "'$id'").join(', ');

      // Assuming DeviceInfo class with these async methods
      final deviceInfo = DeviceInfo(context);
      final String deviceId = await deviceInfo.devicesUniqueId!;
      final String? deviceIp = await deviceInfo.getDeviceIp();

      paramsIDs["pRowIDs"] = ids;
      paramsIDs["device_id"] = deviceId;
      paramsIDs["device_ip"] = deviceIp;
      paramsIDs["device_location"] = "";
      paramsIDs["device_type"] = "A";

      final Map<String, dynamic> params = {
        "Finalize": [paramsIDs], // Using List to mimic JSONArray
      };

      return params;
    }

    return null;
  }

  Future<List<Map<String, dynamic>>> getQRFeedbackhdrJson(String hdrID) async {
    List<Map<String, dynamic>> jsonArrayList = [];
    final db = await DatabaseHelper().database;
    try {
      String query = '''
      SELECT 
        pRowID, QRID, 
        IFNULL(InspectorID, '') AS InspectorID, 
        IFNULL(CriticalDefect, 0) AS CriticalDefect,
        IFNULL(MajorDefect, 0) AS MajorDefect,  
        IFNULL(MinorDefect, 0) AS MinorDefect, 
        recUser, recDt, Status,
        IFNULL(VendorContact, '') AS VendorContact, 
        IFNULL(Arrivaltime, '') AS Arrivaltime, 
        IFNULL(Inspstarttime, '') AS Inspstarttime, 
        IFNULL(CompleteTime, '') AS CompleteTime,
        IFNULL(DATETIME(AcceptedDt), '') AS AcceptedDt,   
        IFNULL(QLMajor, '') AS QLMajor,
        IFNULL(QLMinor, '') AS QLMinor, 
        IFNULL(Comments, '') AS Comments, 
        IFNULL(InspectionLevel, '') AS InspectionLevel, 
        IFNULL(InspectionDt, '') AS InspectionDt, 
        IFNULL(ProductionCompletionDt, '') AS ProductionCompletionDt,
        IFNULL(ProductionStatusRemark, '') AS ProductionStatusRemark 
      FROM QRFeedbackhdr 
      WHERE pRowID IN (?)
    ''';
      print('Query Executed: $query');
      jsonArrayList = await db.rawQuery(query, [hdrID]);

      print('Query Result: $jsonArrayList');
    } catch (e) {
      print('Error in getQRFeedbackhdrJson: $e');
    }

    return jsonArrayList;
  }

  Future<List<Map<String, dynamic>>> getQRPOItemHdrJson(String hdrID) async {
    List<Map<String, dynamic>> jsonArrayList = [];
    final db = await DatabaseHelper().database;
    try {
      String query = '''
      SELECT * FROM QRPOItemHdr i
      WHERE i.QRHdrID IN (?)
    ''';

      jsonArrayList = await db.rawQuery(query, [hdrID]);

      print("jsonArrayList getQRPOItemHdrJson: $query");
      print("jsonArrayList getQRPOItemHdrJson result: $jsonArrayList");
    } catch (e) {
      print('Error in getQRPOItemHdrJson: $e');
    }

    return jsonArrayList;
  }

  Future<List<Map<String, dynamic>>> getQRPOItemdtlJson(String hdrID) async {
    List<Map<String, dynamic>> jsonArrayList = [];
    final db = await DatabaseHelper().database;
    try {
      String query = '''
      SELECT 
        i.pRowID, 
        i.QRHdrID, 
        IFNULL(i.QRPOItemHdrID, '') AS QRPOItemHdrID, 
        i.FurtherInspectionReqd,
        IFNULL(i.PalletPackedQty, 0) AS PalletPackedQty,   
        IFNULL(i.MASterPackedQty, 0) AS MASterPackedQty,
        IFNULL(i.InnerPackedQty, 0) AS InnerPackedQty, 
        IFNULL(i.PackedQty, 0) AS PackedQty, 
        IFNULL(i.UnpackedQty, 0) AS UnpackedQty, 
        IFNULL(i.UnfinishedQty, 0) AS UnfinishedQty, 
        i.CriticalDefectsAllowed,
        i.MajorDefectsAllowed, 
        i.MinorDefectsAllowed,   
        IFNULL(i.SampleCodeID, '') AS SampleCodeID, 
        i.recUser,
        IFNULL(i.InspectedQty, 0) AS InspectedQty, 
        i.recEnable,   
        IFNULL(i.CartonsPacked, 0) AS CartonsPacked,
        IFNULL(i.CartonsInspected, 0) AS CartonsInspected, 
        IFNULL(i.AvailableQty, 0) AS AvailableQty, 
        IFNULL(i.AcceptedQty, 0) AS AcceptedQty, 
        IFNULL(i.ShortStockQty, 0) AS ShortStockQty,
        IFNULL(i.CartonsPacked2, 0) AS CartonsPacked2,   
        IFNULL(i.CriticalDefect, 0) AS CriticalDefect,
        IFNULL(i.MajorDefect, 0) AS MajorDefect, 
        IFNULL(i.MinorDefect, 0) AS MinorDefect,  
        IFNULL(i.AllowedInspectionQty, 0) AS AllowedInspectionQty
      FROM QRPOItemDtl i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
      WHERE i.QRHdrID IN (?)
    ''';

      jsonArrayList = await db.rawQuery(query, [hdrID]);

      // print("Query: $query");
      // print("Result from getQRPOItemdtlJson: $jsonArrayList");
    } catch (e) {
      print('Error in getQRPOItemdtlJson: $e');
    }

    return jsonArrayList;
  }

  Future<List<Map<String, dynamic>>> getSizeQtyJson(String hdrID) async {
    List<Map<String, dynamic>> result = [];
    final db = await DatabaseHelper().database;
    try {
      final String query = '''
      SELECT size.* 
      FROM SizeQuantity size 
      INNER JOIN QRPOItemHdr ItemHdr 
        ON size.QRPOItemHdrID = ItemHdr.pRowID 
      WHERE ItemHdr.QRHdrID IN ('$hdrID')
    ''';

      result = await db.rawQuery(query);

      print('json from SizeQuantity table: $result');
    } catch (e) {
      print('Error fetching size qty JSON: $e');
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getQRAuditBatchDetailOrWorkManShipsJson(
      String hdrID) async {
    List<Map<String, dynamic>> result = [];
    final db = await DatabaseHelper().database;
    try {
      String query = '''
      SELECT 
        i.pRowID,
        i.LocID,
        IFNULL(i.QRHdrID, '') AS QRHdrID,
        IFNULL(i.QRPOItemHdrID, '') AS QRPOItemHdrID,
        IFNULL(i.QRPOItemDtlRowID, '') AS QRPOItemDtlRowID,
        IFNULL(i.ItemID, '') AS ItemID,
        IFNULL(i.ColorID, '') AS ColorID,
        IFNULL(i.DefectID, '') AS DefectID,
        IFNULL(i.DefectCode, '') AS DefectCode,
        IFNULL(i.DefectName, '') AS DefectName,
        IFNULL(i.DCLTypeID, '') AS DCLTypeID,
        IFNULL(i.DefectComments, '') AS DefectComments,
        IFNULL(i.DefectDescription, '') AS DefectDescription,
        i.CriticalDefect,
        i.MajorDefect,
        i.MinorDefect,
        IFNULL(i.CriticalType, 1) AS CriticalType,
        IFNULL(i.MajorType, 1) AS MajorType,
        IFNULL(i.MinorType, 1) AS MinorType,
        IFNULL(i.SampleRqstCriticalRowID, '') AS SampleRqstCriticalRowID,
        IFNULL(i.POItemHdrCriticalRowID, '') AS POItemHdrCriticalRowID,
        IFNULL(i.Digitals, '') AS Digitals,
        i.recAddUser,
        i.recUser,
        IFNULL(i.recEnable, 1) AS recEnable
      FROM QRAuditBatchDetails i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
      WHERE i.QRHdrID IN (?)
    ''';

      result = await db.rawQuery(query, [hdrID]);

      print('json from QRAuditBatchDetails table: $result');
    } catch (e) {
      print('Error fetching QRAuditBatchDetails data: $e');
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getQRPOItemDtlImageJson(
      String hdrID) async {
    final db = await DatabaseHelper().database;
    List<Map<String, dynamic>> result = [];

    try {
      const String query = '''
      SELECT i.pRowID, i.LocID, i.QRHdrID,
        IFNULL(i.QRPOItemHdrID, '') AS QRPOItemHdrID,
        IFNULL(i.QRPOItemDtlID, '') AS QRPOItemDtlID,
        IFNULL(i.ItemID, '') AS ItemID,
        IFNULL(i.ColorID, '') AS ColorID,
        IFNULL(i.Title, '') AS Title,
        i.ImageName, i.fileContent, i.ImageExtn,
        IFNULL(i.ImageSymbol, '') AS ImageSymbol,
        i.ImageSqn, i.recUser,
        IFNULL(i.BE_pRowID, 'NULL') AS BE_pRowID,
        IFNULL(i.FileSent, 0) AS FileSent
      FROM QRPOItemDtl_Image i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
      WHERE i.QRHdrID = ? AND i.recEnable = 1
    ''';

      result = await db.rawQuery(query, [hdrID]);
      print('json from QRPOItemDtl_Image table: $result');
    } catch (e) {
      print('Error fetching QRPOItemDtl_Image: $e');
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getQRPOItemDtlItemMeasurementJson(
      String hdrID) async {
    final db = await DatabaseHelper().database;
    List<Map<String, dynamic>> result = [];

    try {
      const String query = '''
      SELECT i.pRowID, i.LocID, i.QRHdrID,
        IFNULL(i.QRPOItemHdrID, '') AS QRPOItemHdrID,
        IFNULL(i.QRPOItemDtlID, '') AS QRPOItemDtlID,
        IFNULL(i.ItemID, '') AS ItemID,
        IFNULL(i.ColorID, '') AS ColorID,
        IFNULL(i.ItemMeasurementDescr, '') AS ItemMeasurementDescr,
        IFNULL(i.SampleSizeID, '') AS SampleSizeID,
        IFNULL(i.SampleSizeValue, '') AS SampleSizeValue,
        IFNULL(i.Finding, '') AS Finding,
        IFNULL(i.InspectionResultID, '') AS InspectionResultID,
        i.recUser,
        IFNULL(i.Dim_Height, '') AS Dim_Height,
        IFNULL(i.Dim_Width, '') AS Dim_Width,
        IFNULL(i.Dim_Length, '') AS Dim_Length,
        IFNULL(i.Tolerance_Range, '') AS Tolerance_Range,
        i.Digitals
      FROM QRPOItemDtl_ItemMeasurement i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
      WHERE i.QRHdrID = ? AND i.recEnable = 1
    ''';

      result = await db.rawQuery(query, [hdrID]);
      print('json from QRPOItemDtl_ItemMeasurement table: $result');
    } catch (e) {
      print('Error fetching item measurement: $e');
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getQRFindingsJson(String hdrID) async {
    final db = await DatabaseHelper().database;
    List<Map<String, dynamic>> result = [];

    try {
      const String query = '''
      SELECT i.pRowID, i.LocID,
        IFNULL(i.QRHdrID, '') AS QRHdrID,
        IFNULL(i.QRPOItemHdrID, '') AS QRPOItemHdrID,
        IFNULL(i.ItemID, '') AS ItemID,
        IFNULL(i.Descr, '') AS Descr,
        IFNULL(i.recUser, '') AS recUser,
        IFNULL(i.SampleSizeID, '') AS SampleSizeID,
        IFNULL(i.ChangeCount, '') AS ChangeCount,
        IFNULL(i.Old_Height, '') AS Old_Height,
        IFNULL(i.Old_Width, '') AS Old_Width,
        IFNULL(i.Old_Length, '') AS Old_Length,
        IFNULL(i.New_Height, '') AS New_Height,
        IFNULL(i.New_Width, '') AS New_Width,
        IFNULL(i.New_Length, '') AS New_Length,
        IFNULL(i.MeasurementID, '') AS MeasurementID
      FROM QRFindings i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
      WHERE i.MeasurementID IS NOT NULL AND i.QRHdrID = ?
    ''';

      result = await db.rawQuery(query, [hdrID]);
      print('json from QRFindings table: $result');
    } catch (e) {
      print('Error fetching QRFindings: $e');
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getQRQualiltyParameterFields(
      String hdrID) async {
    final db = await DatabaseHelper().database;
    List<Map<String, dynamic>> result = [];

    try {
      const String query = '''
      SELECT i.pRowID, i.LocID, i.QRHdrID,
        IFNULL(i.QRPOItemDtlID, '') AS QRPOItemDtlID,
        IFNULL(i.ItemID, '') AS ItemID,
        IFNULL(i.ColorID, '') AS ColorID,
        i.QualityParameterID,
        IFNULL(i.IsApplicable, '') AS IsApplicable,
        IFNULL(i.OptionSelected, '') AS OptionSelected,
        IFNULL(i.Remarks, '') AS Remarks,
        i.recAddUser, i.recEnable, i.recDirty, i.recUser,
        IFNULL(i.QRPOItemHdrID, '') AS QRPOItemHdrID,
        i.Digitals
      FROM QRQualiltyParameterFields i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
      WHERE i.QRHdrID = ?
    ''';

      result = await db.rawQuery(query, [hdrID]);
      print('QRQualiltyParameterFields: $result');
    } catch (e) {
      print('Error in getQRQualiltyParameterFields: $e');
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getQRProductionStatusJson(
      String hdrID) async {
    final db = await DatabaseHelper().database;
    List<Map<String, dynamic>> result = [];

    try {
      const String query = '''
      SELECT i.pRowID, i.LocID, i.QRHdrID,
        i.QRProdStatusID, i.recEnable, i.recUser, i.Percentage
      FROM QRProductionStatus i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
      WHERE i.QRHdrID = ?
    ''';

      result = await db.rawQuery(query, [hdrID]);
      print('QRProductionStatus: $result');
    } catch (e) {
      print('Error in getQRProductionStatusJson: $e');
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getQRPOItemFitnessCheckJson(
      String hdrID) async {
    final db = await DatabaseHelper().database;
    List<Map<String, dynamic>> result = [];

    try {
      const String query = '''
      SELECT i.pRowID, i.LocID, i.QRHdrID,
        IFNULL(i.QRPOItemDtlID, '') AS QRPOItemDtlID,
        IFNULL(i.ItemID, '') AS ItemID,
        IFNULL(i.ColorID, '') AS ColorID,
        i.QRFitnessCheckID,
        IFNULL(i.IsApplicable, '') AS IsApplicable,
        IFNULL(i.OptionSelected, '') AS OptionSelected,
        IFNULL(i.Remarks, '') AS Remarks,
        i.recAddUser, i.recEnable, i.recDirty, i.recUser,
        IFNULL(i.QRPOItemHdrID, '') AS QRPOItemHdrID,
        i.Digitals
      FROM QRPOItemFitnessCheck i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
      WHERE i.QRHdrID = ?
    ''';

      result = await db.rawQuery(query, [hdrID]);
      print('QRPOItemFitnessCheck: $result');
    } catch (e) {
      print('Error in getQRPOItemFitnessCheckJson: $e');
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getQRPOIntimationDetailsJson(
      String hdrID) async {
    final db = await DatabaseHelper().database;
    List<Map<String, dynamic>> result = [];

    try {
      const String query = '''
      SELECT i.pRowID, i.LocID, i.QRHdrID,
        IFNULL(i.Name, '') AS Name,
        IFNULL(i.EmailID, '') AS EmailID,
        IFNULL(i.ID, '') AS ID,
        i.IsLink, i.IsReport, i.recType, i.recEnable,
        i.recAddUser, i.recAddDt, i.recUser, i.recDt,
        i.IsHtmlLink, i.IsRcvApplicable, i.BE_pRowID
      FROM QRPOIntimationDetails i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
      WHERE i.IsSelected = 1 AND i.QRHdrID = ?
    ''';

      result = await db.rawQuery(query, [hdrID]);
      print('QRPOIntimationDetails: $result');
    } catch (e) {
      print('Error in getQRPOIntimationDetailsJson: $e');
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getQREnclosureJson(String hdrID) async {
    final db = await DatabaseHelper().database;
    List<Map<String, dynamic>> result = [];

    try {
      const String query = '''
      SELECT i.pRowID, i.LocID, i.IsMandatory,
        i.ContextID, i.ContextType, i.EnclType,
        i.ImageName, i.ImageExtn, i.Title, i.FileName,
        i.recUser, i.recAddDt, i.recDt, i.numVal1,
        i.ContextID AS QRHdrID,
        IFNULL(i.FileSent, 0) AS FileSent
      FROM QREnclosure i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.ContextID
      WHERE i.ContextID = ?
    ''';

      result = await db.rawQuery(query, [hdrID]);
      print('QREnclosure: $result');
    } catch (e) {
      print('Error in getQREnclosureJson: $e');
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getFilesQREnclosureJson(
      String hdrID) async {
    final db = await DatabaseHelper().database;
    List<Map<String, dynamic>> result = [];

    try {
      const String query = '''
      SELECT i.pRowID, i.LocID, i.IsMandatory, i.ContextID, i.ContextType, i.EnclType,
        i.ImageName, i.ImageExtn, i.Title, i.FileName, i.fileContent,
        i.recUser, i.recAddDt, i.recDt, i.numVal1,
        i.ContextID AS QRHdrID,
        IFNULL(i.FileSent, 0) AS FileSent
      FROM QREnclosure i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.ContextID
      WHERE i.ContextID = ?
    ''';

      result = await db.rawQuery(query, [hdrID]);
      print('Files from QREnclosure: $result');
    } catch (e) {
      print('Error in getFilesQREnclosureJson: $e');
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getDigitalsColumnFromMultipleJson(
      String hdrID) async {
    final db = await DatabaseHelper().database;
    List<Map<String, dynamic>> result = [];

    try {
      final String query = '''
      SELECT i.pRowID AS pRowID, i.Digitals AS Digitals, 'OITemp_QRAuditBatchDetails' AS TableName,
        i.QRHdrID, i.QRPOItemHdrID, 'Digitals' AS Col
      FROM QRAuditBatchDetails i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
      WHERE i.QRHdrID = ? AND IFNULL(i.BE_pRowID, '') = ''

      UNION

      SELECT i.pRowID, i.Digitals, 'OITemp_QRPOItemDtl_ItemMeasurement' AS TableName,
        i.QRHdrID, i.QRPOItemHdrID, 'Digitals' AS Col
      FROM QRPOItemDtl_ItemMeasurement i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
      WHERE i.QRHdrID = ? AND IFNULL(i.BE_pRowID, '') = '' AND i.recEnable = 1

      UNION

      SELECT i.pRowID, i.Digitals, 'OITemp_QRQualiltyParameterFields' AS TableName,
        i.QRHdrID, i.QRPOItemHdrID, 'Digitals' AS Col
      FROM QRQualiltyParameterFields i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
      WHERE i.QRHdrID = ?

      UNION

      SELECT i.pRowID, i.Digitals, 'OITemp_QRPOItemFitnessCheck' AS TableName,
        i.QRHdrID, i.QRPOItemHdrID, 'Digitals' AS Col
      FROM QRPOItemFitnessCheck i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
      WHERE i.QRHdrID = ?

      UNION

      SELECT '' AS pRowID, i.PKG_Me_Pallet_Digitals AS Digitals, 'OITemp_QRPOItemHdr' AS TableName,
        i.QRHdrID, i.pRowID AS QRPOItemHdrID, 'PKG_Me_Pallet_Digitals' AS Col
      FROM QRPOItemHdr i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
      WHERE i.QRHdrID = ?

      UNION

      SELECT '' AS pRowID, i.PKG_Me_Master_Digitals AS Digitals, 'OITemp_QRPOItemHdr' AS TableName,
        i.QRHdrID, i.pRowID AS QRPOItemHdrID, 'PKG_Me_Master_Digitals' AS Col
      FROM QRPOItemHdr i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
      WHERE i.QRHdrID = ?

      UNION

      SELECT '' AS pRowID, i.PKG_Me_Inner_Digitals AS Digitals, 'OITemp_QRPOItemHdr' AS TableName,
        i.QRHdrID, i.pRowID AS QRPOItemHdrID, 'PKG_Me_Inner_Digitals' AS Col
      FROM QRPOItemHdr i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
      WHERE i.QRHdrID = ?

      UNION

      SELECT '' AS pRowID, i.PKG_Me_Unit_Digitals AS Digitals, 'OITemp_QRPOItemHdr' AS TableName,
        i.QRHdrID, i.pRowID AS QRPOItemHdrID, 'PKG_Me_Unit_Digitals' AS Col
      FROM QRPOItemHdr i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
      WHERE i.QRHdrID = ?
    ''';

      // hdrID is reused 8 times in the query
      result = await db.rawQuery(query, List.filled(8, hdrID));
      print('Digitals data from multiple tables: $result');
    } catch (e) {
      print('Error in getDigitalsColumnFromMultipleJson: $e');
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getQRPOItemDtl_ImageJson(
      String hdrId) async {
    List<Map<String, dynamic>> jsonArrayList = [];

    try {
      final db = await DatabaseHelper().database; // Use your DB instance
      final String query = '''
      SELECT 
        i.pRowID, i.LocID, i.QRHdrID, 
        IFNULL(i.QRPOItemHdrID, '') AS QRPOItemHdrID, 
        IFNULL(i.QRPOItemDtlID, '') AS QRPOItemDtlID, 
        IFNULL(i.ItemID, '') AS ItemID, 
        IFNULL(i.ColorID, '') AS ColorID, 
        IFNULL(i.Title, '') AS Title, 
        i.ImageName, 
        i.fileContent, 
        i.ImageExtn, 
        IFNULL(i.ImageSymbol, '') AS ImageSymbol, 
        i.ImageSqn, 
        i.recUser, 
        IFNULL(i.BE_pRowID, 'NULL') AS BE_pRowID, 
        IFNULL(i.FileSent, 0) AS FileSent
      FROM QRPOItemDtl_Image i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
      WHERE i.QRHdrID IN (?) AND i.recEnable = 1
    ''';

      jsonArrayList = await db.rawQuery(query, [hdrId]);

      developer.log('json from QRPOItemDtl_Image table: $query $hdrId');
      developer.log('json from QRPOItemDtl_Image table: $jsonArrayList');
    } catch (e) {
      print('Error retrieving image JSON: $e');
    }

    return jsonArrayList;
  }
/* static Future<List<ImageModal>> getImageFilesJson( String hdrID) async {
    try {
      final db = await DatabaseHelper().database;
      String query = '''
      SELECT i.pRowID, i.LocID, i.QRHdrID, IFNULL(i.QRPOItemHdrID,'') AS QRPOItemHdrID,
             IFNULL(i.QRPOItemDtlID,'') AS QRPOItemDtlID, IFNULL(i.ItemID,'') AS ItemID,
             IFNULL(i.ColorID,'') AS ColorID, IFNULL(i.Title,'') AS Title, i.ImageName,
             i.fileContent, i.ImageExtn, IFNULL(i.ImageSymbol,'') AS ImageSymbol,
             i.ImageSqn, i.recUser, IFNULL(i.BE_pRowID,'NULL') AS BE_pRowID,
             IFNULL(i.FileSent,0) AS FileSent
      FROM QRPOItemDtl_Image i
      INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
      WHERE i.QRHdrID = ? AND i.recEnable = 1
    ''';

      return await getFileContentFromTableToSendSeparateImageColumn( query, hdrID);
    } catch (e) {
      print('Error in getImageFilesJson: $e');
      return [];
    }
  }

static  Future<List<ImageModal>> getFileContentFromTableToSendSeparateImageColumn(
       String query,  String hdrID) async {
    List<ImageModal> imageModals = [];
    final db = await DatabaseHelper().database;
    try {
      final List<Map<String, dynamic>> result = await db.rawQuery(query, [hdrID]);
      print('result :>> ${result}');
      for (var row in result) {
        int fileSent = row['FileSent'] ?? 0;

        if (fileSent == 0) {
          String? filePath = row['fileContent'];

          if (filePath != null && filePath != 'null' && filePath.isNotEmpty) {
            File file = File(filePath);
            if (await file.exists()) {
              ImageModal imageModal = ImageModal();
              imageModal.pRowID = row['pRowID']?.toString() ?? '';
              imageModal.qrHdrID = row['QRHdrID']?.toString() ?? '';
              imageModal.qrPOItemHdrID = row['QRPOItemHdrID']?.toString() ?? '';

              String fileExt = row['ImageExtn'] ?? 'jpg';
              imageModal.fileName = '${imageModal.qrHdrID}_${imageModal.pRowID}.$fileExt';
              imageModal.fileContent = filePath;
              imageModal.length = ''; // Not used in Java, kept as placeholder

              imageModals.add(imageModal);
            } else {
              print('FILE NOT FOUND: $filePath');
            }
          } else {
            print('FILE CONTENT IS NULL for pRowID: ${row['pRowID']}');
          }
        } else {
          print('FILE ALREADY SYNC for pRowID: ${row['pRowID']}');
        }
      }

      print('JSON list images from table: ${imageModals.length}');
    } catch (e) {
      print('Error in getFileContentFromTableToSendSeparateImageColumn: $e');
    }

    return imageModals;
  }*/
  static Future<List<ImageModal>> getImageFilesJson(String hdrID) async {
    List<ImageModal> imageList = [];

    try {
      final db = await DatabaseHelper().database;

      final String query = '''
        SELECT i.pRowID, i.LocID, i.QRHdrID, 
               IFNULL(i.QRPOItemHdrID, '') AS QRPOItemHdrID,
               IFNULL(i.QRPOItemDtlID, '') AS QRPOItemDtlID,
               IFNULL(i.ItemID, '') AS ItemID,
               IFNULL(i.ColorID, '') AS ColorID,
               IFNULL(i.Title, '') AS Title,
               i.ImageName, i.fileContent, i.ImageExtn,
               IFNULL(i.ImageSymbol, '') AS ImageSymbol,
               i.ImageSqn, i.recUser,
               IFNULL(i.BE_pRowID, 'NULL') AS BE_pRowID,
               IFNULL(i.FileSent, 0) AS FileSent,
               IFNULL(i.ImagePathID, '') AS ImagePathID
        FROM QRPOItemDtl_Image i
        INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
        WHERE i.QRHdrID IN (?)
          AND i.recEnable = 1
      ''';

      final List<Map<String, dynamic>> results =
          await db.rawQuery(query, [hdrID]);

      imageList = results.map((map) => ImageModal.fromJson(map)).toList();
      // imageList = await getFileContentFromTableToSendSeparateImageColumn(query,hdrID);
      print("JSON from QRPOItemDtl_Image table: ${results}");
      print("JSON from QRPOItemDtl_Image table: ${jsonEncode(imageList)}");
      developer.log("json from QRPOItemDtl_Image table   >>.: $imageList");
    } catch (e) {
      debugPrint("Error in getImageFilesJson: $e");
    }

    return imageList;
  }

static  Future<List<ImageModal>> getFileContentFromTableToSendSeparateImageColumn(
 String query,String hdrID) async {
    List<ImageModal>? imageModals;

    try {
      final db = await DatabaseHelper().database;

      final List<Map<String, dynamic>> result =
      await db.rawQuery(query, [hdrID]);
      print("JSON from QRPOItemDtl_Image table>>: ${result}");
      if (result.isNotEmpty) {
        imageModals = [];

        for (var row in result) {
          int sentFile = row['FileSent'] ?? 0;

          if (sentFile == 0) {
            String? fileContent = row['fileContent'];

            if (fileContent != null && fileContent.isNotEmpty && fileContent != 'null') {
              Uri uri = Uri.parse(fileContent);
              File testFile = File(uri.path);

              if (await testFile.exists()) {
                ImageModal imageModal = ImageModal();
                imageModal.pRowID = row['pRowID']?.toString();
                imageModal.qrHdrID = row['QRHdrID']?.toString();
                imageModal.qrPOItemHdrID = row['QRPOItemHdrID']?.toString();
                imageModal.length = "";

                String fileExtn = 'jpg'; // default extension
                String? _fileEx = row['ImageExtn'];
                if (_fileEx != null && _fileEx.isNotEmpty && _fileEx != 'null') {
                  fileExtn = _fileEx;
                }

                String fileName = '${row['QRHdrID']}_${row['pRowID']}.$fileExtn';
                imageModal.fileName = fileName;
                imageModal.fileContent = fileContent;
                print("JSON from QRPOItemDtl_Image table: ${jsonEncode(imageModal)}");
                imageModals.add(imageModal);
              } else {
                debugPrint("FILE NOT FOUND: $fileContent");
              }
            } else {
              debugPrint("FILE CONTENT IS NULL");
            }
          } else {
            debugPrint("FILE ALREADY SYNCED");
          }
        }
      }



      if (imageModals != null) {
        debugPrint("List of images from table: ${imageModals.length}");
      } else {
        debugPrint("No images found in table");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    return imageModals!;
  }

  Future<List<Map<String, dynamic>>> getQRPOItemDtl_ItemMeasurementJson(
      String hdrID) async {
    final db = await DatabaseHelper().database;

    final String query = '''
    SELECT 
      i.pRowID, i.LocID, i.QRHdrID, IFNULL(i.QRPOItemHdrID, '') AS QRPOItemHdrID,
      IFNULL(i.QRPOItemDtlID, '') AS QRPOItemDtlID, IFNULL(i.ItemID, '') AS ItemID,
      IFNULL(i.ColorID, '') AS ColorID, IFNULL(i.ItemMeasurementDescr, '') AS ItemMeasurementDescr,
      IFNULL(i.SampleSizeID, '') AS SampleSizeID, IFNULL(i.SampleSizeValue, '') AS SampleSizeValue,
      IFNULL(i.Finding, '') AS Finding, IFNULL(i.InspectionResultID, '') AS InspectionResultID,
      i.recUser,
      IFNULL(i.Dim_Height, '') AS Dim_Height, IFNULL(i.Dim_Width, '') AS Dim_Width,
      IFNULL(i.Dim_Length, '') AS Dim_Length, IFNULL(i.Tolerance_Range, '') AS Tolerance_Range,
      i.Digitals
    FROM QRPOItemDtl_ItemMeasurement i
    INNER JOIN QRFeedbackhdr hdr ON hdr.pRowID = i.QRHdrID
    WHERE i.QRHdrID IN (?) AND i.recEnable = 1
  ''';

    try {
      final result = await db.rawQuery(query, [hdrID]);
      print("Result from QRPOItemDtl_ItemMeasurement: $result");
      return result;
    } catch (e) {
      print("Error executing query: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getOnSiteJsonData(String hdrID) async {
    final db = await DatabaseHelper().database;

    try {
      final String query = 'SELECT * FROM QRPOItemDtl_OnSite_Test';
      final result = await db.rawQuery(query);
      print('JSON from QRPOItemDtl_OnSite_Test table: $result');
      return result;
    } catch (e) {
      print('Error fetching OnSite data: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getPkgAppJsonData(String hdrID) async {
    final db = await DatabaseHelper().database;

    try {
      final String query = '''
      SELECT d.*, 
        h.PKG_App_Unit_Digitals, h.PKG_App_Inner_Digitals,
        h.PKG_App_Master_Digitals, h.PKG_App_Pallet_Digitals,
        h.PKG_App_Shipping_Digitals
      FROM QRPOItemDtl_PKG_App_Details d
      INNER JOIN QRPOItemHdr h ON h.pRowID = d.QRPOItemHdrID
      WHERE d.QRHdrID = ?
    ''';

      final result = await db.rawQuery(query, [hdrID]);
      print('JSON from QRPOItemDtl_PKG_App_Details table: $result');
      return result;
    } catch (e) {
      print('Error fetching PkgApp data: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSampleCollectedJsonData(
      String hdrID) async {
    final db = await DatabaseHelper().database;

    try {
      final String query = 'SELECT * FROM QRPOItemDtl_Sample_Purpose';
      final result = await db.rawQuery(query);
      print('JSON from QRPOItemDtl_Sample_Purpose table: $result');
      return result;
    } catch (e) {
      print('Error fetching SampleCollected data: $e');
      return [];
    }
  }

// void handleToHeaderSync({
//   required List<String> idsListForSync,
//   required SyncToServerCubit syncCubit,
//   required Future<List<dynamic>> Function(List<String>) getHdrTableData,
//   required void Function(String, String) updateSyncList,
//   required void Function() handleToSizeQtySync,
//   required void Function() handleToImageSync,
// }) async {
//   if (idsListForSync.isNotEmpty) {
//     try {
//       final hdrTables = await getHdrTableData(idsListForSync);
//
//       print("Header table data: $hdrTables");
//
//       if (hdrTables.isNotEmpty) {
//         updateSyncList("E_SYNC_HEADER_TABLE", "E_SYNC_PENDING_STATUS");
//
//         final inspectionData = {
//           "InspectionData": {
//             "Data": hdrTables,
//             "ImageFiles": "",
//             "EnclosureFiles": "",
//             "TestReportFiles": "",
//             "Result": true,
//             "Message": "",
//             "MsgDetail": "",
//           }
//         };
//
//         print("Params to send: $inspectionData");
//         print("Header sync .........................................\n\n");
//
//         await syncCubit.sendInspection(inspectionData);
//
//         final currentState = syncCubit.state;
//       }
//     } catch (e) {
//       updateSyncList("E_SYNC_HEADER_TABLE", "E_SYNC_FAILED_STATUS");
//       print("Exception in header sync: $e");
//     }
//   }
// }
}
