

import 'package:buyerease/utils/fsl_log.dart';
import 'package:sqflite/sqflite.dart';


import '../../database/database_helper.dart';
import '../../database/table/qr_po_item_dtl_image_table.dart';
import '../../utils/gen_utils.dart';

import '../get_data_handler.dart';


class ItemInspectionDetailHandler {
    static const String _tag = 'ItemInspectionDetailHandler';

    static Future<List<int>> isImportant({

        required String qrHdrId,
        required String? qrPoItemHdrId,
    }) async
    {
        List<int> importantList = [];

        try {
            // Check and alter table for IsImportant column
            if (!await GenUtils.columnExistsInTable(table:'Enclosures', columnToCheck:'IsImportant', )) {
                FslLog.e(_tag, 'Column IsImportant not found in Enclosures table, altering table');
                await GetDataHandler.handleToAlterAsIn( 'Enclosures', 'IsImportant');
            }

            // Check and alter table for IsRead column
            if (!await GenUtils.columnExistsInTable( table:'Enclosures', columnToCheck:'IsRead')) {
                FslLog.e(_tag, 'Column IsRead not found in Enclosures table, altering table');
                await GetDataHandler.handleToAlterAsIn( 'Enclosures', 'IsRead');
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
    Future<void> updateImageTitle(String pRowID, String title) async {
        try {
            final contentValues = {
                QrPoItemDtlImageTable.title: title,
            };
            await QrPoItemDtlImageTable().update(pRowID, contentValues);
            print('Updated QRPOItemDtl_Image Title for pRowID: $pRowID');
        } catch (e) {
            print('Error updating QRPOItemDtl_Image title: $e');
            rethrow;
        }
    }

  static  Future<void> updateImageToMakeAgainNotSync(String qrHdrID) async {
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
}