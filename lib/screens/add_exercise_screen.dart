import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/exercise_model.dart';
import '../providers/workout_provider.dart';

class AddExerciseScreen extends StatefulWidget {
  final String day;
  final Exercise? exercise;
  final int? exerciseIndex;

  const AddExerciseScreen({
    super.key,
    required this.day,
    this.exercise,
    this.exerciseIndex,
  });

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final nameController = TextEditingController();

  final setsController = TextEditingController();

  final repsController = TextEditingController();

  final weightController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool get isEditMode => widget.exercise != null;

  @override
  void initState() {
    super.initState();

    if (isEditMode) {
      final exercise = widget.exercise!;

      nameController.text = exercise.name;
      setsController.text = exercise.sets.toString();
      repsController.text = exercise.reps.toString();
      weightController.text = exercise.weight.toString();
    }
  }

  Future<void> saveExercise() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final exercise = Exercise(
      name: nameController.text.trim(),
      sets: int.tryParse(setsController.text.trim()) ?? 0,
      reps: int.tryParse(repsController.text.trim()) ?? 0,
      weight: double.tryParse(weightController.text.trim()) ?? 0,
      completed: widget.exercise?.completed ?? false,
    );

    final provider = Provider.of<WorkoutProvider>(context, listen: false);

    if (isEditMode) {
      await provider.updateExercise(
        widget.day,
        widget.exerciseIndex!,
        exercise,
      );
    } else {
      await provider.addExercise(widget.day, exercise);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  InputDecoration fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFF1E293B),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Exercise' : 'Add Exercise'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: fieldDecoration('Exercise Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter exercise name';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: setsController,
                keyboardType: TextInputType.number,
                decoration: fieldDecoration('Sets'),
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: repsController,
                keyboardType: TextInputType.number,
                decoration: fieldDecoration('Reps'),
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: fieldDecoration('Weight (KG)'),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: saveExercise,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    isEditMode ? 'Update Exercise' : 'Save Exercise',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
