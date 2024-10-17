import 'package:get/get.dart';

class Navigationcontroller extends GetxController {
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    currentIndex.value = 0;
  }
}
