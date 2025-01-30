import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeditationCubit extends Cubit<Map<String, bool>> {
  MeditationCubit() : super({});

  Future<void> loadCompletedSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final completedSessions = <String, bool>{};
    for (var key in keys) {
      completedSessions[key] = prefs.getBool(key) ?? false;
    }
    emit(completedSessions);
  }

  Future<void> markCompleted(String title) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(title, true);

    final updatedState = Map<String, bool>.from(state);
    updatedState[title] = true;
    emit(updatedState);
  }

  bool isCompleted(String title) {
    return state[title] ?? false;
  }
}
