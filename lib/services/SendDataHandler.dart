/**
 * Created by Sumit on 24/06/25.
 */
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

import '../database/database_helper.dart';
import '../model/digital_image_model.dart';

/// SendDataHandler: Dart/Flutter version
/// This class provides static methods to fetch and prepare data from SQLite for sending to a server.
/// All methods assume you have a [Database] instance from sqflite.
class SendDataHandler {
  /// Example: Get all user master data as a map
  static Future<Map<String, dynamic>?> getUserMasterJson(Database db) async {
    try {
      final List<Map<String, dynamic>> result = await db.query('UserMaster');
      if (result.isNotEmpty) {
        return {'Data': result};
      }
    } catch (e) {
      print('Error in getUserMasterJson: $e');
    }
    return null;
  }

  /// Example: Get header table data for a list of IDs
  static Future<Map<String, dynamic>> getHdrTableData(
      List<String> hdrIdList) async {
    final Database db = await DatabaseHelper().database;
    final Map<String, dynamic> params = {};
    for (final id in hdrIdList) {
      params['QRFeedbackhdr'] = await getQRFeedbackhdrJson(db, id);
      params['QRPOItemHdr'] = await getQRPOItemHdrJson(db, id);
      params['QRPOItemDtl'] = await getQRPOItemdtlJson(db, id);
    }
    return params;
  }

  /// Example: Get all rows from QRFeedbackhdr for a given id
  static Future<List<Map<String, dynamic>>> getQRFeedbackhdrJson(
      Database db, String hdrID) async {
    try {
      final result = await db.query(
        'QRFeedbackhdr',
        where: 'pRowID = ?',
        whereArgs: [hdrID],
      );
      return result;
    } catch (e) {
      print('Error in getQRFeedbackhdrJson: $e');
      return [];
    }
  }

  /// Example: Get all rows from QRPOItemHdr for a given id
  static Future<List<Map<String, dynamic>>> getQRPOItemHdrJson(
      Database db, String hdrID) async {
    try {
      final result = await db.query(
        'QRPOItemHdr',
        where: 'QRHdrID = ?',
        whereArgs: [hdrID],
      );
      return result;
    } catch (e) {
      print('Error in getQRPOItemHdrJson: $e');
      return [];
    }
  }

  /// Example: Get all rows from QRPOItemDtl for a given id
  static Future<List<Map<String, dynamic>>> getQRPOItemdtlJson(
      Database db, String hdrID) async {
    try {
      final result = await db.query(
        'QRPOItemDtl',
        where: 'QRHdrID = ?',
        whereArgs: [hdrID],
      );
      return result;
    } catch (e) {
      print('Error in getQRPOItemdtlJson: $e');
      return [];
    }
  }

  // TODO: Implement other methods as needed, following the same pattern.
  // For example: getSizeQtyData, getImagesTableData, getWorkmanShipData, etc.
  // Use async/await and sqflite queries, and return Dart Maps/Lists.

  static Future<List<DigitalImageModel>>
      getFileContentFromTableToSendSeparateImageColumn(String query) async {
    List<DigitalImageModel> imageModals = [];

    try {
      final Database db = await DatabaseHelper().database;
      debugPrint("Query to execute: $query");

      final List<Map<String, dynamic>> result = await db.rawQuery(query);

      for (var row in result) {
        int sentFile = row["FileSent"] ?? 1;

        if (sentFile == 0) {
          String? fileContent = row["fileContent"];

          if (fileContent != null &&
              fileContent.toLowerCase() != "null" &&
              fileContent.isNotEmpty) {
            final uri = Uri.parse(fileContent);
            final filePath = uri.path;
            final file = File(filePath);

            if (await file.exists()) {
              final imageModal = DigitalImageModel(
                pRowID: row["pRowID"] ?? '',
                QRHdrID: row["QRHdrID"] ?? '',
                QRPOItemHdrID: row["QRPOItemHdrID"] ?? '',
                Length: '', // Not used in original code
                FileName: _buildFileName(row),
                fileContent: fileContent, title: '', imagePath: '',
              );

              imageModals.add(imageModal);
            } else {
              debugPrint("File not found at path: $filePath");
            }
          } else {
            debugPrint("File content is empty or null.");
          }
        } else {
          debugPrint("File already synced. Skipping...");
        }
      }

      await db.close();
      debugPrint("Total images fetched: ${imageModals.length}");
    } catch (e) {
      debugPrint("Exception in getFileContentFromTableToSendSeparateImageColumn: $e");
    }

    return imageModals;
  }

  static String _buildFileName(Map<String, dynamic> row) {
    final fileExtn = (row["ImageExtn"] != null &&
            row["ImageExtn"].toString().toLowerCase() != "null")
        ? row["ImageExtn"]
        : "jpg"; // Default extension

    return "${row["QRHdrID"]}_${row["pRowID"]}.$fileExtn";
  }

  // Example placeholder for a callback-based sendData method
  static Future<void> sendData(
    Map<String, dynamic> params,
    Future<void> Function(Map<String, dynamic>) onSuccess,
    Future<void> Function(Object) onError,
  ) async {
    try {
      // TODO: Implement actual network sending logic using http or dio
      print('Sending data: ${jsonEncode(params)}');
      await onSuccess({'result': 'success'}); // Placeholder
    } catch (e) {
      await onError(e);
    }
  }
}
