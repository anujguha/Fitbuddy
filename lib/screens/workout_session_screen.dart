import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/workout_provider.dart';

class WorkoutSessionScreen extends StatelessWidget {
  final String day;

  const WorkoutSessionScreen({
    super.key,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    final workoutProvider =
        Provider.of<WorkoutProvider>(
      context,
    );

    final workoutDay = workoutProvider
        .weeklyWorkout
        .firstWhere(
          (element) => element.day == day,
        );

    final totalExercises =
        workoutDay.exercises.length;

    final completedExercises =
        workoutDay.exercises
            .where(
              (exercise) =>
                  exercise.completed,
            )
            .length;

    final progress = totalExercises == 0
        ? 0.0
        : completedExercises /
            totalExercises;

    return Scaffold(
      appBar: AppBar(
        title:
            Text('$day Session'),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(
                      20),

              decoration: BoxDecoration(
                gradient:
                    const LinearGradient(
                  colors: [
                    Color(0xFF2563EB),
                    Color(0xFF1D4ED8),
                  ],
                ),

                borderRadius:
                    BorderRadius.circular(
                        24),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  const Text(
                    'Workout Progress',

                    style: TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                      height: 18),

                  Text(
                    '$completedExercises / $totalExercises Exercises Completed',

                    style:
                        const TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(
                      height: 18),

                  ClipRRect(
                    borderRadius:
                        BorderRadius
                            .circular(12),

                    child:
                        LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor:
                          Colors.white24,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Live Workout',
              style: TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount:
                    workoutDay
                        .exercises.length,

                itemBuilder:
                    (context, index) {
                  final exercise =
                      workoutDay
                          .exercises[index];

                  return Container(
                    margin:
                        const EdgeInsets
                            .only(
                            bottom: 16),

                    padding:
                        const EdgeInsets
                            .all(16),

                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                              0xFF1E293B),

                      borderRadius:
                          BorderRadius
                              .circular(
                                  20),
                    ),

                    child: Row(
                      children: [
                        Checkbox(
                          value: exercise
                              .completed,

                          onChanged: (_) {
                            workoutProvider
                                .toggleExercise(
                              day,
                              index,
                            );
                          },
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [
                              Text(
                                exercise.name,

                                style:
                                    const TextStyle(
                                  fontSize:
                                      18,

                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              const SizedBox(
                                  height:
                                      6),

                              Text(
                                '${exercise.sets} Sets • ${exercise.reps} Reps • ${exercise.weight} KG',

                                style:
                                    const TextStyle(
                                  color:
                                      Colors
                                          .grey,
                                ),
                              ),
                            ],
                          ),
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
                onPressed: () {
                  showDialog(
                    context: context,

                    builder: (_) =>
                        AlertDialog(
                      title: const Text(
                        'Workout Complete',
                      ),

                      content:
                          Text(
                        'You completed $completedExercises out of $totalExercises exercises.',
                      ),

                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                                context);

                            Navigator.pop(
                                context);
                          },

                          child:
                              const Text(
                            'Finish',
                          ),
                        ),
                      ],
                    ),
                  );
                },

                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      const Color(
                          0xFF2563EB),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                                18),
                  ),
                ),

                child: const Text(
                  'Complete Workout',

                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}