import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:samajapp/Controllers/HomeController.dart';
import 'package:samajapp/Controllers/profileController.dart';
import 'package:samajapp/Utils/SharedPrefunc.dart';
import 'package:samajapp/Utils/Toast.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/myAppBar.dart';
import 'package:samajapp/Utils/mytxt.dart';
import 'package:samajapp/Views/Dashboard_dir/AchievementView.dart';
import 'package:samajapp/Views/Dashboard_dir/DontaionView.dart';
import 'package:samajapp/Views/Dashboard_dir/wishView.dart';
import 'package:video_player/video_player.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  ProfileController pc = Get.find<ProfileController>();
  Homecontroller hc = Get.find<Homecontroller>();

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',


      ),
      body: Container(
        height: mySize.height,
        width: mySize.width,
        child: GetBuilder<Homecontroller>(builder: (hc) {
          if (hc.Loading.value == true) {
            return Center(child: myCircular());
          } else {
            return RefreshIndicator.adaptive(
              color: Green,
              backgroundColor: Colors.white,
              onRefresh: () async {
                await hc.fetchEntireHomeData();
                ToastUtils().showCustom('Refreshed');
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    hc.AdvertiseHomeList.length != 0
                        ? CarouselSlider.builder(
                            itemCount: hc.AdvertiseHomeList.length,
                            itemBuilder: (context, index, realIndex) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                                child: Container(
                                  width: mySize.width,
                                  child: hc.AdvertiseHomeList[index]
                                              ['advertis_type'] ==
                                          2
                                      ? VideoPlayerWidget(
                                          videoUrl: hc.AdvertiseHomeList[index]
                                              ['video'])
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: CachedNetworkImage(
                                            errorWidget: (b, o, s) {
                                              return Center(
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  size: 30,
                                                ),
                                              );
                                            },
                                            imageUrl:
                                                hc.AdvertiseHomeList[index]
                                                    ['image'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 3,
                                          color: Colors.grey,
                                          spreadRadius: 0.01)
                                    ],
                                    //color: Colors.red
                                  ),
                                ),
                              );
                            },
                            options: CarouselOptions(
                              autoPlayInterval: Duration(seconds: 10),
                              onPageChanged: (page, o) {
                                hc.Adver.value = page;
                              },
                              viewportFraction: 0.9,
                              autoPlay: true,
                              height: mySize.height / 4,
                              scrollDirection: Axis.horizontal,
                            ))
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    ),
                    hc.AdvertiseHomeList.length != 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(hc.AdvertiseHomeList.length,
                                (index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3),
                                child: Obx(() {
                                  return AnimatedContainer(
                                    height: hc.Adver.value == index ? 12 : 10,
                                    width: hc.Adver.value == index ? 12 : 10,
                                    duration: Duration(milliseconds: 400),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: hc.Adver.value == index
                                            ? Green
                                            : Colors.grey),
                                  );
                                }),
                              );
                            }),
                          )
                        : SizedBox(),
                    Column(
                      children: [
                        hc.donationHomeList.length != 0
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    DataText(
                                      text: 'Donations',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        Get.dialog(Center(
                                          child: myCircular(),
                                        ));
                                        try {
                                          await hc.fetchDonationData();
                                        } finally {
                                          Get.back();
                                        }
                                        Get.to(() => DonationView());
                                      },
                                      child: DataText(
                                        text: 'See All  ',
                                        fontSize: 14,
                                        color: Green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                        hc.donationHomeList.length != 0
                            ? CarouselSlider.builder(
                                itemBuilder: (context, index, real) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.shade300,
                                                blurRadius: 5,
                                                spreadRadius: 0.1)
                                          ],
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  errorWidget: (b, o, s) {
                                                    return Icon(
                                                      Icons.account_circle,
                                                      size: 30,
                                                    );
                                                  },
                                                  imageUrl:
                                                      hc.donationHomeList[index]
                                                          ['profile_pic'],
                                                  height: double.infinity,
                                                  width: 85,
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                DataText(
                                                  text:
                                                      hc.donationHomeList[index]
                                                          ['user_name'],
                                                  fontSize: 16,
                                                  color: Green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                // SizedBox(
                                                //   height: 5,
                                                // ),
                                                DataText(
                                                  wantels: true,
                                                  maxLines: 3,
                                                  text:
                                                      hc.donationHomeList[index]
                                                          ['description'],
                                                  fontSize: 14,
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          hc.donationHomeList[index]
                                                      ['event_contribution'] ==
                                                  1
                                              ? Center(
                                                  child: Icon(
                                                    Icons.card_giftcard,
                                                    color: Green,
                                                  ),
                                                )
                                              : Center(
                                                  child: DataText(
                                                    text: '₹' +
                                                        hc.donationHomeList[
                                                                index]['amount']
                                                            .toString(),
                                                    fontSize: 17,
                                                    color: Green,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: hc.donationHomeList.length,
                                options: CarouselOptions(
                                  autoPlayInterval: Duration(seconds: 10),
                                  onPageChanged: (i, o) {
                                    hc.Donat.value = i;
                                  },
                                  viewportFraction: 1,
                                  autoPlay: true,
                                  height: mySize.height / 6,
                                  scrollDirection: Axis.horizontal,
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 15,
                        ),
                        hc.wishHomeList.length != 0
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    DataText(
                                      text: 'Wishes',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        Get.dialog(Center(
                                          child: myCircular(),
                                        ));
                                        try {
                                          await hc.fetchWishList();
                                        } finally {
                                          Get.back();
                                        }
                                        Get.to(() => WishView());
                                      },
                                      child: DataText(
                                        text: 'See All  ',
                                        fontSize: 14,
                                        color: Green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 5,
                                      spreadRadius: 0.1)
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            // color: Colors.orange,
                            child: Column(
                              children: [
                                hc.wishHomeList.length != 0
                                    ? CarouselSlider.builder(
                                        itemBuilder: (context, index, real) {
                                          return GestureDetector(
                                            // onTap: () {
                                            //   showDialog(
                                            //     context: context,
                                            //     builder:
                                            //         (BuildContext context) {
                                            //       return Dialog(
                                            //         shape:
                                            //             RoundedRectangleBorder(
                                            //           borderRadius:
                                            //               BorderRadius.circular(
                                            //                   10),
                                            //         ),
                                            //         child: Padding(
                                            //           padding:
                                            //               const EdgeInsets.all(
                                            //                   20.0),
                                            //           child: Column(
                                            //             mainAxisSize:
                                            //                 MainAxisSize.min,
                                            //             children: [
                                            //               Text(
                                            //                 "🎉 Happy Birthday 🎉",
                                            //                 style: TextStyle(
                                            //                   fontSize: 22,
                                            //                   fontWeight:
                                            //                       FontWeight
                                            //                           .bold,
                                            //                   color:
                                            //                       Colors.pink,
                                            //                 ),
                                            //                 textAlign: TextAlign
                                            //                     .center,
                                            //               ),
                                            //               SizedBox(height: 20),
                                            //               // Lottie.asset(
                                            //               //   'assets/animation_lottiy.json',
                                            //               //   // Add a Lottie animation file
                                            //               //   height: 150,
                                            //               //   width: double.infinity,
                                            //               // ),
                                            //               SizedBox(height: 20),
                                            //               Stack(
                                            //                 children: [
                                            //                   ClipRRect(
                                            //                       borderRadius:
                                            //                       BorderRadius
                                            //                           .circular(10),
                                            //                       child:
                                            //                       CachedNetworkImage(
                                            //                         errorWidget:
                                            //                             (b, o, s) {
                                            //                           return Icon(
                                            //                               Icons
                                            //                                   .account_circle,
                                            //                               size: 30);
                                            //                         },
                                            //                         imageUrl: hc
                                            //                             .wishHomeList[
                                            //                         index]['image'],
                                            //                         height: 250,
                                            //                         width: double.infinity,
                                            //                         fit: BoxFit.cover,
                                            //                       )),
                                            //                   Lottie.asset(
                                            //                     'assets/animation_lottiy.json',
                                            //                     // Add a Lottie animation file
                                            //                     height: 150,
                                            //                     width: double.infinity,
                                            //                   ),
                                            //                 ],
                                            //               ),
                                            //               SizedBox(height: 20),
                                            //               ElevatedButton(
                                            //                 onPressed: () {
                                            //                   Navigator.pop(
                                            //                       context); // Close the dialog
                                            //                 },
                                            //                 child:
                                            //                     Text("Close"),
                                            //               ),
                                            //             ],
                                            //           ),
                                            //         ),
                                            //       );
                                            //     },
                                            //   );
                                            // },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 15),
                                              child: SizedBox(
                                                width: mySize.width,
                                                child: Row(
                                                  //mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child:
                                                            CachedNetworkImage(
                                                          errorWidget:
                                                              (b, o, s) {
                                                            return Icon(
                                                                Icons
                                                                    .account_circle,
                                                                size: 30);
                                                          },
                                                          imageUrl: hc
                                                                  .wishHomeList[
                                                              index]['image'],
                                                          height: 110,
                                                          width: 80,
                                                          fit: BoxFit.cover,
                                                        )),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        // mainAxisSize:
                                                        // MainAxisSize.min,

                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          DataText(
                                                            text:
                                                                hc.wishHomeList[
                                                                        index][
                                                                    'user_name'],
                                                            fontSize: 18,
                                                            color: Green,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          DataText(
                                                            text: hc.wishHomeList[
                                                                    index]
                                                                ['wishes_type'],
                                                            // +
                                                            // " "
                                                            // +
                                                            // hc.wishHomeList[index]
                                                            // ['title'],
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          DataText(
                                                            text: hc.wishHomeList[
                                                                    index]
                                                                ['description'],
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            wantels: true,
                                                            maxLines: 2,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: hc.wishHomeList.length,
                                        options: CarouselOptions(
                                          autoPlayInterval:
                                              Duration(seconds: 10),
                                          onPageChanged: (i, d) {
                                            hc.Wishh.value = i;
                                          },
                                          viewportFraction: 1,
                                          autoPlay: true,
                                          height: mySize.height / 6,
                                          scrollDirection: Axis.horizontal,
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(
                    //   height: 5,
                    // ),

                    const SizedBox(
                      height: 10,
                    ),
                    hc.achievementrHomeList.length != 0
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DataText(
                                  text: 'Achievements',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    Get.dialog(Center(
                                      child: myCircular(),
                                    ));
                                    try {
                                      await hc.fetchAchievementList();
                                    } finally {
                                      Get.back();
                                    }
                                    Get.to(() => Achievementview());
                                  },
                                  child: DataText(
                                    text: 'See All  ',
                                    fontSize: 14,
                                    color: Green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    const SizedBox(
                      height: 5,
                    ),
                    hc.achievementrHomeList.length != 0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                              // padding: const EdgeInsets.symmetric(
                              //     vertical: 10,),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 5,
                                    )
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              // color: Colors.orange,
                              child: CarouselSlider.builder(
                                itemBuilder: (context, index, real) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.dialog(
                                        AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: Text(
                                              hc.achievementrHomeList[index]
                                                  ['user_name']),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                height: 300,
                                                width: double.infinity,
                                                color: Colors.red,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      hc.achievementrHomeList[
                                                          index]['image'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              //Image.network(hc.achievementrHomeList[index]['image']),
                                              SizedBox(height: 10),
                                              Text(
                                                  hc.achievementrHomeList[index]
                                                      ['description']),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Get.back(); // To close the dialog
                                              },
                                              child: Text(
                                                "Close",
                                                style: GoogleFonts.dmSans(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18,
                                                    color: AppBarColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                        barrierDismissible:
                                            true, // Tap outside to dismiss the dialog
                                      );
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: hc.achievementrHomeList[
                                                            index]['image'] !=
                                                        ""
                                                    ? SizedBox()
                                                    : Center(
                                                        child: Icon(Icons
                                                            .image_not_supported),
                                                      ),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                        image: CachedNetworkImageProvider(
                                                            hc.achievementrHomeList[
                                                                    index]
                                                                ['image']),
                                                        fit: BoxFit.cover)),
                                              ),
                                            ),
                                            DataText(
                                              text:
                                                  hc.achievementrHomeList[index]
                                                      ['user_name'],
                                              wantels: true,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Green,
                                            ),
                                            DataText(
                                              text:
                                                  hc.achievementrHomeList[index]
                                                      ['description'],
                                              fontSize: 17,
                                              wantels: true,
                                            )
                                          ],
                                        )),
                                  );
                                },
                                itemCount: hc.achievementrHomeList.length,
                                options: CarouselOptions(
                                  autoPlayInterval: Duration(seconds: 10),
                                  onPageChanged: (i, o) {
                                    hc.Ach.value = i;
                                  },
                                  viewportFraction: 1,
                                  autoPlay: true,
                                  height: mySize.height / 4,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    const SizedBox(
                      height: 10,
                    ),
                    hc.achievementrHomeList.length != 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                hc.achievementrHomeList.length, (index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3),
                                child: Obx(() {
                                  return AnimatedContainer(
                                    height: hc.Ach.value == index ? 12 : 10,
                                    width: hc.Ach.value == index ? 12 : 10,
                                    duration: Duration(milliseconds: 400),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: hc.Ach.value == index
                                            ? Green
                                            : Colors.grey),
                                  );
                                }),
                              );
                            }),
                          )
                        : SizedBox(),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}

class DashboardDetails extends StatelessWidget {
  const DashboardDetails(
      {super.key,
      required this.image,
      required this.title,
      required this.description});

  final String image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: MediaQuery.sizeOf(context).width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            image == ""
                ? SizedBox()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )),
            DataText(
              text: title,
              wantels: true,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Green,
            ),
            DataText(
              text: description,
              fontSize: 17,
            )
          ],
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.play();
    _controller.setVolume(0);
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  //   ToastUtils().showCustom('Dispose');
  // }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: Green,
              strokeWidth: 2,
            ));
          }
        },
      ),
    );
  }
}
