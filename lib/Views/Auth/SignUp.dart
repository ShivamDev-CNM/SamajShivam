import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samajapp/Controllers/authController.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/myAppBar.dart';
import 'package:samajapp/Utils/myButtom.dart';
import 'package:samajapp/Utils/myInputDecoration.dart';
import 'package:samajapp/Utils/myPhotoBottmSheet.dart';
import 'package:samajapp/Utils/myTextField.dart';
import 'package:samajapp/Utils/mytxt.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
Authcontroller ac = Get.find<Authcontroller>();

  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Sign Up',
        wantBackButton: true,
        wantTextWhite: false,
        wantbell: false,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: mySize.height,
        width: mySize.height,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 3)),
                      child: Obx(() => ac.signUpImage.value != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(
                                ac.signUpImage.value!,
                                fit: BoxFit.cover,
                              ))
                          : Icon(
                              Icons.person,
                              size: 100,
                              color: Colors.grey,
                            )),
                    ),
                    Positioned(
                      bottom: 1,
                      right: 9,
                      child: GestureDetector(
                        onTap: () {
                          Get.bottomSheet(myPhotoBottomSheet(
                            imageVariable: ac.signUpImage,
                          ));
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: const Icon(
                            size: 35,
                            Icons.add_circle,
                            color: Green,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                myTextField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  controller: ac.firstNameController,
                  labeltxt: 'First Name',
                ),
                myTextField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  controller: ac.lastNameController,
                  labeltxt: 'Last Name',
                ),
                myTextField(
                  // validator: (val) {
                  //   // if (val!.isEmpty) {
                  //   //   return 'This field is required';
                  //   // }
                  //
                  //   if (GetUtils.isEmail(val) == false) {
                  //     return 'Enter correct email';
                  //   }
                  //   return null;
                  // },
                  controller: ac.emailController,
                  labeltxt: 'Email',
                ),
                Obx(() {
                  return DropdownButtonFormField(
                    decoration: myInputDecoration(hintText: 'Earning Member'),
                    validator: (val) {
                      if (val == null) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    items: [
                      DropdownMenuItem(
                        child: Text('Yes'),
                        value: '1',
                      ),
                      DropdownMenuItem(
                        child: Text('No'),
                        value: '2',
                      )
                    ],
                    onChanged: (val) {
                      ac.isEarning.value = val!;
                    },
                    value: ac.isEarning.value == "" ? null : ac.isEarning.value,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                myTextField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'This field is required';
                    } if (val.length != 10) {
                      return 'Enter Correct Mobile No.';
                    }
                    return null;
                  },
                  controller: ac.mobileNumberController,
                  maxLength: 10,
                  labeltxt: 'Mobile No.',
                  keyboardType: const TextInputType.numberWithOptions(),
                ),
                myTextField(
                  keyboardType: TextInputType.multiline,
                  controller: ac.addressController,
                  maxLine: 3,
                  labeltxt: 'Address',
                ),
                Obx(() {
                  return myTextField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'This field is required';
                      }
                      if (val.length < 6) {
                        return 'Password must be 6 letters';
                      }
                      return null;
                    },
                    obscureTex: ac.Obscure1.value,
                    pref: IconButton(
                        onPressed: () {
                          ac.Obscure1.toggle();
                        },
                        icon: ac.Obscure1.value == true
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility)),
                    controller: ac.passwordController,
                    labeltxt: 'Password',
                  );
                }),
                Obx(() {
                  return myTextField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'This field is required';
                      }
                      if (val != ac.passwordController.text) {
                        return 'Password mismatched';
                      }
                      return null;
                    },
                    obscureTex: ac.Obscure2.value,
                    pref: IconButton(
                        onPressed: () {
                          ac.Obscure2.toggle();
                        },
                        icon: ac.Obscure2.value == true
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility)),
                    controller: ac.ConfirmpasswordController,
                    labeltxt: 'Confirm Password',
                  );
                }),
                Obx(() {
                  return Row(
                    children: [
                      DataText(
                        text: ' Gender :',
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      DataText(
                        text: ' Male',
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      GestureDetector(
                        onTap: () {
                          ac.gender.value = 1;
                        },
                        child: AnimatedContainer(
                          height: 17,
                          width: 17,
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  ac.gender.value == 1 ? Green : Colors.white,
                              border: Border.all(color: Colors.grey, width: 3)),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      DataText(
                        text: ' Female',
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      GestureDetector(
                        onTap: () {
                          ac.gender.value = 2;
                        },
                        child: AnimatedContainer(
                          height: 17,
                          width: 17,
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  ac.gender.value == 2 ? Green : Colors.white,
                              border: Border.all(color: Colors.grey, width: 3)),
                        ),
                      )
                    ],
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
                Obx(() {
                  return myButton(
                      text: 'Sign Up',
                      Condition: ac.signUpLoadingBool.value,
                      function: () async {
                        if (_formKey.currentState!.validate()) {
                          await ac.SignUpFunction();
                        }
                      });
                }),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
