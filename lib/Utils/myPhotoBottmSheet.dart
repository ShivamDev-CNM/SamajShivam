import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samajapp/Controllers/authController.dart';

class myPhotoBottomSheet extends StatelessWidget {
  Authcontroller ac = Get.find<Authcontroller>();

  myPhotoBottomSheet({super.key, required this.imageVariable});

  final Rx<File?> imageVariable;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 100),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () {
              ac.pickImageFromGallery(imageVariable);
              Get.back();
            },
            child: Container(
              color: Colors.green.shade400,
              child: Center(
                child: Icon(Icons.image, size: 40, color: Colors.white),
              ),
            ),
          )),
          Expanded(
              child: GestureDetector(
            onTap: () {
              ac.pickImageFromCamera(imageVariable);
              Get.back();
            },
            child: Container(
              color: Colors.blue.shade400,
              child: Center(
                child: Icon(Icons.camera_alt, size: 40, color: Colors.white),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
