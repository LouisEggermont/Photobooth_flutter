import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '/widgets/title.dart';
import '/widgets/progress_steps.dart';

import 'sent.dart';

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

        print(
            "Received data from backend: $data"); // Add this line to print the entire response

        setState(() {
          _images = List<ImageData>.from(
            data['generated_images'].map(
              (item) => ImageData(
                url: item['url'],
                base64: item['base64'],
              ),
            ),
          );
          print(
              "Images processed: $_images"); // Add this line to check if the images are correctly processed
          _isLoading = false;
        });
      } else {
        print("Failed to load images, status code: ${response.statusCode}");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching images: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6CD4FF),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  CustomTitle(
                    mainText: 'Choose Your Pictures',
                    subText: '',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _buildImageGrid(),
                  SizedBox(height: 20),
                  _buildSendButton(),
                  SizedBox(height: 20),
                  ProgressSteps(totalSteps: 4, currentStep: 4),
                ],
              ),
            ),
    );
  }

  Widget _buildImageGrid() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(_images.length, (index) {
          return _buildImageOption(index);
        }),
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
            margin: EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.memory(
                gaplessPlayback: true,
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
    return ElevatedButton(
      onPressed: _selectedImages.isNotEmpty
          ? () {
              // _sendSelectedImages();
              // Get the URLs of the selected images
              List<String> selectedImageUrls =
                  _selectedImages.map((index) => _images[index].url).toList();

              // Navigate to SentPage and pass the selectedImageUrls
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SentPage(selectedImageUrls: selectedImageUrls),
                ),
              );
            }
          : null,
      child: Text('Send'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFE91E63),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Future<void> _sendSelectedImages() async {
    final selectedImageUrls =
        _selectedImages.map((index) => _images[index].url).toList();

    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.177:2000/send_email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'selected_image_urls': selectedImageUrls}),
      );

      if (response.statusCode == 200) {
        // Handle success
        print('Images sent successfully');
      } else {
        // Handle failure
        print('Failed to send images');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
