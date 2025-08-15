import 'package:go_router/go_router.dart';
import 'package:magic_test/feature/workout/screen/workout_screen.dart';
import 'package:magic_test/feature/workoutList/bloc/screen/workout_list_screen.dart';
import 'package:magic_test/models/workout.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const WorkoutListScreen()),
    GoRoute(
      path: '/workout',
      builder: (context, state) {
        // The workout should always be provided by the calling code
        final workout = state.extra as Workout;
        return WorkoutScreen(workout: workout);
      },
    ),
  ],
);
