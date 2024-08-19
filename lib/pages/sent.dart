import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:photobooth/widgets/error_dialog.dart';
import 'dart:convert';

import '../widgets/title.dart';

class SentPage extends StatefulWidget {
  final List<String> selectedImageUrls;

  const SentPage({Key? key, required this.selectedImageUrls}) : super(key: key);

  @override
  _SentPageState createState() => _SentPageState();
}

class _SentPageState extends State<SentPage> {
  bool isSuccessful = false;

  @override
  void initState() {
    super.initState();
    _sendRequest();
  }

  Future<void> _sendRequest() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.177:2000/send_email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'selected_image_urls': widget.selectedImageUrls}),
      );

      if (response.statusCode == 200) {
        setState(() {
          isSuccessful = true;
        });
        await Future.delayed(
            Duration(seconds: 2)); // Short delay to show success animation

        // Optionally navigate to another page or pop back to the previous one
        Navigator.pushReplacementNamed(context, '/start');
      } else {
        ErrorDialog.show(
          context,
          'Failed to send images. Please try again.',
          onRetry: _sendRequest, // Retry logic
        );
      }
    } catch (e) {
      ErrorDialog.show(
        context,
        'Error: $e',
        onRetry: _sendRequest, // Retry logic
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isSuccessful
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTitle(
                    mainText: 'Images are sent!',
                    subText: 'Thank you and enjoy!',
                  ),
                  Lottie.asset('assets/sent_animation.json',
                      width: 200, height: 200, fit: BoxFit.fill, repeat: false),
                ],
              )
            : Lottie.asset(
                'assets/loading_animation.json',
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              ), // Show loading spinner while waiting
      ),
    );
  }
}
