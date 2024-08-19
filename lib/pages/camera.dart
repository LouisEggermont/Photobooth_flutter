import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:photobooth/widgets/camera_button.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photobooth/widgets/error_dialog.dart';
import 'package:photobooth/widgets/progress_steps.dart';
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

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
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
        // Camera Preview
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
          top: 120.h,
          left: 90.w,
          child: CustomTitle(
            mainText: 'Take a Picture',
            subText: 'You get a 5 second countdown',
            leftOffset: 100,
            scaleFactor: .9,
          ),
        ),
        // Add head guide as an outline
        Positioned(
          top: -250.h,
          left: -200.w,
          right: -200.w,
          child: Center(
            child: SvgPicture.string(
              color: Colors.white.withOpacity(0.5), // Set the outline color
              '''
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 567.08 420.93">
                <path fill="none" stroke="#fff" stroke-linecap="round" stroke-miterlimit="10" stroke-width="5px" d="M564.58,418.43c-.37-3.13-1.5-7.23-3.2-12.6-7.79-24.64-25.65-40.15-47.54-51.87-21.19-11.34-44.48-16.55-67.44-22.61-26.96-7.12-54.21-13.14-80.77-21.68-5.17-1.66-11.96-2.04-13.29-9.11-2.17-11.47-4.98-23.03,3.92-33.44,3.92-4.59,6.05-10.4,7.81-16.19,3.42-11.22,6.64-22.49,10.08-33.7.9-2.94,1.19-6.78,4.92-7.57,10.76-2.28,12.7-11.09,15.4-19.64,3.39-10.71,4.45-21.8,4.66-32.84.16-8.3.97-17.98-8.18-22.8-4.37-2.3-4.76-4.82-4.54-8.96.72-13.26,2.22-26.56.33-39.83-2.47-17.42-4.72-35.01-23.26-44.01-1.28-.62-2.42-2.12-3.02-3.48-7.15-16.17-21.05-23.99-36.68-29.43-21.51-7.48-43.69-7.41-65.73-3.77-22.32,3.69-41.94,12.5-52.84,34.32-.64,1.29-2.14,2.38-3.49,3.04-11.01,5.38-15.8,15.22-18.62,26.25-4.27,16.73-5.52,33.68-3.3,50.92.6,4.64,3.26,10.56-2.68,13.78-7.91,4.29-9.49,11.44-9.72,19.28-.46,15.7,2.14,30.94,7.67,45.65,1.59,4.24,3.57,8.62,8.23,9.85,6.64,1.75,8.37,6.58,10.16,12.3,5.65,18.04,9.15,36.72,20.71,52.75,8.56,11.86-.97,34.52-15,38.19-28.51,7.46-57.17,14.34-85.67,21.86-28.52,7.53-57.21,14.84-80.86,34.01-16.39,13.29-27.02,29.92-30.12,51.15,0,.07-.01.12-.02.19"/>
              </svg>
              ''', // SVG content as a string
              height:
                  MediaQuery.of(context).size.height * 1.5, // Scale the height
              fit: BoxFit.contain,
            ),
          ),
        ),
        // Camera Button
        Positioned(
          bottom: 150.h,
          left: 0,
          right: 0,
          child: Center(
            child: CustomCameraButton(
              onPressed: takePicture,
              icon: Icons.photo_camera,
            ),
          ),
        ),
        // Countdown Display
        if (isCountdown)
          Center(
            child: Text(
              countdown.toString(),
              style: TextStyle(
                fontSize: 300.sp,
                color: Colors.white.withOpacity(0.75),
                fontWeight: FontWeight.bold,
                fontFamily: 'VAG-Rounded',
              ),
            ),
          ),
        Positioned(
          bottom: 35.h, // Adjust the bottom position as needed
          left: 0,
          right: 0,
          child: ProgressSteps(
            totalSteps: 4,
            currentStep: 1, // Adjust the current step as necessary
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
          top: 120.h, // Adjust the position as needed
          left: 120.w,
          child: CustomTitle(
            mainText: 'You like it?',
            subText: 'You can retake or move on',
            leftOffset: 60,
            // scaleFactor: .9,
          ),
        ),
        Positioned(
          bottom: 150.h,
          left: 350.w,
          child: CustomCameraButton(
            onPressed: retakePicture,
            icon: Icons.refresh,
          ),
        ),
        Positioned(
          bottom: 150.h,
          right: 350.w,
          child: CustomCameraButton(
            onPressed: () {
              sendPictureToApi(picture!.path);
              // Navigator.pushReplacementNamed(context, '/prompt');
            },
            icon: Icons.done,
          ),
        ),
        Positioned(
          bottom: 35.h, // Adjust the bottom position as needed
          left: 0,
          right: 0,
          child: ProgressSteps(
            totalSteps: 4,
            currentStep: 2, // Adjust the current step as necessary
          ),
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
  //   File imageFile = File(path);
  //   List<int> imageBytes = await imageFile.readAsBytes();
  //   String base64Image = base64Encode(imageBytes);

  //   var payload = jsonEncode({'image': 'data:image/png;base64,$base64Image'});

  //   var response = await http.post(
  //     Uri.parse('http://192.168.0.177:2000/save_image'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: payload,
  //   );

  //   if (response.statusCode == 200) {
  //     print('Picture sent successfully');
  //   } else {
  //     print('Failed to send picture');
  //   }
  // }

  Future<void> sendPictureToApi(String path) async {
    try {
      File imageFile = File(path);
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      var payload = jsonEncode({'image': 'data:image/png;base64,$base64Image'});

      var response = await http.post(
        Uri.parse('http://192.168.0.177:2000/save_image'),
        headers: {'Content-Type': 'application/json'},
        body: payload,
      );

      if (response.statusCode == 200) {
        print('Picture sent successfully');
        Navigator.pushReplacementNamed(context, '/prompt');
      } else {
        ErrorDialog.show(
          context,
          'Failed to send picture. Please try again.',
          onRetry: () => sendPictureToApi(path), // Retry logic
        );
      }
    } catch (e) {
      ErrorDialog.show(
        context,
        'Error sending picture: $e',
        onRetry: () => sendPictureToApi(path), // Retry logic
      );
    }
  }
}
