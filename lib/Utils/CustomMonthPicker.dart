import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:samajapp/Controllers/FundsController.dart';
import 'package:samajapp/Utils/Toast.dart';
import 'package:samajapp/Utils/mytxt.dart';

class CustomMonthPicker extends StatelessWidget {
  FundsController fc = Get.find<FundsController>();

  CustomMonthPicker({
    super.key,
    required this.myFunc,
    required this.selectedDate,
  });

  final Future<void> Function()
      myFunc; // Update type to function returning Future<void>
  final Rx<DateTime> selectedDate;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () async {
          await fc.CommonMonthPicker(selectedDate, myFunc);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.green),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DataText(
                text: DateFormat('MMMM yyyy').format(selectedDate.value),
                fontSize: 15,
              ),
              SizedBox(
                width: 2,
              ),
              Icon(
                Icons.calendar_month_outlined,
                size: 20,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class CustomYearPicker extends StatelessWidget {
  FundsController fc = Get.find<FundsController>();

  CustomYearPicker({
    super.key,
    required this.myFunc,
    required this.selectedDate,
  });

  final Future<void> Function()
      myFunc; // Update type to function returning Future<void>
  final Rx<DateTime> selectedDate;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () async {
          await fc.CommonYearPicker(selectedDate, myFunc);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.green),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DataText(
                text: DateFormat('yyyy').format(selectedDate.value),
                fontSize: 15,
              ),
              SizedBox(
                width: 2,
              ),
              Icon(
                Icons.calendar_month_outlined,
                size: 20,
              ),
            ],
          ),
        ),
      );
    });
  }
}
