import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:photobooth/widgets/camera_button.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:photobooth/widgets/title.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  XFile? picture;
  bool isCountdown = false;
  bool isPictureTaken = false;
  int countdown = 5;

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (cameraController == null ||
  //       cameraController?.value.isInitialized == false) {
  //     return;
  //   }

  //   if (state == AppLifecycleState.inactive) {
  //     cameraController?.dispose();
  //   } else if (state == AppLifecycleState.resumed) {
  //     _setupCameraController();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isPictureTaken ? _buildPicturePreview() : _buildCameraPreview(),
    );
  }

  Widget _buildCameraPreview() {
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
            width: size.width,
            height: size.height,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Container(
                  width: 500, // the actual width is not important here
                  child: CameraPreview(cameraController!)),
            )),
        // Add CustomTitle at the top
        Positioned(
          top: 40, // Adjust the position as needed
          left: 20,
          right: 20,
          child: CustomTitle(
            mainText: 'Take a Picture',
            subText: 'You get a 5 second countdown',
          ),
        ),
        // Positioned.fill(
        //   child: Center(
        //     child: SvgPicture.asset(
        //       'assets/head_guide.svg', // Path to your SVG file
        //       width: 1000, // Adjust the size as needed
        //       height: 1000,
        //       fit: BoxFit.contain,
        //       color: Colors.white.withOpacity(0.5),
        //     ),
        //   ),
        // ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: CustomCameraButton(
              onPressed: takePicture,
              icon: Icons.photo_camera,
            ),
          ),
        ),
        if (isCountdown)
          Center(
            child: Text(
              countdown.toString(),
              style: TextStyle(
                  fontSize: 100,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'VAG-Rounded'),
            ),
          ),
      ],
    );
  }

  Widget _buildPicturePreview() {
    return Stack(
      children: [
        if (picture != null)
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..scale(-1.0, 1.0, 1.0), // Mirror the image horizontally
            child: Image.file(
              File(picture!.path),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        Positioned(
          top: 40, // Adjust the position as needed
          left: 20,
          right: 20,
          child: CustomTitle(
            mainText: 'You like it?',
            subText: 'You can retake or move on',
          ),
        ),
        Positioned(
            bottom: 20,
            left: 20,
            child: CustomCameraButton(
              onPressed: retakePicture,
              icon: Icons.refresh,
            )
            // ElevatedButton(
            //   onPressed: retakePicture,
            //   child: const Text('Retake'),
            // ),
            ),
        Positioned(
          bottom: 20,
          right: 20,
          child: CustomCameraButton(
              onPressed: () {
                sendPictureToApi(picture!.path);
                Navigator.pushReplacementNamed(context, '/prompt');
              },
              icon: Icons.done),
        ),
      ],
    );
  }

  Future<void> _setupCameraController() async {
    List<CameraDescription> _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      setState(() {
        cameras = _cameras;
        cameraController = CameraController(
          _cameras.last,
          ResolutionPreset.high,
        );
      });
      cameraController?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((Object e) {
        print(e);
      });
    }
  }

  Future<void> takePicture() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      isCountdown = true;
      countdown = 5;
    });

    for (int i = 4; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        countdown = i;
      });
    }

    setState(() {
      isCountdown = false;
    });

    picture = await cameraController!.takePicture();
    setState(() {
      isPictureTaken = true;
    });
  }

  void retakePicture() {
    setState(() {
      isPictureTaken = false;
    });
  }

  // Future<void> sendPictureToApi(String path) async {
  //   var request = http.MultipartRequest('POST', Uri.parse('YOUR_API_ENDPOINT'));
  //   request.files.add(await http.MultipartFile.fromPath('picture', path));
  //   var response = await request.send();

  //   if (response.statusCode == 200) {
  //     print('Picture sent successfully');
  //     // Navigate to the next screen
  //   } else {
  //     print('Failed to send picture');
  //   }
  // }

  Future<void> sendPictureToApi(String path) async {
    // Read the image file
    File imageFile = File(path);
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    // Create the JSON payload
    var payload = jsonEncode({'image': 'data:image/png;base64,$base64Image'});

    // Send the request
    var response = await http.post(
      Uri.parse('http://192.168.0.177:2000/save_image'),
      headers: {'Content-Type': 'application/json'},
      body: payload,
    );

    if (response.statusCode == 200) {
      print('Picture sent successfully');
      // Navigate to the next screen
    } else {
      print('Failed to send picture');
    }
  }
}
