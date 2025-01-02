import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:samajapp/APIS/APIS.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends GetxController {
  var notificationList = <dynamic>[].obs;
  var isLoading = true.obs;
  var selectedIndex = <int>[].obs;

  void onInit() {
    super.onInit();
    fetchNotificationList();
    notificationAlertDote();
    isFirstSelection.value = false;
    selectedIndex.clear();
  }

  RxString accesstoken = ''.obs;
  var isFirstSelection = false.obs;

  fetchNotificationList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accesstoken.value = prefs.getString("token") ?? "";
    try {
      //isLoading(true);
      final response = await http.get(
        Uri.parse('https://samaj.edigillence.com/api/notification_list'),
        headers: {
          "x-api-key": accesstoken.value, // If you have an auth token
        },
      );
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        notificationList.assignAll(jsonData['data']);
        isLoading(false);
      } else {
        // Handle error

        print('Failed to load jobs');
      }
    } finally {
      isLoading(false);
    }
  }
  void onClose() {
    super.onClose();
    // Reset the state when the screen is closed
    isFirstSelection.value = false;
    selectedIndex.clear();
  }
  Future<void> deleteNotification(String notificationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accesstoken.value = prefs.getString("token") ?? "";
    final url = Uri.parse(
        'https://samaj.edigillence.com/api/delete_notification?is_deleted=$notificationId');

    try {
      final response = await http.post(
        Uri.parse(myApi.BaseUrl +
            "/api/delete_notification?is_deleted=$notificationId"),
        headers: {
          "x-api-key": accesstoken.value, // If you have an auth token
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        await fetchNotificationList();
        print('Notification deleted successfully: $responseBody');
      } else {
        print('Failed to delete notification: ${response.body}');
      }
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  Future<void> notificationAlertDote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accesstoken.value = prefs.getString("token") ?? "";
    final response = await http
        .get(Uri.parse(myApi.BaseUrl + "/api/notification_dote"), headers: {
      "x-api-key": accesstoken.value, // If you have an auth token
    });
    if(response.statusCode==200){
      print("Successfully Update ");
    }else{
      print(response.body);
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
