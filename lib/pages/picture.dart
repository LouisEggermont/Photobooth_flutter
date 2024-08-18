import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photobooth/widgets/button.dart';
import 'package:photobooth/widgets/page_template.dart';
import 'dart:convert';
import '/widgets/title.dart';
import '/widgets/progress_steps.dart';
import 'sent.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(MaterialApp(home: ChoosePicturePage()));

class ImageData {
  final String url;
  final String base64;

  ImageData({required this.url, required this.base64});
}

class ChoosePicturePage extends StatefulWidget {
  @override
  _ChoosePicturePageState createState() => _ChoosePicturePageState();
}

class _ChoosePicturePageState extends State<ChoosePicturePage> {
  List<ImageData> _images = [];
  bool _isLoading = true;
  List<int> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.0.177:2000/choosepicture'));

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
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsivePageTemplate(
      title: CustomTitle(
        mainText: 'Choose Your Pictures',
        subText: '',
        scaleFactor: 0.9,
      ),
      content: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildImageGrid(),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSendButton(),
          SizedBox(height: 20.h),
          ProgressSteps(totalSteps: 4, currentStep: 4),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemCount: _images.length,
      itemBuilder: (context, index) {
        return _buildImageOption(index);
      },
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
            margin: EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.memory(
                base64Decode(_images[index].base64),
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (isSelected)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: CustomButton(
        text: 'Send',
        onPressed: _selectedImages.isNotEmpty
            ? () {
                List<String> selectedImageUrls =
                    _selectedImages.map((index) => _images[index].url).toList();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SentPage(selectedImageUrls: selectedImageUrls),
                  ),
                );
              }
            : () {}, // Provide an empty callback for the disabled state
        isDisabled: _selectedImages
            .isEmpty, // Disable the button if no images are selected
      ),
    );
  }
}
