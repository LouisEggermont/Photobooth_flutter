import 'package:flutter/material.dart';
import 'package:photobooth/widgets/progress_steps.dart';
import '/widgets/title.dart';
import '/widgets/button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChoosePromptPage extends StatefulWidget {
  @override
  _ChoosePromptPageState createState() => _ChoosePromptPageState();
}

class _ChoosePromptPageState extends State<ChoosePromptPage> {
  int? _selectedPrompt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: 90.h, // Top padding
          bottom: 50.h, // Bottom padding
          left: 90.w, // Left padding
          right: 90.w, // Right padding
        ),
        child: Column(
          children: [
            SizedBox(height: 10.h), // Using ScreenUtil for responsive spacing
            _buildTitle(),
            SizedBox(height: 120.h), // Using ScreenUtil for responsive spacing
            _buildPromptOptions(),
            SizedBox(height: 10.h), // Using ScreenUtil for responsive spacing
            _buildNextButton(),
            SizedBox(height: 40.h), // Using ScreenUtil for responsive spacing
            ProgressSteps(totalSteps: 4, currentStep: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return CustomTitle(
      mainText: 'Choose a prompt',
      subText: '',
    );
  }

  Widget _buildPromptOptions() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildPromptOption(1, 'Sport', 'assets/sport.png'),
          _buildPromptOption(2, 'Space', 'assets/space.png'),
          _buildPromptOption(3, 'Nature', 'assets/nature.png'),
          _buildPromptOption(4, 'Gangster', 'assets/gangster.png'),
        ],
      ),
    );
  }

  Widget _buildPromptOption(int value, String label, String assetPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPrompt = value;
        });
      },
      child: Container(
        margin: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.2), // Use color inside BoxDecoration
          border: Border.all(
            color: _selectedPrompt == value ? Colors.white : Colors.transparent,
            width: 10.w, // Scaled border width
          ),
          borderRadius: BorderRadius.circular(50.w), // Scaled border radius
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
            colorFilter: _selectedPrompt == value
                ? ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.darken)
                : null,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter, // Aligns text at the bottom center
          child: Padding(
            padding:
                EdgeInsets.only(bottom: 8.h), // Add some padding at the bottom
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'VAG-Rounded',
                fontSize: 55.sp, // Scaled font size
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10.r, // Scaled blur radius
                    color: Colors.black,
                    offset: Offset(2.w, 2.h), // Scaled shadow offset
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomButton(
          text: 'Next',
          onPressed: () async {
            if (_selectedPrompt != null) {
              await _sendPromptToApi(_selectedPrompt!, context);
            }
          },
          isDisabled: _selectedPrompt == null,
        ),
      ],
    );
  }
}

Future<void> _sendPromptToApi(int promptNumber, BuildContext context) async {
  try {
    var response = await http.get(
      Uri.parse('http://192.168.0.177:2000/get_prompt/$promptNumber'),
    );

    if (response.statusCode == 200) {
      print('Prompt sent successfully');
      Navigator.pushReplacementNamed(context, '/form');
    } else {
      print('Failed to send prompt');
    }
  } catch (e) {
    print('Error sending prompt: $e');
  }
}

void main() => runApp(MaterialApp(home: ChoosePromptPage()));
