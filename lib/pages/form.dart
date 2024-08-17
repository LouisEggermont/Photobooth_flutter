import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photobooth/widgets/button.dart';
import 'package:photobooth/widgets/form_field.dart';
import 'package:photobooth/widgets/progress_steps.dart';
import 'dart:convert';
import 'package:photobooth/widgets/title.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _year = '5';
  bool _acceptPrivacyPolicy = false;
  bool _isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF63C9F2),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            _buildTitle(),
            SizedBox(height: 20),
            _buildForm(),
            Spacer(),
            ProgressSteps(totalSteps: 4, currentStep: 3),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return CustomTitle(
      mainText: 'Generating images',
      subText: 'Where shall we send them?',
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildFirstNameField()),
              SizedBox(width: 16),
              Expanded(child: _buildLastNameField()),
            ],
          ),
          SizedBox(height: 16),
          _buildEmailField(),
          SizedBox(height: 16),
          _buildPrivacyPolicyCheckbox(),
          SizedBox(height: 16),
          _buildSecondaryYearRadioButtons(),
          SizedBox(height: 16),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildFirstNameField() {
    return CustomTextFormField(
      labelText: 'First name',
      validator: (value) {
        if (_isSubmitted && (value == null || value.isEmpty)) {
          return 'Please enter your first name';
        }
        return null;
      },
      onSaved: (value) {
        _firstName = value!;
      },
    );
  }

  Widget _buildLastNameField() {
    return CustomTextFormField(
      labelText: 'Last name',
      validator: (value) {
        if (_isSubmitted && (value == null || value.isEmpty)) {
          return 'Please enter your last name';
        }
        return null;
      },
      onSaved: (value) {
        _lastName = value!;
      },
    );
  }

  Widget _buildEmailField() {
    return CustomTextFormField(
      labelText: 'Email',
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (_isSubmitted && (value == null || value.isEmpty)) {
          return 'Please enter your email';
        } else if (_isSubmitted &&
            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      onSaved: (value) {
        _email = value!;
      },
    );
  }

  Widget _buildPrivacyPolicyCheckbox() {
    return CheckboxListTile(
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'I accept the ',
              style: TextStyle(color: Colors.black, fontFamily: "OpenSans"),
            ),
            TextSpan(
              text: 'privacy policy',
              style: TextStyle(
                color: Colors.black,
                fontFamily: "OpenSans",
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      value: _acceptPrivacyPolicy,
      onChanged: (value) {
        setState(() {
          _acceptPrivacyPolicy = value!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.white,
      checkColor: Color(0xFF63C9F2),
      tileColor: Colors.transparent,
    );
  }

  Widget _buildSecondaryYearRadioButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current secondary year',
          style: TextStyle(
              fontSize: 16.0, color: Colors.black, fontFamily: "OpenSans"),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile(
                title: Text('5th',
                    style:
                        TextStyle(color: Colors.black, fontFamily: "OpenSans")),
                value: '5',
                groupValue: _year,
                onChanged: (value) {
                  setState(() {
                    _year = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile(
                title: Text('6th',
                    style:
                        TextStyle(color: Colors.black, fontFamily: "OpenSans")),
                value: '6',
                groupValue: _year,
                onChanged: (value) {
                  setState(() {
                    _year = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile(
                title: Text('Other',
                    style:
                        TextStyle(color: Colors.black, fontFamily: "OpenSans")),
                value: 'other',
                groupValue: _year,
                onChanged: (value) {
                  setState(() {
                    _year = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return CustomButton(
      onPressed: () {
        setState(() {
          _isSubmitted = true;
        });

        if (_formKey.currentState!.validate() && _acceptPrivacyPolicy) {
          _formKey.currentState!.save();
          _sendFormToApi();
        } else if (!_acceptPrivacyPolicy) {
          _showPrivacyPolicyDialog();
        }
      },
      text: "Submit",
      isDisabled: !_isFormValid(),
    );
  }

  bool _isFormValid() {
    return _acceptPrivacyPolicy;
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Policy'),
        content: Text('You must accept the privacy policy to proceed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendFormToApi() async {
    try {
      var response = await http.post(
        Uri.parse('http://192.168.0.177:2000/form'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fname': _firstName,
          'lname': _lastName,
          'email': _email,
          'year': _year,
          'tof': _acceptPrivacyPolicy
        }),
      );

      if (response.statusCode == 200) {
        print('Form submitted successfully');
        _checkStatus(); // Start checking the status
      } else {
        print('Failed to submit form');
      }
    } catch (e) {
      print('Error submitting form: $e');
    }
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
          Navigator.pushReplacementNamed(context, '/wait');
        }
      } else {
        Future.delayed(Duration(seconds: 5), _checkStatus);
      }
    } catch (e) {
      Future.delayed(Duration(seconds: 5), _checkStatus);
    }
  }
}

void main() => runApp(MaterialApp(home: FormPage()));
