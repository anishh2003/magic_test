import 'package:hive_flutter/hive_flutter.dart';
import 'package:magic_test/models/workout.dart';

class WorkoutRepository {
  final Box<Workout> box;

  WorkoutRepository(this.box);

  List<Workout> getWorkouts() {
    return box.values.toList();
  }

  void saveWorkout(Workout workout) {
    box.put(workout.id, workout);
  }

  void deleteWorkout(String id) async {
    await box.delete(id);
  }
}
