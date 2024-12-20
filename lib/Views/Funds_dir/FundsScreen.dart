import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:samajapp/Controllers/FundsController.dart';
import 'package:samajapp/Controllers/eventController.dart';
import 'package:samajapp/Utils/CustomMonthPicker.dart';
import 'package:samajapp/Utils/SharedPrefunc.dart';
import 'package:samajapp/Utils/Toast.dart';
import 'package:samajapp/Utils/UI%20Resuse%20Fields.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/myAppBar.dart';
import 'package:samajapp/Utils/mytxt.dart';
import 'package:samajapp/Views/Events_dir/EventDetailScreen.dart';

class FundsScreen extends StatefulWidget {
  FundsScreen({super.key});

  @override
  State<FundsScreen> createState() => _FundsScreenState();
}

class _FundsScreenState extends State<FundsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fc.currentIndex.value = 0;
  }

  FundsController fc = Get.find<FundsController>();

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Funds',
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: mySize.height,
          width: mySize.width,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: mySize.width,
                decoration: BoxDecoration(
                    color: AppBarColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DataText(
                          text: 'Total Available Funds',
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        IconButton(
                            onPressed: () async {
                              await fc.fetchTotalCommunity();
                              await fc.fetchMonthlyCommunityList();
                              await fc.fetchDonationList();
                              await fc.fetchMonthlyContributionList();
                              await fc.fetchExpensesList();
                              await fc.fetchNormalDonationList();
                              await fc.fetchSponSorshipList();
                              await fc.fetchAdverList();
                              await fc.fetchNormalExpenseList();
                              ToastUtils().showCustom('Refreshed');
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ))
                      ],
                    ),
                    GetBuilder<FundsController>(builder: (fc) {
                      if (fc.TotalComData.isEmpty) {
                        return SizedBox();
                      } else {
                        return DataText(
                          text: "₹" +
                              " " +
                              NumberFormat('##,##,##,##,###.00')
                                  .format(fc.TotalComData[0]['remaining']),
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        );
                      }
                    }),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                controller: fc.sc,
                scrollDirection: Axis.horizontal,
                child: GetBuilder<FundsController>(builder: (fc) {
                  return Row(
                    children: [
                      myContainer('Community\nFunds', 0,0),
                      SizedBox(
                        width: 10,
                      ),
                      myContainer('Monthly\nContributions', 1,1),
                      SizedBox(
                        width: 10,
                      ),
                      myContainer('Expenses', 2,2),
                      SizedBox(
                        width: 10,
                      ),
                      myContainer('Donations', 3,3),
                      SizedBox(
                        width: 10,
                      ),
                      myContainer('Sponsorships', 4,4),
                      SizedBox(
                        width: 10,
                      ),
                      myContainer('Advertisements', 5,5),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    fc.currentIndex.value = index;
                    fc.update();
                  },
                  controller: fc.pg,
                  children: [
                    CommunityFundsScreen(),
                    MonthlyContribution(),
                    ExpensesScreen(),
                    Donations(),
                    SponsorShipList(),
                    AdvertisList(),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

Widget myContainer(String text, int Index,int scrollIndex) {
  FundsController fc = Get.find<FundsController>();

  return GestureDetector(
    onTap: () {
      fc.scrollToIndex(scrollIndex);
      fc.currentIndex.value = Index;
      fc.pg.jumpToPage(fc.currentIndex.value);
      fc.update();
    },
    child: AnimatedContainer(
      constraints: const BoxConstraints(minWidth: 170, minHeight: 60),
      decoration: BoxDecoration(
          color: fc.currentIndex.value == Index ? AppBarColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Green)),
      duration: const Duration(milliseconds: 300),
      child: Center(
          child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.dmSans(
            color: fc.currentIndex.value == Index ? Colors.white : Green,
            fontWeight: FontWeight.bold,
            fontSize: 16),
      )),
    ),
  );
}

class CommunityFundsScreen extends StatelessWidget {
  CommunityFundsScreen({super.key});

  FundsController fc = Get.find<FundsController>();

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SizedBox(
        height: mySize.height,
        width: mySize.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomMonthPicker(
                  myFunc: fc.fetchMonthlyCommunityList,
                  // Pass the function reference
                  selectedDate: fc.selectMonthCom,
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.grey, blurRadius: 1)
                    ]),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DataText(
                          text: 'Donations',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        GetBuilder<FundsController>(builder: (fc) {
                          if (fc.MonthlyCommunityList.isEmpty) {
                            return Text('--');
                          } else {
                            return DataText(
                              text: "₹" +
                                  " " +
                                  NumberFormat('##,##,##,##,###').format(
                                      fc.MonthlyCommunityList[0]['donation']),
                              fontSize: 18,
                              color: Green,
                              fontWeight: FontWeight.bold,
                            );
                          }
                        })
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DataText(
                          text: 'Advertisements',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        GetBuilder<FundsController>(builder: (fc) {
                          if (fc.MonthlyCommunityList.isEmpty) {
                            return Text('--');
                          } else {
                            return DataText(
                              text: "₹" +
                                  " " +
                                  NumberFormat('##,##,##,##,###').format(
                                      fc.MonthlyCommunityList[0]['advertise']),
                              fontSize: 18,
                              color: Green,
                              fontWeight: FontWeight.bold,
                            );
                          }
                        })
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DataText(
                          text: 'Sponsorships',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        GetBuilder<FundsController>(builder: (fc) {
                          if (fc.MonthlyCommunityList.isEmpty) {
                            return Text('--');
                          } else {
                            return DataText(
                              text: "₹" +
                                  " " +
                                  NumberFormat('##,##,##,##,###').format(fc
                                      .MonthlyCommunityList[0]['sponsorship']),
                              // text:
                              //     '+ ₹${fc.MonthlyCommunityList[0]['sponsorship'].toString()}',
                              fontSize: 18,
                              color: Green,
                              fontWeight: FontWeight.bold,
                            );
                          }
                        })
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DataText(
                          text: 'Monthly',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        GetBuilder<FundsController>(builder: (fc) {
                          if (fc.MonthlyCommunityList.isEmpty) {
                            return Text('--');
                          } else {
                            return DataText(
                              text: "₹" +
                                  " " +
                                  NumberFormat('##,##,##,##,###.00').format(
                                      fc.MonthlyCommunityList[0]['monthly']),
                              // text:
                              //     '+ ₹${fc.MonthlyCommunityList[0]['monthly'].toString()}',
                              fontSize: 18,
                              color: Green,
                              fontWeight: FontWeight.bold,
                            );
                          }
                        })
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DataText(
                          text: 'Expenses',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        GetBuilder<FundsController>(builder: (fc) {
                          if (fc.MonthlyCommunityList.isEmpty) {
                            return Text('--');
                          } else {
                            return DataText(
                              text: "₹" +
                                  " " +
                                  NumberFormat('##,##,##,##,###.00').format(
                                      fc.MonthlyCommunityList[0]['expense']),
                              // text:
                              //     '- ₹${fc.MonthlyCommunityList[0]['expense'].toString()}',
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            );
                          }
                        })
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DataText(
                          text: 'Remaining',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        GetBuilder<FundsController>(builder: (fc) {
                          if (fc.MonthlyCommunityList.isEmpty) {
                            return Text('--');
                          } else {
                            return DataText(
                              text: "₹" +
                                  " " +
                                  NumberFormat('##,##,##,##,###.00').format(
                                      fc.MonthlyCommunityList[0]['remaining']),
                              // text:
                              //     '₹${fc.MonthlyCommunityList[0]['remaining'].toString()}',
                              fontSize: 18,
                              color:
                                  fc.MonthlyCommunityList[0]['remaining'] <= 0
                                      ? Colors.red
                                      : Colors.green,
                              fontWeight: FontWeight.bold,
                            );
                          }
                        })
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Donations extends StatelessWidget {
  Donations({super.key});

  FundsController fc = Get.find<FundsController>();
  Eventcontroller ec = Get.find<Eventcontroller>();

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);

    return Scaffold(
        body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return myTappableContainer(
                  title: 'Event',
                  Condition: fc.NormalDonationCondition.value == '1',
                  ontap: () async {
                    Get.dialog(Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ));
                    try {
                      fc.NormalDonationCondition.value = '1';
                      await fc.fetchDonationList();
                    } finally {
                      Get.back();
                    }

                    fc.update();
                  });
            }),
            SizedBox(
              width: 5,
            ),
            Obx(() {
              return myTappableContainer(
                  title: 'General',
                  Condition: fc.NormalDonationCondition.value == '2',
                  ontap: () async {
                    Get.dialog(Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ));
                    try {
                      fc.NormalDonationCondition.value = '2';
                      await fc.fetchNormalDonationList();
                    } finally {
                      Get.back();
                    }
                    fc.update();
                  });
            }),
            SizedBox(
              width: 5,
            ),
            Obx(() {
              return CustomMonthPicker(
                myFunc: fc.NormalDonationCondition.value == '1'
                    ? fc.fetchDonationList
                    : fc.fetchNormalDonationList,
                // Pass the function reference
                selectedDate: fc.selectDonation,
              );
            })
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Expanded(child: GetBuilder<FundsController>(builder: (fc) {
          if (fc.NormalDonationCondition.value == '1') {
            if (fc.DonationList.isEmpty) {
              return Center(
                child: DataText(text: 'No Data Found', fontSize: 15),
              );
            } else {
              return ListView.builder(
                  itemCount: fc.DonationList.length,
                  itemBuilder: (context, index) {
                    var d = fc.DonationList[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: GestureDetector(
                        onTap: fc.myDonationBools[index] == true
                            ? () {
                                fc.myDonationBools[index] = false;
                                fc.update();
                              }
                            : () async {
                                for (int i = 0;
                                    i < fc.myDonationBools.length;
                                    i++) {
                                  fc.myDonationBools[i] = false;
                                }
                                fc.update();

                                fc.DonationuserNames.value = "";
                                List<String> userName =
                                    d['multiple_user_name'].split(',');
                                fc.DonationuserNames.value =
                                    userName.join(', ');

                                fc.myDonationBools[index] =
                                    !fc.myDonationBools[index];
                                fc.update();
                              },
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
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
                                      text: d['user_name'],
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  d['event_contribution'] == 1
                                      ? Icon(
                                          Icons.card_giftcard,
                                          color: Green,
                                        )
                                      : DataText(
                                    text: "+" " ₹" +
                                        " " +
                                        NumberFormat('##,##,##,##,###')
                                            .format(d[
                                        'amount']),
                                          //text: '+ ₹' + d['amount'].toString(),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Green,
                                        ),
                                  fc.myDonationBools[index] == true
                                      ? Icon(
                                          Icons.arrow_drop_up,
                                          color: Colors.grey,
                                        )
                                      : Icon(
                                          Icons.arrow_drop_down_outlined,
                                          color: Colors.grey,
                                        ),
                                  GestureDetector(
                                      onTap: () async {
                                        Get.dialog(myCircular());

                                        try {
                                          await ec.fetchEventDetail(
                                              d['event_id'].toString());
                                          await ec.fetchEventExpenseList(
                                              d['event_id']);
                                          await ec.fetchEventDonationList(
                                              d['event_id']);
                                          await ec.LoopIt();
                                        } finally {
                                          Get.back();
                                        }
                                        if (ec.eventDetailData['data'] !=
                                            null) {
                                          Get.to(() => EventDetailScreen(
                                                id: d['id'].toString(),
                                                indxx: 0,
                                              ));
                                        } else {
                                          ToastUtils().showCustom(
                                              'Unable to load data');
                                        }
                                      },
                                      child: Icon(
                                        Icons.info,
                                        color: Green,
                                      )),
                                ],
                              ),
                              myEventDate(
                                  mobile: d['event_name'],
                                  date: d['transaction_date']),
                              fc.myDonationBools[index] == true
                                  ? DataText(
                                      text: '      All Users:',
                                      fontSize: 13,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    )
                                  : SizedBox(),
                              fc.myDonationBools[index] == true
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Wrap(children: [
                                        DataText(
                                          text: fc.DonationuserNames.value
                                              .toString(),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        )
                                      ]),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
          } else {
            if (fc.NormalDonationList.isEmpty) {
              return Center(
                child: DataText(text: 'No Data Found', fontSize: 15),
              );
            } else {
              return ListView.builder(
                  itemCount: fc.NormalDonationList.length,
                  itemBuilder: (context, index) {
                    var d = fc.NormalDonationList[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
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
                        child: Column(
                          children: [
                            Row(
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
                                    text: d['user_name'],
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                DataText(
                                  text: "+" " ₹" +
                                      " " +
                                      NumberFormat('##,##,##,##,###')
                                          .format(d[
                                      'amount']),
                                  //text: '+ ₹' + d['amount'].toString(),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Green,
                                ),
                              ],
                            ),
                            myPhoneDate(
                                mobile: d['area_name'],
                                date: d['transaction_date'])
                          ],
                        ),
                      ),
                    );
                  });
            }
          }
        }))
      ],
    ));
  }
}

class MonthlyContribution extends StatelessWidget {
  MonthlyContribution({super.key});

  FundsController fc = Get.find<FundsController>();

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);

    return Scaffold(
        body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomMonthPicker(
              myFunc: fc.fetchMonthlyContributionList,
              // Pass the function reference
              selectedDate: fc.selectMonthlyContributionDate,
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Expanded(child: GetBuilder<FundsController>(builder: (fc) {
          if (fc.MonthlyContributionList.isEmpty) {
            return Center(
              child: DataText(text: 'No Data Found', fontSize: 15),
            );
          } else {
            return ListView.builder(
                itemCount: fc.MonthlyContributionList.length,
                itemBuilder: (context, index) {
                  var d = fc.MonthlyContributionList[index];

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
                      child: Column(
                        children: [
                          Row(
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
                                  text: d['user_name'],
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              DataText(
                                text: "+" " ₹" +
                                    " " +
                                    NumberFormat('##,##,##,##,###')
                                        .format(d['amount']),
                                //text: '+ ₹' +.toString(),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Green,
                              ),
                            ],
                          ),
                          myPhoneDate(
                              mobile: d['area_name'],
                              date: d['transaction_date'])
                        ],
                      ),
                    ),
                  );
                });
          }
        }))
      ],
    ));
  }
}

class ExpensesScreen extends StatelessWidget {
  ExpensesScreen({super.key});

  Eventcontroller ec = Get.find<Eventcontroller>();

  FundsController fc = Get.find<FundsController>();

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);

    return Scaffold(
        body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return myTappableContainer(
                  title: 'Event',
                  Condition: fc.ConditionExpense.value == '1',
                  ontap: () async {
                    Get.dialog(Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ));
                    try {
                      fc.ConditionExpense.value = '1';
                      await fc.fetchExpensesList();
                    } finally {
                      Get.back();
                    }

                    fc.update();
                  });
            }),
            SizedBox(
              width: 5,
            ),
            Obx(() {
              return myTappableContainer(
                  title: 'General',
                  Condition: fc.ConditionExpense.value == '2',
                  ontap: () async {
                    Get.dialog(Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ));
                    try {
                      fc.ConditionExpense.value = '2';
                      await fc.fetchNormalExpenseList();
                    } finally {
                      Get.back();
                    }

                    fc.update();
                  });
            }),
            SizedBox(
              width: 5,
            ),
            CustomMonthPicker(
              myFunc: fc.ConditionExpense.value == '2'
                  ? fc.fetchNormalExpenseList
                  : fc.fetchExpensesList,
              // Pass the function reference
              selectedDate: fc.selectExpensesMonth,
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Expanded(child: GetBuilder<FundsController>(builder: (fc) {
          if (fc.ConditionExpense.value == '1') {
            if (fc.ExpensesMonthList.isEmpty) {
              return Center(
                child: DataText(text: 'No Data Found', fontSize: 15),
              );
            } else {
              return ListView.builder(
                  itemCount: fc.ExpensesMonthList.length,
                  itemBuilder: (context, index) {
                    var d = fc.ExpensesMonthList[index];

                    return fc.ExpensesMonthList[index]['amount'] == ""
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: GestureDetector(
                              onTap: () async {
                                Get.dialog(myCircular());

                                try {
                                  await ec.fetchEventDetail(d['id'].toString());
                                  await ec.fetchEventExpenseList(d['id']);
                                  await ec.fetchEventDonationList(d['id']);
                                  await ec.LoopIt();
                                } finally {
                                  Get.back();
                                }
                                if (ec.eventDetailData['data'] != null) {
                                  Get.to(() => EventDetailScreen(
                                        id: d['id'].toString(),
                                        indxx: 1,
                                      ));
                                } else {
                                  ToastUtils()
                                      .showCustom('Unable to load data');
                                }
                              },
                              child: Container(
                                width: mySize.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.grey, blurRadius: 1)
                                    ],
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
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
                                            text: d['event_name'],
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DataText(
                                          text: "-" " ₹" +
                                              " " +
                                              NumberFormat('##,##,##,##,###')
                                                  .format(d[
                                                      'total_expence_amount']),
                                          // text: '- ₹' +
                                          //     d['total_expence_amount']
                                          //         .toString(),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                    fromDateToDate(
                                      date: d['from_date'],
                                      mobile: d['to_date'],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                  });
            }
          } else {
            if (fc.NormalExpenseList.isEmpty) {
              return Center(
                child: DataText(text: 'No Data Found', fontSize: 15),
              );
            } else {
              return ListView.builder(
                  itemCount: fc.NormalExpenseList.length,
                  itemBuilder: (context, index) {
                    var d = fc.NormalExpenseList[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
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
                        child: Column(
                          children: [
                            Row(
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
                                    text: d['title'],
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                DataText(
                                  text: "-" " ₹" +
                                      " " +
                                      NumberFormat('##,##,##,##,###')
                                          .format(d[
                                      'amount']),
                                  //text: '- ₹' + d['amount'].toString(),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                            myDate(date: d['transaction_date'])
                          ],
                        ),
                      ),
                    );
                  });
            }
          }
        }))
      ],
    ));
  }
}

////////////////

class SponsorShipList extends StatelessWidget {
  SponsorShipList({super.key});

  FundsController fc = Get.find<FundsController>();

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);

    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomMonthPicker(
            myFunc: fc.fetchSponSorshipList,
            selectedDate: fc.selectSponsership),
        Expanded(
          child: GetBuilder<FundsController>(builder: (fc) {
            if (fc.SponsorShipList.isEmpty) {
              return Center(
                child: DataText(text: 'No Data Found', fontSize: 15),
              );
            } else {
              return ListView.builder(
                  itemCount: fc.SponsorShipList.length,
                  itemBuilder: (context, index) {
                    var d = fc.SponsorShipList[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    text: d['title'] + ' - ' + d['event_name'],
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                DataText(
                                  text: "+" " ₹" +
                                      " " +
                                      NumberFormat('##,##,##,##,###')
                                          .format(d[
                                      'amount']),
                                  //text: '+ ₹' + d['amount'].toString(),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                myDatenPerson(
                                  date: d['transaction_date'],
                                  person: d['user_name'],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            }
          }),
        ),
      ],
    ));
  }
}

class AdvertisList extends StatelessWidget {
  AdvertisList({super.key});

  FundsController fc = Get.find<FundsController>();

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);

    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomMonthPicker(
            myFunc: fc.fetchAdverList, selectedDate: fc.selectAdverTime),
        Expanded(
          child: GetBuilder<FundsController>(builder: (fc) {
            if (fc.AdverList.isEmpty) {
              return Center(
                child: DataText(text: 'No Data Found', fontSize: 15),
              );
            } else {
              return ListView.builder(
                  itemCount: fc.AdverList.length,
                  itemBuilder: (context, index) {
                    var d = fc.AdverList[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: GestureDetector(
                        onTap: fc.myBools[index] == true
                            ? () {
                                fc.myBools[index] = false;
                                fc.update();
                              }
                            : () async {
                                for (int i = 0; i < fc.myBools.length; i++) {
                                  fc.myBools[i] = false;
                                }
                                fc.update();

                                fc.userNames.value = "";
                                List<String> userName =
                                    d['multiple_user_name'].split(',');
                                fc.userNames.value = userName.join(', ');

                                fc.myBools[index] = !fc.myBools[index];
                                fc.update();
                              },
                        child: AnimatedContainer(
                          width: mySize.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(color: Colors.grey, blurRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          duration: Duration(milliseconds: 300),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
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
                                      text: d['title'],
                                      fontSize: 17,
                                      wantels: true,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  DataText(
                                    text: "+" " ₹" +
                                        " " +
                                        NumberFormat('##,##,##,##,###')
                                            .format(d[
                                        'amount']),
                                    //text: '+ ₹' + d['amount'].toString(),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                  fc.myBools[index] == true
                                      ? Icon(
                                          Icons.arrow_drop_up,
                                          color: Colors.grey,
                                        )
                                      : Icon(
                                          Icons.arrow_drop_down_outlined,
                                          color: Colors.grey,
                                        )
                                ],
                              ),
                              fromDateToDate(
                                  mobile: d['to_date'], date: d['from_date']),
                              fc.myBools[index] == true
                                  ? DataText(
                                      text: '      All Users:',
                                      fontSize: 13,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    )
                                  : SizedBox(),
                              fc.myBools[index] == true
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Wrap(children: [
                                        DataText(
                                          text: fc.userNames.value.toString(),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        )
                                      ]),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
          }),
        ),
      ],
    ));
  }
}

///////////////

class myTappableContainer extends StatelessWidget {
  const myTappableContainer(
      {super.key,
      required this.title,
      required this.Condition,
      required this.ontap});

  final String title;
  final bool Condition;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        decoration: BoxDecoration(
          color: Condition == true ? Green : Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.green),
        ),
        child: Row(
          children: [
            DataText(
              text: title,
              fontSize: 15,
              color: Condition == true ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
