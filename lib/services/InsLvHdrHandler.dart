import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_helper.dart';
import '../model/InsLvHdrModal.dart';

class InsLvHdrHandler {
    static const String TAG = "InsLvHdrHandler";

    // Insert or update InsLvHdr
    static Future<bool> insertInsLvHdrMaster(
        BuildContext context, InsLvHdrModal insLvHdrModal) async {
        try {
            final Database db = await DatabaseHelper().database;
            final contentValues = <String, dynamic>{
                'pRowID': insLvHdrModal.pRowID,
                'LocID': insLvHdrModal.LocID,
                'InspDescr': insLvHdrModal.InspDescr,
                'InspAbbrv': insLvHdrModal.InspAbbrv,
                'recDirty': insLvHdrModal.recDirty,
                'recEnable': insLvHdrModal.recEnable,
                'recUser': insLvHdrModal.recUser,
                'recDt': insLvHdrModal.recDt,
                'IsDefault': insLvHdrModal.IsDefault,
            };

            int rows = await db.update(
                'InsplvlHdr',
                contentValues,
                where: 'pRowID = ?',
                whereArgs: [insLvHdrModal.pRowID],
            );
            if (rows == 0) {
                await db.insert('InsplvlHdr', contentValues);
            }

            db.close();
            return true;
        } catch (e) {
            print("Exception while inserting InsLvHdr: $e");
            return false;
        }
    }

    // Get InsLvHdr List
    static Future<List<InsLvHdrModal>> getInsLvHdrList(BuildContext context) async {
        try {
            final Database db = await DatabaseHelper().database;
            final List<Map<String, dynamic>> queryResult =
            await db.rawQuery('SELECT * FROM InsplvlHdr');

            List<InsLvHdrModal> lGeneral = [];
            for (var row in queryResult) {
                lGeneral.add(InsLvHdrModal.fromMap(row));
            }

            db.close();
            return lGeneral;
        } catch (e) {
            print("Exception in getInsLvHdrList: $e");
            return [];
        }
    }
    // Get data according to a particular list
    static Future<List<InsLvHdrModal>> getDataAccordingToParticularList(
        BuildContext context, String pRowID) async {
        try {
            final Database db = await DatabaseHelper().database;
            final List<Map<String, dynamic>> queryResult = await db.rawQuery(
                'SELECT * FROM InsplvlHdr WHERE pRowID = ?', [pRowID]);

            List<InsLvHdrModal> lGeneral = [];
            for (var row in queryResult) {
                lGeneral.add(InsLvHdrModal.fromMap(row));
            }

            db.close();
            return lGeneral;
        } catch (e) {
            print("Exception in getDataAccordingToParticularList: $e");
            return [];
        }
    }

    // Get data according to ID
    static Future<String?> getDataAccordingId(BuildContext context, String pRowID) async {
        try {
            final Database db = await DatabaseHelper().database;
            final List<Map<String, dynamic>> queryResult = await db.rawQuery(
                'SELECT InspDescr FROM InsplvlHdr WHERE pRowID = ?', [pRowID]);

            String? MainDescr;
            if (queryResult.isNotEmpty) {
                MainDescr = queryResult[0]['InspDescr'];
            }

            db.close();
            return MainDescr;
        } catch (e) {
            print("Exception in getDataAccordingId: $e");
            return null;
        }
    }

    // Handler for InsLvHdr Master
    static Future<void> handlerToInsLvHdrMaster(
        BuildContext context, int isBackGround, String dataFor, String filter,
        {required Function onSuccess, required Function onError}) async
    {
        String url = 'YOUR_API_URL_HERE'; // Update with actual URL
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userId = prefs.getString('userId') ?? '';

        Map<String, String> params = {
            'userId': userId,
            'dataFilter': filter,
        };

        if (!(await isNetworkAvailable())) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("No Network Connectivity")));
            return;
        }

        try {
            final response = await http.post(Uri.parse(url), body: json.encode(params));
            if (response.statusCode == 200) {
                final jsonResponse = json.decode(response.body);
                if (isBackGround == 1) {
                    handleOfGenMaster(context, dataFor, jsonResponse);
                } else {
                    onSuccess(jsonResponse);
                }
            } else {
                onError("Error: ${response.statusCode}");
            }
        } catch (e) {
            print("Error in request: $e");
            onError(e.toString());
        }
    }

    // Handle response to update database
    static void handleOfGenMaster(BuildContext context, String generalMasterType, dynamic result) {
        List<InsLvHdrModal> lGeneralModelTypeList = parseInsLvHdr(generalMasterType, result);
        if (context != null && lGeneralModelTypeList.isNotEmpty) {
            updateDataBaseOfGeneralMaster(context, lGeneralModelTypeList);
        }
    }

    // Update the database with new records
    static Future<void> updateDataBaseOfGeneralMaster(
        BuildContext context, List<InsLvHdrModal> lGeneralModelTypeList) async {
        if (context != null && lGeneralModelTypeList.isNotEmpty) {
            for (var item in lGeneralModelTypeList) {
                await insertInsLvHdrMaster(context, item);
            }
        }
    }

    // Parse JSON data for InsLvHdr
    static List<InsLvHdrModal> parseInsLvHdr(
        String generalMasterType, dynamic jsonObject) {
        List<InsLvHdrModal> generalModelList = [];
        if (jsonObject != null) {
            final jsonArray = jsonObject[generalMasterType] as List<dynamic>;
            for (var jsonObjectOfComplaint in jsonArray) {
                generalModelList.add(InsLvHdrModal.fromJson(jsonObjectOfComplaint));
            }
        }
        return generalModelList;
    }

    // Check network availability
    static Future<bool> isNetworkAvailable() async {
        // Implement network check logic
        return true;
    }
}

