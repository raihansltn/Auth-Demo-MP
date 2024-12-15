import 'package:flutter/material.dart';
import 'package:crud_app/models/todo.dart';
import 'package:crud_app/services/todo_service.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TodoService _todoService = TodoService();
  late Future<List<Todo>> _todos;
  @override
  void initState() {
    super.initState();
    _todos = _todoService.fetchTodos();
  }

// Pull to refresh handler
  Future<void> _refreshData() async {
    setState(() {
      _todos = _todoService.fetchTodos(); // Re-fetch todos on refresh
    });
  }

// Show add todo modal
  void _showAddTodoDialog() {
    final TextEditingController _titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Todo'),
          content: TextField(
            controller: _titleController,
            decoration: InputDecoration(hintText: 'Enter todo title'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  final newTodo = Todo(
                    id: DateTime.now().toString(),
                    title: _titleController.text,
                    completed: false,
                  );
                  _todoService.addTodo(newTodo); // Add todo
                  setState(() {
                    _todos = _todoService.fetchTodos(); // Re-fetch todos
                  });
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a title')),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

// Show edit todo modal
  void _showEditTodoDialog(Todo todo) {
    final TextEditingController _titleController =
        TextEditingController(text: todo.title);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Todo'),
          content: TextField(
            controller: _titleController,
            decoration: InputDecoration(hintText: 'Enter todo title'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  todo.title = _titleController.text; // Update title
                  _todoService.updateTodoTitle(todo); // Update todo
                  setState(() {
                    _todos = _todoService.fetchTodos(); // Re-fetch todos
                  });
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a title')),
                  );
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Todo List'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddTodoDialog, // Open modal when pressed
            tooltip: 'Add Todo',
          ),
        ],
      ),
      body: FutureBuilder<List<Todo>>(
        future: _todos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No todos available.'));
          }
          List<Todo> todos = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshData, // Trigger onRefresh when pulling
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return Dismissible(
                  key: Key(todo.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
// Delete todo when swiped
                    await _todoService.deleteTodo(todo.id);
                    setState(() {
                      _todos = _todoService.fetchTodos(); // Re-fetch todos
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Todo berhasil di hapus!')),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(todo.title),
                    leading: Checkbox(
                      value: todo.completed,
                      onChanged: (bool? value) {
                        setState(() {
                          todo.completed = value!;
                        });
                        _todoService.updateTodoTitle(todo);
                      },
                    ),
                    onTap: () {
                      _showEditTodoDialog(todo); // Show edit modal
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
