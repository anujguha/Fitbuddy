import 'exercise_model.dart';

class WorkoutLog {
  DateTime date;
  List<Exercise> completedExercises;

  WorkoutLog({required this.date, required this.completedExercises});
}
