import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samajapp/Utils/colors.dart';

InputDecoration myInputDecoration5({String? hintText}) {
  return InputDecoration(
    constraints: BoxConstraints(maxHeight: 40),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 5,
      vertical: 5,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Green, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Green, width: 2),
    ),
    filled: true,
    fillColor: Colors.white,
    labelStyle: GoogleFonts.dmSans(
        color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),
    labelText: hintText,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Green, width: 2),
    ),
  );
}

InputDecoration myInputDecoration({String? hintText}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 5,
      vertical: 5,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Green, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Green, width: 2),
    ),
    filled: true,
    fillColor: Colors.white,
    labelStyle: GoogleFonts.dmSans(
        color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),
    labelText: hintText,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Green, width: 2),
    ),
  );
}
