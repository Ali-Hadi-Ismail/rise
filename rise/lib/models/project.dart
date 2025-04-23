import 'package:rise/models/task.dart';

class Project {
  List<Task> tasks = [];
  String title = '';

  String description = '';
  int deadline = 0;
  int priority = 0;
  int progress = 0;
  int id = 0;
  Project(String title, String description, int deadline, int priority) {
    this.title = title;
    this.description = description;
    this.deadline = deadline;
    this.priority = priority;
  }
}
