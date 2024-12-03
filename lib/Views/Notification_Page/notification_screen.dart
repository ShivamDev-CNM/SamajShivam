import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:samajapp/Views/Notification_Page/notification_controller.dart';
import 'package:readmore/readmore.dart';

import '../../Utils/colors.dart';
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

          // Obx(
          //       () {
          //     return controller.selectedIndex.isNotEmpty
          //         ? Row(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: [
          //         GestureDetector(
          //           onTap: () async {
          //             // Loop through all selected notification IDs and delete them
          //             for (var notificationId
          //             in controller.selectedIndex) {
          //               await controller.deleteNotification(
          //                   notificationId.toString());
          //             }
          //             // Clear selected notifications after deletion
          //             controller.selectedIndex.clear();
          //             controller.isFirstSelection.value =
          //             false; // Reset first selection
          //           },
          //           child: Container(
          //             height: 30,
          //             width: 90,
          //             decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(8),
          //                 color: Colors.red),
          //             child: Center(
          //               child: Text(
          //                 "Delete ",
          //                 style: TextStyle(
          //                     fontSize: 16,
          //                     color: Colors.white,
          //                     fontWeight: FontWeight.w600),
          //               ),
          //             ),
          //           ),
          //         ),
          //         SizedBox(
          //           width: 15,
          //         ),
          //         GestureDetector(
          //           onTap: () {
          //             // Check if all notifications are selected
          //             if (controller.selectedIndex.length ==
          //                 controller.notificationList["data"].length) {
          //               // Deselect all if already selected
          //               controller.selectedIndex.clear();
          //               controller.isFirstSelection.value = false;
          //             } else {
          //               // Select all items by adding all notification IDs to selectedIndex
          //               controller.selectedIndex.clear();
          //               for (var notification
          //               in controller.notificationList["data"]) {
          //                 controller.selectedIndex
          //                     .add(notification["id"]);
          //               }
          //               controller.isFirstSelection.value = true;
          //             }
          //           },
          //           child: Obx(() => Container(
          //             height: 30,
          //             width: 100,
          //             // padding:
          //             // EdgeInsets.symmetric(horizontal: 15, vertical: 2),
          //             decoration: BoxDecoration(
          //               border: Border.all(color: Colors.black),
          //               borderRadius: BorderRadius.circular(8),
          //               color: Colors.white,
          //             ),
          //             child: Center(
          //               child: Text(
          //                 controller.selectedIndex.length ==
          //                     controller.notificationList.length
          //                     ? "Deselect All"
          //                     : "Select All",
          //                 // Update text based on selection state
          //                 style: TextStyle(
          //                   fontSize: 16,
          //                   color: Colors.black,
          //                   fontWeight: FontWeight.w600,
          //                 ),
          //               ),
          //             ),
          //           )),
          //         ),
          //         SizedBox(
          //           width: 15,
          //         ),
          //       ],
          //     )
          //         : SizedBox(
          //       height: 30,
          //     );
          //   },
          // ),
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
                itemCount: controller.notificationList["data"].length,
                // Correct the item count
                itemBuilder: (context, index) {
                  final notification =
                      controller.notificationList["data"][index];
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
                            backgroundImage:
                                AssetImage("assets/images/Logo.png"),
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
                                ReadMoreText(
                                  notification["message"],
                                  trimLines: 3,
                                  colorClickableText: Colors.blue,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'Read More',
                                  trimExpandedText: '  Read Less',
                                  style: GoogleFonts.dmSans(
                                      fontSize: 14, color: Colors.grey),
                                  moreStyle: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                  lessStyle: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      color: Green,
                                      fontWeight: FontWeight.bold),
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
