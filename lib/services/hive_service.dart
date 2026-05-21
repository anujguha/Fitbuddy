import 'package:hive/hive.dart';

import '../models/workout_day_model.dart';

class HiveService {
  static const String workoutBox =
      'workoutBox';

  static Future<void> init() async {
    await Hive.openBox(workoutBox);
  }

  static Box getBox() {
    return Hive.box(workoutBox);
  }

  static Future<void> saveWorkoutData(
    List<WorkoutDay> workouts,
  ) async {
    final box = getBox();

    await box.put(
      'weeklyWorkout',
      workouts,
    );
  }

  static List<WorkoutDay>
      getWorkoutData() {
    final box = getBox();

    final data =
        box.get('weeklyWorkout');

    if (data != null) {
      return List<WorkoutDay>.from(data);
    }

    return [];
  }
}