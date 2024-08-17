import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:lottie/lottie.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WaitingForImagesPage(),
    );
  }
}

class WaitingForImagesPage extends StatefulWidget {
  @override
  _WaitingForImagesPageState createState() => _WaitingForImagesPageState();
}

class _WaitingForImagesPageState extends State<WaitingForImagesPage> {
  final List<String> stringList = [
    "4 MCT students made this photobooth: Benoît, Hube, Louis, Roel.",
    "Only two different AI-models were used to create your masterpiece.",
    "We use the AI-model 'Stable diffusion faceId' as the text-to-picture to create the masterpiece with your face.",
    "We use the AI-model 'Stable diffusion upscale'.",
    "We use a Raspberry Pi 4b as a minicomputer to control the Led strips and the interface you are on.",
    "We used 5 programming languages to develop this.",
    "Our project is cloud-based: the pictures are saved, and the two AI-models are used in the cloud.",
    "There were 500+ 'saftjes' rolled to make this project.",
    "This project was tested 200+ times to perfect the user experience and functionality.",
    "We use state-of-the-art AI models to guarantee good and fast results.",
    "AI has been around for decades; the concept existed around the 1950s.",
    "AI is already around us; it has become part of our life.",
    "AI can be used for everything, from making little jokes to diagnosing diseases.",
    "An AI uses on average 6.79Wh on solving a query, that is like running a 5W led bulb for 1hr 20min.",
    "Small AI models take a few hours or a couple of days to train fully.",
    "Large, state-of-the-art AI models take several weeks or even months to train fully.",
    "AI can help predict certain events, like natural disasters, road accidents …",
    "Ethics in the world of AI remains a hot topic not only between active members in the field but also in the global community at large.",
    "In 2020, Elon Musk predicted that AI would overtake humans and grow more intelligent than our species by 2025. Are they? Will they?",
    "Google-owned AI 'DeepMind' can beat most 'Starcraft 2' players and compete with the best.",
    "Because of concerns over data privacy, the EU has created a draft of ethical guidelines for AI.",
    "Deep Blue was the first AI robot, made in 1996. It was a chess-playing computer which won its first game against a World Champion in February 1996.",
    "Experts believe that AI will take over 16% of current jobs within the next 10 years, but worry not, a new era of job opportunities will arise.",
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
    _timer = Timer.periodic(Duration(seconds: 7), (timer) {
      _displayRandomString();
    });
  }

  Future<void> _checkStatus() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.0.177:2000/check_status'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['isDone'] == true) {
          Navigator.pushReplacementNamed(context, '/picture');
        } else {
          Future.delayed(Duration(seconds: 5), _checkStatus);
        }
      } else {
        Future.delayed(Duration(seconds: 5), _checkStatus);
      }
    } catch (e) {
      Future.delayed(Duration(seconds: 5), _checkStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/loading_animation.json',
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 20),
            Text(
              'Did you know?',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: "OpenSans"),
            ),
            SizedBox(height: 10),
            Text(
              randomString,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontFamily: "OpenSans"),
            ),
          ],
        ),
      ),
    );
  }
}
