import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:samajapp/Views/Notification_Page/notification_controller.dart';

import '../../Utils/myAppBar.dart';
import '../../Utils/mytxt.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  NotificationController controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.keyboard_backspace_outlined,
                size: 30,
                color: Colors.white,
              )),
          title: DataText(
            text: "Notification",
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
      body: Column(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (controller.notificationList["data"].isEmpty ||
                controller.notificationList["data"] == null) {
              return Center(child: Text("NO Data Found"));
            }
            // Use Expanded to allow ListView to take full space
            return Expanded(
              child: ListView.builder(
                itemCount: controller.notificationList["data"].length, // Correct the item count
                itemBuilder: (context, index) {
                  final notification = controller.notificationList["data"][index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 0.2,
                                spreadRadius: 0.5)
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage("assets/images/Logo.png"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Community",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  notification["message"],
                                  maxLines: 3,
                                  softWrap: true,
                                  style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat("dd-MM-yy").format(
                                    DateTime.parse(notification["created_at"])),
                                //notification["created_at"],
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                notification["time"],
                                style:
                                TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          })
        ],
      ),
    );
  }
}
