import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:samajapp/Views/Notification_Page/notification_controller.dart';
import 'package:readmore/readmore.dart';

import '../../Utils/Toast.dart';
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
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: GestureDetector(
                onTap: () async {
                  // Show loading dialog before deleting notifications
                  Get.dialog(
                    Dialog(
                      backgroundColor: Colors.transparent,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.green, // Set the color as needed
                        ),
                      ),
                    ),
                    barrierDismissible:
                        false, // Prevent closing the dialog by tapping outside
                  );

                  // Loop through selected notifications and delete them
                  for (var notificationId in controller.selectedIndex) {
                    await controller
                        .deleteNotification(notificationId.toString());
                  }

                  // Clear the selected notifications list
                  controller.selectedIndex.clear();
                  controller.isFirstSelection.value = false;

                  // Dismiss the dialog after completing the deletion
                  Get.back(); // Close the dialog

                },
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            )
          ],
          title: DataText(
            text: "Notification",
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
      body: Column(
        children: [
          Obx(
            () {
              return controller.selectedIndex.isNotEmpty
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // GestureDetector(
                          //   onTap: () async {
                          //     for (var notificationId
                          //         in controller.selectedIndex) {
                          //       await controller.deleteNotification(
                          //           notificationId.toString());
                          //     }
                          //     controller.selectedIndex.clear();
                          //     controller.isFirstSelection.value = false;
                          //   },
                          //   child: Container(
                          //     height: 30,
                          //     width: 90,
                          //     decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(8),
                          //         color: Colors.red),
                          //     child: Center(
                          //       child: Text(
                          //         "Delete ",
                          //         style: TextStyle(
                          //             fontSize: 16,
                          //             color: Colors.white,
                          //             fontWeight: FontWeight.w600),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(width: 15),
                          GestureDetector(
                            onTap: () {
                              if (controller.selectedIndex.length ==
                                  controller.notificationList.length) {
                                controller.selectedIndex.clear();
                                controller.isFirstSelection.value = false;
                              } else {
                                controller.selectedIndex.clear();
                                for (var notification
                                    in controller.notificationList) {
                                  controller.selectedIndex
                                      .add(notification["id"]);
                                }
                                controller.isFirstSelection.value = true;
                              }
                            },
                            child: Obx(() => Container(
                                  height: 30,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      controller.selectedIndex.length ==
                                              controller.notificationList.length
                                          ? "Deselect All"
                                          : "Select All",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(height: 10);
            },
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (controller.notificationList.isEmpty ||
                controller.notificationList == null) {
              return Expanded(child: Center(child: Text("NO Data Found")));
            }
            // Use Expanded to allow ListView to take full space
            return Expanded(
              child: RefreshIndicator.adaptive(
                color: Green,
                backgroundColor: Colors.white,
                onRefresh: () async {
                  await controller.fetchNotificationList();

                  ToastUtils().showCustom('Refreshed');
                },
                child: ListView.builder(
                  itemCount: controller.notificationList.length,
                  // Correct the item count
                  itemBuilder: (context, index) {
                    final notification = controller.notificationList[index];
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: GestureDetector(
                        onLongPress: () {
                          if (!controller.isFirstSelection.value) {
                            controller.selectedIndex.add(notification["id"]);
                            controller.isFirstSelection.value = true;
                          }
                        },
                        onTap: () {
                          if (controller.isFirstSelection.value) {
                            if (controller.selectedIndex
                                .contains(notification["id"])) {
                              controller.selectedIndex
                                  .remove(notification["id"]);
                              if (controller.selectedIndex.isEmpty) {
                                controller.isFirstSelection.value = false;
                              }
                            } else {
                              controller.selectedIndex.add(notification["id"]);
                            }
                          }
                        },
                        child: Obx(() => Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: controller.selectedIndex
                                          .contains(notification["id"])
                                      ? Green.withOpacity(0.4)
                                      : Colors.white,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                              fontSize: 14,
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                          moreStyle: GoogleFonts.dmSans(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          lessStyle: GoogleFonts.dmSans(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat("dd-MM-yy").format(
                                            DateTime.parse(
                                                notification["created_at"])),
                                        //notification["created_at"],
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        notification["time"],
                                        style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ),
                    );
                  },
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
