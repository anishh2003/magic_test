part of 'workout_list_bloc.dart';

sealed class WorkoutListEvent extends Equatable {
  const WorkoutListEvent();

  @override
  List<Object> get props => [];
}

class LoadWorkouts extends WorkoutListEvent {}

class AddWorkout extends WorkoutListEvent {
  final Workout workout;
  const AddWorkout(this.workout);

  @override
  List<Object> get props => [workout];
}

class UpdateWorkout extends WorkoutListEvent {
  final Workout workout;
  const UpdateWorkout(this.workout);

  @override
  List<Object> get props => [workout];
}

class DeleteWorkout extends WorkoutListEvent {
  final String id;
  const DeleteWorkout(this.id);

  @override
  List<Object> get props => [id];
}
