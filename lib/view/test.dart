import 'package:buyerease/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';

import '../database/table/qr_po_item_dtl_table.dart';
import '../model/inspection_model.dart';
import '../services/inspection_list/InspectionListHandler.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<InspectionModal> inspectionList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // fetchItemIds(); // Don't await here.
    getUnsyncedFeedback();
    getLocalList("");
  }

  Future<void> fetchItemIds() async {

     await InspectionListHandler.getInspectionList("");
    final qrpoTable = QRPOItemDtlTable();
    // String? itemIds = await qrpoTable.getCustomerItemRefByPRowID('Search By DEL Id');
    String? itemIds = await qrpoTable.getCustomerItemRefByPRowID('DEL0366268');

    if (itemIds != null) {
      print("Fetched Item IDs: $itemIds");
    } else {
      print("No Item IDs found.");
    }
  }
  Future<List<Map<String, dynamic>>> getUnsyncedFeedback() async {
    try {
      final db = await DatabaseHelper().database;
      final String query = '''
      SELECT * FROM QRFeedbackhdr 
      WHERE pRowID NOT IN (
        SELECT pRowID FROM QRFeedbackhdr 
        WHERE status IN (20, 40, 45, 50, 60, 65) 
        AND datetime(recDt) <= datetime(IFNULL(Last_Sync_Dt, '1900-01-01 00:00:00'))
      )
      AND IsSynced = 0
      ORDER BY InspectionDt DESC
    ''';

      final List<Map<String, dynamic>> result = await db.rawQuery(query);
      print("print result $result");
      return result;
    } on DatabaseException catch (e) {
      if (e.isNoSuchTableError()) {
        print('Error: Table QRFeedbackhdr does not exist.');
      } else {
        print('Database error: $e');
      }
      return []; // Return empty list on error
    } catch (e) {
      print('Unknown error: $e');
      return [];
    }
  }


  Future<void> getLocalList(String searchStr) async {
    setState(() {
      isLoading = true;
    });

    try {
      List<InspectionModal> localList = await InspectionListHandler.getInspectionList(searchStr);

      setState(() {
        inspectionList.clear();
        if (localList.isNotEmpty) {
          inspectionList.addAll(localList);
          print("Fetched inspections: ${inspectionList.length}");
          for (var item in localList) {
            print("pRowID: ${item.pRowID}, QRHdrID: ${item.qrHdrID}");
          }
        } else {
          Fluttertoast.showToast(msg: "Inspection did not find");
        }
      });
    } catch (e) {
      debugPrint("Error fetching local list: $e");
      Fluttertoast.showToast(msg: "Failed to load inspections");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inspections")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : inspectionList.isEmpty
          ? Center(child: Text("No inspections found"))
          : ListView.builder(
        itemCount: inspectionList.length,
        itemBuilder: (context, index) {
          final item = inspectionList[index];
          return ListTile(
            title: Text(item.pRowID ?? ""),
            subtitle: Text(item.qrHdrID ?? ""),
          );
        },
      ),
    );
  }
}
