import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_test/core/const.dart';
import 'package:magic_test/feature/workout/bloc/workout_bloc.dart';
import 'package:magic_test/feature/workoutList/bloc/workout_list_bloc.dart';
import 'package:magic_test/models/workout.dart';
import 'package:magic_test/models/workout_set.dart';

class WorkoutScreen extends StatefulWidget {
  final Workout workout;
  const WorkoutScreen({super.key, required this.workout});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late String selectedExercise;
  late double selectedWeight;
  late int selectedRepetitions;

  @override
  void initState() {
    selectedExercise = Constants.exerciseList[0];
    selectedWeight = Constants.weightOptions[0];
    selectedRepetitions = Constants.repetitionOptions[0];
    super.initState();
  }

  void _showEditDialog(BuildContext parentContext, int index, WorkoutSet set) {
    // Initialize dialog values
    String localExercise = set.exercise;
    double localWeight = set.weight;
    int localRepetitions = set.repetitions;

    showDialog(
      context: parentContext,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext dialogContext, StateSetter setState) {
            return AlertDialog(
              title: const Text('Edit Set'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    key: const ValueKey('exercise'),
                    value: localExercise,
                    items: Constants.exerciseList
                        .map(
                          (exercise) => DropdownMenuItem(
                            value: exercise,
                            child: Text(exercise),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        localExercise = value!;
                      });
                    },
                  ),
                  DropdownButton<double>(
                    key: const ValueKey('weight'),
                    value: localWeight,
                    items: Constants.weightOptions
                        .map(
                          (weight) => DropdownMenuItem(
                            value: weight,
                            child: Text('$weight kg'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        localWeight = value!;
                      });
                    },
                  ),
                  DropdownButton<int>(
                    key: const ValueKey('repetitions'),
                    value: localRepetitions,
                    items: Constants.repetitionOptions
                        .map(
                          (reps) => DropdownMenuItem(
                            value: reps,
                            child: Text('$reps repetitions'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        localRepetitions = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    dialogContext.pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  key: const ValueKey('saveButton'),
                  onPressed: () {
                    parentContext.read<WorkoutBloc>().add(
                      UpdateSet(
                        index,
                        WorkoutSet(
                          exercise: localExercise,
                          weight: localWeight,
                          repetitions: localRepetitions,
                        ),
                      ),
                    );

                    dialogContext.pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkoutBloc(widget.workout),
      child: BlocConsumer<WorkoutBloc, WorkoutState>(
        listener: (context, state) {
          if (state is WorkoutSaveFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is WorkoutSaveSuccess) {
            final workoutToSave = state.workout;
            final listBloc = context.read<WorkoutListBloc>();
            final exists =
                listBloc.state is WorkoutListSuccess &&
                (listBloc.state as WorkoutListSuccess).workouts.any(
                  (w) => w.id == workoutToSave.id,
                );
            if (exists) {
              listBloc.add(UpdateWorkout(workoutToSave));
            } else {
              listBloc.add(AddWorkout(workoutToSave));
            }
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(Constants.workoutScreen),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    context.read<WorkoutBloc>().add(SaveWorkout());
                  },
                ),
              ],
            ),

            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(Constants.selectAnExercise),
                      DropdownButton<String>(
                        value: selectedExercise,
                        items: Constants.exerciseList
                            .map(
                              (exercise) => DropdownMenuItem(
                                value: exercise,
                                child: Text(exercise),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedExercise = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Select a weight:"),
                      DropdownButton<double>(
                        value: selectedWeight,
                        items: Constants.weightOptions
                            .map(
                              (weight) => DropdownMenuItem(
                                value: weight,
                                child: Text("$weight kg"),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedWeight = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Select repetitions:"),
                      DropdownButton<int>(
                        value: selectedRepetitions,
                        items: Constants.repetitionOptions
                            .map(
                              (reps) => DropdownMenuItem(
                                value: reps,
                                child: Text("$reps"),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRepetitions = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WorkoutBloc>().add(
                        AddSet(
                          WorkoutSet(
                            exercise: selectedExercise,
                            weight: selectedWeight,
                            repetitions: selectedRepetitions,
                          ),
                        ),
                      );
                    },
                    child: const Text(Constants.addSet),
                  ),
                  const SizedBox(height: 20.0),
                  const Divider(height: 5),
                  state is WorkoutSaving
                      ? SizedBox(
                          height: 100,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : state is WorkoutInitial
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: widget.workout.sets.length,
                            itemBuilder: (BuildContext context, int index) {
                              var set = widget.workout.sets[index];
                              return ListTile(
                                title: Text(
                                  'Set ${index + 1}: ${set.exercise}',
                                ),
                                subtitle: Text(
                                  "${set.weight}kg, ${set.repetitions} reps",
                                ),
                                trailing: SizedBox(
                                  height: 60,
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          _showEditDialog(
                                            context,
                                            index,
                                            widget.workout.sets[index],
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          context.read<WorkoutBloc>().add(
                                            RemoveSet(index),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : state is WorkoutEditing
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: state.workout.sets.length,
                            itemBuilder: (BuildContext context, int index) {
                              var set = state.workout.sets[index];
                              return ListTile(
                                title: Text(
                                  'Set ${index + 1}: ${set.exercise}',
                                ),
                                subtitle: Text(
                                  "${set.weight}kg, ${set.repetitions} reps",
                                ),
                                trailing: SizedBox(
                                  height: 60,
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          _showEditDialog(
                                            context,
                                            index,
                                            state.workout.sets[index],
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          context.read<WorkoutBloc>().add(
                                            RemoveSet(index),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
