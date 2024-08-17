import 'package:flutter/material.dart';

class ProgressSteps extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const ProgressSteps({
    Key? key,
    required this.totalSteps,
    required this.currentStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isOdd) {
          // Add a line between steps
          return Container(
            width: 25,
            height: 4,
            color: Colors.white.withOpacity(0.6),
          );
        } else {
          int stepIndex = index ~/ 2 + 1;
          bool isCompleted = stepIndex <= currentStep;

          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? Colors.white : Colors.transparent,
              border: isCompleted
                  ? Border.all(color: Color(0xFF44C8F5), width: 3)
                  : Border.all(color: Colors.white, width: 3),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: isCompleted ? Colors.white : Colors.transparent,
              child: Text(
                '$stepIndex',
                style: TextStyle(
                  color: isCompleted ? Color(0xFF44C8F5) : Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
