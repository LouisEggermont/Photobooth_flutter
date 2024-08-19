import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorDialog({
    Key? key,
    required this.title,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        if (onRetry != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onRetry!();
            },
            child: Text('Retry'),
          ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/start');
          },
          child: Text('OK'),
        ),
      ],
    );
  }

  static void show(BuildContext context, String message,
      {VoidCallback? onRetry}) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        title: 'Error',
        message: message,
        onRetry: onRetry,
      ),
    );
  }
}
