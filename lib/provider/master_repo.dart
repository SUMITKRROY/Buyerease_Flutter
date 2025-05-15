import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../config/api_route.dart';
import '../utils/dio_helper.dart';

class MasterRepo {
  Dio dio = DioApi().sendRequest;


  Future<Response> getCommunityCode(String code) async {
    try {
      Dio dio = DioApi().sendRequest;
      final response = await dio.post(
        ApiRoute.communityCode,
        data: {
          "Code": code,
        },
      );
      return response;
    } catch (e) {
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
  }) async
  {
    try {
      Dio dio = DioApi().sendRequest;

      final response = await dio.post(
        ApiRoute.login,
        data: {
          "UserID": user,
          "Password": password,
          "DeviceID": deviceId,
          "DeviceIP": deviceIP,
          "HDDSerialNo": hddSerialNo,
          "DeviceType": deviceType,
          "Location": location,
        },
      );

      return response;
    } catch (e) {
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
  }) async
  {
    try {
      Dio dio = DioApi().sendRequest;

      final response = await dio.post(
        ApiRoute.getInspection,
        data: {
          "UserID": user,
          "DeviceID": deviceId,
          "DeviceIP": deviceIP,
          "HDDSerialNo": hddSerialNo,
          "DeviceType": deviceType,
          "Location": location,
          "LastSyncDate": "2000-01-01",
          "DeviceLocation": "",
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getDefectMaster({
    required String user,
  }) async
  {
    try {
      Dio dio = DioApi().sendRequest;

      final response = await dio.post(
        ApiRoute.defectMaster,
        data: {
          "UserID": user,
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }




}
