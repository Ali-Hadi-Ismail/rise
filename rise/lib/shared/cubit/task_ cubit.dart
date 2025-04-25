import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rise/models/note.dart';
import 'package:rise/models/task.dart';
import 'package:rise/shared/cubit/task_state.dart';
import 'package:rise/shared/data/data_helper.dart';

class TaskCubit extends Cubit<TaskCubitStates> {
  TaskCubit() : super(TaskInitialState());

  static TaskCubit get(context) => BlocProvider.of(context);

  DataHelper dataHelper = DataHelper();
  List<Task> allTasks = [];
  List<Note> allNotes = [];
  List<Task> incompleteTasks = [];
  List<Task> completeTasks = [];

  Future<void> getAllTasks() async {
    emit(TaskLoadingState());
    try {
      final tasks = await dataHelper.getAllTasks();
      allTasks = tasks.map((task) => Task.fromMap(task)).toList();

      // Sort tasks into complete and incomplete
      incompleteTasks = allTasks.where((task) => !task.isCompleted).toList();
      completeTasks = allTasks.where((task) => task.isCompleted).toList();

      emit(TaskLoadedState());
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }

  Future<void> addTask(String title, String description) async {
    emit(TaskLoadingState());
    try {
      await dataHelper.insertTask(title, description);
      await getAllTasks(); // Refresh tasks after adding
      emit(TaskLoadedState());
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    emit(TaskLoadingState());
    try {
      // Toggle the isCompleted status
      final updatedTask = {
        'isCompleted': task.isCompleted ? 0 : 1,
      };

      await dataHelper.updateTask(task.id, updatedTask);
      await getAllTasks(); // Refresh tasks after updating
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }

  Future<void> deleteTask(int id) async {
    emit(TaskLoadingState());
    try {
      await dataHelper.deleteTask(id);
      await getAllTasks(); // Refresh tasks after deleting
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }
}
