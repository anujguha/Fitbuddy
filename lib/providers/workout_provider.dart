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

  Future<void> toggleSetCompletion(
    String day,
    int exerciseIndex,
    int setIndex,
  ) async {
    final workoutDay = _weeklyWorkout.firstWhere(
      (element) => element.day == day,
    );

    final exercise = workoutDay.exercises[exerciseIndex];

    exercise.completedSets[setIndex] = !exercise.completedSets[setIndex];

    exercise.completed = exercise.completedSets.every((set) => set);

    await saveWorkouts();

    notifyListeners();
  }

  int getTotalSets(String day) {
    final workoutDay = _weeklyWorkout.firstWhere(
      (element) => element.day == day,
    );

    return workoutDay.exercises.fold(0, (sum, exercise) => sum + exercise.sets);
  }

  int getCompletedSets(String day) {
    final workoutDay = _weeklyWorkout.firstWhere(
      (element) => element.day == day,
    );

    int completed = 0;

    for (var exercise in workoutDay.exercises) {
      completed += exercise.completedSets.where((set) => set).length;
    }

    return completed;
  }

  Future<void> loadWorkouts() async {
    final data = HiveService.getWorkoutData();

    if (data.isNotEmpty) {
      _weeklyWorkout.clear();
      _weeklyWorkout.addAll(data);
    }

    notifyListeners();
  }

  Future<void> resetWorkout(String day) async {
    final workoutDay = _weeklyWorkout.firstWhere(
      (element) => element.day == day,
    );

    for (var exercise in workoutDay.exercises) {
      exercise.completed = false;

      exercise.completedSets = List.generate(exercise.sets, (_) => false);
    }

    await saveWorkouts();

    notifyListeners();
  }

  Future<void> startWorkout(String day) async {
    await resetWorkout(day);
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
