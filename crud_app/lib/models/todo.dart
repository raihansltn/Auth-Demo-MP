class Todo {
  final String id;
  String title;
  bool completed;
// Konstruktor untuk inisialisasi properti
  Todo({required this.id, required this.title, this.completed = false});
// Fungsi untuk mengubah data JSON menjadi objek Todo
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
// Fungsi untuk mengubah objek Todo menjadi format JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'completed': completed,
    };
  }
}
