part of 'workout_list_bloc.dart';

sealed class WorkoutListState extends Equatable {
  const WorkoutListState();

  @override
  List<Object> get props => [];
}

final class WorkoutListInitial extends WorkoutListState {}

final class WorkoutListLoading extends WorkoutListState {}

final class WorkoutListSuccess extends WorkoutListState {
  final List<Workout> workouts;

  const WorkoutListSuccess(this.workouts);

  @override
  List<Object> get props => [workouts];
}

final class WorkoutListFailure extends WorkoutListState {
  final String errorMessage;

  const WorkoutListFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
