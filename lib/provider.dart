import 'package:flutter/material.dart';

class MeditationProvider extends ChangeNotifier {
  Map<String, bool> _completedSessions = {};

  bool isCompleted(String title) {
    return _completedSessions[title] ?? false;
  }

  void markCompleted(String title) {
    _completedSessions[title] = true;
    notifyListeners();
  }
}
