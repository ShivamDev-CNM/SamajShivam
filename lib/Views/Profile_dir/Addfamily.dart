import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samajapp/Controllers/profileController.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/myAppBar.dart';
import 'package:samajapp/Utils/myButtom.dart';
import 'package:samajapp/Utils/myInputDecoration.dart';
import 'package:samajapp/Utils/myPhotoBottmSheet.dart';
import 'package:samajapp/Utils/myReusableDropdown.dart';
import 'package:samajapp/Utils/myTextField.dart';
import 'package:samajapp/Utils/mytxt.dart';

class AddFamilyScreen extends StatelessWidget {
  AddFamilyScreen({super.key});

  ProfileController pc = Get.find<ProfileController>();

  GlobalKey<FormState> _formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: (){
          Get.back();
          pc.clearUserAddFields();
        },
        title: 'Add Family',
        wantBackButton: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: mySize.height,
        width: mySize.width,
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(
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
                      child: Obx(() => pc.signUpImage.value != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(
                                pc.signUpImage.value!,
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
                            imageVariable: pc.signUpImage,
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
                SizedBox(
                  height: 10,
                ),
                myTextField(
                  controller: pc.userFirstName,
                  labeltxt: 'First Name',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                myTextField(
                  controller: pc.userLastName,
                  labeltxt: 'Last Name',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                myTextField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  controller: pc.userMobileNumber,
                  labeltxt: 'Mobile No.',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                myTextField(
                  controller: pc.userEmail,
                  labeltxt: 'Email',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'This field is required';
                    }
                    if (!GetUtils.isEmail(val)) {
                      return 'Enter Valid Email';
                    }
                    return null;
                  },
                ),
                myTextField(
                  keyboardType: TextInputType.none,
                  labeltxt: 'Date of birth',
                  pref: IconButton(
                      onPressed: () async {
                        await pc.pickDate();
                      },
                      icon: Icon(
                        Icons.calendar_month,
                        color: Colors.grey,
                      )),
                  controller: pc.DateController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
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
                      pc.isEarning.value = val!;
                    },
                    value: pc.isEarning.value == "" ? null : pc.isEarning.value,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                // Obx(() {
                //   return ReusableDropdownSearch(
                //     onChanged: (val) async {
                //       pc.father_id.value = pc.fatherList
                //           .firstWhere((element) =>
                //               element['first_name'] +
                //                   " " +
                //                   element['last_name'] ==
                //               val)['id']
                //           .toString();
                //     },
                //     selectedItem: pc.father_id.value == ""
                //         ? null
                //         : pc.fatherList.firstWhere((element) =>
                //                 element['id'].toString() ==
                //                 pc.father_id.value)['first_name'] +
                //             " " +
                //             pc.fatherList.firstWhere((element) =>
                //                 element['id'].toString() ==
                //                 pc.father_id.value)['last_name'],
                //     searchHint: 'Select Parental Name',
                //     dropHint: 'Select Parental Name',
                //     myList: pc.fatherList
                //         .map((element) =>
                //             element['first_name'].toString() +
                //             " " +
                //             element['last_name'])
                //         .toList(),
                //     OnTap: () async {
                //       pc.father_id.value = '';
                //     },
                //     visible: pc.father_id.value == "" ? false : true,
                //   );
                // }),
                // Obx(() {
                //   return ReusableDropdownSearch(
                //     onChanged: (val) async {
                //       pc.mother_id.value = pc.motherList
                //           .firstWhere((element) =>
                //               element['first_name'] +
                //                   " " +
                //                   element['last_name'] ==
                //               val)['id']
                //           .toString();
                //     },
                //     selectedItem: pc.mother_id.value == ""
                //         ? null
                //         : pc.motherList.firstWhere((element) =>
                //                 element['id'].toString() ==
                //                 pc.mother_id.value)['first_name'] +
                //             " " +
                //             pc.motherList.firstWhere((element) =>
                //                 element['id'].toString() ==
                //                 pc.mother_id.value)['last_name'],
                //     searchHint: 'Select Maternal Name',
                //     dropHint: 'Select Maternal Name',
                //     myList: pc.motherList
                //         .map((element) =>
                //             element['first_name'].toString() +
                //             " " +
                //             element['last_name'])
                //         .toList(),
                //     OnTap: () async {
                //       pc.mother_id.value = '';
                //     },
                //     visible: pc.mother_id.value == "" ? false : true,
                //   );
                // }),
                Obx(() {
                  return ReusableDropdownSearch(
                    // validator: (val) {
                    //   if (val == null) {
                    //     return 'This field is required';
                    //   }
                    //   return null;
                    // },
                    onChanged: (val) async {
                      pc.userRelation.value = pc.relationList
                          .firstWhere((element) => element['name'] == val)['id']
                          .toString();
                    },
                    selectedItem: pc.userRelation.value == ""
                        ? null
                        : pc.relationList.firstWhere((element) =>
                            element['id'].toString() ==
                            pc.userRelation.value)['first_name'],
                    searchHint: 'Search Relation with this person',
                    dropHint: 'Search Relation with this person',
                    myList: pc.relationList
                        .map((element) => element['name'].toString())
                        .toList(),
                    OnTap: () async {
                      pc.userRelation.value = '';
                    },
                    // visible: pc.selectTimeDuration.value == "" ? false : true,
                  );
                }),
               Obx(() {
                 if( pc.isEarning.value == '1'){
                   return ReusableDropdownSearch(
                     validator: pc.isEarning.value == '2'
                         ? null
                         : (val) {
                       if (val == null) {
                         return 'This field is required';
                       }
                       return null;
                     },
                     onChanged: (val) async {
                       pc.userOccupation.value = pc.occupationList
                           .firstWhere((element) => element['name'] == val)['id']
                           .toString();
                     },
                     selectedItem: pc.userOccupation.value == ""
                         ? null
                         : pc.occupationList.firstWhere((element) =>
                     element['id'].toString() ==
                         pc.userOccupation.value)['name'],
                     searchHint: 'Search Occupation',
                     dropHint: 'Select Occupation',
                     myList: pc.occupationList
                         .map((element) => element['name'].toString())
                         .toList(),
                     OnTap: () async {
                       pc.userOccupation.value = '';
                     },
                     // visible: pc.selectTimeDuration.value == "" ? false : true,
                   );
                 }else{
                   return SizedBox();
                 }

                }),
                Obx(() {
                  return myTextField(
                    obscureTex: pc.isObscure.value,
                    pref: IconButton(
                        onPressed: () {
                          pc.isObscure.toggle();
                        },
                        icon: Icon(pc.isObscure.value
                            ? Icons.visibility_off
                            : Icons.visibility)),
                    controller: pc.userPassword,
                    labeltxt: 'Password',
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  );
                }),
                Obx(() {
                  return myTextField(
                    obscureTex: pc.isObscure2.value,
                    pref: IconButton(
                        onPressed: () {
                          pc.isObscure2.toggle();
                        },
                        icon: Icon(pc.isObscure2.value
                            ? Icons.visibility_off
                            : Icons.visibility)),
                    controller: pc.ConfirmPassword,
                    labeltxt: 'Confirm Password',
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'This field is required';
                      }

                      if (val != pc.userPassword.text) {
                        return 'Password mismatch';
                      }
                      return null;
                    },
                  );
                }),
                myTextField(
                  maxLine: 3,
                  controller: pc.Address,
                  labeltxt: 'Address',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
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
                      pc.userCountry.value = pc.countryList
                          .firstWhere(
                              (element) => element['country_name'] == val)['id']
                          .toString();
                      pc.userState.value = '';
                      await pc.fetchStateList();
                    },
                    selectedItem: pc.userCountry.value == ""
                        ? null
                        : pc.countryList.firstWhere((element) =>
                    element['id'].toString() ==
                        pc.userCountry.value)['country_name'],
                    searchHint: 'Search Country',
                    dropHint: 'Select Country',
                    myList: pc.countryList
                        .map((element) => element['country_name'].toString())
                        .toList(),
                    OnTap: () async {
                      pc.userCountry.value = '';
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
                      pc.userState.value = pc.stateList
                          .firstWhere(
                              (element) => element['state_name'] == val)['id']
                          .toString();
                      pc.userCity.value = '';
                      await pc.fetchCityList();
                    },
                    selectedItem: pc.userState.value == ""
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
                      pc.userState.value = '';
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
                      // Update selected city ID in selectCity
                      pc.selectCity.value = pc.cityList
                          .firstWhere((element) => element['city_name'] == val)['id']
                          .toString();

                      // Clear the area and fetch new area list
                      pc.userArea.value = '';
                      await pc.fetchAreaList();
                    },
                    selectedItem: pc.userCity.value == ""
                        ? null
                        : pc.cityList.firstWhere((element) =>
                    element['id'].toString() == pc.userCity.value)['city_name'],
                    searchHint: 'Search City',
                    dropHint: 'Select City',
                    myList: pc.cityList
                        .map((element) => element['city_name'].toString())
                        .toList(),
                    OnTap: () async {
                      pc.userCity.value = '';
                    },
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
                      pc.userArea.value = pc.areaList
                          .firstWhere(
                              (element) => element['area_name'] == val)['id']
                          .toString();
                    },
                    selectedItem: pc.userArea.value == ""
                        ? null
                        : pc.areaList.firstWhere((element) =>
                            element['id'].toString() ==
                            pc.userArea.value)['area_name'],
                    searchHint: 'Search Area',
                    dropHint: 'Select Area',
                    myList: pc.areaList
                        .map((element) => element['area_name'].toString())
                        .toList(),
                    OnTap: () async {
                      pc.userArea.value = '';
                    },
                    // visible: pc.selectTimeDuration.value == "" ? false : true,
                  );
                }),


                // Obx(() {
                //   return ReusableDropdownSearch(
                //     validator: (val) {
                //       if (val == null) {
                //         return 'This field is required';
                //       }
                //       return null;
                //     },
                //     onChanged: (val) async {
                //       pc.userCity.value = pc.cityList
                //           .firstWhere(
                //               (element) => element['city_name'] == val)['id']
                //           .toString();
                //       pc.userArea.value = '';
                //       await pc.fetchAreaList();
                //     },
                //     selectedItem: pc.userCity.value == ""
                //         ? null
                //         : pc.cityList.firstWhere((element) =>
                //             element['id'].toString() ==
                //             pc.userCity.value)['city_name'],
                //     searchHint: 'Search City',
                //     dropHint: 'Select City',
                //     myList: pc.cityList
                //         .map((element) => element['city_name'].toString())
                //         .toList(),
                //     OnTap: () async {
                //       pc.userCity.value = '';
                //     },
                //     // visible: pc.selectTimeDuration.value == "" ? false : true,
                //   );
                // }),


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
                          pc.gender.value = 1;
                        },
                        child: AnimatedContainer(
                          height: 17,
                          width: 17,
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  pc.gender.value == 1 ? Green : Colors.white,
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
                          pc.gender.value = 2;
                        },
                        child: AnimatedContainer(
                          height: 17,
                          width: 17,
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  pc.gender.value == 2 ? Green : Colors.white,
                              border: Border.all(color: Colors.grey, width: 3)),
                        ),
                      )
                    ],
                  );
                }),
                SizedBox(
                  height: 30,
                ),
                Obx(() {
                  return myButton(
                      text: 'Add User',
                      Condition: pc.updateBool.value,
                      function: () async {
                        if (_formkey.currentState!.validate()) {
                          await pc.AddUserFunction();
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
