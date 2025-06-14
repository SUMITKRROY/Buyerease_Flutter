class InspectionLevelModel {
  final String? pRowID;
  final String? inspAbbrv;
  final String? inspDescr;

  InspectionLevelModel({
    this.pRowID,
    this.inspAbbrv,
    this.inspDescr,
  });

  factory InspectionLevelModel.fromMap(Map<String, dynamic> map) {
    return InspectionLevelModel(
      pRowID: map['pRowID']?.toString(),
      inspAbbrv: map['InspAbbrv']?.toString(),
      inspDescr: map['InspDescr']?.toString(),
    );
  }
} 