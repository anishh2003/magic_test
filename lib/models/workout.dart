import 'package:magic_test/models/workout_set.dart';

class Workout {
  final String id;

  final DateTime date;

  final List<WorkoutSet> sets;

  Workout({required this.id, required this.date, required this.sets});

  Workout copyWith({String? id, DateTime? date, List<WorkoutSet>? sets}) {
    return Workout(
      id: id ?? this.id,
      date: date ?? this.date,
      sets: sets ?? this.sets,
    );
  }
}
