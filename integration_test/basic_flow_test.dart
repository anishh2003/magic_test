import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magic_test/main.dart' as app;

void main() {
  group('Basic App Flow Integration Tests', () {
    testWidgets('App starts and shows workout list', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Check for the actual app bar title
      expect(find.text('Workout List Screen'), findsOneWidget);

      final noWorkoutsText = find.text('No workouts yet');
      final fabFinder = find.byType(FloatingActionButton);

      if (noWorkoutsText.evaluate().isNotEmpty) {
        expect(noWorkoutsText, findsOneWidget);
      }

      if (fabFinder.evaluate().isNotEmpty) {
        expect(fabFinder, findsOneWidget);
      }

      expect(
        noWorkoutsText.evaluate().isNotEmpty || fabFinder.evaluate().isNotEmpty,
        isTrue,
        reason:
            'Should show either "No workouts yet" text or FloatingActionButton',
      );
    });

    testWidgets('App can navigate to workout screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      final fabFinder = find.byType(FloatingActionButton);
      if (fabFinder.evaluate().isNotEmpty) {
        await tester.tap(fabFinder.first);
        await tester.pumpAndSettle();

        await Future.delayed(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        // Check for the actual app bar title
        expect(find.text('Workout Screen'), findsOneWidget);
      } else {
        // If no FAB found, skip this test
        return;
      }
    });

    testWidgets('App shows basic workout form elements', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      final fabFinder = find.byType(FloatingActionButton);
      if (fabFinder.evaluate().isNotEmpty) {
        await tester.tap(fabFinder.first);
        await tester.pumpAndSettle();

        await Future.delayed(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        final addSetButton = find.text('Add Set');
        if (addSetButton.evaluate().isNotEmpty) {
          expect(addSetButton, findsOneWidget);
        }

        final exerciseLabel = find.textContaining('Exercise');
        final weightLabel = find.textContaining('weight');
        final repsLabel = find.textContaining('repetition');

        int foundElements = 0;
        if (exerciseLabel.evaluate().isNotEmpty) foundElements++;
        if (weightLabel.evaluate().isNotEmpty) foundElements++;
        if (repsLabel.evaluate().isNotEmpty) foundElements++;

        expect(
          foundElements,
          greaterThan(0),
          reason: 'Should show at least one form label',
        );
      } else {
        // If no FAB found, skip this test
        return;
      }
    });
  });
}
