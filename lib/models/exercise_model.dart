import 'package:hive/hive.dart';

part 'exercise_model.g.dart';

@HiveType(typeId: 0)
class Exercise extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int sets;

  @HiveField(2)
  int reps;

  @HiveField(3)
  double weight;

  @HiveField(4)
  bool completed;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    this.completed = false,
  });
}