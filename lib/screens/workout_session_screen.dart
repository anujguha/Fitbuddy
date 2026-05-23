import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/workout_provider.dart';
import '../widgets/set_tile.dart';

class WorkoutSessionScreen extends StatelessWidget {
  final String day;

  const WorkoutSessionScreen({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);

    final workoutDay = workoutProvider.weeklyWorkout.firstWhere(
      (element) => element.day == day,
    );

    final totalSets = workoutProvider.getTotalSets(day);

    final completedSets = workoutProvider.getCompletedSets(day);

    final progress = totalSets == 0 ? 0.0 : completedSets / totalSets;

    return Scaffold(
      appBar: AppBar(title: Text('$day Session')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                ),

                borderRadius: BorderRadius.circular(24),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Workout Progress',

                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    '$completedSets / $totalSets Sets Completed',

                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 18),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),

                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: ListView.builder(
                itemCount: workoutDay.exercises.length,

                itemBuilder: (context, exerciseIndex) {
                  final exercise = workoutDay.exercises[exerciseIndex];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 18),

                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),

                      borderRadius: BorderRadius.circular(24),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    exercise.name,

                                    style: const TextStyle(
                                      fontSize: 20,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    '${exercise.sets} Sets • ${exercise.reps} Reps • ${exercise.weight} KG',

                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),

                            if (exercise.completed)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Wrap(
                          children: List.generate(exercise.sets, (setIndex) {
                            return SetTile(
                              setNumber: setIndex + 1,

                              completed: exercise.completedSets[setIndex],

                              onTap: () {
                                workoutProvider.toggleSetCompletion(
                                  day,
                                  exerciseIndex,
                                  setIndex,
                                );
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 58,

              child: ElevatedButton(
                onPressed: () async {
                  await workoutProvider.resetWorkout(day);

                  if (context.mounted) {
                    showDialog(
                      context: context,

                      builder: (_) => AlertDialog(
                        title: const Text('Workout Complete'),

                        content: Text(
                          'You completed $completedSets out of $totalSets sets.',
                        ),

                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);

                              Navigator.pop(context);
                            },

                            child: const Text('Finish'),
                          ),
                        ],
                      ),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                child: const Text(
                  'Complete Workout',

                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
