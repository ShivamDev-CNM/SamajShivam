import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:samajapp/Controllers/profileController.dart';
import 'package:samajapp/Utils/CustomMonthPicker.dart';
import 'package:samajapp/Utils/UI%20Resuse%20Fields.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/myAppBar.dart';
import 'package:samajapp/Utils/mytxt.dart';

class myPersonalExpense extends StatelessWidget {
  myPersonalExpense({super.key});

  ProfileController pc = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Payment',
        wantBackButton: true,
      ),
      body: SizedBox(
        height: mySize.height,
        width: mySize.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Green, width: 2),
                    borderRadius: BorderRadius.circular(10)),
                child: GetBuilder<ProfileController>(builder: (pc) {
                  return SingleChildScrollView(
                    controller: pc.expenseScroll,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        mynewCont2('Monthly', 0, pc.allPayPage.value, false),
                        mynewCont2('Donations', 1, pc.allPayPage.value, false),
                        mynewCont2('Sponsorship', 2, pc.allPayPage.value, true),
                        mynewCont2('Advertise', 3, pc.allPayPage.value, true),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Expanded(
                child: PageView(
              controller: pc.paypg,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                pc.allPayPage.value = index;
                pc.update();
              },
              children: [
                Monthly1(),
                Monthly(),
                Monthly3(),
                Monthly2(),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class Monthly1 extends StatelessWidget {
  Monthly1({super.key});

  ProfileController pf = Get.find<ProfileController>();

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
            CustomYearPicker(
              myFunc: pf.fetchAllPayment,
              // Pass the function reference
              selectedDate: pf.selectedDate,
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Expanded(child: GetBuilder<ProfileController>(builder: (fc) {
          if (fc.myPaymentData.isEmpty) {
            return Center(
              child: DataText(
                  text: 'Contact Admin To make Donations', fontSize: 15),
            );
          } else {
            return ListView.builder(
                itemCount: fc.myPaymentData.length,
                itemBuilder: (context, index) {
                  var d = fc.myPaymentData[index];

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
                                  text: DateFormat('dd-MMM-yyyy').format(
                                      DateTime.parse(d['transaction_date'])),
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              DataText(
                                text: ' ₹' + d['amount'].toString(),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
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

class Monthly extends StatelessWidget {
  Monthly({super.key});

  ProfileController pf = Get.find<ProfileController>();

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
            CustomYearPicker(
              myFunc: pf.fetchAllPayment,
              // Pass the function reference
              selectedDate: pf.selectedDate,
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Expanded(child: GetBuilder<ProfileController>(builder: (fc) {
          if (fc.myPaymentData.isEmpty) {
            return Center(
              child: DataText(text: 'No Data Found', fontSize: 15),
            );
          } else {
            return ListView.builder(
                itemCount: fc.myPaymentData.length,
                itemBuilder: (context, index) {
                  var d = fc.myPaymentData[index];

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
                                  text: d['event_name'] == ""
                                      ? d['title']
                                      : d['event_name'],
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
                                      text: ' ₹' + d['amount'].toString(),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          myTypetDate(
                            date: d['transaction_date'],
                            mobile: d['event_id'] == "" ? 'General' : 'Event',
                          ),
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

class Monthly2 extends StatelessWidget {
  Monthly2({super.key});

  ProfileController pf = Get.find<ProfileController>();

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
            CustomYearPicker(
              myFunc: pf.fetchAllPayment,
              // Pass the function reference
              selectedDate: pf.selectedDate,
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Expanded(child: GetBuilder<ProfileController>(builder: (fc) {
          if (fc.myPaymentData.isEmpty) {
            return Center(
              child: DataText(text: 'No Data Found', fontSize: 15),
            );
          } else {
            return ListView.builder(
                itemCount: fc.myPaymentData.length,
                itemBuilder: (context, index) {
                  var d = fc.myPaymentData[index];

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
                                  text: d['adverties_title'],
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              DataText(
                                text: ' ₹' + d['amount'].toString(),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          myDate(date: d['transaction_date']),
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

class Monthly3 extends StatelessWidget {
  Monthly3({super.key});

  ProfileController pf = Get.find<ProfileController>();

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
            CustomYearPicker(
              myFunc: pf.fetchAllPayment,
              // Pass the function reference
              selectedDate: pf.selectedDate,
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Expanded(child: GetBuilder<ProfileController>(builder: (fc) {
          if (fc.myPaymentData.isEmpty) {
            return Center(
              child: DataText(text: 'No Data Found', fontSize: 15),
            );
          } else {
            return ListView.builder(
                itemCount: fc.myPaymentData.length,
                itemBuilder: (context, index) {
                  var d = fc.myPaymentData[index];

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
                                  text: d['title'].toString() +
                                      ' - ' +
                                      d['event_name'],
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              DataText(
                                text: ' ₹' + d['amount'].toString(),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          myDate(date: d['transaction_date']),
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

mynewCont2(
  String text,
  int Index,
  int myIndex,
  bool want,
) {
  ProfileController pc = Get.find<ProfileController>();
  return GestureDetector(
    onTap: () async {
      want == true
          ? pc.expenseScroll.animateTo(
              pc.expenseScroll.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.linear)
          : pc.expenseScroll.animateTo(
              pc.expenseScroll.position.minScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.linear);

      pc.allPayPage.value = Index;

      switch (Index) {
        case 0:
          pc.type.value = '1';
          await pc.fetchAllPayment();
          break;
        case 1:
          pc.type.value = '2';
          await pc.fetchAllPayment();
          break;
        case 2:
          pc.type.value = '4';
          await pc.fetchAllPayment();
          break;
        case 3:
          pc.type.value = '5';
          await pc.fetchAllPayment();
          break;
        default:
      }

      pc.paypg.jumpToPage(
        pc.allPayPage.value,
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
