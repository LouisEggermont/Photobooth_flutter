import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String mainText;
  final String subText;

  CustomTitle({required this.mainText, required this.subText});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.rotate(
        angle: -0.05,
        child: SizedBox(
          height:
              150, // Define height to ensure both containers fit within the stack
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Color(0xFFe6007e),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(4, 4),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  mainText,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'VAG-Rounded',
                  ),
                ),
              ),
              if (subText.isNotEmpty)
                Positioned(
                  top: 97.5, // Adjust this value to control the overlap
                  right: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFFffff00),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(4, 4),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      subText,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'VAG-Rounded',
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
