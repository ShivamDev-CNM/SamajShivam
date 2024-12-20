import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:samajapp/Controllers/eventController.dart';
import 'package:samajapp/Utils/SharedPrefunc.dart';
import 'package:samajapp/Utils/Toast.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/myFilterBoxes.dart';
import 'package:samajapp/Utils/myTextField.dart';
import 'package:samajapp/Utils/mytxt.dart';
import 'package:samajapp/Views/Events_dir/EventDetailScreen.dart';

import '../../Utils/myAppBar.dart';
class EventsScreen extends StatelessWidget {
  EventsScreen({super.key});

  Eventcontroller ec = Get.find<Eventcontroller>();

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Events',
        ),
        body: SizedBox(
          height: mySize.height,
          width: mySize.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: myTextField(
                        onChanged: (val) async {
                          ec.searchController.text.isEmpty
                              ? ec.isSearched(false)
                              : ec.isSearched(true);

                          await ec.fetchEventList();
                        },
                        pref: Obx(
                          () => ec.isSearched.value
                              ? GestureDetector(
                                  onTap: () async {
                                    ec.searchController.clear();
                                    FocusScope.of(context).unfocus();
                                    await ec.fetchEventList();
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                )
                              : SizedBox(),
                        ),
                        controller: ec.searchController,
                        prefixI: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(Icons.search),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.grey,
                            )
                          ],
                        ),
                        hintText: 'Search Events',
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        ec.openFilterBox.toggle();
                      },
                      child: CircleAvatar(
                        backgroundColor: Green,
                        child: Obx(() => ec.openFilterBox.value
                            ? Icon(
                                Icons.filter_alt_outlined,
                                color: Colors.white,
                                size: 25,
                              )
                            : Icon(
                                Icons.filter_list_alt,
                                color: Colors.white,
                                size: 25,
                              )),
                      ),
                    )
                  ],
                ),
                Obx(() {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.linear,
                    height: ec.openFilterBox.value ? 50 : 0,
                    width: mySize.width,
                    child: ec.openFilterBox.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              myFilterBoxes(
                                  title: 'Upcoming/Current',
                                  onTap: () async {
                                    if (ec.filter.value == 'upcoming') {
                                      ec.Loading(true);
                                      ec.update();
                                      ec.filter.value = '';
                                      ec.openFilterBox.value = false;
                                      await ec.fetchEventList();
                                      return;
                                    }
                                    ec.Loading(true);
                                    ec.update();
                                    ec.filter.value = 'upcoming';
                                    await ec.fetchEventList();
                                  },
                                  value: ec.filter.value == 'upcoming'),
                              myFilterBoxes(
                                  title: 'Previous',
                                  onTap: () async {
                                    if (ec.filter.value == 'previous') {
                                      ec.Loading(true);
                                      ec.update();
                                      ec.filter.value = '';
                                      ec.openFilterBox.value = false;

                                      await ec.fetchEventList();
                                      return;
                                    }
                                    ec.Loading(true);
                                    ec.update();
                                    ec.filter.value = 'previous';

                                    await ec.fetchEventList();
                                  },
                                  value: ec.filter.value == 'previous'),
                            ],
                          )
                        : SizedBox(),
                  );
                }),
                Expanded(child: GetBuilder<Eventcontroller>(builder: (ec) {
                  if (ec.Loading.value) {
                    return Center(
                      child: myCircular(),
                    );
                  } else if (ec.eventData.isEmpty) {
                    return Center(
                      child: DataText(text: 'No Data Found', fontSize: 15),
                    );
                  } else {
                    return RefreshIndicator.adaptive(backgroundColor: Colors.white,
                      color: Green,
                      onRefresh: () async {
                        await ec.fetchEventList();
                        ToastUtils().showCustom('Refreshed');
                      },
                      child: ListView.builder(
                          itemCount: ec.eventData.length,
                          itemBuilder: (context, index) {
                            var d = ec.eventData[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: GestureDetector(
                                onTap: () async {
                                  Get.dialog(myCircular());

                                  try {
                                    await ec
                                        .fetchEventDetail(d['id'].toString());
                                    await ec.fetchEventExpenseList(d['id']);
                                    await ec.fetchEventDonationList(d['id']);
                                    await ec.LoopIt();
                                  } finally {
                                    Get.back();
                                  }
                                  if (ec.eventDetailData['data'] != null) {
                                    Get.to(() => EventDetailScreen(
                                          id: d['id'].toString(),
                                          indxx: 0,
                                        ));
                                  } else {
                                    ToastUtils()
                                        .showCustom('Unable to load data');
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey, blurRadius: 2)
                                      ],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Hero(
                                        tag: d['id'],
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            errorWidget: (b, o, s) {
                                              return Center(
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.black,
                                                  size: 50,
                                                ),
                                              );
                                            },
                                            imageUrl: d['event_photo'],
                                            height: 150,
                                            width: mySize.width,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      DataText(
                                        text: d['event_name'],
                                        fontSize: 20,
                                        color: Green,
                                        wantels: true,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      DataText(
                                        text: d['description'],
                                        fontSize: 15,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          myRow(iconr:Icons.location_on_outlined,
                                             text: d['address'],
                                              // onTap:() async {
                                              //   final Uri url = Uri.parse(
                                              //       'https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(d['address'])}');
                                              //   if (await canLaunchUrl(url)) {
                                              //   await launchUrl(url, mode: LaunchMode.externalApplication);
                                              //   } else {
                                              //   throw 'Could not open Google Maps';
                                              //   }
                                              //}
                                              ),
                                          d['from_date'] == ""
                                              ? SizedBox()
                                              : myRow(
                                              iconr:Icons.calendar_month_outlined,
                                                  text:DateFormat('dd MMM, y')
                                                      .format(DateTime.parse(
                                                          d['from_date']))),
                                          d['from_time'] == ""
                                              ? SizedBox()
                                              : myRow(
                                              iconr:Icons.watch_later_outlined,
                                                  text:DateFormat('h:mma').format(
                                                      DateFormat('HH:mm:ss')
                                                          .parse(
                                                              d['from_time'])))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  }
                }))
              ],
            ),
          ),
        ));
  }
}

Widget myRow(
{ required IconData iconr,
  required String text, void Function()? onTap,}
) {
  return Flexible(
    child: GestureDetector(
      onTap:onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconr,
            color: Green,
            size: 20,
          ),
          SizedBox(
            width: 1,
          ),
          Flexible(
            child: DataText(
              text: text,
              fontSize: 13,
              wantels: true,
            ),
          )
        ],
      ),
    ),
  );
}
