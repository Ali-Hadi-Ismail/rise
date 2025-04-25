abstract class TaskCubitStates {}

class TaskInitialState extends TaskCubitStates {}

class TaskLoadingState extends TaskCubitStates {}

class TaskLoadedState extends TaskCubitStates {}

class TaskErrorState extends TaskCubitStates {
  final String error;
  TaskErrorState(this.error);
}
