import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDisabled;

  CustomButton({
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled
          ? null
          : onPressed, // Disable the button if isDisabled is true
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled
            ? Colors.transparent
            : Color(0xFFe6007e), // Background color
        foregroundColor: isDisabled ? Colors.pink : Colors.white, // Text color
        side: BorderSide(
          color: isDisabled ? Colors.pink : Color(0xFFe6007e), // Border color
          width: 3,
        ),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 17.5),
        elevation: 0, // Remove shadow for transparent background
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDisabled
              ? Colors.pink
              : Colors.white, // Text color based on state
          fontFamily: 'VAG-Rounded',
        ),
      ),
    );
  }
}
