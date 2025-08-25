class SampleModel {
  String? sampleCode;
  String? mainDescr;
  int? sampleVal; // changed to int

  SampleModel({
    this.sampleCode,
    this.mainDescr,
    this.sampleVal,
  });

  factory SampleModel.fromJson(Map<String, dynamic> json) {
    return SampleModel(
      sampleCode: json['SampleCode']?.toString(),
      mainDescr: json['MainDescr']?.toString(),
      sampleVal: _parseToInt(json['numVal1']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SampleCode': sampleCode,
      'MainDescr': mainDescr,
      'numVal1': sampleVal,
    };
  }

  // Helper method to safely parse int from any number type
  static int? _parseToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt(); // truncate decimal
    return int.tryParse(value.toString());
  }
}
