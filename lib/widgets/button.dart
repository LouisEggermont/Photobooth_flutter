import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDisabled;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ElevatedButton(
        onPressed: isDisabled
            ? null
            : onPressed, // Disable the button if isDisabled is true
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? Colors.transparent
              : const Color(0xFFe6007e), // Background color
          foregroundColor:
              isDisabled ? Colors.pink : Colors.white, // Text color
          side: BorderSide(
            color: isDisabled
                ? Colors.pink
                : const Color(0xFFe6007e), // Border color
            width: 3.w, // Scaled width
          ),
          padding: EdgeInsets.symmetric(
              horizontal: 60.w, vertical: 15.h), // Scaled padding
          elevation: 0, // Remove shadow for transparent background
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 60.sp, // Scaled font size
            fontWeight: FontWeight.bold,
            color: isDisabled
                ? Colors.pink
                : Colors.white, // Text color based on state
            fontFamily: 'VAG-Rounded',
          ),
        ),
      ),
    );
  }
}
