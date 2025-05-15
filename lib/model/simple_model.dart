// File: sample_model.dart

class SampleModel {
  String? sampleCode;
  String? mainDescr;
  String? sampleVal;

  SampleModel({
    this.sampleCode,
    this.mainDescr,
    this.sampleVal,
  });

  factory SampleModel.fromJson(Map<String, dynamic> json) {
    return SampleModel(
      sampleCode: json['SampleCode'],
      mainDescr: json['MainDescr'],
      sampleVal: json['SampleVal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SampleCode': sampleCode,
      'MainDescr': mainDescr,
      'SampleVal': sampleVal,
    };
  }
}
