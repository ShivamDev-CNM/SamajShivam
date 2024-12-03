import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends GetxController {
  var notificationList = {}.obs;
  var isLoading = true.obs;
  var selectedIndex = <int>[].obs;
  void onInit() {
    super.onInit();
   fetchNotificationList();
  }
  fetchNotificationList() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // accessToken.value = prefs.getString("token") ?? "";
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('https://samaj.edigillence.com/api/notification_list'),
        // headers: {
        //   "x-api-key": accessToken.value, // If you have an auth token
        // },
      );
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        notificationList.value = jsonData;
        isLoading(false);
      } else {
        // Handle error

        print('Failed to load jobs');
      }
    } finally {
      isLoading(false);
    }
  }
  // Future<void> markAllAsSeen() async {
  //   notificationList["data"]?.forEach((notification) {
  //     notification["isSeen"] = true;
  //   });
  //   notificationList.refresh();
  // }
  //
  // // Method to mark individual notification as seen
  // void markAsSeen(int notificationId) {
  //   final notification = notificationList["data"]?.firstWhere(
  //         (notification) => notification["id"] == notificationId,
  //   );
  //   if (notification != null) {
  //     notification["isSeen"] = true;
  //     notificationList.refresh();
  //   }
  // }
}
