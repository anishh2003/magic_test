import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'workout_list_event.dart';
part 'workout_list_state.dart';

class WorkoutListBloc extends Bloc<WorkoutListEvent, WorkoutListState> {
  WorkoutListBloc() : super(WorkoutListInitial()) {
    on<WorkoutListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
