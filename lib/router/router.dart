import 'package:go_router/go_router.dart';
import 'package:magic_test/feature/workout/screen/workout_screen.dart';
import 'package:magic_test/feature/workoutList/screen/workout_list_screen.dart';
import 'package:magic_test/models/workout.dart';
import 'package:uuid/uuid.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const WorkoutListScreen()),
    GoRoute(
      path: '/workout',
      builder: (context, state) {
        // Handle null case and provide a default workout
        final workout = state.extra as Workout?;
        if (workout == null) {
          return WorkoutScreen(
            workout: Workout(
              id: const Uuid().v4(),
              date: DateTime.now(),
              sets: [],
            ),
          );
        }
        return WorkoutScreen(workout: workout);
      },
    ),
  ],
);
