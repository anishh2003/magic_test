import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magic_test/models/workout.dart';
import 'package:uuid/uuid.dart';
part 'workout_list_event.dart';
part 'workout_list_state.dart';

class WorkoutListBloc extends Bloc<WorkoutListEvent, WorkoutListState> {
  WorkoutListBloc() : super(WorkoutListInitial()) {
    on<LoadWorkouts>(_onLoad);
    on<AddWorkout>(_onAdd);
    on<UpdateWorkout>(_onUpdate);
    on<DeleteWorkout>(_onDelete);
  }

  Future<void> _onLoad(
    LoadWorkouts event,
    Emitter<WorkoutListState> emit,
  ) async {
    late List<Workout> storedWorkouts;

    if (state is WorkoutListInitial) {
      emit(WorkoutListLoading());
      await Future.delayed(const Duration(milliseconds: 1000));
      //TODO : fill this with repo workouts
      storedWorkouts = [];
    }
    emit(WorkoutListSuccess([...storedWorkouts]));
  }

  void _onAdd(AddWorkout event, Emitter<WorkoutListState> emit) {
    if (state is WorkoutListSuccess) {
      final current = (state as WorkoutListSuccess).workouts;
      emit(WorkoutListSuccess([...current, event.workout]));
    }
  }

  void _onUpdate(UpdateWorkout event, Emitter<WorkoutListState> emit) {
    if (state is WorkoutListSuccess) {
      final updatedList = (state as WorkoutListSuccess).workouts
          .map((w) => w.id == event.workout.id ? event.workout : w)
          .toList();
      emit(WorkoutListSuccess(updatedList));
    }
  }

  void _onDelete(DeleteWorkout event, Emitter<WorkoutListState> emit) {
    if (state is WorkoutListSuccess) {
      final updatedList = (state as WorkoutListSuccess).workouts
          .where((w) => w.id != event.id)
          .toList();
      emit(WorkoutListSuccess(updatedList));
    }
  }

  Workout createEmptyWorkout() {
    return Workout(id: const Uuid().v4(), sets: [], date: DateTime.now());
  }
}
