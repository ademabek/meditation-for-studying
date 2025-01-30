import 'package:hive/hive.dart';

part 'meditation_model.g.dart';

@HiveType(typeId: 0)
class MeditationModel {
  @HiveField(0)
  final String title;

  @HiveField(1)
  bool isCompleted;

  MeditationModel({required this.title, this.isCompleted = false});
}
