import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magic_test/feature/workoutList/bloc/workout_list_bloc.dart';
import 'package:magic_test/feature/workoutList/screen/workout_list_screen.dart';
import 'package:magic_test/models/workout.dart';
import 'package:magic_test/models/workout_set.dart';
import 'package:mocktail/mocktail.dart';

class MockWorkoutListBloc extends Mock implements WorkoutListBloc {}

void main() {
  late MockWorkoutListBloc mockBloc;

  Workout buildWorkout({String id = 'w1'}) => Workout(
    id: id,
    date: DateTime(2025, 1, 1),
    sets: [WorkoutSet(exercise: 'Squat', weight: 140, repetitions: 3)],
  );

  setUp(() {
    mockBloc = MockWorkoutListBloc();

    when(
      () => mockBloc.stream,
    ).thenAnswer((_) => Stream.value(WorkoutListInitial()));
    when(() => mockBloc.state).thenReturn(WorkoutListInitial());

    // Register fallback values for common types
    registerFallbackValue(WorkoutListInitial());
    registerFallbackValue(LoadWorkouts());
    registerFallbackValue(AddWorkout(buildWorkout()));
    registerFallbackValue(UpdateWorkout(buildWorkout()));
    registerFallbackValue(DeleteWorkout('w1'));
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<WorkoutListBloc>.value(
        value: mockBloc,
        child: const WorkoutListScreen(),
      ),
    );
  }

  group('WorkoutListScreen', () {
    testWidgets('shows loading indicator when state is WorkoutListLoading', (
      tester,
    ) async {
      when(
        () => mockBloc.stream,
      ).thenAnswer((_) => Stream.value(WorkoutListLoading()));
      when(() => mockBloc.state).thenReturn(WorkoutListLoading());

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
      'shows "No workouts yet" when state is WorkoutListSuccess with empty list',
      (tester) async {
        when(
          () => mockBloc.stream,
        ).thenAnswer((_) => Stream.value(const WorkoutListSuccess([])));
        when(() => mockBloc.state).thenReturn(const WorkoutListSuccess([]));

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.text('No workouts yet'), findsOneWidget);
      },
    );

    testWidgets(
      'shows workout list when state is WorkoutListSuccess with workouts',
      (tester) async {
        final workout = buildWorkout();
        when(
          () => mockBloc.stream,
        ).thenAnswer((_) => Stream.value(WorkoutListSuccess([workout])));
        when(() => mockBloc.state).thenReturn(WorkoutListSuccess([workout]));

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Debug: print what's actually being displayed
        print('Debug: Found widgets:');
        for (final widget in find.byType(Text).evaluate()) {
          print('  - ${widget.widget}');
        }

        // Test that workout data is displayed correctly
        expect(find.textContaining('Workout 1'), findsOneWidget);
        expect(find.textContaining('1 sets'), findsOneWidget);
      },
    );

    testWidgets('shows error message when state is WorkoutListFailure', (
      tester,
    ) async {
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.value(const WorkoutListFailure('Error message')),
      );
      when(
        () => mockBloc.state,
      ).thenReturn(const WorkoutListFailure('Error message'));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // The error message should be shown in a SnackBar
      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('shows workout data when workout exists', (tester) async {
      final workouts = [buildWorkout(id: 'w1'), buildWorkout(id: 'w2')];
      when(
        () => mockBloc.stream,
      ).thenAnswer((_) => Stream.value(WorkoutListSuccess(workouts)));
      when(() => mockBloc.state).thenReturn(WorkoutListSuccess(workouts));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Test that workout data is displayed correctly
      expect(find.textContaining('Workout 1'), findsOneWidget);
      expect(find.textContaining('Workout 2'), findsOneWidget);
      expect(find.textContaining('1 sets'), findsNWidgets(2));
    });
  });
}
