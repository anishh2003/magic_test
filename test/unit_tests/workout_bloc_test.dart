import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magic_test/feature/workout/bloc/workout_bloc.dart';
import 'package:magic_test/models/workout.dart';
import 'package:magic_test/models/workout_set.dart';

void main() {
  Workout buildEmptyWorkout() =>
      Workout(id: 'w1', date: DateTime(2025, 1, 1), sets: []);

  WorkoutSet buildSet({
    String exercise = 'Bench Press',
    double weight = 100,
    int repetitions = 5,
  }) =>
      WorkoutSet(exercise: exercise, weight: weight, repetitions: repetitions);

  group('WorkoutBloc', () {
    test('initial state contains provided workout', () {
      final bloc = WorkoutBloc(buildEmptyWorkout());
      expect(bloc.state, isA<WorkoutInitial>());
    });

    blocTest<WorkoutBloc, WorkoutState>(
      'emits WorkoutEditing with appended set when AddSet is added',
      build: () => WorkoutBloc(buildEmptyWorkout()),
      act: (bloc) => bloc.add(AddSet(buildSet())),
      expect: () => [
        isA<WorkoutEditing>().having(
          (state) => state.workout.sets.length,
          'sets length',
          1,
        ),
      ],
    );

    blocTest<WorkoutBloc, WorkoutState>(
      'emits WorkoutEditing with updated set when UpdateSet is added',
      build: () => WorkoutBloc(buildEmptyWorkout()),
      seed: () => WorkoutEditing(
        Workout(id: 'w1', date: DateTime(2025, 1, 1), sets: [buildSet()]),
      ),
      act: (bloc) => bloc.add(UpdateSet(0, buildSet(weight: 120))),
      expect: () => [
        isA<WorkoutEditing>().having(
          (state) => state.workout.sets[0].weight,
          'updated weight',
          120,
        ),
      ],
    );

    blocTest<WorkoutBloc, WorkoutState>(
      'emits WorkoutEditing with item removed when RemoveSet is added',
      build: () => WorkoutBloc(buildEmptyWorkout()),
      seed: () => WorkoutEditing(
        Workout(id: 'w1', date: DateTime(2025, 1, 1), sets: [buildSet()]),
      ),
      act: (bloc) => bloc.add(RemoveSet(0)),
      expect: () => [
        isA<WorkoutEditing>().having(
          (state) => state.workout.sets.length,
          'sets length',
          0,
        ),
      ],
    );

    blocTest<WorkoutBloc, WorkoutState>(
      'emits WorkoutSaveFailure when SaveWorkout is added with no sets',
      build: () => WorkoutBloc(buildEmptyWorkout()),
      act: (bloc) => bloc.add(SaveWorkout()),
      expect: () => [
        isA<WorkoutSaveFailure>().having(
          (state) => state.message,
          'message',
          'Workout must have at least one set.',
        ),
      ],
    );

    blocTest<WorkoutBloc, WorkoutState>(
      'emits WorkoutSaving then WorkoutSaveSuccess when SaveWorkout is added with sets',
      build: () => WorkoutBloc(buildEmptyWorkout()),
      seed: () => WorkoutEditing(
        Workout(id: 'w1', date: DateTime(2025, 1, 1), sets: [buildSet()]),
      ),
      act: (bloc) => bloc.add(SaveWorkout()),
      expect: () => [isA<WorkoutSaving>(), isA<WorkoutSaveSuccess>()],
      wait: const Duration(milliseconds: 600), // Wait for the 500ms delay
    );
  });
}
