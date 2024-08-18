import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTitle extends StatelessWidget {
  final String mainText;
  final String subText;
  final double leftOffset; // Parameter for left offset
  final double scaleFactor; // New parameter for scaling the title

  const CustomTitle({
    required this.mainText,
    required this.subText,
    this.leftOffset = 190.0, // Default value for the left offset
    this.scaleFactor = 1.0, // Default scale factor
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.05, // Rotate the title slightly
      child: Stack(
        clipBehavior: Clip
            .none, // Allows the subtitle to overflow and stack above the main title
        children: [
          // Main Title (Pink Box)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 22.w * scaleFactor, // Scaled padding with factor
              vertical: 6.h * scaleFactor, // Scaled padding with factor
            ),
            decoration: BoxDecoration(
              color: Color(0xFFe6007e), // Background color for the main text
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(4.w, 4.h), // Scaled shadow offset
                  blurRadius: 4.r, // Scaled blur radius
                ),
              ],
            ),
            child: Text(
              mainText,
              style: TextStyle(
                fontSize: 99.sp * scaleFactor, // Scaled font size with factor
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'VAG-Rounded',
              ),
            ),
          ),
          // Conditionally render the Subtitle (Yellow Box)
          if (subText.isNotEmpty)
            Positioned(
              top: 140.w * scaleFactor, // Scaled top position with factor
              left: leftOffset.w *
                  scaleFactor, // Scaled left position with factor
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w * scaleFactor, // Scaled padding with factor
                  vertical: 6.h * scaleFactor, // Scaled padding with factor
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFFFFF00), // Background color for the subtext
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(4.w, 4.h), // Scaled shadow offset
                      blurRadius: 4.r, // Scaled blur radius
                    ),
                  ],
                ),
                child: Text(
                  subText,
                  style: TextStyle(
                    fontSize:
                        62.sp * scaleFactor, // Scaled font size with factor
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.sp * scaleFactor, // Scaled letter spacing
                    color: Colors.black,
                    fontFamily: 'VAG-Rounded',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
