class User {
  final String pUserID;
  final String parentID;
  final String loginName;
  final String password;
  final String userName;
  final String email;
  final String fCommunityID;
  final String fContactID;
  final int isAdmin;
  final String locId;
  final String desg;
  final String address;
  final String city;
  final String zip;
  final String state;
  final String countryID;
  final String phoneNo1;
  final String phoneNo2;
  final String phoneNo3;
  final String fax;
  final String webURL;
  final int pageSize;
  final int dateFormat;
  final int homePOGraph;
  final String homePOGraphXValue;
  final String homePOGraphYValue;
  final int srView;
  final int poView;
  final int poView12;
  final int qrView;
  final int invoiceView;
  final int vesselView;
  final int columnPickerView;
  final String approvalPassword;
  final String birthDt;
  final String joiningDt;
  final int recEnable;
  final String anniversaryDt;
  final int isOfflineInspection;
  final String offlineInspectionStaticIP;
  final String offlineInspectionMACID;
  final String userType;

  User({
    required this.pUserID,
    required this.parentID,
    required this.loginName,
    required this.password,
    required this.userName,
    required this.email,
    required this.fCommunityID,
    required this.fContactID,
    required this.isAdmin,
    required this.locId,
    required this.desg,
    required this.address,
    required this.city,
    required this.zip,
    required this.state,
    required this.countryID,
    required this.phoneNo1,
    required this.phoneNo2,
    required this.phoneNo3,
    required this.fax,
    required this.webURL,
    required this.pageSize,
    required this.dateFormat,
    required this.homePOGraph,
    required this.homePOGraphXValue,
    required this.homePOGraphYValue,
    required this.srView,
    required this.poView,
    required this.poView12,
    required this.qrView,
    required this.invoiceView,
    required this.vesselView,
    required this.columnPickerView,
    required this.approvalPassword,
    required this.birthDt,
    required this.joiningDt,
    required this.recEnable,
    required this.anniversaryDt,
    required this.isOfflineInspection,
    required this.offlineInspectionStaticIP,
    required this.offlineInspectionMACID,
    required this.userType,
  });

  Map<String, dynamic> toMap() {
    return {
      'pUserID': pUserID,
      'ParentID': parentID,
      'LoginName': loginName,
      'Password': password,
      'UserName': userName,
      'Email': email,
      'fCommunityID': fCommunityID,
      'fContactID': fContactID,
      'Isadmin': isAdmin,
      'LocId': locId,
      'Desg': desg,
      'Address': address,
      'City': city,
      'Zip': zip,
      'State': state,
      'CountryID': countryID,
      'PhoneNo1': phoneNo1,
      'PhoneNo2': phoneNo2,
      'PhoneNo3': phoneNo3,
      'Fax': fax,
      'WebURL': webURL,
      'PageSize': pageSize,
      'DateFormat': dateFormat,
      'HomePOGraph': homePOGraph,
      'HomePOGraphXValue': homePOGraphXValue,
      'HomePOGraphYValue': homePOGraphYValue,
      'SRView': srView,
      'POView': poView,
      'POView12': poView12,
      'QRView': qrView,
      'InvoiceView': invoiceView,
      'VesselView': vesselView,
      'ColumnPickerView': columnPickerView,
      'ApprovalPassword': approvalPassword,
      'BirthDt': birthDt,
      'JoiningDt': joiningDt,
      'recEnable': recEnable,
      'AnniversaryDt': anniversaryDt,
      'IsOffLineInspection': isOfflineInspection,
      'OffLineInspectionStaticIP': offlineInspectionStaticIP,
      'OffLineInspectionMACID': offlineInspectionMACID,
      'UserType': userType,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      pUserID: json['pUserID'],
      parentID: json['ParentID'],
      loginName: json['LoginName'],
      password: json['Password'],
      userName: json['UserName'],
      email: json['Email'],
      fCommunityID: json['fCommunityID'],
      fContactID: json['fContactID'],
      isAdmin: json['Isadmin'],
      locId: json['LocId'],
      desg: json['Desg'],
      address: json['Address'],
      city: json['City'],
      zip: json['Zip'],
      state: json['State'],
      countryID: json['CountryID'],
      phoneNo1: json['PhoneNo1'],
      phoneNo2: json['PhoneNo2'],
      phoneNo3: json['PhoneNo3'],
      fax: json['Fax'],
      webURL: json['WebURL'],
      pageSize: json['PageSize'],
      dateFormat: json['DateFormat'],
      homePOGraph: json['HomePOGraph'],
      homePOGraphXValue: json['HomePOGraphXValue'],
      homePOGraphYValue: json['HomePOGraphYValue'],
      srView: json['SRView'],
      poView: json['POView'],
      poView12: json['POView12'],
      qrView: json['QRView'],
      invoiceView: json['InvoiceView'],
      vesselView: json['VesselView'],
      columnPickerView: json['ColumnPickerView'],
      approvalPassword: json['ApprovalPassword'],
      birthDt: json['BirthDt'],
      joiningDt: json['JoiningDt'],
      recEnable: json['recEnable'],
      anniversaryDt: json['AnniversaryDt'],
      isOfflineInspection: json['IsOffLineInspection'],
      offlineInspectionStaticIP: json['OffLineInspectionStaticIP'],
      offlineInspectionMACID: json['OffLineInspectionMACID'],
      userType: json['UserType'],
    );
  }
}
