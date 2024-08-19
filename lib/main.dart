import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// Pages
import 'pages/start.dart';
import 'pages/camera.dart';
import 'pages/prompt.dart';
import 'pages/form.dart';
import 'pages/picture.dart';
import 'pages/waiting.dart';
// import 'pages/sent.dart';

// Widgets

// Providers
import 'package:photobooth/provider/backend_config.dart';

// Colors
const Color howestBlue = Color(0xFF44C8F5);
const Color howestYellow = Color(0xFFFFFF00);
const Color howestPink = Color(0xFFE6007E);
const Color howestGreen = Color(0xFF009A93);
const Color howestBlack = Color(0xFF000000);
const Color howestWhite = Color(0xFFFFFFFF);

// void main() {
//   runApp(MyApp());
// }

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BackendConfig(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize:
          const Size(1066, 1536), // Adjust this to your design's dimensions
      builder: (context, child) {
        return MaterialApp(
          title: 'Howest AI Photobooth',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: howestBlue, // Primary color
              primary: howestBlue, // Primary color
              onPrimary: howestWhite,
              onSecondary: howestWhite,
              tertiary: howestYellow, // Secondary color - Yellow
              onTertiary: howestBlack,
              surface: const Color(0xFF8AC9ED), // Tertiary color - Light Blue
              onSurface: howestBlack,
              error: Colors.red, // Tertiary color - Teal
              onError: howestWhite,
            ),
            scaffoldBackgroundColor: howestBlue,
            checkboxTheme: CheckboxThemeData(
              fillColor: WidgetStateProperty.all<Color>(Colors.white),
              checkColor: WidgetStateProperty.all<Color>(Colors.white),
              side: BorderSide(color: Colors.grey.shade100, width: .5.w),
            ),
            radioTheme: RadioThemeData(
                fillColor: WidgetStateProperty.all<Color>(Colors.white),
                visualDensity: VisualDensity.adaptivePlatformDensity
                // .copyWith(horizontal: -4.0, vertical: -4.0),
                ),
            // switchTheme: SwitchThemeData(
            //   thumbColor: WidgetStateProperty.all<Color>(Colors.green),
            //   trackColor: WidgetStateProperty.all<Color>(
            //     Colors.green.withOpacity(0.5),
            //   ),
            // ),
          ),
          home: const StartPage(),
          routes: {
            '/start': (context) => const StartPage(),
            '/camera': (context) => const CameraPage(),
            '/prompt': (context) => const ChoosePromptPage(),
            '/form': (context) => const FormPage(),
            '/wait': (context) => const WaitingForImagesPage(),
            '/picture': (context) => const ChoosePicturePage(),
            // '/sent': (context) => SentPage(selectedImageUrls: []),
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
