import 'package:flutter/material.dart';

class WorkoutScreen extends StatelessWidget {
  final String day;

  const WorkoutScreen({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$day Workout')),
      body: const Center(child: Text('Workout tracking screen coming next')),
    );
  }
}
