import 'package:buyerease/database/database_helper.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../database/table/user_master_table.dart';
import '../view/login/login.dart';

logout(context) {
  final hiveBox = Hive.box("myBox");
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      // title: const Text('LOG OUT'),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'Would you like to log out?',
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('NO'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('YES'),
          onPressed: () async{
              // dynamic data = await SQLHelper.getItems();
              // await SQLHelper.deleteLoginOut(data[0]['id']);
              hiveBox.put('loggedIn', false);
             // await UserMasterTable().deleteAll();
              await DatabaseHelper().deleteAllTableData();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                    (route) => false);
          },
        ),
      ],
    ),
  );
}
