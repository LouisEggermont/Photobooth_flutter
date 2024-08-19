import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextInputType? keyboardType;

  CustomTextFormField({
    required this.labelText,
    this.validator,
    this.onSaved,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black,
          fontFamily: "OpenSans",
          fontSize: 28.sp, // Scaled font size for label, smaller than input
        ),
        filled: true,
        fillColor: Colors.white,
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(60.r), // Scaled border radius
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 20.h, // Increased vertical padding for larger input area
          horizontal: 35.w, // Standard horizontal padding
        ),
        isDense: true, // Reduces the space between the label and input
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: 20.sp, // Increased font size for the error text
        ),
      ),
      style: TextStyle(
        fontSize: 31.sp, // Larger font size for the input text
      ),
      validator: validator,
      onSaved: onSaved,
      keyboardType: keyboardType,
    );
  }
}
