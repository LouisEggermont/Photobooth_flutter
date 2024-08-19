import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:photobooth/main.dart';
import 'package:photobooth/provider/backend_config.dart';
import 'package:provider/provider.dart';
import '/widgets/title.dart';
import '/widgets/page_template.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WaitingForImagesPage(),
    );
  }
}

class WaitingForImagesPage extends StatefulWidget {
  const WaitingForImagesPage({super.key});

  @override
  _WaitingForImagesPageState createState() => _WaitingForImagesPageState();
}

class _WaitingForImagesPageState extends State<WaitingForImagesPage> {
  final List<String> stringList = [
    "4 MCT students made this photobooth: Benoît, Hube, Louis, Roel.",
    "Only two different AI-models were used to create your masterpiece.",
    // Additional facts here...
    "The first photobooth was invented in 1925 by a Russian and was called 'Photomaton'."
  ];

  String randomString = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _displayRandomString();
    _checkStatus();
    _startRandomStringTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _displayRandomString() {
    setState(() {
      randomString = (stringList..shuffle()).first;
    });
  }

  void _startRandomStringTimer() {
    _timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      _displayRandomString();
    });
  }

  Future<void> _checkStatus() async {
    try {
      String backendUrl =
          Provider.of<BackendConfig>(context, listen: false).backendUrl;
      final response = await http.get(Uri.parse('$backendUrl/check_status'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Data: $data");
        if (data['isDone'] == true) {
          Navigator.pushReplacementNamed(context, '/picture');
        } else {
          Future.delayed(const Duration(seconds: 5), _checkStatus);
        }
      } else {
        Future.delayed(const Duration(seconds: 5), _checkStatus);
      }
    } catch (e) {
      Future.delayed(const Duration(seconds: 5), _checkStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsivePageTemplate(
      title: const CustomTitle(
        mainText: '',
        subText: '',
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/loading_animation.json',
            width: 300.w,
            // height: 200.h,
            fit: BoxFit.fill,
          ),
          SizedBox(height: 20.h),
          Text(
            'Did you know?',
            style: TextStyle(
              fontSize: 52.sp,
              fontWeight: FontWeight.bold,
              fontFamily: "VAG-Rounded",
              color: howestWhite,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            randomString,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 31.sp,
              fontFamily: "OpenSans",
              color: howestWhite,
            ),
          ),
        ],
      ),
      footer: const SizedBox.shrink(), // No footer needed for this page
    );
  }
}
