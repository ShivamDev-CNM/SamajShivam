import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samajapp/Utils/Toast.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Views/Auth/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

getShared() async {
  SharedPreferences sp = await SharedPreferences.getInstance();

  String val = await sp.getString('token') ?? '';
  return val;
}

clearShared() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.clear();
}

RemoveUser() async {
  await clearShared();
  ToastUtils().showCustom('Session Expired');
  Get.offAll(() => LoginScreen());
}

myCircular() {
  return Center(
    child: CircularProgressIndicator(
      color: Green,
      strokeWidth: 2,
    ),
  );
}
