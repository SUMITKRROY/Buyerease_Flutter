import 'package:buyerease/database/database_helper.dart';
import 'package:buyerease/model/quality_level_model.dart';

class QualityLevelHandler {
  static const String _tag = 'QualityLevelHandler';

  static Future<List<QualityLevelModel>> getQualityLevels() async {
    final List<QualityLevelModel> qualityLevels = [];
    try {
      final db = await DatabaseHelper().database;
      final query = '''
        SELECT pRowID, QualityLevel 
        FROM QualityLevel 
        WHERE recEnable = 1 
        ORDER BY QualityLevel
      ''';
      
      print('$_tag: Query for get quality levels: $query');
      final result = await db.rawQuery(query);

      for (var row in result) {
        qualityLevels.add(QualityLevelModel.fromMap(row));
      }
      print('$_tag: Count of founded quality levels: ${qualityLevels.length}');
    } catch (e) {
      print('$_tag: Exception getting quality levels: $e');
    }
    return qualityLevels;
  }
} 