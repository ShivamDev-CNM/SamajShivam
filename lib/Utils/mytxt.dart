import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeadingTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final bool wanttextAlign;

  const HeadingTextWidget({
    Key? key,
    required this.text,
    required this.fontSize,
    this.wanttextAlign = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: wanttextAlign == true ? TextAlign.left : null,
      style: GoogleFonts.dmSans(
        fontSize: fontSize,
        color: Colors.white,
        fontWeight: FontWeight.w600,
        textStyle: TextStyle(overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class DataText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final bool wanttextAlign;
  final FontWeight fontWeight;
  final bool wantels;

  const DataText({
    Key? key,
    required this.text,
    required this.fontSize,
    this.wanttextAlign = false,
    this.fontWeight = FontWeight.w400,
    this.color = Colors.black,
    this.wantels = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text == "" ? '--' : text,
      textAlign: wanttextAlign == true ? TextAlign.left : null,
      style: GoogleFonts.dmSans(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        textStyle:
            TextStyle(overflow: wantels == true ? TextOverflow.ellipsis : null),
      ),
    );
  }
}
