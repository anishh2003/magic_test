import 'package:hive_flutter/hive_flutter.dart';
import 'package:magic_test/models/workout.dart';
import 'package:magic_test/models/workout_set.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters in the correct order with matching type IDs
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(WorkoutSetAdapter()); // typeId: 0
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(WorkoutAdapter()); // typeId: 1
    }

    await Hive.openBox<Workout>('workouts');
  }

  static Box<Workout> get workoutsBox => Hive.box('workouts');
}
