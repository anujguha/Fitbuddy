import 'package:flutter/material.dart';

class WorkoutCard extends StatelessWidget {
  final String day;
  final int exerciseCount;
  final int completedExercises;
  final VoidCallback onTap;

  const WorkoutCard({
    super.key,
    required this.day,
    required this.exerciseCount,
    required this.completedExercises,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = exerciseCount == 0
        ? 0.0
        : completedExercises / exerciseCount;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.fitness_center),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '$completedExercises / $exerciseCount Exercises Completed',
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}