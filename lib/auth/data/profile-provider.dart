import 'package:flutter/material.dart';

class Profile with ChangeNotifier {
  String name = '';
  String email = '';
  String mobile = '';
  String dob = '';
  String gender = '';

  void updateProfile({
    required String name,
    required String email,
    required String mobile,
    required String dob,
    required String gender,
  }) {
    this.name = name;
    this.email = email;
    this.mobile = mobile;
    this.dob = dob;
    this.gender = gender;
    notifyListeners();
  }

  void updateFromFirebase(Map<String, dynamic> data) {
    name = data['name'] ?? name;
    email = data['email'] ?? email;
    mobile = data['mobile'] ?? mobile;
    dob = data['dob'] ?? dob;
    gender = data['gender'] ?? gender;
    notifyListeners();
  }
}
