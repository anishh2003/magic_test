import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:magic_test/feature/workoutList/bloc/workout_list_bloc.dart';
import 'package:magic_test/feature/workoutList/repository/workout_list_repository.dart';
import 'package:magic_test/models/workout.dart';
import 'package:magic_test/models/workout_set.dart';

void main() {
  late Box<Workout> box;
  late WorkoutRepository repository;

  Workout buildWorkout({String id = 'w1'}) => Workout(
    id: id,
    date: DateTime(2025, 1, 1),
    sets: [WorkoutSet(exercise: 'Squat', weight: 140, repetitions: 3)],
  );

  setUpAll(() async {
    // Use in-memory for tests
    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);
    Hive.registerAdapter(WorkoutAdapter());
    Hive.registerAdapter(WorkoutSetAdapter());
  });

  setUp(() async {
    box = await Hive.openBox<Workout>('workouts_test');
    repository = WorkoutRepository(box);
  });

  tearDown(() async {
    await box.clear();
    await box.close();
    await Hive.deleteBoxFromDisk('workouts_test');
  });

  group('WorkoutListBloc', () {
    blocTest<WorkoutListBloc, WorkoutListState>(
      'emits WorkoutListLoading then WorkoutListSuccess when LoadWorkouts is added',
      build: () => WorkoutListBloc(repository),
      seed: () {
        // Seed some data
        final w = buildWorkout(id: 'a');
        repository.saveWorkout(w);
        return WorkoutListInitial();
      },
      act: (bloc) => bloc.add(LoadWorkouts()),
      expect: () => [
        isA<WorkoutListLoading>(),
        isA<WorkoutListSuccess>().having(
          (state) => state.workouts.length,
          'workouts length',
          1,
        ),
      ],
      wait: const Duration(milliseconds: 1100), // Wait for the 1 second delay
    );

    blocTest<WorkoutListBloc, WorkoutListState>(
      'emits WorkoutListSuccess with appended workout when AddWorkout is added',
      build: () => WorkoutListBloc(repository),
      seed: () {
        // Load initial workouts first
        final w = buildWorkout(id: 'a');
        repository.saveWorkout(w);
        return WorkoutListSuccess([w]);
      },
      act: (bloc) => bloc.add(AddWorkout(buildWorkout(id: 'b'))),
      expect: () => [
        isA<WorkoutListSuccess>().having(
          (state) => state.workouts.any((w) => w.id == 'b'),
          'contains b',
          true,
        ),
      ],
      verify: (bloc) {
        expect(repository.getWorkouts().any((w) => w.id == 'b'), true);
      },
    );

    blocTest<WorkoutListBloc, WorkoutListState>(
      'emits WorkoutListSuccess with updated workout when UpdateWorkout is added',
      build: () => WorkoutListBloc(repository),
      seed: () {
        final initial = buildWorkout(id: 'x');
        repository.saveWorkout(initial);
        return WorkoutListSuccess([initial]);
      },
      act: (bloc) {
        final updated = Workout(
          id: 'x',
          date: DateTime(2025, 1, 1),
          sets: [WorkoutSet(exercise: 'Bench', weight: 110, repetitions: 5)],
        );
        bloc.add(UpdateWorkout(updated));
      },
      expect: () => [
        isA<WorkoutListSuccess>().having(
          (state) =>
              state.workouts.firstWhere((w) => w.id == 'x').sets.first.exercise,
          'updated exercise',
          'Bench',
        ),
      ],
      verify: (bloc) {
        final saved = repository.getWorkouts().firstWhere((w) => w.id == 'x');
        expect(saved.sets.first.exercise, 'Bench');
      },
    );

    blocTest<WorkoutListBloc, WorkoutListState>(
      'emits WorkoutListSuccess with workout removed when DeleteWorkout is added',
      build: () => WorkoutListBloc(repository),
      seed: () {
        final a = buildWorkout(id: 'a');
        final b = buildWorkout(id: 'b');
        repository.saveWorkout(a);
        repository.saveWorkout(b);
        return WorkoutListSuccess([a, b]);
      },
      act: (bloc) => bloc.add(DeleteWorkout('a')),
      expect: () => [
        isA<WorkoutListSuccess>().having(
          (state) => state.workouts.any((w) => w.id == 'a'),
          'contains a',
          false,
        ),
      ],
      verify: (bloc) {
        expect(repository.getWorkouts().any((w) => w.id == 'a'), false);
      },
    );

    test(
      'createEmptyWorkout creates workout with uuid and empty sets',
      () async {
        final bloc = WorkoutListBloc(repository);
        final w = bloc.createEmptyWorkout();
        expect(w.id.isNotEmpty, true);
        expect(w.sets, isEmpty);
      },
    );
  });
}
