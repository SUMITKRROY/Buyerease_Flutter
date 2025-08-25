class GeneralModel {
  String? pGenRowID;
  String? locID;
  int? genID;
  String? mainID;
  String? subID;
  String? abbrv;
  String? mainDescr;
  String? subDescr;
  double? numVal1;
  double? numVal2;
  double? numVal3;
  double? numVal4;
  double? numVal5;
  double? numVal6;
  double? numVal7;
  String? chrVal1;
  String? chrVal2;
  String? chrVal3;
  DateTime? dtVal1;
  String? imageName;
  String? imageExtn;
  int? recDirty;
  int? recEnable;
  String? recUser;
  DateTime? recAddDt;
  DateTime? recDt;
  DateTime? ediDt;
  int? isPrivilege;
  DateTime? lastSyncDt;

  GeneralModel({
    this.pGenRowID,
    this.locID,
    this.genID,
    this.mainID,
    this.subID,
    this.abbrv,
    this.mainDescr,
    this.subDescr,
    this.numVal1,
    this.numVal2,
    this.numVal3,
    this.numVal4,
    this.numVal5,
    this.numVal6,
    this.numVal7,
    this.chrVal1,
    this.chrVal2,
    this.chrVal3,
    this.dtVal1,
    this.imageName,
    this.imageExtn,
    this.recDirty,
    this.recEnable,
    this.recUser,
    this.recAddDt,
    this.recDt,
    this.ediDt,
    this.isPrivilege,
    this.lastSyncDt,
  });

  factory GeneralModel.fromJson(Map<String, dynamic> json) {
    return GeneralModel(
      pGenRowID: json['pGenRowID'],
      locID: json['LocID'],
      genID: int.tryParse(json['GenID']?.toString() ?? ''),
      mainID: json['MainID'],
      subID: json['SubID']?.trim().isEmpty ?? true ? null : json['SubID'],
      abbrv: json['Abbrv'],
      mainDescr: json['MainDescr'],
      subDescr: json['SubDescr'],
      numVal1: double.tryParse(json['numVal1']?.toString() ?? ''),
      numVal2: double.tryParse(json['numVal2']?.toString() ?? ''),
      numVal3: double.tryParse(json['numVal3']?.toString() ?? ''),
      numVal4: double.tryParse(json['numVal4']?.toString() ?? ''),
      numVal5: double.tryParse(json['numVal5']?.toString() ?? ''),
      numVal6: double.tryParse(json['numVal6']?.toString() ?? ''),
      numVal7: double.tryParse(json['numval7']?.toString() ?? ''),
      chrVal1: json['chrVal1'],
      chrVal2: json['chrVal2'],
      chrVal3: json['chrVal3'],
      dtVal1: json['dtVal1'] != null ? DateTime.tryParse(json['dtVal1']) : null,
      imageName: json['ImageName'],
      imageExtn: json['ImageExtn'],
      recDirty: int.tryParse(json['recDirty']?.toString() ?? ''),
      recEnable: int.tryParse(json['recEnable']?.toString() ?? ''),
      recUser: json['recUser'],
      recAddDt: DateTime.tryParse(json['recAddDt']),
      recDt: DateTime.tryParse(json['recDt']),
      ediDt: json['EDIDt'] != null ? DateTime.tryParse(json['EDIDt']) : null,
      isPrivilege: int.tryParse(json['IsPrivilege']?.toString() ?? ''),
      lastSyncDt: DateTime.tryParse(json['Last_Sync_Dt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pGenRowID': pGenRowID,
      'LocID': locID,
      'GenID': genID,
      'MainID': mainID,
      'SubID': subID,
      'Abbrv': abbrv,
      'MainDescr': mainDescr,
      'SubDescr': subDescr,
      'numVal1': numVal1,
      'numVal2': numVal2,
      'numVal3': numVal3,
      'numVal4': numVal4,
      'numVal5': numVal5,
      'numVal6': numVal6,
      'numval7': numVal7,
      'chrVal1': chrVal1,
      'chrVal2': chrVal2,
      'chrVal3': chrVal3,
      'dtVal1': dtVal1?.toIso8601String(),
      'ImageName': imageName,
      'ImageExtn': imageExtn,
      'recDirty': recDirty,
      'recEnable': recEnable,
      'recUser': recUser,
      'recAddDt': recAddDt?.toIso8601String(),
      'recDt': recDt?.toIso8601String(),
      'EDIDt': ediDt?.toIso8601String(),
      'IsPrivilege': isPrivilege,
      'Last_Sync_Dt': lastSyncDt?.toIso8601String(),
    };
  }
}
