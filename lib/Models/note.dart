class Note {
  int? id;
  String title, noteDescription;
  DateTime createdAt;

  Note({
    this.id,
    required this.title,
    required this.noteDescription,
    required this.createdAt
});

  Map<String, Object?> toMap() {
    return {
      'title': title,
      'noteDescription': noteDescription,
      'createdAt':createdAt.toString()
    };
  }
}