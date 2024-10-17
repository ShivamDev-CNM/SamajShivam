import 'package:flutter/material.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/mytxt.dart';


class StaticField extends StatelessWidget {
  StaticField({super.key, required this.title, required this.Data, this.icon});

  final String title;
  final String Data;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Green,width: 2)),
            child: Row(
              children: [
                Expanded(
                    child:
                    DataText(text: Data == "" ? '--' : Data, fontSize: 18,)),
                Icon(icon,color: Colors.grey,)
              ],
            )),
        SizedBox(
          height: 5,
        )
      ],
    );
  }
}
