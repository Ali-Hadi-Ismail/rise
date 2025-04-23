class Task {
  late String title;
  bool isCompleted = false;
  late String description;
  late int deadline;

  Task(String title, bool isCompleted, String description) {
    this.description = description;
    this.title = title;
    this.isCompleted = isCompleted;
  }
}
