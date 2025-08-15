class WorkoutSet {
  final String exercise;

  final double weight;

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
