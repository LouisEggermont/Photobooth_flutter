import 'package:flutter/material.dart';
import 'package:photobooth/provider/backend_config.dart';
import 'package:photobooth/widgets/error_dialog.dart';
import 'package:photobooth/widgets/page_template.dart';
import 'package:photobooth/widgets/progress_steps.dart';
import 'package:provider/provider.dart';
import '/widgets/title.dart';
import '/widgets/button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChoosePromptPage extends StatefulWidget {
  const ChoosePromptPage({super.key});

  @override
  _ChoosePromptPageState createState() => _ChoosePromptPageState();
}

class _ChoosePromptPageState extends State<ChoosePromptPage> {
  int? _selectedPrompt;

  @override
  Widget build(BuildContext context) {
    return ResponsivePageTemplate(
      title: _buildTitle(),
      content: _buildPromptOptions(),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNextButton(),
          SizedBox(height: 40.h),
          const ProgressSteps(totalSteps: 4, currentStep: 2),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const CustomTitle(
      mainText: 'Choose a prompt',
      subText: '',
    );
  }

  Widget _buildPromptOptions() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildPromptOption(1, 'Sport', 'assets/sport.png'),
              _buildPromptOption(2, 'Space', 'assets/space.png'),
              _buildPromptOption(3, 'Nature', 'assets/nature.png'),
              _buildPromptOption(4, 'Gangster', 'assets/gangster.png'),
            ],
          ),
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
          color: Colors.red.withOpacity(0.2),
          border: Border.all(
            color: _selectedPrompt == value ? Colors.white : Colors.transparent,
            width: 10.w,
          ),
          borderRadius: BorderRadius.circular(50.w),
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
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'VAG-Rounded',
                fontSize: 55.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10.r,
                    color: Colors.black,
                    offset: Offset(2.w, 2.h),
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
          onPressed: _selectedPrompt != null
              ? () async {
                  if (_selectedPrompt != null) {
                    await _sendPromptToApi(_selectedPrompt!, context);
                  }
                }
              : () {}, // Provide an empty callback when the button is disabled
          isDisabled: _selectedPrompt == null,
        ),
      ],
    );
  }
}

Future<void> _sendPromptToApi(int promptNumber, BuildContext context) async {
  try {
    String backendUrl =
        Provider.of<BackendConfig>(context, listen: false).backendUrl;
    var response = await http.get(
      Uri.parse('$backendUrl/get_prompt/$promptNumber'),
    );

    if (response.statusCode == 200) {
      print('Prompt sent successfully');

      Navigator.pushReplacementNamed(context, '/form');
    } else {
      ErrorDialog.show(
        context,
        'Failed to send prompt. Please try again.',
        onRetry: () => _sendPromptToApi(promptNumber, context), // Retry logic
      );
    }
  } catch (e) {
    ErrorDialog.show(
      context,
      'Error sending prompt: $e',
      onRetry: () => _sendPromptToApi(promptNumber, context), // Retry logic
    );
  }
}

void main() => runApp(const MaterialApp(home: ChoosePromptPage()));
