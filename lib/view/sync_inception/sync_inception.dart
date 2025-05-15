import 'dart:developer';
import 'dart:io';

import 'package:buyerease/database/database_helper.dart';
import 'package:buyerease/database/table/user_master_table.dart';
import 'package:buyerease/main.dart';
import 'package:buyerease/provider/defect_master/defect_master_cubit.dart';
import 'package:buyerease/provider/sync_cubit/sync_cubit.dart';
import 'package:buyerease/utils/app_constants.dart';

import 'package:buyerease/utils/toast.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../custom_appbar/custom_appbar.dart';
import '../../provider/login_cubit/login_cubit.dart';
import '../../routes/route_path.dart';
import '../networks/endpoints.dart';
import '../post/post_api_call.dart';

class SyncInception extends StatefulWidget {
  const SyncInception({super.key});

  @override
  State<SyncInception> createState() => _SyncInceptionState();
}

class _SyncInceptionState extends State<SyncInception> {


  String deviceID = '';
  String userId = '';

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getId();
    getUserId();
  }
  Future<Object?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceID = iosDeviceInfo.identifierForVendor!;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceID = androidDeviceInfo.id;
      debugPrint('deviceID $deviceID');
    }
    return null;
  }
  Future<void> getUserId() async {
    final userRecords = await UserMasterTable().getAll();

    if (userRecords.isNotEmpty) {
      setState(() {
        userId = userRecords.first[UserMasterTable.pUserID];
      });
      print("User ID: $userId");
    } else {
      print("No user record found.");
    }
  }


  // Future<void> getData() async {
  //   // dynamic data = await SQLHelper.getItems();
  //   final apiUrl =
  //       'http://${sp?.getString('IP')}${APIUrls.baseUrl}${APIUrls.urlGetData}';
  //   Map<String, dynamic> requestBody = {
  //     "UserID": 'DEL0000002',
  //     "LASTSyncDate": '2000-01-01',
  //     "DeviceID": "7c7bc1f1b2736ba0",
  //     //"DeviceID": deviceID,
  //     "DeviceIP": sp?.getString('IP'),
  //     "HDDSerialNo": "",
  //     "DeviceType": "A",
  //     "Location": ""
  //   };
  //   final responseData = await fetchDataFromAPI(apiUrl, requestBody);
  //   if (responseData['Message'].toString() == 'success') {
  //     debugPrint('SQLAddData1 ${responseData['Data'][0]}');
  //
  //     if (responseData['Data'][0] != null) {
  //       for (int i = 0; i < responseData['Data'][0].length; i++) {
  //         debugPrint('data ${responseData['Data'][0]['Table$i'].length}');
  //         if (responseData['Data'][0]['Table$i'].isNotEmpty) {
  //          List <dynamic> data = responseData['Data'][0]['Table$i'];
  //           // debugPrint('data ${responseData['Data'][0]['Table$i'].length}');
  //           for (int j = 0; j < responseData['Data'][0]['Table$i'].length; j++) {
  //             // debugPrint('qwerty: - ${responseData['Data'][0]['Table$i'].length}');
  //             // log('qwerty ${responseData['Data'][0]['Table$i'][j]}');
  //             debugPrint('qwerty : - -${responseData['Data'][0]['Table$i'][j]}');
  //             // SQLHelper.insertTables(responseData['Data'][0]['Table$i'][j], i);
  //              // data = [];
  //           }
  //         } else {
  //           debugPrint('Null ${responseData['Data'][0]['Table0']}');
  //         }
  //       }
  //     }
  //
  //     // Images Files
  //     if(responseData['ImageFiles'] != null) {
  //       for(int i =0 ;i< responseData['ImageFiles'].length; i++){
  //         debugPrint('response ${responseData['ImageFiles'][i]}');
  //         // SQLHelper.insertTablesImageFiles(responseData['ImageFiles'][i]);
  //       }
  //     }
  //     // SQLAddData.createItem(responseData);
  //     showToast(responseData['Message'].toString(), true);
  //   } else {
  //     debugPrint('response2 $responseData');
  //     showToast(responseData['Message'].toString(), false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(name: 'Buyerease\'s'),
      ),
      body: BlocListener<SyncCubit, SyncState>(
        listener: (context, state) {
          if (state is SyncLoading) {
            showToast("Syncing started...", true);
          } else if (state is SyncSuccess) {
            showToast("Sync successful!", true);
context.read<DefectMasterCubit>().fetchDefectMaster(data:userId);
            Navigator.of(context).pushReplacementNamed(RoutePath.inspection);

          } else if (state is SyncFailure) {
            showToast("Sync failed: ${state.error}", false);
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<SyncCubit>().sync(
                    user: userId,
                    deviceId: deviceID,
                    deviceIP: "10.0.2.16",
                    hddSerialNo: "",
                    deviceType: "A",
                    location: "",
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Get Data',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      )

    );
  }

}
