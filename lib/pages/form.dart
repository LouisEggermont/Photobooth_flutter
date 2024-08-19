import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:photobooth/provider/backend_config.dart';
import 'package:photobooth/widgets/error_dialog.dart';
import 'package:photobooth/widgets/form_field.dart';
import 'package:photobooth/widgets/progress_steps.dart';
import 'package:provider/provider.dart';
import '/widgets/title.dart';
import '/widgets/button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '/widgets/page_template.dart';

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
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return ResponsivePageTemplate(
      title: _buildTitle(),
      content: Padding(
        padding: EdgeInsets.only(top: 80.h),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  600.h, // Adjust height to center the form
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFormContent(),
                ],
              ),
            ),
          ),
        ),
      ),
      footer: Visibility(
        visible:
            !isKeyboardVisible, // Hide the footer if the keyboard is visible
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSubmitButton(),
            SizedBox(height: 20.h),
            _buildProgressSteps(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        CustomTitle(
          mainText: 'Generating images',
          subText: 'Where shall we send your pictures?',
          leftOffset: 40,
          scaleFactor: .87,
        ),
      ],
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          _buildForm(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 2, // Smaller width for the first name field
              child: _buildFirstNameField(),
            ),
            SizedBox(width: 32.w),
            Flexible(
              flex: 3, // Larger width for the last name field
              child: _buildLastNameField(),
            ),
          ],
        ),
        SizedBox(height: 44.h),
        _buildEmailField(),
        SizedBox(height: 85.h),
        _buildPrivacyPolicyCheckbox(),
        SizedBox(height: 85.h),
        _buildSecondaryYearRadioButtons(),
      ],
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
              style: TextStyle(
                  color: Colors.black, fontFamily: "OpenSans", fontSize: 31.sp),
            ),
            TextSpan(
              text: 'privacy policy',
              style: TextStyle(
                color: Colors.black,
                fontFamily: "OpenSans",
                fontSize: 31.sp,
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
            fontSize: 31.sp,
            color: Colors.black,
            fontFamily: "OpenSans",
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: RadioListTile(
                title: Text('5th',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "OpenSans",
                        fontSize: 31.sp)),
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
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "OpenSans",
                        fontSize: 31.sp)),
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
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "OpenSans",
                        fontSize: 31.sp)),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomButton(
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
          // isDisabled: !_isFormValid(),
        ),
      ],
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
      String backendUrl =
          Provider.of<BackendConfig>(context, listen: false).backendUrl;
      var response = await http.post(
        Uri.parse('$backendUrl/form'),
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
        ErrorDialog.show(
          context,
          'Failed to submit form. Please try again.',
          onRetry: _sendFormToApi, // Retry logic
        );
      }
    } catch (e) {
      ErrorDialog.show(
        context,
        'Error submitting form: $e',
        onRetry: _sendFormToApi, // Retry logic
      );
    }
  }

  Future<void> _checkStatus() async {
    try {
      String backendUrl =
          Provider.of<BackendConfig>(context, listen: false).backendUrl;
      final response = await http.get(Uri.parse('$backendUrl/check_status'));
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

  Widget _buildProgressSteps() {
    return ProgressSteps(totalSteps: 4, currentStep: 3);
  }
}

void main() => runApp(MaterialApp(home: FormPage()));
