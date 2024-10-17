// ignore_for_file: unused_import

import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';

class ToastUtils {
  showCustom(String message, {ToastGravity gravity = ToastGravity.BOTTOM}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
