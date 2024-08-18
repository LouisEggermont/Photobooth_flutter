import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsivePageTemplate extends StatelessWidget {
  final Widget title;
  final Widget content;
  final Widget footer;

  const ResponsivePageTemplate({
    required this.title,
    required this.content,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6CD4FF),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
        child: Column(
          children: [
            Expanded(
              flex: 2,
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
            Expanded(
              flex: 2,
              child: footer,
            ),
          ],
        ),
      ),
    );
  }
}
