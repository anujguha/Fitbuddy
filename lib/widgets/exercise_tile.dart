import 'package:flutter/material.dart';

import '../models/exercise_model.dart';

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final bool value;
  final VoidCallback onTap;

  const ExerciseTile({
    super.key,
    required this.exercise,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(exercise.name),
      subtitle: Text(
        '${exercise.sets} Sets • ${exercise.reps} Reps • ${exercise.weight} KG',
      ),
      value: value,
      onChanged: (_) => onTap(),
    );
  }
}
