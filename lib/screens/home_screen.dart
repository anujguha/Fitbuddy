import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/workout_provider.dart';
import '../widgets/workout_card.dart';
import 'day_schedule_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutProvider =
        Provider.of<WorkoutProvider>(context);

    int totalExercises = 0;
    int completedExercises = 0;

    for (var day in workoutProvider.weeklyWorkout) {
      totalExercises += day.exercises.length;

      for (var exercise in day.exercises) {
        if (exercise.completed) {
          completedExercises++;
        }
      }
    }

    final progress = totalExercises == 0
        ? 0.0
        : completedExercises / totalExercises;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              const Text(
                'FitBuddy',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Track your weekly workouts',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2563EB),
                      Color(0xFF1D4ED8),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Progress',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            const Text(
                              'Completed',
                              style: TextStyle(
                                color:
                                    Colors.white70,
                              ),
                            ),
                            Text(
                              '$completedExercises',
                              style:
                                  const TextStyle(
                                fontSize: 28,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                color:
                                    Colors.white70,
                              ),
                            ),
                            Text(
                              '$totalExercises',
                              style:
                                  const TextStyle(
                                fontSize: 28,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(
                              12),
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
                'Workout Schedule',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: workoutProvider
                      .weeklyWorkout.length,
                  itemBuilder: (context, index) {
                    final workoutDay =
                        workoutProvider
                            .weeklyWorkout[index];

                    return WorkoutCard(
                      day: workoutDay.day,
                      exerciseCount: workoutDay
                          .exercises.length,
                      completedExercises:
                          workoutDay.exercises
                              .where(
                                (exercise) =>
                                    exercise
                                        .completed,
                              )
                              .length,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DayScheduleScreen(
                              day:
                                  workoutDay.day,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}