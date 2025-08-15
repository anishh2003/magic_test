import 'package:flutter/material.dart';
import 'package:magic_test/models/workout.dart';

class WorkoutScreen extends StatelessWidget {
  final Workout workout;
  const WorkoutScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workout')),
      body: Center(child: Text('Workout Screen')),
    );
  }
}
