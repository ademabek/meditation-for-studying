import 'package:flutter/material.dart';

class Profile with ChangeNotifier {
  String _name = '';
  String _email = '';

  String get name => _name;
  String get email => _email;

  void updateFromFirebase(Map<String, dynamic> data) {
    _name = data['name'] ?? '';
    _email = data['email'] ?? '';
    notifyListeners();
  }

  void updateProfile({required String name, required String email}) {
    _name = name;
    _email = email;
    notifyListeners();
  }
}
