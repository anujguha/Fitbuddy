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

  // NEW
  @HiveField(5)
  List<bool> completedSets;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    this.completed = false,
    List<bool>? completedSets,
  }) : completedSets = completedSets ?? List.generate(sets, (_) => false);

  int get completedSetCount => completedSets.where((set) => set).length;
}
