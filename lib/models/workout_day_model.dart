import 'package:hive/hive.dart';

import 'exercise_model.dart';

part 'workout_day_model.g.dart';

@HiveType(typeId: 1)
class WorkoutDay extends HiveObject {
  @HiveField(0)
  String day;

  @HiveField(1)
  List<Exercise> exercises;

  WorkoutDay({
    required this.day,
    required this.exercises,
  });
}