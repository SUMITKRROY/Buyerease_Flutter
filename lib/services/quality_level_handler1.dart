// import 'package:buyerease/database/database_helper.dart';
// import 'package:buyerease/model/quality_level_model.dart';
//
// import '../model/quality_modal/quality_level_modal.dart';
//
// class QualityLevelHandler {
//   static const String _tag = 'QualityLevelHandler';
//
//   static Future<bool> insertQualityLevelMaster(QualityLevelModel qualityLevelModel) async {
//     try {
//       final db = await DatabaseHelper().database;
//       final data = qualityLevelModel.();
//
//       // Try to update first
//       int rows = await db.update(
//         'QualityLevel',
//         data,
//         where: 'pRowID = ?',
//         whereArgs: [qualityLevelModel.pRowID],
//       );
//
//       if (rows == 0) {
//         // No rows updated, insert instead
//         int result = await db.insert('QualityLevel', data);
//         print('QualityLevel insert result: $result');
//       } else {
//         print('QualityLevel update result: $rows');
//       }
//
//       return true;
//     } catch (e) {
//       print('Exception while inserting QualityLevel: $e');
//       return false;
//     }
//   }
//
//   static Future<List<QualityLevelModel>> getQualityLevels() async {
//     final List<QualityLevelModel> qualityLevels = [];
//     try {
//       final db = await DatabaseHelper().database;
//       final query = '''
//         SELECT pRowID, QualityLevel
//         FROM QualityLevel
//         WHERE recEnable = 1
//         ORDER BY QualityLevel
//       ''';
//
//       print('$_tag: Query for get quality levels: $query');
//       final result = await db.rawQuery(query);
//
//       for (var row in result) {
//         qualityLevels.add(QualityLevelModel.fromMap(row));
//       }
//       print('$_tag: Count of founded quality levels: ${qualityLevels.length}');
//     } catch (e) {
//       print('$_tag: Exception getting quality levels: $e');
//     }
//     return qualityLevels;
//   }
//
//
//   static Future<List<QualityLevelModel>> getDataAccordingToParticularList(String pRowID) async {
//     final db = await DatabaseHelper().database;
//
//     final String query = '''
//     SELECT * FROM QualityLevel
//     WHERE pRowID = ?
//   ''';
//
//     final List<Map<String, dynamic>> result = await db.rawQuery(query, [pRowID]);
//
//     return result.map((row) => QualityLevelModel.fromJson(row)).toList();
//   }
//
//   static Future<List<QualityLevelModel>> getQualityLevelList() async {
//     final List<QualityLevelModel> resultList = [];
//
//     try {
//       final db = await DatabaseHelper().database;
//
//       final String query = 'SELECT * FROM QualityLevel';
//       final List<Map<String, dynamic>> result = await db.rawQuery(query);
//
//       for (var row in result) {
//         resultList.add(QualityLevelModel.fromMap(row));
//       }
//     } catch (e) {
//       print('Error in getQualityLevelList: $e');
//     }
//
//     return resultList;
//   }
//
//
//
// }