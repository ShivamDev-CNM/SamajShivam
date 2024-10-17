import 'package:flutter/material.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/mytxt.dart';

class CustomAlert extends StatelessWidget {
  final String title;
  final String content;
  final String positiveText;
  final String negativeText;
  final double height;
  final Function()? onCancel;
  final Function()? onConfirm;

  const CustomAlert({
    Key? key,
    required this.title,
    required this.content,
    this.onCancel,
    this.onConfirm,
    required this.positiveText,
    required this.negativeText,
    this.height = 5.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      contentPadding: const EdgeInsets.all(15),
      content: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              DataText(
                text: title,
                fontSize: 20,
                wantels: false,
                fontWeight: FontWeight.w600,
              ),
              DataText(
                text: content,
                fontSize: 14,
                wantels: false,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onCancel ??
                        () {
                          Navigator.pop(context);
                        },
                    child: Text(
                      negativeText.toString(),
                      style: const TextStyle(
                        color: Green,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.red)),
                    onPressed: onConfirm ?? () {},
                    child: Text(
                      positiveText,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
