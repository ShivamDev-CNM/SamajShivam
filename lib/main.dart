import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samajapp/Controllers/FundsController.dart';
import 'package:samajapp/Controllers/HomeController.dart';
import 'package:samajapp/Controllers/NavigationController.dart';
import 'package:samajapp/Controllers/SplashScreenController.dart';
import 'package:samajapp/Controllers/authController.dart';
import 'package:samajapp/Controllers/eventController.dart';
import 'package:samajapp/Controllers/profileController.dart';
import 'package:samajapp/Fireabse/Notification.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Views/SplashScreen/SplashScreen.dart';
import 'package:samajapp/firebase_options.dart';

import 'Views/Notification_Page/notification_controller.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Platform.isIOS
  //     ? await NotificationServices()
  //     : await myNotification().initialize();

  Get.put(SplashScreenController());
  Get.put(ProfileController());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationServices _notificationServices = NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notificationServices.requestNotificationPermission();
    _notificationServices.firebaseInit(context);
    _notificationServices.setupInteractMessage(context);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: initialBinding(),
      debugShowCheckedModeBanner: false,
      title: 'Samaj',
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: AppBarColor,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class initialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashScreenController(), fenix: true);
    Get.lazyPut(() => Navigationcontroller(), fenix: true);
    Get.lazyPut(() => Authcontroller(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => Eventcontroller(), fenix: true);
    Get.lazyPut(() => Homecontroller(), fenix: true);
    Get.lazyPut(() => FundsController(), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
  }
}
