import 'package:hive/hive.dart';

part 'workout_set.g.dart';

@HiveType(typeId: 0)
class WorkoutSet {
  @HiveField(0)
  final String exercise;

  @HiveField(1)
  final double weight;

  @HiveField(2)
  final int repetitions;

  WorkoutSet({
    required this.exercise,
    required this.weight,
    required this.repetitions,
  });

  WorkoutSet copyWith({String? exercise, double? weight, int? repetitions}) {
    return WorkoutSet(
      exercise: exercise ?? this.exercise,
      weight: weight ?? this.weight,
      repetitions: repetitions ?? this.repetitions,
    );
  }
}
