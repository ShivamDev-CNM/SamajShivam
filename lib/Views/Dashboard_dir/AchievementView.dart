import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samajapp/Controllers/HomeController.dart';
import 'package:samajapp/Utils/Toast.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/myAppBar.dart';
import 'package:samajapp/Utils/mytxt.dart';

class Achievementview extends StatelessWidget {
  Achievementview({super.key});

  Homecontroller hc = Get.find<Homecontroller>();

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Achievements',
        wantBackButton: true,
      ),
      body: SizedBox(
        height: mySize.height,
        width: mySize.width,
        child: GetBuilder<Homecontroller>(builder: (hc) {
          if (hc.achievementData['data'].isEmpty) {
            return Center(
              child: DataText(text: 'No Data Found', fontSize: 15),
            );
          } else {
            return RefreshIndicator.adaptive(
              onRefresh: () async {
                await hc.fetchAchievementList();
                ToastUtils().showCustom('Refreshed');
              },
              backgroundColor: Colors.white,
              color: Green,
              child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: hc.achievementData['data'].length,
                  itemBuilder: (context, index) {
                    var d = hc.achievementData['data'][index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Container(
                        width: mySize.width,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5,
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  errorWidget: (b, os, s) {
                                    return Center(
                                      child: Icon(Icons.image_not_supported),
                                    );
                                  },
                                  imageUrl: d['image'],
                                  height: 110,
                                  width: 80,
                                  fit: BoxFit.cover,
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DataText(
                                    text: d['user_name'],
                                    fontSize: 18,
                                    color: Green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  DataText(
                                    text: d['description'],
                                    fontSize: 18,
                                  )
                                ],
                              ),
                            )
                          ],
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
