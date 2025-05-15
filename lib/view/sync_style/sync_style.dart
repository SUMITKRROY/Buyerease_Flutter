import 'package:buyerease/custom_appbar/custom_appbar.dart';
import 'package:buyerease/database/database_helper.dart';

import 'package:buyerease/utils/toast.dart';
import 'package:buyerease/main.dart';
import 'package:flutter/material.dart';

import '../networks/endpoints.dart';
import '../post/post_api_call.dart';

class SyncStyle extends StatefulWidget {
  const SyncStyle({super.key});

  @override
  State<SyncStyle> createState() => _SyncStyleState();
}

class _SyncStyleState extends State<SyncStyle> {
  Future<void> getData() async {
    final apiUrl =
        'http://${sp?.getString('IP')}${APIUrls.baseUrl}${APIUrls.urlGetStyleData}';

    Map<String, dynamic> requestBody = {"UserID": sp?.getString('UserID')};

    final responseData = await fetchDataFromAPI(apiUrl, requestBody);

    if (responseData['Message'].toString() == 'Success') {
      debugPrint('Data $responseData');
      showToast(responseData['Message'].toString(), true);
    } else {
      debugPrint('Data $responseData');
      showToast(responseData['Message'].toString(), false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(name: 'Buyerease\'s')),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  getData();
                },
                child: const Text('Get Data')),
          ],
        ),
      ),
    );
  }
}
