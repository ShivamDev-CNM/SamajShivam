import 'package:flutter/material.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/mytxt.dart';

class myButton extends StatelessWidget {
  const myButton(
      {super.key,
      required this.text,
      required this.Condition,
      required this.function});

  final String text;
  final bool Condition;
  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    var mySize = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 50,
        width: mySize.width / 1.2,
        decoration: BoxDecoration(
          border: Border.all(color: Green),
          color: Condition == true ? Colors.white : Green,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
            child: DataText(
          text: text,
          fontSize: 20,
          color: Condition == true ? Green : Colors.white,
          fontWeight: FontWeight.w800,
        )),
      ),
    );
  }
}
