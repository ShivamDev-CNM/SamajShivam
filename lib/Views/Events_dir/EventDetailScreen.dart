import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:samajapp/Controllers/eventController.dart';
import 'package:samajapp/Utils/SharedPrefunc.dart';
import 'package:samajapp/Utils/Toast.dart';
import 'package:samajapp/Utils/VideoPlayerWidget.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/mytxt.dart';

class EventDetailScreen extends StatelessWidget {
  EventDetailScreen({super.key, required this.id, required this.indxx});

  final String id;
  final int indxx;

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
      body: GetBuilder<Eventcontroller>(builder: (ec) {
        if (ec.eventDetailData == null || ec.eventDetailData.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: Green,
              strokeWidth: 2,
            ),
          );
        } else {
          var d = ec.eventDetailData['data'][0];
          var i = ec.eventDetailData['multiple_event_photo'];
          var v = ec.eventDetailData['multiple_event_video'];
          return Stack(
            children: [
              SizedBox(
                height: mySize.height,
                width: mySize.width,
              ),
              Stack(
                children: [
                  Hero(
                    tag: d['id'],
                    child: CachedNetworkImage(
                      imageUrl: d['event_photo'],
                      height: 300,
                      width: mySize.width,
                      fit: BoxFit.cover,
                      errorWidget: (b, o, s) {
                        return Icon(
                          Icons.image_not_supported,
                          size: 100,
                        );
                      },
                    ),
                  ),
                  Positioned(
                      left: 5,
                      top: 50,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const CircleAvatar(
                          backgroundColor: Green,
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                        ),
                      ))
                ],
              ),
              Positioned(
                top: 285,
                child: Container(
                  height: mySize.height / 1.5,
                  width: mySize.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DataText(
                        text: d['event_name'],
                        fontSize: 22,
                        color: Green,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 15,),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.watch_later_outlined,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  DataText(
                                    text: DateFormat('h:mma').format(
                                            DateFormat('HH:mm:ss')
                                                .parse(d['from_time'])) +
                                        ' to ' +
                                        DateFormat('h:mma').format(
                                            DateFormat('HH:mm:ss')
                                                .parse(d['to_time'])),
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  DataText(
                                    text: d['from_date'] == ""
                                        ? ''
                                        : DateFormat('dd-MMM-yy').format(
                                        DateTime.parse(d['from_date'])) +
                                        " to " +
                                        DateFormat('dd-MMM yy').format(
                                            DateTime.parse(d['to_date'])),
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined,size: 22,),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  DataText(text: d['address'], fontSize: 17),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              DataText(
                                text: 'Description',
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Green,
                              ),
                              DataText(text: d['description'], fontSize: 17),
                              SizedBox(
                                height: 10,
                              ),
                              v.length <= 0 && i.length <= 0
                                  ? SizedBox()
                                  : DataText(
                                      text: 'Photos & Videos',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Green,
                                    ),
                              Wrap(
                                children: [
                                  Wrap(
                                      children: List.generate(i.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 4),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.find<Eventcontroller>().imageIndex.value =
                                              index;
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              scrollControlDisabledMaxHeightRatio: 200,
                                              context: context,
                                              builder: (context) {
                                                return ImageWatch(
                                                  Images: i,
                                                );
                                              });
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            imageUrl: i[index]['image'],
                                            height: 80,
                                            fit: BoxFit.cover,
                                            width: 80,
                                          ),
                                        ),
                                      ),
                                    );
                                  })),
                                  Wrap(
                                      children: List.generate(v.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 4),
                                      child: GestureDetector(
                                        onTap: () async {
                                          Get.dialog(myCircular());
                                          try {
                                            ec.ViInd.value = index;
                                            ec.videoIndex.value = index + 1;
                                            await ec.loadVideo(v[index]['video']);
                                          } catch (e) {
                                          } finally {
                                            Get.back();
                                          }
                          
                                          if (ec.isVideoInitialized.value == true) {
                                            Get.bottomSheet(myVideoPlayerWidget(
                                              vides: v,
                                              thumbNail: ec.thumbnailList,
                                            ));
                                          } else {
                                            ToastUtils()
                                                .showCustom('Failed to load video');
                                          }
                                        },
                                        child: Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: FileImage(
                                                      File(ec.thumbnailList[index])),
                                                  fit: BoxFit.cover),
                                              borderRadius: BorderRadius.circular(10)),
                                          child: Icon(
                                            Icons.play_circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  })),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DefaultTabController(
                                initialIndex: indxx,
                                length: 2,
                                child: Column(
                                  children: [
                                    TabBar(
                                      isScrollable: false,
                                      indicatorColor: Colors.black45,
                                      unselectedLabelColor: Colors.black,
                                      indicatorSize: TabBarIndicatorSize.label,
                                      physics: NeverScrollableScrollPhysics(),
                                      tabs: [
                                        Tab(
                                          child: Text(
                                            'Donations',
                                            style:
                                                TextStyle(color: Green, fontSize: 20),
                                          ),
                                        ),
                                        Tab(
                                          child: Text(
                                            'Expenses',
                                            style: TextStyle(
                                                color: Colors.red, fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: mySize.height / 3,
                                      child: TabBarView(
                                        children: [
                                          // Replace with your actual content widgets
                                          DonationList(
                                            myList: ec.eventDonationList,
                                            title: '  Donation',
                                            col: Green,
                                          ),
                                          ExpenseList(
                                            myList: ec.eventExpenseList,
                                            title: '  Expense',
                                            col: Colors.red,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}

class ImageWatch extends StatelessWidget {
  ImageWatch({
    super.key,
    required this.Images,
  });

  Eventcontroller ee = Get.find<Eventcontroller>();

  final List Images;

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Obx(() {
        return Stack(
          children: [
            GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.velocity.pixelsPerSecond.dx < 0) {
                  // Swipe Left
                  if (ee.imageIndex.value < Images.length - 1) {
                    ee.imageIndex.value++;
                  }
                } else if (details.velocity.pixelsPerSecond.dx > 0) {
                  // Swipe Right
                  if (ee.imageIndex.value > 0) {
                    ee.imageIndex.value--;
                  }
                }
              },
              child: SizedBox(
                height: mySize.height,
                width: mySize.width,
                child: CachedNetworkImage(
                  imageUrl: Images[ee.imageIndex.value]['image'],
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              child: Container(
                color: Colors.white10,
                width: mySize.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(Images.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: GestureDetector(
                          onTap: () {
                            ee.imageIndex.value = index;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: index == ee.imageIndex.value
                                    ? Border.all(color: Green, width: 2)
                                    : null),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: Images[index]['image'],
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}

class DonationList extends StatelessWidget {
  DonationList(
      {super.key,
      required this.myList,
      required this.title,
      required this.col});

  Eventcontroller ec = Get.find<Eventcontroller>();
  final List myList;
  final String title;
  final Color col;

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SizedBox(
        height: mySize.height,
        width: mySize.width,
        child: myList.length <= 0
            ? Center(
                child: Text('No Data Found'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: col, borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: mySize.width / 4,
                          child: DataText(
                            text: '  User',
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          width: mySize.width / 4.5,
                          child: DataText(
                            text: 'Amount',
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          width: mySize.width / 4.5,
                          child: DataText(
                            text: 'Date',
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          child: DataText(
                            text: 'Title',
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: myList.length,
                        itemBuilder: (context, index) {
                          var d = myList[index];
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Container(
                                      width: mySize.width / 4,
                                      child: DataText(
                                        text: d['user_name'],
                                        wantels: true,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: mySize.width / 4.5,
                                      child: DataText(
                                        text: d['amount'].toString(),
                                        fontSize: 12,
                                        wantels: true,
                                      ),
                                    ),
                                    Container(
                                      width: mySize.width / 4.5,
                                      child: DataText(
                                          text: DateFormat('dd-MMM-yy').format(
                                              DateTime.parse(
                                                  d['transaction_date'])),
                                          fontSize: 12,
                                          wantels: true),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: DataText(
                                            text: d['title'],
                                            fontSize: 12,
                                            wantels: true),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider()
                            ],
                          );
                        }),
                  )
                ],
              ),
      ),
    );
  }
}

class ExpenseList extends StatelessWidget {
  ExpenseList(
      {super.key,
      required this.myList,
      required this.title,
      required this.col});

  Eventcontroller ec = Get.find<Eventcontroller>();
  final List myList;
  final String title;
  final Color col;

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SizedBox(
        height: mySize.height,
        width: mySize.width,
        child: myList.length <= 0
            ? Center(
                child: Text('No Data Found'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: col, borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: mySize.width / 4,
                          child: DataText(
                            text: '  Title',
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          width: mySize.width / 4.5,
                          child: DataText(
                            text: 'Amount',
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          width: mySize.width / 4.5,
                          child: DataText(
                            text: 'Date',
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          child: DataText(
                            text: 'Desc',
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: myList.length,
                        itemBuilder: (context, index) {
                          var d = myList[index];
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Container(
                                      width: mySize.width / 4,
                                      child: DataText(
                                        text: d['title'],
                                        wantels: true,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: mySize.width / 4.5,
                                      child: DataText(
                                        text: d['amount'].toString(),
                                        fontSize: 12,
                                        wantels: true,
                                      ),
                                    ),
                                    Container(
                                      width: mySize.width / 4.5,
                                      child: DataText(
                                          text: DateFormat('dd-MMM-yy').format(
                                              DateTime.parse(
                                                  d['transaction_date'])),
                                          fontSize: 12,
                                          wantels: true),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: DataText(
                                            text: d['description'],
                                            fontSize: 12,
                                            wantels: true),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider()
                            ],
                          );
                        }),
                  )
                ],
              ),
      ),
    );
  }
}
