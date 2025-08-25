class QualityLevelModal {
  String? pRowID;
  String? locID;
  String? qualityLevel;
  int? recDirty;
  int? recEnable;
  String? recUser;
  String? recAddDt;
  String? recDt;

  QualityLevelModal({
    this.pRowID,
    this.locID,
    this.qualityLevel,
    this.recDirty,
    this.recEnable,
    this.recUser,
    this.recAddDt,
    this.recDt,
  });

  // Optional: From JSON
  factory QualityLevelModal.fromJson(Map<String, dynamic> json) {
    return QualityLevelModal(
      pRowID: json['pRowID'],
      locID: json['locID'],
      qualityLevel: json['qualityLevel'],
      recDirty: json['recDirty'],
      recEnable: json['recEnable'],
      recUser: json['recUser'],
      recAddDt: json['recAddDt'],
      recDt: json['recDt'],
    );
  }

  // Optional: To JSON
  Map<String, dynamic> toJson() {
    return {
      'pRowID': pRowID,
      'locID': locID,
      'qualityLevel': qualityLevel,
      'recDirty': recDirty,
      'recEnable': recEnable,
      'recUser': recUser,
      'recAddDt': recAddDt,
      'recDt': recDt,
    };
  }
}
