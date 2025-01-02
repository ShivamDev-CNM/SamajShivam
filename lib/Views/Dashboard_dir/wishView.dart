import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:samajapp/Controllers/HomeController.dart';
import 'package:samajapp/Utils/Toast.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/myAppBar.dart';
import 'package:samajapp/Utils/mytxt.dart';

class WishView extends StatelessWidget {
  WishView({super.key});

  Homecontroller hc = Get.find<Homecontroller>();

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Wishes',
        wantBackButton: true,
      ),
      body: SizedBox(
        height: mySize.height,
        width: mySize.width,
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: GetBuilder<Homecontroller>(builder: (hc) {
                if (hc.wishesData['data'].isEmpty) {
                  return Center(
                    child: DataText(text: 'No Data Found', fontSize: 15),
                  );
                } else {
                  return RefreshIndicator.adaptive(
                    onRefresh: () async {
                      await hc.fetchWishList();
                      ToastUtils().showCustom('Refreshed');
                    },
                    backgroundColor: Colors.white,
                    color: Green,
                    child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: hc.wishesData['data'].length,
                        itemBuilder: (context, index) {
                          var d = hc.wishesData['data'][index];
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
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          errorWidget: (b, o, s) {
                                            return Center(
                                              child: Icon(
                                                Icons.account_circle,
                                                size: 30,
                                              ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          DataText(
                                            text: d['user_name'],
                                            fontSize: 18,
                                            color: Green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          DataText(
                                            text: d['wishes_type']

                                            // +
                                            // " " +
                                            // d
                                            // ['title']
                                            ,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          ReadMoreText(
                                            hc.wishHomeList[index]
                                            ['description'],
                                            trimLines: 3,
                                            colorClickableText: Colors.blue,
                                            trimMode: TrimMode.Line,
                                            trimCollapsedText: 'Read More',
                                            trimExpandedText: ' ...Read Less',
                                            style: GoogleFonts.dmSans(
                                                fontSize: 14, color: Colors.black),
                                            moreStyle: GoogleFonts.dmSans(
                                                fontSize: 14,
                                                color: Green,
                                                fontWeight: FontWeight.bold),
                                            lessStyle: GoogleFonts.dmSans(
                                                fontSize: 14,
                                                color: Green,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          // DataText(
                                          //   text:
                                          //   hc.wishHomeList[index]
                                          //   ['description'],
                                          //   fontSize: 14,
                                          //   color: Colors.black,
                                          //   wantels: true,
                                          //   maxLines: 8,
                                          // ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
