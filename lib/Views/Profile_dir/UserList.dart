import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samajapp/Controllers/profileController.dart';
import 'package:samajapp/Utils/Toast.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/myAppBar.dart';
import 'package:samajapp/Utils/mytxt.dart';
import 'package:samajapp/Views/Profile_dir/Addfamily.dart';

class UserList extends StatelessWidget {
  UserList({super.key});

  ProfileController pc = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.person_add_alt_1_outlined,
          color: Colors.white,
        ),
        onPressed: () {
          Get.dialog(Center(
            child: CircularProgressIndicator(),
          ));

          try {} finally {
            Get.back();
          }

          Get.to(() => AddFamilyScreen());
        },
        backgroundColor: Green,
      ),
      appBar: CustomAppBar(
        title: 'My User',
        wantBackButton: true,
      ),
      body: SizedBox(
        height: mySize.height,
        width: mySize.width,
        child: GetBuilder<ProfileController>(builder: (pc) {
          if (pc.userList.isEmpty) {
            return Center(
              child: DataText(text: 'No Data Found', fontSize: 15),
            );
          } else {
            return RefreshIndicator(
              color: Green,
              backgroundColor: Colors.white,
              onRefresh: () async {
                await pc.fetchUserList();
                ToastUtils().showCustom('Refreshed');
              },
              child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: pc.userList.length,
                  itemBuilder: (context, index) {
                    var d = pc.userList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: InkWell(
                        onTap: () {
                          pc.showDetail3[index] = !pc.showDetail3[index];
                          pc.update();
                        },
                        child: AnimatedContainer(
                          width: mySize.width,
                          height: pc.showDetail3[index] ? 120 : 50,
                          decoration: BoxDecoration(
                              color: d['earning_member'] == 1
                                  ? Colors.white
                                  : Colors.orange.shade100,
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
                                        text: d['first_name'].toString() +
                                            ' ' +
                                            d['last_name'].toString() +
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
                                    pc.showDetail3[index]
                                        ? Icon(Icons.arrow_drop_up)
                                        : Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                                pc.showDetail3[index] == true
                                    ? SizedBox(
                                        height: 4,
                                      )
                                    : SizedBox(),
                                pc.showDetail3[index] == true
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
            );
          }
        }),
      ),
    );
  }
}
