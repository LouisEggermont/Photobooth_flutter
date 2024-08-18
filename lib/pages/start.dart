import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg package
import '/widgets/title.dart';
import '/widgets/button.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _verticalAnimation;
  late Animation<double> _horizontalAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5), // Duration for one full loop
    )..repeat(reverse: true); // Repeat the animation back and forth

    // Define the vertical animation (up and down)
    _verticalAnimation = Tween<double>(begin: 0.0, end: 30.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Define the horizontal animation (left and right)
    _horizontalAnimation = Tween<double>(begin: 0.0, end: 15.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Define the rotation animation (slight tilt)
    _rotationAnimation = Tween<double>(begin: -0.02, end: 0.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when not in use
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Ensure the container takes full width
        height: double.infinity, // Ensure the container takes full height
        child: Stack(
          alignment: Alignment.center, // Aligns children in the center
          children: [
            // Background Image
            Positioned.fill(
              child: SvgPicture.asset(
                  'assets/start_bg.svg', // Path to your SVG file
                  fit: BoxFit.cover),
            ),
            // Animated Spaceman Image
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Positioned(
                  top: 120.h +
                      _verticalAnimation.value, // Adjusted vertical position
                  left: MediaQuery.of(context).size.width / 2 -
                      550.w +
                      _horizontalAnimation
                          .value, // Adjusted horizontal position
                  child: Transform.rotate(
                    angle: _rotationAnimation.value, // Rotational movement
                    child: Image.asset(
                      'assets/spaceman.png', // Make sure the image path is correct
                      height: 1300.h, // Increased height for the image
                      width: 1100.w, // Increased width for the image
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
            // Title
            Positioned(
              top: 120.h,
              child: CustomTitle(
                mainText: 'Snap, Share, Shine',
                subText: 'Your Story Starts Here!',
              ),
            ),
            // Start Button
            Positioned(
              bottom: 50.h, // Adjust this value as needed
              right: 50.w, // Align to the bottom right
              child: CustomButton(
                text: 'Start',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/camera');
                },
                isDisabled: false, // Enable or disable based on your needs
              ),
            ),
          ],
        ),
      ),
    );
  }
}
