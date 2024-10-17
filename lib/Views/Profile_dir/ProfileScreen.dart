import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:samajapp/Controllers/profileController.dart';
import 'package:samajapp/Utils/CustomAlertt.dart';
import 'package:samajapp/Utils/SharedPrefunc.dart';
import 'package:samajapp/Utils/Toast.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/images.dart';
import 'package:samajapp/Utils/mytxt.dart';
import 'package:samajapp/Views/Profile_dir/Addfamily.dart';
import 'package:samajapp/Views/Profile_dir/UpdateProfileScreen.dart';
import 'package:samajapp/Views/Profile_dir/UserList.dart';
import 'package:samajapp/Views/Profile_dir/personalExpense.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  ProfileController pc = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            child: Icon(
              Icons.auto_graph_rounded,
              color: Colors.white,
            ),
            onPressed: () async {
              Get.dialog(Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ));

              try {
                pc.type.value = '1';
                await pc.fetchAllPayment();
              } finally {
                Get.back();
              }

              pc.allPayPage.value = 0;

              Get.to(() => myPersonalExpense());
            },
            backgroundColor: Green,
          ),
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            child: Icon(
              Icons.family_restroom,
              color: Colors.white,
            ),
            onPressed: () async {
              Get.dialog(Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ));

              try {
                await pc.fetchUserList();
              } finally {
                Get.back();
              }

              Get.to(() => UserList());
            },
            backgroundColor: Green,
          )
        ],
      ),
      body: Container(
        height: mySize.height,
        width: mySize.width,
        color: Colors.grey,
        child: Stack(
          children: [
            Container(
              color: AppBarColor,
              height: mySize.height,
              width: mySize.width,
            ),
            Positioned(
              top: -50,
              child: Container(
                width: mySize.width,
                height: mySize.height / 3,
                decoration: BoxDecoration(
                    color: Colors.greenAccent.shade400,
                    image: const DecorationImage(
                        image: AssetImage(profilebg), fit: BoxFit.cover)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5, left: 10),
                          child: CircleAvatar(
                            backgroundColor: Green,
                            child: IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            backgroundColor: Green,
                            child: IconButton(
                                onPressed: () async {
                                  Get.dialog(CustomAlert(
                                    title: 'Confirm Log Out',
                                    content:
                                        'Are you sure you want to log out?',
                                    positiveText: 'Yes',
                                    negativeText: 'No',
                                    onConfirm: () async {
                                      Get.dialog(myCircular());
                                      try {
                                        await pc.logout();
                                      } catch (e) {}
                                    },
                                  ));
                                },
                                icon: const Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 200,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: mySize.height,
                width: mySize.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: () async {
                              Get.dialog(Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ));
                              try {
                                await pc.fetchOccupationList();
                              } finally {
                                Get.back();
                              }
                              pc.occupationId.value =
                                  pc.profileData[0]['occupation'].toString();
                              pc.passvalue();
                              Get.to(() => UpdateProfileScreen());
                            },
                            icon: const Icon(
                              Icons.mode_edit_outlined,
                              size: 30,
                            ))),
                    GetBuilder<ProfileController>(builder: (pc) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DataText(
                            text: pc.profileData[0]['first_name'],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          DataText(
                            text: pc.profileData[0]['last_name'],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      );
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Green, width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      child: GetBuilder<ProfileController>(builder: (pc) {
                        return SingleChildScrollView(
                          controller: pc.profileScroll,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              mynewCont(
                                  'Family', 0, pc.currentIndex.value, false),
                              mynewCont(
                                  'Details', 1, pc.currentIndex.value, false),
                              mynewCont('Contribution', 2,
                                  pc.currentIndex.value, true),
                              mynewCont(
                                  'Pending', 3, pc.currentIndex.value, true),
                            ],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: mySize.height / 2,
                      child: GetBuilder<ProfileController>(builder: (pc) {
                        return PageView(
                          controller: pc.pg,
                          onPageChanged: (index) {
                            switch (index) {
                              case 0:
                                pc.profileScroll.animateTo(
                                    pc.profileScroll.position.minScrollExtent,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.linear);
                                break;
                              case 1:
                                pc.profileScroll.animateTo(
                                    pc.profileScroll.position.minScrollExtent,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.linear);
                                break;
                              case 2:
                                pc.profileScroll.animateTo(
                                    pc.profileScroll.position.maxScrollExtent,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.linear);
                                break;
                              case 3:
                                pc.profileScroll.animateTo(
                                    pc.profileScroll.position.maxScrollExtent,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.linear);
                                break;
                            }

                            pc.currentIndex.value = index;
                            pc.update();
                          },
                          children: [
                            const FamilyPage(),
                            DetailPage(
                              address: pc.profileData[0]['address'],
                              number: pc.profileData[0]['mobilenumber'],
                              country:
                                  pc.profileData[0]['country_name'] ?? '--',
                              State: pc.profileData[0]['state_name'] ?? '--',
                              city: pc.profileData[0]['city_name'] ?? '--',
                              area: pc.profileData[0]['area_name'] ?? '--',
                            ),
                            ContributionPage(),
                            MonthlyPendingData(),
                          ],
                        );
                      }),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: mySize.height / 8.5,
              left: mySize.width / 3.3,
              child: Hero(
                tag: 123,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: GetBuilder<ProfileController>(builder: (pc) {
                    if (pc.profileData.isEmpty) {
                      return Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Green)),
                        child: Center(
                          child: Icon(Icons.person),
                        ),
                      );
                    }
                    return GestureDetector(
                      onTap: () {
                        Get.dialog(
                            barrierColor: Colors.black87,
                            Center(
                              child: CachedNetworkImage(
                                  width: MediaQuery.sizeOf(context).width / 1.5,
                                  height:
                                      MediaQuery.sizeOf(context).height / 1.5,
                                  imageUrl: pc.profileData[0]['profile_pic']),
                            ));
                      },
                      child: CachedNetworkImage(
                        imageUrl: pc.profileData[0]['profile_pic'],
                        fit: BoxFit.cover,
                        height: 150,
                        width: 150,
                        errorWidget: (b, o, s) {
                          return Icon(
                            Icons.person,
                            size: 50,
                          );
                        },
                      ),
                    );
                  }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

mynewCont(
  String text,
  int Index,
  int myIndex,
  bool want,
) {
  ProfileController pc = Get.find<ProfileController>();
  return GestureDetector(
    onTap: () {
      want == true
          ? pc.profileScroll.animateTo(
              pc.profileScroll.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.linear)
          : pc.profileScroll.animateTo(
              pc.profileScroll.position.minScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.linear);

      pc.currentIndex.value = Index;
      pc.pg.jumpToPage(
        pc.currentIndex.value,
      );
      pc.update();
    },
    child: AnimatedContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      constraints: const BoxConstraints(maxHeight: 50),
      decoration: BoxDecoration(
          color: Index == myIndex ? AppBarColor : null,
          borderRadius: BorderRadius.circular(8)),
      duration: const Duration(milliseconds: 300),
      child: Center(
          child: DataText(
        text: text,
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Index == myIndex ? Colors.white : Green,
      )),
    ),
  );
}

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<ProfileController>(builder: (pc) {
        if (pc.parentData['parent_detail']['father'].isEmpty &&
            pc.parentData['parent_detail']['mother'].isEmpty &&
            pc.parentData['wife_brother_sister'].isEmpty &&
            pc.parentData['child'].isEmpty) {
          return Center(
            child: DataText(text: 'No Data Found', fontSize: 15),
          );
        } else {
          var d = pc.parentData['parent_detail'];
          var wi = pc.parentData['wife_brother_sister'];
          var c = pc.parentData['child'];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                d['father'].isEmpty && d['mother'].isEmpty
                    ? DataText(text: '', fontSize: 15)
                    : DataText(
                        text: 'Parents',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Green,
                      ),
                d['father'].isEmpty
                    ? SizedBox()
                    : GestureDetector(
                        onTap: () {
                          pc.fatherBool.toggle();
                          pc.update();
                        },
                        child: AnimatedContainer(
                          width: mySize.width,
                          height: pc.fatherBool.value ? 120 : 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(color: Colors.grey, blurRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          duration: Duration(milliseconds: 500),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: DataText(
                                        text: d['father'][0]['user_name']
                                                .toString() +
                                            " - " +
                                            (d['father'][0]['relation_name']
                                                        .toString() ==
                                                    ""
                                                ? 'N/A'
                                                : d['father'][0]
                                                        ['relation_name']
                                                    .toString()),
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    d['father'][0]['earning_member'] == 2
                                        ? SizedBox()
                                        : CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Green,
                                            child: Icon(
                                              Icons.currency_rupee,
                                              color: Colors.white,
                                              size: 15,
                                            )),
                                    pc.fatherBool.value
                                        ? Icon(Icons.arrow_drop_up)
                                        : Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                                pc.fatherBool.value == true
                                    ? SizedBox(
                                        height: 4,
                                      )
                                    : SizedBox(),
                                pc.fatherBool.value == true
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              DataText(
                                                  text: ('Mobile No :'),
                                                  fontSize: 15),
                                              Expanded(child: SizedBox()),
                                              DataText(
                                                  text: (d['father'][0]
                                                          ['mobilenumber']
                                                      .toString()),
                                                  fontSize: 15),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              DataText(
                                                  text: ('Email :'),
                                                  fontSize: 15),
                                              Expanded(child: SizedBox()),
                                              DataText(
                                                  text: (d['father'][0]['email']
                                                      .toString()),
                                                  fontSize: 15),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              DataText(
                                                  text: ('Occupation :'),
                                                  fontSize: 15),
                                              Expanded(child: SizedBox()),
                                              DataText(
                                                  text: d['father'][0]
                                                          ['occupation_name']
                                                      .toString(),
                                                  fontSize: 15),
                                            ],
                                          ),
                                        ],
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ),
                        ),
                      ),
                d['mother'].isEmpty
                    ? SizedBox()
                    : GestureDetector(
                        onTap: () {
                          pc.fatherBool.toggle();
                          pc.update();
                        },
                        child: AnimatedContainer(
                          width: mySize.width,
                          height: pc.fatherBool.value ? 120 : 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(color: Colors.grey, blurRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          duration: Duration(milliseconds: 500),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: DataText(
                                        text: d['mother'][0]['user_name']
                                                .toString() +
                                            " - " +
                                            (d['mother'][0]['relation_name']
                                                        .toString() ==
                                                    ""
                                                ? 'N/A'
                                                : d['mother'][0]
                                                        ['relation_name']
                                                    .toString()),
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    d['mother'][0]['earning_member'] == 2
                                        ? SizedBox()
                                        : CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Green,
                                            child: Icon(
                                              Icons.currency_rupee,
                                              color: Colors.white,
                                              size: 15,
                                            )),
                                    pc.fatherBool.value
                                        ? Icon(Icons.arrow_drop_up)
                                        : Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                                pc.fatherBool.value == true
                                    ? SizedBox(
                                        height: 4,
                                      )
                                    : SizedBox(),
                                pc.fatherBool.value == true
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              DataText(
                                                  text: ('Mobile No :'),
                                                  fontSize: 15),
                                              Expanded(child: SizedBox()),
                                              DataText(
                                                  text: (d['mother'][0]
                                                          ['mobilenumber']
                                                      .toString()),
                                                  fontSize: 15),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              DataText(
                                                  text: ('Email :'),
                                                  fontSize: 15),
                                              Expanded(child: SizedBox()),
                                              DataText(
                                                  text: (d['mother'][0]['email']
                                                      .toString()),
                                                  fontSize: 15),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              DataText(
                                                  text: ('Occupation :'),
                                                  fontSize: 15),
                                              Expanded(child: SizedBox()),
                                              DataText(
                                                  text: d['mother'][0]
                                                          ['occupation_name']
                                                      .toString(),
                                                  fontSize: 15),
                                            ],
                                          ),
                                        ],
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 5,
                ),
                wi.isEmpty
                    ? DataText(text: '', fontSize: 15)
                    : DataText(
                        text: 'Wife & Siblings',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Green,
                      ),
                Column(
                  children: List.generate(
                      pc.parentData['wife_brother_sister'].length, (index) {
                    var d = pc.parentData['wife_brother_sister'][index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: InkWell(
                        onTap: () {
                          pc.showDetail[index] = !pc.showDetail[index];
                          pc.update();
                        },
                        child: AnimatedContainer(
                          width: mySize.width,
                          height: pc.showDetail[index] ? 120 : 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(color: Colors.grey, blurRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          duration: Duration(milliseconds: 500),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: DataText(
                                        text: d['user_name'].toString() +
                                            " - " +
                                            (d['relation_name'].toString() == ""
                                                ? 'N/A'
                                                : d['relation_name']
                                                    .toString()),
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    d['earning_member'] == 2
                                        ? SizedBox()
                                        : CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Green,
                                            child: Icon(
                                              Icons.currency_rupee,
                                              color: Colors.white,
                                              size: 15,
                                            )),
                                    pc.showDetail[index]
                                        ? Icon(Icons.arrow_drop_up)
                                        : Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                                pc.showDetail[index] == true
                                    ? SizedBox(
                                        height: 4,
                                      )
                                    : SizedBox(),
                                pc.showDetail[index] == true
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              DataText(
                                                  text: ('Mobile No :'),
                                                  fontSize: 15),
                                              Expanded(child: SizedBox()),
                                              DataText(
                                                  text: (d['mobilenumber']
                                                      .toString()),
                                                  fontSize: 15),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              DataText(
                                                  text: ('Email :'),
                                                  fontSize: 15),
                                              Expanded(child: SizedBox()),
                                              DataText(
                                                  text: (d['email'].toString()),
                                                  fontSize: 15),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              DataText(
                                                  text: ('Occupation :'),
                                                  fontSize: 15),
                                              Expanded(child: SizedBox()),
                                              DataText(
                                                  text: d['occupation_name']
                                                      .toString(),
                                                  fontSize: 15),
                                            ],
                                          ),
                                        ],
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                c.isEmpty
                    ? DataText(text: '', fontSize: 15)
                    : DataText(
                        text: 'Childrens',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Green,
                      ),
                Column(
                  children: List.generate(c.length, (index) {
                    var d = c[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: InkWell(
                        onTap: () {
                          pc.showDetail2[index] = !pc.showDetail2[index];
                          pc.update();
                        },
                        child: AnimatedContainer(
                          width: mySize.width,
                          height: pc.showDetail2[index] ? 120 : 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(color: Colors.grey, blurRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          duration: Duration(milliseconds: 500),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: DataText(
                                        text: d['user_name'].toString() +
                                            " - " +
                                            (d['relation_name'].toString() == ""
                                                ? 'N/A'
                                                : d['relation_name']
                                                    .toString()),
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    d['earning_member'] == 2
                                        ? SizedBox()
                                        : CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Green,
                                            child: Icon(
                                              Icons.currency_rupee,
                                              color: Colors.white,
                                              size: 15,
                                            )),
                                    GestureDetector(
                                        onTap: () {
                                          if (d['father_children'].isEmpty) {
                                            ToastUtils()
                                                .showCustom('No Data Found');
                                          } else {
                                            Get.bottomSheet(ChildresnDetails(
                                                myList: d['father_children']));
                                          }
                                        },
                                        child: Icon(
                                          size: 28,
                                          Icons.info,
                                          color: Green,
                                        )),
                                    pc.showDetail2[index]
                                        ? Icon(Icons.arrow_drop_up)
                                        : Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                                pc.showDetail2[index] == true
                                    ? SizedBox(
                                        height: 4,
                                      )
                                    : SizedBox(),
                                pc.showDetail2[index] == true
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              DataText(
                                                  text: ('Mobile No :'),
                                                  fontSize: 15),
                                              Expanded(child: SizedBox()),
                                              DataText(
                                                  text: (d['mobilenumber']
                                                      .toString()),
                                                  fontSize: 15),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              DataText(
                                                  text: ('Email :'),
                                                  fontSize: 15),
                                              Expanded(child: SizedBox()),
                                              DataText(
                                                  text: (d['email'].toString()),
                                                  fontSize: 15),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              DataText(
                                                  text: ('Occupation :'),
                                                  fontSize: 15),
                                              Expanded(child: SizedBox()),
                                              DataText(
                                                  text: d['occupation_name']
                                                      .toString(),
                                                  fontSize: 15),
                                            ],
                                          ),
                                        ],
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          );
        }
      }),
    );
  }
}

class ChildresnDetails extends StatelessWidget {
  const ChildresnDetails({super.key, required this.myList});

  final List myList;

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Container(
      height: mySize.height,
      width: mySize.width,
      color: Colors.white,
      child: ListView.builder(
          itemCount: myList.length,
          itemBuilder: (context, index) {
            var d = myList[index];
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Colors.grey, blurRadius: 1)
                  ],
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DataText(
                          text: d['user_name'] ??
                              'N/A' + " - " + (d['relation_name'] ?? 'N/A'),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      d['earning_member'] == 2
                          ? SizedBox()
                          : CircleAvatar(
                              radius: 12,
                              backgroundColor: Green,
                              child: Icon(
                                Icons.currency_rupee,
                                color: Colors.white,
                                size: 15,
                              )),
                      GestureDetector(
                          onTap: () {
                            if (d['father_children'].isEmpty) {
                              ToastUtils().showCustom('No Data Found');
                            } else {
                              Get.bottomSheet(ChildresnDetails(
                                  myList: d['father_children']));
                            }
                          },
                          child: Icon(
                            size: 28,
                            Icons.info,
                            color: Green,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      DataText(text: ('Mobile No :'), fontSize: 15),
                      Expanded(child: SizedBox()),
                      DataText(
                          text: (d['mobilenumber'].toString()), fontSize: 15),
                    ],
                  ),
                  Row(
                    children: [
                      DataText(text: ('Email :'), fontSize: 15),
                      Expanded(child: SizedBox()),
                      DataText(text: (d['email'].toString()), fontSize: 15),
                    ],
                  ),
                  Row(
                    children: [
                      DataText(text: ('Occupation :'), fontSize: 15),
                      Expanded(child: SizedBox()),
                      DataText(
                          text: d['occupation_name'] ?? 'N/A', fontSize: 15),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage(
      {super.key,
      required this.address,
      required this.number,
      required this.country,
      required this.State,
      required this.city,
      required this.area});

  final String address;
  final String number;
  final String country;
  final String State;
  final String city;
  final String area;

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DataText(
                text: 'Address : ',
                fontSize: 17,
                color: Green,
                fontWeight: FontWeight.bold,
              ),
              DataText(
                text: address,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: 5,
              ),
              DataText(
                text: 'Area : ',
                fontSize: 17,
                color: Green,
                fontWeight: FontWeight.bold,
              ),
              DataText(
                text: area,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: 5,
              ),
              DataText(
                text: 'City : ',
                fontSize: 17,
                color: Green,
                fontWeight: FontWeight.bold,
              ),
              DataText(
                text: city,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: 5,
              ),
              DataText(
                text: 'State : ',
                fontSize: 17,
                color: Green,
                fontWeight: FontWeight.bold,
              ),
              DataText(
                text: State,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: 5,
              ),
              DataText(
                text: 'Country : ',
                fontSize: 17,
                color: Green,
                fontWeight: FontWeight.bold,
              ),
              DataText(
                text: country,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: 5,
              ),
              DataText(
                text: 'Contact : ',
                fontSize: 17,
                color: Green,
                fontWeight: FontWeight.bold,
              ),
              DataText(
                text: number,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: 120,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ContributionPage extends StatelessWidget {
  ContributionPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<ProfileController>(builder: (pc) {
        if (pc.ContributionData.isEmpty) {
          return Center(
            child: DataText(text: 'No Data Found', fontSize: 15),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: List.generate(pc.ContributionData.length, (index) {
                var d = pc.ContributionData[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Container(
                    width: mySize.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(color: Colors.grey, blurRadius: 1)
                        ],
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        DataText(
                          text: '${index + 1})',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: DataText(
                            text: DateFormat('dd-MMM-yyyy')
                                .format(DateTime.parse(d['transaction_date'])),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DataText(
                          text: '₹' + d['amount'].toString(),
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          );
        }
      }),
    );
  }
}

class MonthlyPendingData extends StatelessWidget {
  MonthlyPendingData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<ProfileController>(builder: (pc) {
        if (pc.MonthlyPending.isEmpty) {
          return Center(
            child: DataText(text: 'No Data Found', fontSize: 15),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: List.generate(pc.MonthlyPending.length, (index) {
                var d = pc.MonthlyPending[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Container(
                    width: mySize.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(color: Colors.grey, blurRadius: 1)
                        ],
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        DataText(
                          text: '${index + 1})',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: DataText(
                            text: DateFormat('dd-MMM-yyyy')
                                    .format(DateTime.parse(d['date'])) +
                                " - " +
                                DateFormat('MMM/yy').format(
                                    DateTime(DateTime.now().year, d['month'])),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DataText(
                          text: '₹' + d['amount'].toString(),
                          fontSize: 18,
                          color: d['payment_status'] == 2
                              ? Colors.red
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          );
        }
      }),
    );
  }
}
