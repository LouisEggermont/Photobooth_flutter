import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photobooth/main.dart';

class CustomCameraButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const CustomCameraButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: howestBlue, // Background color
        shape: BoxShape.circle, // Make the button circular
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: howestWhite, // Icon color
          size: 100.sp, // Scaled icon size
        ),
        padding:
            EdgeInsets.all(30.w), // Scaled padding to make the button circular
        splashRadius: 30.r, // Scaled splash radius
      ),
    );
  }
}
