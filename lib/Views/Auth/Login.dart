import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samajapp/Controllers/authController.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/images.dart';
import 'package:samajapp/Utils/myButtom.dart';
import 'package:samajapp/Utils/myTextField.dart';
import 'package:samajapp/Utils/mytxt.dart';
import 'package:samajapp/Views/Auth/SignUp.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
Authcontroller ac = Get.find<Authcontroller>();

  GlobalKey<FormState> _formState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: mySize.height,
        width: mySize.width,
        child: SingleChildScrollView(
          child: Form(
            key: _formState,
            child: Column(
              children: [
                SizedBox(
                  height: mySize.height / 10,
                ),
                Image.asset(
                  logoImage,
                  height: 300,
                ),
                const SizedBox(
                  height: 30,
                ),
                myTextField(
                    validator: (val) {
                      if (val!.isEmpty || val.length < 10) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    keyboardType: const TextInputType.numberWithOptions(),
                    maxLength: 10,
                    labeltxt: 'Mobile Number',
                    controller: ac.LoginMobileController),
                const SizedBox(
                  height: 10,
                ),
                Obx(() {
                  return myTextField(
                      obscureTex: ac.Obscure3.value,
                      pref: IconButton(
                          onPressed: () {
                            ac.Obscure3.toggle();
                          },
                          icon: ac.Obscure3.value == true
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility)),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      labeltxt: 'Password',
                      controller: ac.LoginPasswordController);
                }),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DataText(
                      text: "Don't have an Account? ",
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => SignUpScreen(),
                            transition: Transition.rightToLeft);
                      },
                      child: const DataText(
                        text: 'Sign Up',
                        fontSize: 14,
                        color: Green,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(() {
                  return myButton(
                      text: 'Log In',
                      Condition: ac.loginboolLoading.value,
                      function: () async {
                        if (_formState.currentState!.validate()) {
                          await ac.loginFuntion();
                        }
                      });
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
