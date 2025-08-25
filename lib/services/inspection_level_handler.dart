import 'package:buyerease/database/database_helper.dart';
import 'package:buyerease/model/inspection_level_model.dart';

class InspectionLevelHandler {
  static const String _tag = 'InspectionLevelHandler';

  static Future<List<InspectionLevelModel>> getInspectionLevels() async {
    final List<InspectionLevelModel> inspectionLevels = [];
    try {
      final db = await DatabaseHelper().database;
      final query = '''
        SELECT pRowID, InspAbbrv, InspDescr 
        FROM InsplvlHdr 
        WHERE recEnable = 1 
      ''';
      
      print('$_tag: Query for get inspection levels: $query');
      final result = await db.rawQuery(query);

      for (var row in result) {
        inspectionLevels.add(InspectionLevelModel.fromMap(row));
      }
      print('$_tag: Count of founded inspection levels: ${inspectionLevels.length}');
      print('$_tag: Count of founded inspection levels: ${inspectionLevels}');
    } catch (e) {
      print('$_tag: Exception getting inspection levels: $e');
    }
    return inspectionLevels;
  }
} 