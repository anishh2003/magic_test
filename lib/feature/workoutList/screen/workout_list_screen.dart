import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_test/core/const.dart';
import 'package:magic_test/feature/workoutList/bloc/workout_list_bloc.dart';

class WorkoutListScreen extends StatelessWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Constants.workoutListScreen)),
      body: BlocConsumer<WorkoutListBloc, WorkoutListState>(
        listener: (context, state) {
          if (state is WorkoutListFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          if (state is WorkoutListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkoutListSuccess) {
            if (state.workouts.isEmpty) {
              return const Center(child: Text(Constants.noWorkoutsYet));
            }
            return ListView.builder(
              itemCount: state.workouts.length,
              itemBuilder: (context, index) {
                final workout = state.workouts[index];
                return ListTile(
                  title: Text("Workout ${index + 1} on ${workout.date}"),
                  subtitle: Text("${workout.sets.length} sets"),
                  onTap: () => context.push('/workout', extra: workout),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => context.read<WorkoutListBloc>().add(
                      DeleteWorkout(workout.id),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final bloc = context.read<WorkoutListBloc>();

          if (bloc.state is WorkoutListSuccess ||
              bloc.state is WorkoutListInitial) {
            final newWorkout = bloc.createEmptyWorkout();
            context.push('/workout', extra: newWorkout);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(Constants.waitforWorkoutsToLoad)),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
