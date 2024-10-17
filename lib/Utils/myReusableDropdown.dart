import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samajapp/Utils/myInputDecoration.dart';

class ReusableDropdownSearch extends StatelessWidget {
  String? selectedItem;
  final List<String> myList;
  final String? Function(dynamic)? validator;
  final String searchHint;
  final void Function(String?)? onChanged;
  final String dropHint;
  final VoidCallback OnTap;
  final bool visible;
  final bool want4;

  TextEditingController ss = TextEditingController();

  ReusableDropdownSearch({
    this.selectedItem,
    this.validator,
    this.onChanged,
    required this.myList,
    required this.searchHint,
    required this.dropHint,
    required this.OnTap,
    this.visible = false,
    this.want4 = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownSearch<String>(
          dropdownDecoratorProps: DropDownDecoratorProps(
              baseStyle: GoogleFonts.dmSans(
                  fontSize: 16,
                  color: Colors.black,
                  textStyle: TextStyle(overflow: TextOverflow.ellipsis)),
              dropdownSearchDecoration: want4 == true
                  ? myInputDecoration5(hintText: dropHint)
                  : myInputDecoration(hintText: dropHint)),
          selectedItem: selectedItem,
          popupProps: PopupProps<String>.menu(
            searchFieldProps: TextFieldProps(
              controller: ss,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.close)),
                border: OutlineInputBorder(),
                hintText: searchHint,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              ),
            ),
            showSearchBox: true,
            menuProps: MenuProps(
              backgroundColor: Colors.white,
            ),
          ),
          onChanged: onChanged,
          itemAsString: (val) {
            return val;
          },
          clearButtonProps: ClearButtonProps(
              icon: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
              ),
              isVisible: visible,
              onPressed: OnTap),
          items: myList,
          // itemAsString: (item) => item,
          validator: validator != null
              ? (val) {
                  if (val == null || val.isEmpty) {
                    return 'This field is required';
                  }
                  return validator!(val);
                }
              : null,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
