import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:photobooth/provider/backend_config.dart';
import 'package:photobooth/widgets/error_dialog.dart';
import 'package:photobooth/widgets/page_template.dart';
import 'package:provider/provider.dart';
import '../widgets/title.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SentPage extends StatefulWidget {
  final List<String> selectedImageUrls;

  const SentPage({super.key, required this.selectedImageUrls});

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
      String backendUrl =
          Provider.of<BackendConfig>(context, listen: false).backendUrl;
      final response = await http.post(
        Uri.parse('$backendUrl/send_email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'selected_image_urls': widget.selectedImageUrls}),
      );

      if (response.statusCode == 200) {
        setState(() {
          isSuccessful = true;
        });
        await Future.delayed(const Duration(
            seconds: 5)); // Short delay to show success animation

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
    return ResponsivePageTemplate(
      title: _buildTitle(),
      content: _buildContent(),
      footer:
          const SizedBox(), // No footer needed for this page, leaving it empty
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        CustomTitle(
          mainText: isSuccessful ? 'Images are sent!' : '',
          subText: isSuccessful ? 'Thank you and enjoy!' : '',
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Center(
      child: isSuccessful
          ? Lottie.asset(
              'assets/sent_animation.json',
              width: 800.w,
              // height: 200.h,
              fit: BoxFit.fill,
              repeat: false,
            )
          : Lottie.asset(
              'assets/loading_animation.json',
              width: 200.w,
              // height: 200.h,
              fit: BoxFit.fill,
            ), // Show loading spinner while waiting
    );
  }
}
