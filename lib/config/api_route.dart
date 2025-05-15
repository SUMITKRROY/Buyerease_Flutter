import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ApiRoute {
  static SharedPreferences? sharedPreferences;

  // Server URLs
  static String communityCode = "http://www.buyerease.co.in/buyereasewebAPI/API/Account/GetCommunityURL";
  static String? ipAddressDownload;
  static String? ipAddressLive;
  static String? ipAddress;

  static String baseAddressDownload = "Helps/DownloadFile.aspx?FileName=output/";
  static String baseUrlLive = "api";
  static String? baseUrl;

  static String login = "$ipAddress$baseUrl/Account/AuthenticateUser";
  static String getInspection = "$ipAddress$baseUrl/Quality/GetQualityInspection";
  static String sendInspection = "$ipAddress$baseUrl/Quality/SendQualityInspection";
  static String uploadFile = "$ipAddress$baseUrl/Quality/SendFile";
  static String otp = "$ipAddress$baseUrl/account/AuthenticateUser";
  static String defectMaster = "$ipAddress$baseUrl/quality/GetDefectMaster";
  static String sendStyle = sendInspection;
  static String uploadStyleFile = uploadFile;
  static String getStyles = "$ipAddress$baseUrl/Quality/GetStyles";
  static String changePassword = "$ipAddress$baseUrl/Account/ChangePassword";
  static String forgotPassword = "$ipAddress$baseUrl/Account/ForgotPassword";
  static String syncProfile = "$ipAddress$baseUrl/Associate/UpdateProfile";
  static String downloadBase = "$ipAddressDownload$baseAddressDownload";
  static String encryptHistory = "$ipAddress$baseUrl" + "Quality/Encrypt";
  static String historyDetails = "$ipAddressDownload/QR/InspectionReportEntryViaHtml.aspx?Session=";
  static String updateReadStatus = "$ipAddress$baseUrl/Quality/DownloadStatus";


  /// Reset config dynamically
  static void resetConfig(String downloadUrl, String apiUrl) {
    ipAddressDownload = downloadUrl;
    ipAddressLive = apiUrl;
    ipAddress = ipAddressLive;
    baseUrl = baseUrlLive;
    login = "$ipAddress$baseUrl/Account/AuthenticateUser";
    getInspection = "$ipAddress$baseUrl/Quality/GetQualityInspection";
    sendInspection = "$ipAddress$baseUrl/Quality/SendQualityInspection";
    uploadFile = "$ipAddress$baseUrl/Quality/SendFile";
    otp = "$ipAddress$baseUrl/account/AuthenticateUser";
    defectMaster = "$ipAddress$baseUrl/quality/GetDefectMaster";
    sendStyle = sendInspection;
    uploadStyleFile = uploadFile;
    getStyles = "$ipAddress$baseUrl/Quality/GetStyles";
    changePassword = "$ipAddress$baseUrl/Account/ChangePassword";
    forgotPassword = "$ipAddress$baseUrl/Account/ForgotPassword";
    syncProfile = "$ipAddress$baseUrl/Associate/UpdateProfile";
    downloadBase = "$ipAddressDownload$baseAddressDownload";
    encryptHistory = "$ipAddress$baseUrl" + "Quality/Encrypt";
    historyDetails = "$ipAddressDownload/QR/InspectionReportEntryViaHtml.aspx?Session=";
    updateReadStatus = "$ipAddress$baseUrl/Quality/DownloadStatus";

  }

  /// Check if device is online
  static Future<bool> isOnline() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  // /// Get unique device ID
  // static Future<String?> getUniqueDeviceID() async {
  //   final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  //   try {
  //     var androidInfo = await deviceInfoPlugin.androidInfo;
  //     return androidInfo.androidId; // Unique ID on Android
  //   } on PlatformException {
  //     return null;
  //   }
  // }

  /// Get current date and time in ISO format
  static String getCurrentDate() {
    final now = DateTime.now();
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(now);
  }

  /// Get current date only
  static String getCurrentDateOnly() {
    final now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }

  /// Get current date in dd-MMM-yyyy format
  static String getCurrentDateDDMMYY() {
    final now = DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(now);
  }

  /// Get current time
  static String getCurrentTime() {
    final now = DateTime.now();
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(now);
  }
}
