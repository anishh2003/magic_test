part of 'workout_bloc.dart';

sealed class WorkoutState extends Equatable {
  const WorkoutState();
  
  @override
  List<Object> get props => [];
}

final class WorkoutInitial extends WorkoutState {}
