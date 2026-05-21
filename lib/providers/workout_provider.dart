import 'package:flutter/material.dart';

import '../models/exercise_model.dart';
import '../models/workout_day_model.dart';
import '../services/hive_service.dart';

class WorkoutProvider extends ChangeNotifier {
  final List<WorkoutDay> _weeklyWorkout = [
    WorkoutDay(day: 'Monday', exercises: []),
    WorkoutDay(day: 'Tuesday', exercises: []),
    WorkoutDay(day: 'Wednesday', exercises: []),
    WorkoutDay(day: 'Thursday', exercises: []),
    WorkoutDay(day: 'Friday', exercises: []),
    WorkoutDay(day: 'Saturday', exercises: []),
    WorkoutDay(day: 'Sunday', exercises: []),
  ];

  List<WorkoutDay> get weeklyWorkout => _weeklyWorkout;

  WorkoutProvider() {
    loadWorkouts();
  }

  Future<void> loadWorkouts() async {
    final data = HiveService.getWorkoutData();

    if (data.isNotEmpty) {
      _weeklyWorkout.clear();
      _weeklyWorkout.addAll(data);
    }

    notifyListeners();
  }

  Future<void> saveWorkouts() async {
    await HiveService.saveWorkoutData(_weeklyWorkout);
  }

  Future<void> addExercise(String day, Exercise exercise) async {
    final workoutDay = _weeklyWorkout.firstWhere(
      (element) => element.day == day,
    );

    workoutDay.exercises.add(exercise);

    await saveWorkouts();

    notifyListeners();
  }

  Future<void> updateExercise(
    String day,
    int index,
    Exercise updatedExercise,
  ) async {
    final workoutDay = _weeklyWorkout.firstWhere(
      (element) => element.day == day,
    );

    workoutDay.exercises[index] = updatedExercise;

    await saveWorkouts();

    notifyListeners();
  }

  Future<void> deleteExercise(String day, int index) async {
    final workoutDay = _weeklyWorkout.firstWhere(
      (element) => element.day == day,
    );

    workoutDay.exercises.removeAt(index);

    await saveWorkouts();

    notifyListeners();
  }

  Future<void> toggleExercise(String day, int index) async {
    final workoutDay = _weeklyWorkout.firstWhere(
      (element) => element.day == day,
    );

    workoutDay.exercises[index].completed =
        !workoutDay.exercises[index].completed;

    await saveWorkouts();

    notifyListeners();
  }
}
