import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samajapp/Controllers/profileController.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/myAppBar.dart';
import 'package:samajapp/Utils/myButtom.dart';
import 'package:samajapp/Utils/myPhotoBottmSheet.dart';
import 'package:samajapp/Utils/myReusableDropdown.dart';
import 'package:samajapp/Utils/myTextField.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({super.key});

  GlobalKey<FormState> _formKey = GlobalKey();

  ProfileController pc = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Profile',
        wantBackButton: true,
        wantbell: false,
      ),
      body: Container(
        height: mySize.height,
        width: mySize.width,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Hero(
                  tag: 123,
                  child: Stack(
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey, width: 3)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Obx(() => pc.updateProfileImage.value != null
                                ? Image.file(
                                    pc.updateProfileImage.value!,
                                    fit: BoxFit.cover,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: pc.myImage.value,
                                    fit: BoxFit.cover,
                                    errorWidget: (b, o, s) {
                                      return Icon(
                                        Icons.person,
                                        size: 100,
                                        color: Colors.grey,
                                      );
                                    },
                                  ))),
                      ),
                      Positioned(
                        bottom: 1,
                        right: 9,
                        child: Obx(() {
                          return GestureDetector(
                            onTap: pc.updateProfileImage.value == null
                                ? () {
                                    Get.bottomSheet(myPhotoBottomSheet(
                                      imageVariable: pc.updateProfileImage,
                                    ));
                                  }
                                : () {
                                    pc.updateProfileImage.value = null;
                                  },
                            child: Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Icon(
                                size: 35,
                                pc.updateProfileImage.value == null
                                    ? Icons.add_circle
                                    : Icons.cancel,
                                color: pc.updateProfileImage.value == null
                                    ? Green
                                    : Colors.red,
                              ),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                myTextField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  controller: pc.firstNameController,
                  labeltxt: 'First Name',
                ),
                myTextField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  controller: pc.lastNameController,
                  labeltxt: 'Last Name',
                ),
                Obx(() {
                  return ReusableDropdownSearch(
                    validator: (val) {
                      if (val == null) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    onChanged: (val) async {
                      pc.occupationId.value = pc.occupationList
                          .firstWhere((element) => element['name'] == val)['id']
                          .toString();
                    },
                    selectedItem: pc.occupationId.value == ""
                        ? null
                        : pc.occupationList.firstWhere((element) =>
                            element['id'].toString() ==
                            pc.occupationId.value)['name'],
                    searchHint: 'Search Occupation',
                    dropHint: 'Select Occupation',
                    myList: pc.occupationList
                        .map((element) => element['name'].toString())
                        .toList(),
                    OnTap: () async {
                      pc.occupationId.value = '';
                    },
                    // visible: pc.selectTimeDuration.value == "" ? false : true,
                  );
                }),
                myTextField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  controller: pc.addressController,
                  labeltxt: 'Address',
                  maxLine: 3,
                ),
                Obx(() {
                  return ReusableDropdownSearch(
                    validator: (val) {
                      if (val == null) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    onChanged: (val) async {
                      pc.selectCountry.value = pc.countryList
                          .firstWhere(
                              (element) => element['country_name'] == val)['id']
                          .toString();
                      pc.selectState.value = '';
                      await pc.fetchStateList();
                    },
                    selectedItem: pc.selectCountry.value == ""
                        ? null
                        : pc.countryList.firstWhere((element) =>
                            element['id'].toString() ==
                            pc.selectCountry.value)['country_name'],
                    searchHint: 'Search Country',
                    dropHint: 'Select Country',
                    myList: pc.countryList
                        .map((element) => element['country_name'].toString())
                        .toList(),
                    OnTap: () async {
                      pc.selectCountry.value = '';
                    },
                    // visible: pc.selectTimeDuration.value == "" ? false : true,
                  );
                }),
                Obx(() {
                  return ReusableDropdownSearch(
                    validator: (val) {
                      if (val == null) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    onChanged: (val) async {
                      pc.selectState.value = pc.stateList
                          .firstWhere(
                              (element) => element['state_name'] == val)['id']
                          .toString();
                      pc.selectCity.value = '';
                      await pc.fetchCityList();
                    },
                    selectedItem: pc.selectState.value == ""
                        ? null
                        : pc.stateList.firstWhere((element) =>
                            element['id'].toString() ==
                            pc.selectState.value)['state_name'],
                    searchHint: 'Search State',
                    dropHint: 'Select State',
                    myList: pc.stateList
                        .map((element) => element['state_name'].toString())
                        .toList(),
                    OnTap: () async {
                      pc.selectState.value = '';
                    },
                    // visible: pc.selectTimeDuration.value == "" ? false : true,
                  );
                }),
                Obx(() {
                  return ReusableDropdownSearch(
                    validator: (val) {
                      if (val == null) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    onChanged: (val) async {
                      pc.selectCity.value = pc.cityList
                          .firstWhere(
                              (element) => element['city_name'] == val)['id']
                          .toString();
                      pc.selectArea.value = '';
                      await pc.fetchAreaList();
                    },
                    selectedItem: pc.selectCity.value == ""
                        ? null
                        : pc.cityList.firstWhere((element) =>
                            element['id'].toString() ==
                            pc.selectCity.value)['city_name'],
                    searchHint: 'Search City',
                    dropHint: 'Select City',
                    myList: pc.cityList
                        .map((element) => element['city_name'].toString())
                        .toList(),
                    OnTap: () async {
                      pc.selectCity.value = '';
                    },
                    // visible: pc.selectTimeDuration.value == "" ? false : true,
                  );
                }),
                Obx(() {
                  return ReusableDropdownSearch(
                    validator: (val) {
                      if (val == null) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    onChanged: (val) async {
                      pc.selectArea.value = pc.areaList
                          .firstWhere(
                              (element) => element['area_name'] == val)['id']
                          .toString();
                    },
                    selectedItem: pc.selectArea.value == ""
                        ? null
                        : pc.areaList.firstWhere((element) =>
                            element['id'].toString() ==
                            pc.selectArea.value)['area_name'],
                    searchHint: 'Search Area',
                    dropHint: 'Select Area',
                    myList: pc.areaList
                        .map((element) => element['area_name'].toString())
                        .toList(),
                    OnTap: () async {
                      pc.selectArea.value = '';
                    },
                    // visible: pc.selectTimeDuration.value == "" ? false : true,
                  );
                }),
                SizedBox(
                  height: 30,
                ),
                Obx(() {
                  return myButton(
                      text: 'Update',
                      Condition: pc.updateBool.value,
                      function: () async {
                        if (_formKey.currentState!.validate()) {
                          await pc.updateProfileFunction();
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
