part of 'workout_bloc.dart';

sealed class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object> get props => [];
}

abstract class WorkoutWithData extends WorkoutState {
  final Workout workout;

  const WorkoutWithData(this.workout);

  @override
  List<Object> get props => [workout];
}

class WorkoutInitial extends WorkoutWithData {
  const WorkoutInitial(super.workout);
}

class WorkoutEditing extends WorkoutWithData {
  const WorkoutEditing(super.workout);
}

class WorkoutSaving extends WorkoutWithData {
  const WorkoutSaving(super.workout);
}

class WorkoutSaveSuccess extends WorkoutWithData {
  const WorkoutSaveSuccess(super.workout);
}

class WorkoutSaveFailure extends WorkoutWithData {
  final String message;

  const WorkoutSaveFailure(super.workout, this.message);

  @override
  List<Object> get props => super.props..add(message);
}
