import 'package:hive/hive.dart';
import 'package:magic_test/models/workout_set.dart';

part 'workout.g.dart';

@HiveType(typeId: 1)
class Workout {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
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
