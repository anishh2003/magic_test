import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magic_test/models/workout.dart';
import 'package:magic_test/models/workout_set.dart';

part 'workout_event.dart';
part 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  WorkoutBloc(Workout workout) : super(WorkoutInitial(workout)) {
    on<AddSet>(_onAddSet);
    on<UpdateSet>(_onUpdateSet);
    on<RemoveSet>(_onRemoveSet);
    on<SaveWorkout>(_onSaveWorkout);
  }

  void _onAddSet(AddSet event, Emitter<WorkoutState> emit) {
    final currentWorkout = _getCurrentWorkout();
    final updatedSets = [
      ...currentWorkout.sets,
      WorkoutSet(
        exercise: event.set.exercise,
        weight: event.set.weight,
        repetitions: event.set.repetitions,
      ),
    ];
    emit(WorkoutEditing(currentWorkout.copyWith(sets: updatedSets)));
  }

  void _onUpdateSet(UpdateSet event, Emitter<WorkoutState> emit) {
    final currentWorkout = _getCurrentWorkout();
    final updatedSets = List<WorkoutSet>.from(currentWorkout.sets);
    updatedSets[event.index] = event.updated;
    emit(WorkoutEditing(currentWorkout.copyWith(sets: updatedSets)));
  }

  void _onRemoveSet(RemoveSet event, Emitter<WorkoutState> emit) {
    final currentWorkout = _getCurrentWorkout();
    final updatedSets = List<WorkoutSet>.from(currentWorkout.sets)
      ..removeAt(event.index);
    emit(WorkoutEditing(currentWorkout.copyWith(sets: updatedSets)));
  }

  Future<void> _onSaveWorkout(
    SaveWorkout event,
    Emitter<WorkoutState> emit,
  ) async {
    final currentWorkout = _getCurrentWorkout();

    // Here validation can be added in
    if (currentWorkout.sets.isEmpty) {
      emit(
        WorkoutSaveFailure(
          currentWorkout,
          "Workout must have at least one set.",
        ),
      );
      return;
    }

    emit(WorkoutSaving(currentWorkout));
    await Future.delayed(const Duration(milliseconds: 500)); // simulate save

    emit(WorkoutSaveSuccess(currentWorkout));
  }

  Workout _getCurrentWorkout() {
    if (state is WorkoutWithData) {
      return (state as WorkoutWithData).workout;
    }
    throw Exception("Invalid state for workout data");
  }
}
