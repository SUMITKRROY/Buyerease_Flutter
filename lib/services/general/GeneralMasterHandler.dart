import 'package:sqflite/sqflite.dart';
import '../../database/database_helper.dart';
import 'GeneralModel.dart';

class GeneralMasterHandler {
  static const String tag = 'GeneralMasterHandler';

  /// Get general list by GenID
  static Future<List<GeneralModel>> getGeneralList(String genId) async {
    final db = await DatabaseHelper().database;
    List<GeneralModel> generalList = [];

    try {
      String query = "SELECT * FROM GenMst WHERE GenID = ?";
      final   result = await db.rawQuery(query, [genId]);

      for (var row in result) {
        generalList.add(GeneralModel.fromJson(row));
      }

    } catch (e) {
      print('$tag: Exception in getGeneralList: $e');
    }

    return generalList;
  }

  /// Get general list by GenID and departmentId (pGenRowID)
  static Future<List<GeneralModel>> getGeneralAccordingToParticularList(
      String genId, String departmentId) async {
    final db = await DatabaseHelper().database;
    List<GeneralModel> generalList = [];

    try {
      String query = "SELECT * FROM GenMst WHERE GenID = ? AND pGenRowID = ?";
      final List<Map<String, dynamic>> result = await db.rawQuery(query, [genId, departmentId]);

      for (var row in result) {
        generalList.add(GeneralModel.fromJson(row));
      }

      print('$tag: Count of found list of general = ${generalList.length}');
    } catch (e) {
      print('$tag: Exception in getGeneralAccordingToParticularList: $e');
    }

    return generalList;
  }



  Future<String?> getComplaintNatureAccordingId(String pGenRowID) async {
    final Database db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> result = await db.query(
      'GenMst',
      columns: ['MainDescr'],
      where: 'pGenRowID = ?',
      whereArgs: [pGenRowID],
    );

    if (result.isNotEmpty) {
      return result.last['MainDescr'] as String?;
    }

    return null;
  }


  List<GeneralModel> parseComplaintType(String generalMasterType, Map<String, dynamic> jsonObject) {
    List<GeneralModel> generalModelList = [];

    if (jsonObject.containsKey(generalMasterType)) {
      List<dynamic> jsonArray = jsonObject[generalMasterType];

      for (var item in jsonArray) {
        // You can expand this model mapping as per actual field mappings
        GeneralModel model = GeneralModel.fromJson(item);
        generalModelList.add(model);
      }
    }

    return generalModelList;
  }

}
