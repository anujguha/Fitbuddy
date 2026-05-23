import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/workout_provider.dart';
import 'add_exercise_screen.dart';
import 'workout_session_screen.dart';

class DayScheduleScreen extends StatelessWidget {
  final String day;

  const DayScheduleScreen({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);

    final workoutDay = workoutProvider.weeklyWorkout.firstWhere(
      (element) => element.day == day,
    );

    final completedExercises = workoutDay.exercises
        .where((exercise) => exercise.completed)
        .length;

    return Scaffold(
      appBar: AppBar(title: Text('$day Workout')),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2563EB),

        child: const Icon(Icons.add),

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddExerciseScreen(day: day)),
          );
        },
      ),

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
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    '$completedExercises / ${workoutDay.exercises.length} Exercises Completed',

                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,

                    height: 52,

                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (workoutDay.exercises.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Add exercises first'),
                            ),
                          );

                          return;
                        }

                        await workoutProvider.startWorkout(day);

                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WorkoutSessionScreen(day: day),
                            ),
                          );
                        }
                      },

                      icon: const Icon(Icons.play_arrow),

                      label: const Text('Start Workout'),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,

                        foregroundColor: Colors.black,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Exercises',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: workoutDay.exercises.isEmpty
                  ? const Center(
                      child: Text(
                        'No exercises added yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: workoutDay.exercises.length,

                      itemBuilder: (context, index) {
                        final exercise = workoutDay.exercises[index];

                        return Dismissible(
                          key: Key('${exercise.name}$index'),

                          direction: DismissDirection.endToStart,

                          background: Container(
                            alignment: Alignment.centerRight,

                            padding: const EdgeInsets.symmetric(horizontal: 20),

                            margin: const EdgeInsets.only(bottom: 16),

                            decoration: BoxDecoration(
                              color: Colors.red,

                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),

                          onDismissed: (_) async {
                            await workoutProvider.deleteExercise(day, index);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${exercise.name} deleted'),
                              ),
                            );
                          },

                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddExerciseScreen(
                                    day: day,
                                    exercise: exercise,
                                    exerciseIndex: index,
                                  ),
                                ),
                              );
                            },

                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),

                              padding: const EdgeInsets.all(16),

                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),

                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: Row(
                                children: [
                                  Checkbox(
                                    value: exercise.completed,

                                    onChanged: (_) {
                                      workoutProvider.toggleExercise(
                                        day,
                                        index,
                                      );
                                    },
                                  ),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          exercise.name,

                                          style: const TextStyle(
                                            fontSize: 18,

                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        Text(
                                          '${exercise.sets} Sets • ${exercise.reps} Reps • ${exercise.weight} KG',

                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Icon(Icons.edit, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
