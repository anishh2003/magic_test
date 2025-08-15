import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magic_test/feature/workout/bloc/workout_bloc.dart';
import 'package:magic_test/feature/workout/screen/workout_screen.dart';
import 'package:magic_test/feature/workoutList/bloc/workout_list_bloc.dart';
import 'package:magic_test/models/workout.dart';
import 'package:magic_test/models/workout_set.dart';
import 'package:mocktail/mocktail.dart';

class MockWorkoutBloc extends Mock implements WorkoutBloc {}

class MockWorkoutListBloc extends Mock implements WorkoutListBloc {}

void main() {
  late MockWorkoutBloc mockWorkoutBloc;
  late MockWorkoutListBloc mockWorkoutListBloc;

  Workout buildEmptyWorkout() =>
      Workout(id: 'w1', date: DateTime(2025, 1, 1), sets: []);

  Workout buildWorkoutWithSets() => Workout(
    id: 'w1',
    date: DateTime(2025, 1, 1),
    sets: [
      WorkoutSet(exercise: 'Bench Press', weight: 100, repetitions: 5),
      WorkoutSet(exercise: 'Squat', weight: 140, repetitions: 3),
    ],
  );

  setUp(() {
    mockWorkoutBloc = MockWorkoutBloc();
    mockWorkoutListBloc = MockWorkoutListBloc();

    // Mock both stream and state properties
    when(
      () => mockWorkoutBloc.stream,
    ).thenAnswer((_) => Stream.value(WorkoutInitial(buildEmptyWorkout())));
    when(
      () => mockWorkoutBloc.state,
    ).thenReturn(WorkoutInitial(buildEmptyWorkout()));

    when(
      () => mockWorkoutListBloc.stream,
    ).thenAnswer((_) => Stream.value(WorkoutListInitial()));
    when(() => mockWorkoutListBloc.state).thenReturn(WorkoutListInitial());

    // Mock the createEmptyWorkout method
    when(
      () => mockWorkoutListBloc.createEmptyWorkout(),
    ).thenReturn(buildEmptyWorkout());

    // Register fallback values
    registerFallbackValue(WorkoutInitial(buildEmptyWorkout()));
    registerFallbackValue(AddSet(buildWorkoutWithSets().sets.first));
    registerFallbackValue(UpdateSet(0, buildWorkoutWithSets().sets.first));
    registerFallbackValue(RemoveSet(0));
    registerFallbackValue(SaveWorkout());
  });

  Widget createTestWidget({Workout? workout}) {
    final testWorkout = workout ?? buildEmptyWorkout();
    return MaterialApp(
      home: BlocProvider<WorkoutListBloc>.value(
        value: mockWorkoutListBloc,
        child: BlocProvider<WorkoutBloc>.value(
          value: mockWorkoutBloc,
          child: WorkoutScreen(workout: testWorkout),
        ),
      ),
    );
  }

  group('WorkoutScreen', () {
    testWidgets('shows correct app bar title and save button', (tester) async {
      when(
        () => mockWorkoutBloc.stream,
      ).thenAnswer((_) => Stream.value(WorkoutInitial(buildEmptyWorkout())));
      when(
        () => mockWorkoutBloc.state,
      ).thenReturn(WorkoutInitial(buildEmptyWorkout()));

      await tester.pumpWidget(createTestWidget());

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      expect(find.text('Workout Screen'), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets('shows exercise, weight, and repetition dropdowns', (
      tester,
    ) async {
      when(
        () => mockWorkoutBloc.stream,
      ).thenAnswer((_) => Stream.value(WorkoutInitial(buildEmptyWorkout())));
      when(
        () => mockWorkoutBloc.state,
      ).thenReturn(WorkoutInitial(buildEmptyWorkout()));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Select an Exercise:'), findsOneWidget);
      expect(find.text('Select a weight:'), findsOneWidget);
      expect(find.text('Select repetitions:'), findsOneWidget);
      // Note: Only testing that dropdowns exist, not counting them
      expect(find.byType(DropdownButton<String>), findsWidgets);
    });

    testWidgets('shows "Add Set" button', (tester) async {
      when(
        () => mockWorkoutBloc.stream,
      ).thenAnswer((_) => Stream.value(WorkoutInitial(buildEmptyWorkout())));
      when(
        () => mockWorkoutBloc.state,
      ).thenReturn(WorkoutInitial(buildEmptyWorkout()));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Add Set'), findsOneWidget);
    });

    testWidgets('shows edit and delete buttons for each set', (tester) async {
      final workout = buildWorkoutWithSets();
      when(
        () => mockWorkoutBloc.stream,
      ).thenAnswer((_) => Stream.value(WorkoutInitial(workout)));
      when(() => mockWorkoutBloc.state).thenReturn(WorkoutInitial(workout));

      await tester.pumpWidget(createTestWidget(workout: workout));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsWidgets);
      expect(find.byIcon(Icons.delete), findsWidgets);
    });

    testWidgets('handles empty workout correctly', (tester) async {
      final emptyWorkout = buildEmptyWorkout();
      when(
        () => mockWorkoutBloc.stream,
      ).thenAnswer((_) => Stream.value(WorkoutInitial(emptyWorkout)));
      when(
        () => mockWorkoutBloc.state,
      ).thenReturn(WorkoutInitial(emptyWorkout));

      await tester.pumpWidget(createTestWidget(workout: emptyWorkout));
      await tester.pumpAndSettle();

      // Should not show any sets
      expect(find.text('Set 1:'), findsNothing);
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('shows form labels correctly', (tester) async {
      when(
        () => mockWorkoutBloc.stream,
      ).thenAnswer((_) => Stream.value(WorkoutInitial(buildEmptyWorkout())));
      when(
        () => mockWorkoutBloc.state,
      ).thenReturn(WorkoutInitial(buildEmptyWorkout()));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Select an Exercise:'), findsOneWidget);
      expect(find.text('Select a weight:'), findsOneWidget);
      expect(find.text('Select repetitions:'), findsOneWidget);
    });
  });
}
