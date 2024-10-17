import 'package:get/get.dart';
import 'package:samajapp/Utils/Toast.dart';
import 'package:samajapp/Views/Auth/Login.dart';
import 'package:samajapp/Views/NavigationBar/NavigationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkLoginStatus();
  }

  RxString isLogin = ''.obs;

  checkLoginStatus() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    isLogin.value = sp.getString('token') ?? '';

    Future.delayed(const Duration(seconds: 1), () {
      if (isLogin.value == "") {
        Get.offAll(() => LoginScreen());
      } else {
        Get.offAll(() => NavigationScreen());
        ToastUtils().showCustom('Welcome to Solanki Parivar');
      }
    });
  }
}
