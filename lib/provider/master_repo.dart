import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../config/api_route.dart';
import '../utils/dio_helper.dart';
import '../utils/fsl_log.dart'; // Make sure this import path matches where FslLog is located

class MasterRepo {
  Dio dio = DioApi().sendRequest;

  Future<Response> getCommunityCode(String code) async {
    try {
      Dio dio = DioApi().sendRequest;

      final payload = { "Code": code };
      FslLog.d("API_CommunityCode", "Sending request with payload: $payload");

      final response = await dio.post(ApiRoute.communityCode, data: payload);

      FslLog.d("API_CommunityCode", "Response: ${response.statusCode} - ${response.data}");

      return response;
    } catch (e, stackTrace) {
      FslLog.e("API_CommunityCode", "Error: $e", stackTrace);
      rethrow;
    }
  }

  Future<Response> getLogin({
    required String user,
    required String password,
    required String deviceId,
    required String deviceIP,
    required String hddSerialNo,
    required String deviceType,
    required String location,
  }) async {
    try {
      Dio dio = DioApi().sendRequest;
      final payload = {
        "UserID": user,
        "Password": password, // Masked for log security
        "DeviceID": deviceId,
        "DeviceIP": deviceIP,
        "HDDSerialNo": hddSerialNo,
        "DeviceType": deviceType,
        "Location": location,
      };

      FslLog.d("API_Login", "Sending login request with payload: $payload");

      final response = await dio.post(ApiRoute.login, data: {
        ...payload,
        "Password": password, // actual password not logged
      });

      FslLog.d("API_Login", "Response: ${response.statusCode} - ${response.data}");

      return response;
    } catch (e, stackTrace) {
      FslLog.e("API_Login", "Login failed: $e", stackTrace);
      rethrow;
    }
  }

  Future<Response> getSyncList({
    required String user,
    required String deviceId,
    required String deviceIP,
    required String hddSerialNo,
    required String deviceType,
    required String location,
  }) async {
    try {
      Dio dio = DioApi().sendRequest;
      final payload = {
        "UserID": user,
        "DeviceID": deviceId,
        "DeviceIP": deviceIP,
        "HDDSerialNo": hddSerialNo,
        "DeviceType": deviceType,
        "Location": location,
        "LastSyncDate": "2000-01-01",
        "DeviceLocation": "",
      };

      FslLog.d("API_SyncList", "Fetching sync list with payload: $payload");

      final response = await dio.post(ApiRoute.getInspection, data: payload);

      FslLog.d("API_SyncList", "Response: ${response.statusCode} - ${response.data}");

      return response;
    } catch (e, stackTrace) {
      FslLog.e("API_SyncList", "Sync failed: $e", stackTrace);
      rethrow;
    }
  }

  Future<Response> getDefectMaster({
    required String userId,
  }) async {
    try {
      Dio dio = DioApi().sendRequest;
      final payload = {
        "UserID": userId,
      };

      FslLog.d("API_DefectMaster", "Requesting defect master with payload: $payload");

      final response = await dio.post(ApiRoute.defectMaster, data: payload);

      FslLog.d("API_DefectMaster", "Response: ${response.statusCode} - ${response.data}");

      return response;
    } catch (e, stackTrace) {
      FslLog.e("API_DefectMaster", "Defect master fetch error: $e", stackTrace);
      rethrow;
    }
  }

  Future<Response> downloadAndUpdateImage({
    required String pRowId,
  }) async {
    try {
      Dio dio = DioApi().sendRequest;

      String url = "${ApiRoute.getQrPoItemImage}QRPOItemImageID=$pRowId";

      FslLog.d("API_ImageDownload", "Downloading image from URL: $url");

      final response = await dio.post(url);

      FslLog.d("API_ImageDownload", "Image downloaded: ${response.statusCode}");

      return response;
    } catch (e, stackTrace) {
      FslLog.e("API_ImageDownload", "Image download error: $e", stackTrace);
      rethrow;
    }
  }

  Future<Response> sendQualityInspection({
    required Map<String, dynamic> inspectionData,
  }) async {
    try {
      Dio dio = DioApi().sendRequest;

      FslLog.d("API_InspectionSend", "Sending inspection data...");
      FslLog.vc("API_InspectionSend", jsonEncode(inspectionData));
      developer.log("API_InspectionSend ${json.encode(inspectionData)}");
      final response = await dio.post(
        ApiRoute.sendInspection,
        data: json.encode(inspectionData),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      FslLog.d("API_InspectionSend", "Response: ${response.statusCode} - ${response.data}");

      return response;
    } catch (e, stackTrace) {
      FslLog.e("API_InspectionSend", "Error sending inspection data: $e", stackTrace);
      rethrow;
    }
  }

/*  Future<Response> sendSingleImageData({
    required Map<String, dynamic> inspectionData,
  }) async {
    try {
      Dio dio = DioApi().sendRequest;

      FslLog.d("API_InspectionSend", "Sending image data...");
      FslLog.vc("API_InspectionSend", jsonEncode(inspectionData));
      developer.log("API_InspectionSend ${json.encode(inspectionData)}");
      final response = await dio.post(
        ApiRoute.uploadFile,
        data: json.encode(inspectionData),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      FslLog.d("API_InspectionSend", "Response: ${response.statusCode} - ${response.data}");

      return response;
    } catch (e, stackTrace) {
      FslLog.e("API_InspectionSend", "Error sending inspection data: $e", stackTrace);
      rethrow;
    }
  }*/
  Future<Response> sendSingleImageData({
    required Map<String, dynamic> inspectionData,
  }) async {
    try {
      Dio dio = DioApi().sendRequest;

      FslLog.d("API_InspectionSend", "Sending image data...");
      FslLog.vc("API_InspectionSend", jsonEncode(inspectionData));
      developer.log("API_InspectionSend ${json.encode(inspectionData)}");

      final response = await dio.post(
        ApiRoute.uploadFile,
        data: json.encode(inspectionData),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      FslLog.d("API_InspectionSend", "Response: ${response.statusCode} - ${response.data}");

      return response;
    } catch (e, stackTrace) {
      FslLog.e("API_InspectionSend", "Error sending inspection data: $e", stackTrace);
      rethrow;
    }
  }

}
