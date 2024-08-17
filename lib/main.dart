import 'package:flutter/material.dart';

// Pages
import 'pages/start.dart';
import 'pages/camera.dart';
import 'pages/prompt.dart';
import 'pages/form.dart';
import 'pages/picture.dart';
import 'pages/waiting.dart';
// import 'pages/sent.dart';

// Widgets
import 'widgets/title.dart';
import 'widgets/button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final howestBlue = Color(0xFF44C8F5);
  final howestYellow = Color(0xFFffff00);
  final howestPink = Color(0xFFe6007e);
  final howestGreen = Color(0xFF009a93);
  final howestBlack = Color(0xFF000000);
  final howestWhite = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Howest AI Photobooth',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF44c8f5), // Primary color
            primary: Color(0xFF44c8f5), // Primary color
            onPrimary: Colors.white,
            // secondary: Color(0xFFe6007e), // Secondary color - Magenta
            onSecondary: Colors.white,
            tertiary: Color(0xFFffff00), // Secondary color - Yellow
            onTertiary: Colors.black,
            surface: Color(0xFF8AC9ED), // Tertiary color - Light Blue
            onSurface: Colors.black,
            // background: Color(0xFFfcc2cc), // Tertiary color - Pink
            error: Colors.red, // Tertiary color - Teal
            onError: Colors.white,
          ),
          scaffoldBackgroundColor: Color(0xFF44C8F5),
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.all<Color>(Colors.white),
            checkColor: MaterialStateProperty.all<Color>(Colors.white),
            side: BorderSide(color: Colors.grey.shade100, width: 1.5),
          ),
          radioTheme: RadioThemeData(
            fillColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          switchTheme: SwitchThemeData(
            thumbColor: MaterialStateProperty.all<Color>(Colors.green),
            trackColor:
                MaterialStateProperty.all<Color>(Colors.green.withOpacity(0.5)),
          )),
      home: StartPage(),
      routes: {
        '/start': (context) => StartPage(),
        '/camera': (context) => CameraPage(),
        '/prompt': (context) => ChoosePromptPage(),
        '/form': (context) => FormPage(),
        '/wait': (context) => WaitingForImagesPage(),
        '/picture': (context) => ChoosePicturePage(),
        // '/sent': (context) => SentPage(selectedImageUrls: []),
      },
    );
  }
}
