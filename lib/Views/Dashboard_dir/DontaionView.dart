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

class DonationView extends StatelessWidget {
  DonationView({super.key});

  Homecontroller hc = Get.find<Homecontroller>();

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Donations',
        wantBackButton: true,
      ),
      body: SizedBox(
        height: mySize.height,
        width: mySize.width,
        child: GetBuilder<Homecontroller>(builder: (hc) {
          if (hc.donationData['data'].isEmpty) {
            return Center(
              child: DataText(text: 'No Data Found', fontSize: 15),
            );
          } else {
            return RefreshIndicator.adaptive(
              color: Green,
              backgroundColor: Colors.white,
              onRefresh: () async {
                await hc.fetchDonationData();

                ToastUtils().showCustom('Refreshed');
              },
              child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: hc.donationData['data'].length,
                  itemBuilder: (context, index) {
                    var d = hc.donationData['data'][index];

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
                          padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
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
                                    imageUrl: d['profile_pic'],
                                    height: 110,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DataText(
                                      text: d['user_name'],
                                      fontSize: 18,
                                      color: Green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ReadMoreText(
                                      d['description'],
                                      trimLines: 3,
                                      colorClickableText: Colors.blue,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: 'Read More',
                                      trimExpandedText: ' ...Read Less',
                                      style: GoogleFonts.dmSans(
                                          fontSize: 14, color: Colors.grey),
                                      moreStyle: GoogleFonts.dmSans(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      lessStyle: GoogleFonts.dmSans(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // DataText(
                                    //   text: d['description'],
                                    //   fontSize: 18,
                                    // )
                                  ],
                                ),
                              ),
                              d['event_contribution'] == 1
                                  ? Icon(
                                      Icons.card_giftcard,
                                      color: Green,
                                    )
                                  : DataText(
                                      text: '+ ₹' +
                                          (d['amount'].toString() == ""
                                              ? '0'
                                              : d['amount'].toString()),
                                      fontSize: 17,
                                      color: Green,
                                      fontWeight: FontWeight.w600,
                                    ),
                              SizedBox(
                                width: 4,
                              ),
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
    );
  }
}
