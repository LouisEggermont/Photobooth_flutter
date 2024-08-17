import 'package:flutter/material.dart';

class CustomCameraButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  CustomCameraButton({
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF44C8F5), // Background color
        shape: BoxShape.circle, // Make the button circular
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white, // Icon color
          size: 30, // Adjust icon size if needed
        ),
        padding:
            EdgeInsets.all(20), // Adjust padding to make the button circular
        splashRadius: 30, // Adjust splash radius if needed
      ),
    );
  }
}
