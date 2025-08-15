import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magic_test/core/hive_service.dart';
import 'package:magic_test/feature/workoutList/bloc/workout_list_bloc.dart';
import 'package:magic_test/feature/workoutList/repository/workout_list_repository.dart';
import 'package:magic_test/router/router.dart';

void main() async {
  await HiveService.init();
  runApp(
    BlocProvider(
      create: (_) =>
          WorkoutListBloc(WorkoutRepository(HiveService.workoutsBox))
            ..add(LoadWorkouts()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Workout Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: appRouter,
    );
  }
}
