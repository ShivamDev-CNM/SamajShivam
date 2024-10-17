import 'package:flutter/material.dart';
import 'package:samajapp/Utils/images.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset(logoImage,height: 300,)),
    );
  }
}
