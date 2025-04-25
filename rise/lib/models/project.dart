import 'package:rise/models/task.dart';

class Project {
  List<Task> tasks = [];
  String title = '';
  String description = '';
  late int id;
  Project(String title, String description) {
    this.title = title;
    this.description = description;
  }
}
