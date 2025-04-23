class Note {
  String title = '';
  String content = '';
  int createdAt = 0;
  int id = 0;

  Note(String title, String content) {
    this.title = title;
    this.content = content;
    this.createdAt = DateTime.now().millisecondsSinceEpoch;
  }
}
