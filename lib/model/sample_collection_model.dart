class SampleCollectedModel {
  String? pRowID;
  String? locID;
  String? samplePurposeID;
  int? sampleNumber;
  String? recDt;

  SampleCollectedModel({
    this.pRowID,
    this.locID,
    this.samplePurposeID,
    this.sampleNumber,
    this.recDt,
  });

  factory SampleCollectedModel.fromJson(Map<String, dynamic> json) {
    return SampleCollectedModel(
      pRowID: json['pRowID'],
      locID: json['locID'],
      samplePurposeID: json['samplePurposeID'],
      sampleNumber: json['sampleNumber'],
      recDt: json['recDt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pRowID': pRowID,
      'locID': locID,
      'samplePurposeID': samplePurposeID,
      'sampleNumber': sampleNumber,
      'recDt': recDt,
    };
  }
}
