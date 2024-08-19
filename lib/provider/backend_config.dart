// lib/providers/backend_config.dart
import 'package:flutter/material.dart';

class BackendConfig with ChangeNotifier {
  String _backendUrl = 'http://192.168.0.177:2000';

  String get backendUrl => _backendUrl;

  void updateBackendUrl(String newUrl) {
    _backendUrl = newUrl;
    notifyListeners();
  }
}
