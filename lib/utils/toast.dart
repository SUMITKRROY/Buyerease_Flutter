import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message, bool error) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: error == true ? Colors.red : Colors.transparent.withOpacity(0.7),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void showSnackBar(BuildContext context, String text, icon, backgroundColor, color) {
  var snackBar = SnackBar(
      content: Row(children: [
        Icon(icon, color: color),
        Text(text, style: TextStyle(color: color)),
      ]),
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.all(20));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
