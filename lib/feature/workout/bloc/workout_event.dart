part of 'workout_bloc.dart';

sealed class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object> get props => [];
}

class AddSet extends WorkoutEvent {
  final WorkoutSet set;
  const AddSet(this.set);

  @override
  List<Object> get props => [set];
}

class UpdateSet extends WorkoutEvent {
  final int index;
  final WorkoutSet updated;
  const UpdateSet(this.index, this.updated);

  @override
  List<Object> get props => [index, updated];
}

class RemoveSet extends WorkoutEvent {
  final int index;
  const RemoveSet(this.index);

  @override
  List<Object> get props => [index];
}

class SaveWorkout extends WorkoutEvent {}
