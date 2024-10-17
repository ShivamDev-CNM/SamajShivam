import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samajapp/Controllers/profileController.dart';
import 'package:samajapp/Utils/Toast.dart';
import 'package:samajapp/Utils/mytxt.dart';
import 'package:samajapp/Views/Notification_Page/notification_screen.dart';
import 'package:samajapp/Views/Profile_dir/ProfileScreen.dart';
import 'package:badges/badges.dart' as badges;
import '../Views/Notification_Page/notification_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  ProfileController pc = Get.find<ProfileController>();
  final NotificationController controller = Get.find<NotificationController>();

  CustomAppBar(
      {super.key,
      required this.title,
      this.wantBackButton = false,
      this.wantTextWhite = true,
      this.wantbell = true});

  final String title;
  final bool wantBackButton;
  final wantTextWhite;
  final wantbell;

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
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
        wantbell == true
            ? Obx(() {
                // Check if the data is null or empty
                final notifications = controller.notificationList["data"];
                return badges.Badge(
                  position: badges.BadgePosition.topEnd(top: 14, end: 14),
                  showBadge: notifications != null && notifications.isNotEmpty,
                  // badgeContent: Text(
                  //   notifications != null
                  //       ? notifications.length.toString()
                  //       : '0',
                  //   style: TextStyle(color: Colors.white),
                  // ),
                  child: IconButton(
                    onPressed: () {
                      Get.to(NotificationScreen());
                    },
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 30,
                    ),
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
