import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/workout_provider.dart';
import 'add_exercise_screen.dart';

class DayScheduleScreen extends StatelessWidget {
  final String day;

  const DayScheduleScreen({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);

    final workoutDay = workoutProvider.weeklyWorkout.firstWhere(
      (element) => element.day == day,
    );

    return Scaffold(
      appBar: AppBar(title: Text(day)),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddExerciseScreen(day: day)),
          );
        },
        label: const Text('Add Exercise'),
        icon: const Icon(Icons.add),
      ),

      body: workoutDay.exercises.isEmpty
          ? const Center(
              child: Text(
                'No exercises added yet',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
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
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),

                  onDismissed: (_) async {
                    await workoutProvider.deleteExercise(day, index);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${exercise.name} deleted')),
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
                              workoutProvider.toggleExercise(day, index);
                            },
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  '${exercise.sets} Sets  •  ${exercise.reps} Reps  •  ${exercise.weight} KG',
                                  style: const TextStyle(color: Colors.grey),
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
    );
  }
}
