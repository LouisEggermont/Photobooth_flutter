import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:photobooth/main.dart';
import 'package:photobooth/provider/backend_config.dart';
import 'package:photobooth/widgets/button.dart';
import 'package:photobooth/widgets/error_dialog.dart';
import 'package:photobooth/widgets/page_template.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '/widgets/title.dart';
import '/widgets/progress_steps.dart';
import 'sent.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageData {
  final String url;
  final String base64;

  ImageData({required this.url, required this.base64});
}

class ChoosePicturePage extends StatefulWidget {
  const ChoosePicturePage({super.key});

  @override
  _ChoosePicturePageState createState() => _ChoosePicturePageState();
}

class _ChoosePicturePageState extends State<ChoosePicturePage> {
  List<ImageData> _images = [];
  bool _isLoading = true;
  final List<int> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    try {
      String backendUrl =
          Provider.of<BackendConfig>(context, listen: false).backendUrl;
      final response = await http.get(Uri.parse('$backendUrl/choosepicture'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _images = List<ImageData>.from(
            data['generated_images'].map(
              (item) => ImageData(
                url: item['url'],
                base64: item['base64'],
              ),
            ),
          );
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Failed to load images. Please try again.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error: Could not fetch images.');
    }
  }

  void _showErrorDialog(String message) {
    ErrorDialog.show(
      context,
      message,
      onRetry: _fetchImages, // Retry logic
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsivePageTemplate(
      title: _buildTitle(),
      content: _isLoading ? _buildLoadingIndicator() : _buildImageGrid(),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSendButton(),
          SizedBox(height: 20.h),
          const ProgressSteps(totalSteps: 4, currentStep: 4),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const CustomTitle(
      mainText: 'Choose Your Pictures',
      subText: '',
      scaleFactor: .87,
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Lottie.asset(
        'assets/loading_animation.json',
        width: 300.w,
        // height: 200.h,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildImageGrid() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
            ),
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return _buildImageOption(index);
            },
            shrinkWrap:
                true, // Ensure the grid takes up only as much space as needed
            physics:
                const NeverScrollableScrollPhysics(), // Disable scrolling inside the grid
          ),
        ],
      ),
    );
  }

  Widget _buildImageOption(int index) {
    final bool isSelected = _selectedImages.contains(index);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedImages.remove(index);
          } else {
            _selectedImages.add(index);
          }
        });
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(12.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.w),
              child: Image.memory(
                base64Decode(_images[index].base64),
                gaplessPlayback: true,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 32.w,
            right: 32.w,
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: !isSelected ? howestBlack.withOpacity(.5) : howestBlue,
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      !isSelected ? Colors.grey.withOpacity(.5) : Colors.white,
                  width: 7.w,
                ),
              ),
              child: Icon(
                size: 60.w,
                Icons.check,
                color: !isSelected ? Colors.transparent : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    final bool isButtonDisabled = _selectedImages.isEmpty;

    return Align(
      alignment: Alignment.centerRight,
      child: CustomButton(
        text: 'Send',
        onPressed: isButtonDisabled
            ? () {} // Provide an empty callback to satisfy the type requirement
            : () {
                List<String> selectedImageUrls =
                    _selectedImages.map((index) => _images[index].url).toList();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SentPage(selectedImageUrls: selectedImageUrls),
                  ),
                );
              },
        isDisabled: isButtonDisabled, // Disable the button visually
      ),
    );
  }
}
