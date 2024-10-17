import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:samajapp/APIS/APIS.dart';
import 'package:samajapp/Controllers/NavigationController.dart';
import 'package:samajapp/Controllers/profileController.dart';
import 'package:samajapp/Utils/Toast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Views/NavigationBar/NavigationScreen.dart';

class Authcontroller extends GetxController {
  // Register///////////////////////////////////////////////
  // Register///////////////////////////////////////////////
  // Register///////////////////////////////////////////////

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  TextEditingController ConfirmpasswordController = TextEditingController();
  Navigationcontroller nc = Get.find<Navigationcontroller>();

  RxInt gender = 1.obs;
  Rx<File?> signUpImage = Rx<File?>(null);

  void pickImageFromCamera(Rx<File?> imageVariable) async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedImage != null) {
      imageVariable.value = File(pickedImage.path);
    }
  }

  void pickImageFromGallery(Rx<File?> imageVariable) async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      imageVariable.value = File(pickedImage.path);
    }
  }

  RxBool signUpLoadingBool = false.obs;
  RxBool Obscure1 = true.obs;
  RxBool Obscure2 = true.obs;
  RxString isEarning = ''.obs;

  SignUpFunction() async {
    try {
      signUpLoadingBool(true);
      final request = http.MultipartRequest('POST', Uri.parse(myApi.SignUpAPI))
        ..fields['first_name'] = firstNameController.text.toString()
        ..fields['last_name'] = lastNameController.text.toString()
        ..fields['earning_member'] = isEarning.value.toString()
        ..fields['email'] = emailController.text.toString()
        ..fields['address'] = addressController.text.toString()
        ..fields['mobilenumber'] = mobileNumberController.text.toString()
        ..fields['gender'] = gender.value.toString()
        ..fields['password'] = passwordController.text.toString();

      if (signUpImage.value != null) {
        request.files.add(http.MultipartFile(
            'profile_pic',
            http.ByteStream.fromBytes(signUpImage.value!.readAsBytesSync()),
            signUpImage.value!.lengthSync(),
            filename: 'profile_pic'));
      }

      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        ToastUtils().showCustom('Account Created');
        Get.back();
        resetValues();
      } else {
        ToastUtils().showCustom('Failed To Create Account');
      }
    } catch (e) {
      ToastUtils().showCustom('Failed To Create Account');
    } finally {
      signUpLoadingBool(false);
    }
  }

  resetValues() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    // Obscure1(true);
    // Obscure2(true);
    // Obscure3(true);
    mobileNumberController.clear();
    isEarning.value = '';
    passwordController.clear();
    gender.value = 1;
    signUpImage.value = null;
    ConfirmpasswordController.clear();
    addressController.clear();
  }

// Register///////////////////////////////////////////////
// Register///////////////////////////////////////////////
// Register///////////////////////////////////////////////

// Login///////////////////////////////////////////////
// Login///////////////////////////////////////////////
// Login///////////////////////////////////////////////

  TextEditingController LoginMobileController = TextEditingController();
  TextEditingController LoginPasswordController = TextEditingController();
  RxBool loginboolLoading = false.obs;
  RxBool Obscure3 = true.obs;

  Future<String?> getDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    return token;
  }

  loginFuntion() async {
    String? deviceToken = await getDeviceToken();
    print(deviceToken);
    final Map<String, dynamic> body = {
      'mobilenumber': LoginMobileController.text.toString(),
      'password': LoginPasswordController.text.toString(),
      "push_token": deviceToken,
      'device_type': Platform.isAndroid ? '1' : '2'
    };
    try {
      loginboolLoading(true);

      // String? pushToken = await FirebaseMessaging.instance.getToken();
      SharedPreferences sp = await SharedPreferences.getInstance();
      final response = await http.post(Uri.parse(myApi.LoginAPI), body: body);
      final jsondata = jsonDecode(response.body);

      if (response.statusCode == 200) {
        nc.currentIndex.value = 0;

        await sp.setString('token', jsondata['token']);
        ToastUtils().showCustom(jsondata['message']);
        await Get.find<ProfileController>().fetchProfileData();
        Get.offAll(() => NavigationScreen(),
            transition: Transition.rightToLeft);
        LoginMobileController.clear();
        LoginPasswordController.clear();
        Obscure3(true);
      } else {
        ToastUtils().showCustom(jsondata['message']);
      }
    } catch (e) {
      ToastUtils().showCustom('Something went wrong');

      print(e.toString());
    } finally {
      loginboolLoading(false);
    }
  }

// Login///////////////////////////////////////////////
// Login///////////////////////////////////////////////
// Login///////////////////////////////////////////////
}
