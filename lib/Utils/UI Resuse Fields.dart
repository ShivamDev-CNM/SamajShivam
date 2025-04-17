import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/mytxt.dart';

class myPhoneDate extends StatelessWidget {
  const myPhoneDate({super.key, required this.mobile, required this.date});

  final String mobile;
  final String date;

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Row(
      children: [
        SizedBox(
          width: mySize.width / 22,
        ),
        Icon(
          Icons.location_on_outlined,
          size: 12,
          color: Colors.grey,
        ),
        SizedBox(
          width: 3,
        ),
        DataText(
          text: mobile.toString(),
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(
          width: 10,
        ),
        Icon(
          Icons.date_range,
          size: 12,
          color: Colors.grey,
        ),
        SizedBox(
          width: 3,
        ),
        DataText(
          text: DateFormat('dd/MMM/yyyy').format(DateTime.parse(date)),
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        )
      ],
    );
  }
}

class myEventDate extends StatelessWidget {
  const myEventDate({super.key, required this.mobile, required this.date});

  final String mobile;
  final String date;

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Row(
      children: [
        SizedBox(
          width: mySize.width / 22,
        ),
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.festival,
                size: 12,
                color: Colors.grey,
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: DataText(
                  text: mobile.toString(),
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.date_range,
                size: 12,
                color: Colors.grey,
              ),
              SizedBox(
                width: 3,
              ),
              DataText(
                text: DateFormat('dd/MMM/yyyy').format(DateTime.parse(date)),
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              )
            ],
          ),
        )
      ],
    );
  }
}

class fromDateToDate extends StatelessWidget {
  const fromDateToDate({super.key, required this.mobile, required this.date});

  final String mobile;
  final String date;

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Row(
      children: [
        SizedBox(
          width: mySize.width / 22,
        ),
        Icon(
          Icons.date_range,
          size: 12,
          color: Colors.grey,
        ),
        SizedBox(
          width: 3,
        ),
        DataText(
          text: DateFormat('dd/MMM').format(DateTime.parse(date)),
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(
          width: 5,
        ),
        DataText(
          text: '-',
          fontSize: 15,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(
          width: 5,
        ),
        Icon(
          Icons.date_range,
          size: 12,
          color: Colors.grey,
        ),
        SizedBox(
          width: 3,
        ),
        DataText(
          text: DateFormat('dd/MMM').format(DateTime.parse(mobile)),
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        )
      ],
    );
  }
}

class myDate extends StatelessWidget {
  const myDate({super.key, required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Row(
      children: [
        SizedBox(
          width: mySize.width / 22,
        ),
        Icon(
          Icons.date_range,
          size: 12,
          color: Colors.grey,
        ),
        SizedBox(
          width: 3,
        ),
        DataText(
          text: date == "" ? '--' : DateFormat('dd/MMM/yyyy').format(DateTime.parse(date)),
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        )
      ],
    );
  }
}

class FundsRow extends StatelessWidget {
  const FundsRow({super.key, required this.title, required this.data});

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DataText(
          text: title + ' : ',
          fontSize: 18,
          color: Green,
          fontWeight: FontWeight.w500,
        ),
        Expanded(
          child: DataText(
            text: data,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class myDatenPerson extends StatelessWidget {
  const myDatenPerson({super.key, required this.date, required this.person});

  final String date;
  final String person;

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Row(
      children: [
        SizedBox(
          width: mySize.width / 22,
        ),
        Icon(
          Icons.date_range,
          size: 12,
          color: Colors.grey,
        ),
        SizedBox(
          width: 3,
        ),
        DataText(
          text: date == "" ? '--' : DateFormat('dd/MMM/yyyy').format(DateTime.parse(date)),
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(
          width: 10,
        ),
        Icon(
          Icons.person,
          size: 12,
          color: Colors.grey,
        ),
        SizedBox(
          width: 3,
        ),
        DataText(
          text: person.toString(),
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}

class myTypetDate extends StatelessWidget {
  const myTypetDate({super.key, required this.mobile, required this.date});

  final String mobile;
  final String date;

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return Row(
      children: [
        SizedBox(
          width: mySize.width / 22,
        ),
        Icon(
          Icons.festival,
          size: 12,
          color: Colors.grey,
        ),
        SizedBox(
          width: 3,
        ),
        DataText(
          text: mobile.toString(),
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(
          width: 10,
        ),
        Icon(
          Icons.date_range,
          size: 12,
          color: Colors.grey,
        ),
        SizedBox(
          width: 3,
        ),
        DataText(
          text: DateFormat('dd/MMM/yyyy').format(DateTime.parse(date)),
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        )
      ],
    );
  }
}
