part of 'workout_list_bloc.dart';

sealed class WorkoutListState extends Equatable {
  const WorkoutListState();
  
  @override
  List<Object> get props => [];
}

final class WorkoutListInitial extends WorkoutListState {}
