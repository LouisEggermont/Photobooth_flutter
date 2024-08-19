import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photobooth/main.dart';

class ProgressSteps extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const ProgressSteps({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Line
        Container(
          height: 10.h, // Same height as the connecting lines
          width: (totalSteps - 1) * 110.w + 70.w, // Adjust width based on steps
          color: howestWhite.withOpacity(0.6),
        ),
        // Steps
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalSteps, (index) {
            bool isCompleted = index < currentStep;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 27.5.w),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? howestWhite : howestBlue,
                  border: Border.all(
                    color: howestWhite, // Border color for all steps
                    width: 6.w, // Scaled border width
                  ),
                ),
                child: CircleAvatar(
                  radius: 35.r, // Scaled radius
                  backgroundColor:
                      isCompleted ? howestWhite : Colors.transparent,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                        color: isCompleted ? howestBlue : howestWhite,
                        fontSize: 50.sp, // Scaled font size
                        fontWeight: FontWeight.bold, // Match font weight
                        fontFamily: 'VAG-Rounded'),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
