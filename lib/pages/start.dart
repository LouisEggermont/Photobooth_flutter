import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/widgets/title.dart';
import '/widgets/button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/widgets/error_dialog.dart'; // Import the ErrorDialog widget

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
  bool isCheckingHealth = false; // To show loading state

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat(reverse: true);

    _verticalAnimation = Tween<double>(begin: 0.0, end: 30.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _horizontalAnimation = Tween<double>(begin: 0.0, end: 15.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: -0.02, end: 0.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  Future<void> _checkBackendHealth() async {
    setState(() {
      isCheckingHealth = true; // Start checking
    });

    try {
      final response = await http
          .get(Uri.parse('http://192.168.0.177:2000/health'))
          .timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'healthy') {
          Navigator.pushReplacementNamed(context, '/camera');
        } else {
          _showErrorDialog('Backend is not healthy.');
        }
      } else {
        _showErrorDialog('Failed to check backend health.');
      }
    } catch (e) {
      _showErrorDialog('Error: Could not connect to backend.');
    } finally {
      setState(() {
        isCheckingHealth = false; // Done checking
      });
    }
  }

  void _showErrorDialog(String message) {
    ErrorDialog.show(
      context,
      message,
      onRetry: _checkBackendHealth, // Retry the health check
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          _buildStartPageContent(),
          if (isCheckingHealth)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildStartPageContent() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: SvgPicture.asset('assets/start_bg.svg', fit: BoxFit.cover),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: 120.h + _verticalAnimation.value,
                left: MediaQuery.of(context).size.width / 2 -
                    550.w +
                    _horizontalAnimation.value,
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Image.asset(
                    'assets/spaceman.png',
                    height: 1300.h,
                    width: 1100.w,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 120.h,
            child: CustomTitle(
              mainText: 'Snap, Share, Shine',
              subText: 'Your Story Starts Here!',
            ),
          ),
          Positioned(
            bottom: 50.h,
            right: 50.w,
            child: CustomButton(
              text: 'Start',
              onPressed: () => _checkBackendHealth(),
            ),
          ),
        ],
      ),
    );
  }
}
