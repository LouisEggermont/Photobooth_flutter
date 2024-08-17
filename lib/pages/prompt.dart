import 'package:flutter/material.dart';
import 'package:photobooth/widgets/progress_steps.dart';
import '/widgets/title.dart';
import '/widgets/button.dart';
import 'package:http/http.dart' as http;

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            _buildTitle(),
            SizedBox(height: 20),
            _buildPromptOptions(),
            SizedBox(height: 20),
            _buildNextButton(),
            SizedBox(height: 20),
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
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedPrompt == value ? Colors.white : Colors.transparent,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
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
            padding: const EdgeInsets.only(
                bottom: 8.0), // Add some padding at the bottom
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'VAG-Rounded',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black,
                    offset: Offset(2, 2),
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
    return CustomButton(
      text: 'Next',
      onPressed: () async {
        if (_selectedPrompt != null) {
          await _sendPromptToApi(_selectedPrompt!, context);
          // Navigator.pushReplacementNamed(context, '/form');
        }
        // Navigator.pushReplacementNamed(context, '/form');
      },
      isDisabled: _selectedPrompt == null,
    );
  }

  Widget _buildProgressBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildProgressStep(1),
        _buildProgressLine(),
        _buildProgressStep(2),
        _buildProgressLine(),
        _buildProgressStep(3),
        _buildProgressLine(),
        _buildProgressStep(4),
      ],
    );
  }

  Widget _buildProgressStep(int step) {
    return CircleAvatar(
      radius: 20,
      backgroundColor:
          _selectedPrompt == step ? Colors.white : Color(0xFF44C8F5),
      child: Text(
        '$step',
        style: TextStyle(
          color: _selectedPrompt == step ? Color(0xFF44C8F5) : Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildProgressLine() {
    return Container(
      width: 40,
      height: 4,
      color: Colors.white.withOpacity(0.6),
    );
  }
}

Future<void> _sendPromptToApi(int promptNumber, BuildContext context) async {
  try {
    // Replace 'YOUR_LOCAL_IP' with your machine's local IP address
    var response = await http.get(
      Uri.parse('http://192.168.0.177:2000/get_prompt/$promptNumber'),
    );

    if (response.statusCode == 200) {
      print('Prompt sent successfully');
      Navigator.pushReplacementNamed(context, '/form');
      // Handle successful response if needed
    } else {
      print('Failed to send prompt');
    }
  } catch (e) {
    print('Error sending prompt: $e');
  }
}

void main() => runApp(MaterialApp(home: ChoosePromptPage()));
