import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samajapp/Controllers/HomeController.dart';
import 'package:samajapp/Controllers/profileController.dart';
import 'package:samajapp/Utils/Toast.dart';
import 'package:samajapp/Utils/mytxt.dart';
import 'package:samajapp/Views/Notification_Page/notification_screen.dart';
import 'package:samajapp/Views/Profile_dir/ProfileScreen.dart';
import 'package:badges/badges.dart' as badges;
import '../Views/Notification_Page/notification_controller.dart';
import 'colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  ProfileController pc = Get.find<ProfileController>();
  Homecontroller homecontroller = Get.find<Homecontroller>();
  final NotificationController controller = Get.find<NotificationController>();

  CustomAppBar(
      {super.key,
      required this.title,
      this.wantBackButton = false,
      this.wantTextWhite = true,
      this.onPressed,
      this.widget,
      this.wantbell = true});

  final String title;
  final bool wantBackButton;
  final wantTextWhite;
  final wantbell;
  final void Function()? onPressed;
  final List<Widget>? widget;

  @override
  Widget build(BuildContext context) {
    var d = homecontroller.contactUs["data"];
    return AppBar(
      title: DataText(
        text: title,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: wantTextWhite == true ? Colors.white : Colors.black,
      ),
      leadingWidth: 55,
      leading: wantBackButton == true
          ? IconButton(
              onPressed: onPressed ??
                  () {
                    Get.back();
                  },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ))
          : Hero(
              tag: 123,
              child: Padding(
                padding: EdgeInsets.all(4),
                child: GestureDetector(
                  onTap: () async {
                    Get.dialog(Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ));

                    try {
                      await pc.fetchProfileData();
                    } finally {
                      Get.back();
                    }
                    if (pc.profileData.isEmpty) {
                      ToastUtils().showCustom('Error Getting Profile Data');
                    } else {
                      pc.currentIndex.value = 0;
                      Get.to(() => ProfileScreen());
                    }
                  },
                  child: GetBuilder<ProfileController>(builder: (pc) {
                    if (pc.profileData.isEmpty) {
                      return Center(
                        child: Icon(Icons.person),
                      );
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: pc.profileData[0]['profile_pic'],
                        fit: BoxFit.cover,
                        errorWidget: (b, o, s) {
                          return Icon(Icons.person);
                        },
                      ),
                    );
                  }),
                ),
              ),
            ),
      actions: [
        GestureDetector(
          onTap: () {
            Get.dialog(
              AlertDialog(
                backgroundColor: Colors.white,
                title: Text(
                  d["name"].toString(),
                  style: GoogleFonts.dmSans(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                content: Container(
                  height: 60,
                  //color: Colors.red,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: Colors.black,
                            size: 25,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            d["email"],
                            style: GoogleFonts.dmSans(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                     const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.black,
                            size: 25,
                          ),
                          SizedBox(width: 8),
                          Text(
                            d["phone"] ?? "No Number",
                            style: GoogleFonts.dmSans(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text(
                      'Close',
                      style: GoogleFonts.dmSans(color: Green),
                    ),
                  ),
                ],
              ),
            );
          },
          child: Image.asset(
            "assets/contact_us.png",
            color: Colors.white,
            width: 28,
          ),
        ),
        wantbell == true
            ? Obx(() {
                // Check if profileData is populated and contains 'is_notification'
                if (pc.profileData.isNotEmpty &&
                    pc.profileData[0].containsKey('is_notification')) {
                  bool showBadge = pc.profileData[0]['is_notification'] == 1;
                  return badges.Badge(
                    position: badges.BadgePosition.topEnd(top: 14, end: 14),
                    showBadge:
                        showBadge, // Show badge if isNotification is true
                    child: IconButton(
                      onPressed: () async {
                        // Navigate to the NotificationScreen
                        await controller.fetchNotificationList();
                        await Get.to(() => NotificationScreen());
                        controller.selectedIndex.clear();
                        controller.selectedIndex.refresh();
                        controller.isFirstSelection.value = false;
                        await pc.fetchProfileData();
                        await controller.notificationAlertDote();
                      },
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  );
                }

                // Return a placeholder widget while profileData is empty
                return IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 30,
                  ),
                );
              })
            : SizedBox(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
