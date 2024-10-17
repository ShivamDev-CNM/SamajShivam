import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samajapp/Utils/colors.dart';

class myTextField extends StatelessWidget {
  final String? hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool isEnabled;
  final Widget? pref;
  final Widget? prefixI;
  final TextEditingController? controller;
  final int? maxLength;
  final bool obscureTex;
  final int? maxLine;
  final bool wanttitle;
  final String? labeltxt;

  final void Function(String)? onChanged; // Added onChanged callback

  const myTextField({
    super.key,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.validator,
     this.controller,
    this.maxLength,
    this.pref,
    this.isEnabled = true,
    this.onChanged,
    this.prefixI,
    this.maxLine = 1,
    this.obscureTex = false,
    this.wanttitle = true,
    this.labeltxt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          obscureText: obscureTex,
          onChanged: onChanged,
          style: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w600),
          controller: controller,
          maxLines: maxLine,
          keyboardType: keyboardType,
          validator: validator,
          inputFormatters: maxLength != null
              ? [
                  LengthLimitingTextInputFormatter(maxLength),
                  FilteringTextInputFormatter.digitsOnly
                ]
              : null,
          decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Green, width: 2),
            ),
            prefixIcon: prefixI,
            enabled: isEnabled,
            suffixIcon: pref,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Green, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Green, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            labelText: labeltxt,
            labelStyle: GoogleFonts.dmSans(
                color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
