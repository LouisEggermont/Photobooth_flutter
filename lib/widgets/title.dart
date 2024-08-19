import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTitle extends StatelessWidget {
  final String mainText;
  final String subText;
  final double leftOffset;
  final double scaleFactor;

  const CustomTitle({
    required this.mainText,
    required this.subText,
    this.leftOffset = 190.0,
    this.scaleFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    // If mainText is empty, return an empty SizedBox (no rendering)
    if (mainText.isEmpty) {
      return SizedBox.shrink();
    }

    return Transform.rotate(
      angle: -0.05,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Title (Pink Box)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 22.w * scaleFactor,
              vertical: 6.h * scaleFactor,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFe6007e),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(4.w, 4.h),
                  blurRadius: 4.r,
                ),
              ],
            ),
            child: Text(
              mainText,
              style: TextStyle(
                fontSize: 99.sp * scaleFactor,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'VAG-Rounded',
              ),
            ),
          ),
          // Conditionally render the Subtitle (Yellow Box)
          if (subText.isNotEmpty)
            Positioned(
              top: 140.w * scaleFactor,
              left: leftOffset.w * scaleFactor,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w * scaleFactor,
                  vertical: 6.h * scaleFactor,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFFFFF00),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(4.w, 4.h),
                      blurRadius: 4.r,
                    ),
                  ],
                ),
                child: Text(
                  subText,
                  style: TextStyle(
                    fontSize: 62.sp * scaleFactor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.sp * scaleFactor,
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
