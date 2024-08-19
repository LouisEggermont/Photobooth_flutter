import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photobooth/main.dart';

class ResponsivePageTemplate extends StatelessWidget {
  final Widget title;
  final Widget content;
  final Widget footer;

  const ResponsivePageTemplate({
    super.key,
    required this.title,
    required this.content,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: howestBlue,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 90.w, vertical: 40.h),
          child: Column(
            children: [
              SizedBox(
                height: 200.h,
                // flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: title,
                ),
              ),
              Expanded(
                flex: 6,
                child: content,
              ),
              SizedBox(height: 20.h),
              footer, // Removing Expanded to avoid the footer taking excess space
            ],
          ),
        ),
      ),
    );
  }
}
