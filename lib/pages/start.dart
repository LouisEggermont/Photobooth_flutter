import 'package:flutter/material.dart';
import '/widgets/title.dart';
import '/widgets/button.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Make sure the container takes full width
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Adjust padding as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // CustomTitle at the top
              CustomTitle(
                mainText: 'Snap, Share, Shine',
                subText: 'Your Story Starts Here!',
              ),
              // Center image (optional)
              // If you have an image to display, uncomment and adjust as needed
              Image.asset(
                'assets/spaceman.png', // Make sure the image is added in pubspec.yaml
                // width: 200,
                height: 400,
              ),
              // SizedBox(height: 20),
              Spacer(), // Pushes the button to the bottom
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0), // Adjust bottom padding
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 20.0), // Adjust right padding
                    child: CustomButton(
                      text: 'Start',
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/camera');
                      },
                      isDisabled:
                          false, // Set to true or false based on your needs
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
