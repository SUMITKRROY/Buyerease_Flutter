class SysData22Modal {
  String genID;
  String mainID;
  String subID;
  String masterName;
  String mainDescr;
  String subDescr;
  String numVal1;
  String numVal2;
  String addonInfo;
  String moreInfo;
  String priviledge;
  String a;
  String moduleAccess;
  String moduleID;

  SysData22Modal({
    required this.genID,
    required this.mainID,
    required this.subID,
    required this.masterName,
    required this.mainDescr,
    required this.subDescr,
    required this.numVal1,
    required this.numVal2,
    required this.addonInfo,
    required this.moreInfo,
    required this.priviledge,
    required this.a,
    required this.moduleAccess,
    required this.moduleID,
  });

  Map<String, dynamic> toMap() {
    return {
      'GenID': genID,
      'MainID': mainID,
      'SubID': subID,
      'MasterName': masterName,
      'MainDescr': mainDescr,
      'SubDescr': subDescr,
      'numVal1': numVal1,
      'numVal2': numVal2,
      'AddonInfo': addonInfo,
      'MoreInfo': moreInfo,
      'Priviledge': priviledge,
      'a': a,
      'ModuleAccess': moduleAccess,
      'ModuleID': moduleID,
    };
  }

  factory SysData22Modal.fromMap(Map<String, dynamic> map) {
    return SysData22Modal(
      genID: map['GenID'] ?? '',
      mainID: map['MainID'] ?? '',
      subID: map['SubID'] ?? '',
      masterName: map['MasterName'] ?? '',
      mainDescr: map['MainDescr'] ?? '',
      subDescr: map['SubDescr'] ?? '',
      numVal1: map['numVal1'] ?? '',
      numVal2: map['numVal2'] ?? '',
      addonInfo: map['AddonInfo'] ?? '',
      moreInfo: map['MoreInfo'] ?? '',
      priviledge: map['Priviledge'] ?? '',
      a: map['a'] ?? '',
      moduleAccess: map['ModuleAccess'] ?? '',
      moduleID: map['ModuleID'] ?? '',
    );
  }
}
