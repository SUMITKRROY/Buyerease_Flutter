class SysData22Modal {
  String? genId;
  String? masterName;
  String? mainId;
  String? mainDescr;
  String? subId;
  String? subDescr;
  String? numVal1;
  String? numVal2;
  String? addonInfo;
  String? moreInfo;
  String? priviledge;
  String? a;
  String? moduleAccess;
  String? moduleId;

  SysData22Modal({
    this.genId,
    this.masterName,
    this.mainId,
    this.mainDescr,
    this.subId,
    this.subDescr,
    this.numVal1,
    this.numVal2,
    this.addonInfo,
    this.moreInfo,
    this.priviledge,
    this.a,
    this.moduleAccess,
    this.moduleId,
  });

  SysData22Modal copyWith({
    String? genId,
    String? masterName,
    String? mainId,
    String? mainDescr,
    String? subId,
    String? subDescr,
    String? numVal1,
    String? numVal2,
    String? addonInfo,
    String? moreInfo,
    String? priviledge,
    String? a,
    String? moduleAccess,
    String? moduleId,
  }) =>
      SysData22Modal(
        genId: genId ?? this.genId,
        masterName: masterName ?? this.masterName,
        mainId: mainId ?? this.mainId,
        mainDescr: mainDescr ?? this.mainDescr,
        subId: subId ?? this.subId,
        subDescr: subDescr ?? this.subDescr,
        numVal1: numVal1 ?? this.numVal1,
        numVal2: numVal2 ?? this.numVal2,
        addonInfo: addonInfo ?? this.addonInfo,
        moreInfo: moreInfo ?? this.moreInfo,
        priviledge: priviledge ?? this.priviledge,
        a: a ?? this.a,
        moduleAccess: moduleAccess ?? this.moduleAccess,
        moduleId: moduleId ?? this.moduleId,
      );

  /// Create object from database row
  factory SysData22Modal.fromMap(Map<String, dynamic> map) {
    return SysData22Modal(
      genId: map['GenID']?.toString(),
      masterName: map['MasterName']?.toString(),
      mainId: map['MainID']?.toString(),
      mainDescr: map['MainDescr']?.toString(),
      subId: map['SubID']?.toString(),
      subDescr: map['SubDescr']?.toString(),
      numVal1: map['NumVal1']?.toString(),
      numVal2: map['NumVal2']?.toString(),
      addonInfo: map['AddonInfo']?.toString(),
      moreInfo: map['MoreInfo']?.toString(),
      priviledge: map['Priviledge']?.toString(),
      a: map['A']?.toString(),
      moduleAccess: map['ModuleAccess']?.toString(),
      moduleId: map['ModuleId']?.toString(),
    );
  }

  /// Convert object to map (for inserts/updates)
  Map<String, dynamic> toMap() {
    return {
      'GenID': genId,
      'MasterName': masterName,
      'MainID': mainId,
      'MainDescr': mainDescr,
      'SubID': subId,
      'SubDescr': subDescr,
      'NumVal1': numVal1,
      'NumVal2': numVal2,
      'AddonInfo': addonInfo,
      'MoreInfo': moreInfo,
      'Priviledge': priviledge,
      'A': a,
      'ModuleAccess': moduleAccess,
      'ModuleId': moduleId,
    };
  }
}
