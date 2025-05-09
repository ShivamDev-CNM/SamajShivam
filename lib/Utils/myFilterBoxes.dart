import 'package:flutter/material.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/mytxt.dart';

class myFilterBoxes extends StatelessWidget {
  const myFilterBoxes(
      {super.key,
      required this.title,
      required this.onTap,
      required this.value});

  final String title;
  final VoidCallback onTap;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minWidth: 80),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        decoration: BoxDecoration(boxShadow: [
          value == true
              ? BoxShadow(
                  color: Colors.black54,
                  blurRadius: 3,
            spreadRadius: 0.1
                )
              : BoxShadow()
        ], color: Green, borderRadius: BorderRadius.circular(10)),
        child: Row(mainAxisAlignment: MainAxisAlignment.start,
          children: [
            value == true
                ? Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 20,
                  )
                : SizedBox(),
            SizedBox(width: 5,),
            Expanded(
              child: DataText(
                text: title,
                fontSize: 15,wantels: true,
                color: Colors.white,
                fontWeight: value == true ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
