class QualityLevelModel {
  final String? pRowID;
  final String? qlAbbrv;
  final String? qlDescr;
  final String? qualityLevel;

  QualityLevelModel({
    this.pRowID,
    this.qlAbbrv,
    this.qlDescr,
    this.qualityLevel,
  });



  factory QualityLevelModel.fromMap(Map<String, dynamic> map) {
    return QualityLevelModel(
      pRowID: map['pRowID']?.toString(),
      qlAbbrv: map['QlAbbrv']?.toString(),
      qlDescr: map['QlDescr']?.toString(),
      qualityLevel: map['QualityLevel']?.toString(),
    );
  }
}