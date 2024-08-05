import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../models/user.dart';
import '../daos/todo_dao_local_file.dart';
import '../daos/user_dao_local_file.dart';
import '../service/work_note_service.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TodoDaoLocalFile _todoDao = TodoDaoLocalFile();
  final UserDaoLocalFile _userDao = UserDaoLocalFile();
  final WorkNoteService _workNoteService = WorkNoteService();
  final TextEditingController _controller = TextEditingController();

  List<Todo> _todos = [];
  User _user = User(totalTodos: 0, completedTodos: 0);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final todos = await _todoDao.readTodos();
    final user = await _userDao.readUser();
    setState(() {
      _todos = todos;
      _user = user;
    });
  }

  void _addTodo() async {
    final description = _controller.text;
    if (description.isNotEmpty) {
      final newTodo = Todo(
        status: 'pending',
        description: description,
        creationTime: DateTime.now(),
      );
      _todos.add(newTodo);
      _user.totalTodos++;
      await _todoDao.writeTodos(_todos);
      await _userDao.writeUser(_user);
      _controller.clear();
      setState(() {});
    }
  }

  void _deleteTodo(int index) async {
    if (_todos[index].status == 'completed') {
      _user.completedTodos--;
    }
    _todos.removeAt(index);
    _user.totalTodos--;
    await _todoDao.writeTodos(_todos);
    await _userDao.writeUser(_user);
    setState(() {});
  }

  void _toggleTodoStatus(int index) async {
    final todo = _todos[index];
    if (todo.status == 'completed') {
      todo.status = 'pending';
      todo.completionTime = null;
      _user.completedTodos--;
    } else {
      todo.status = 'completed';
      todo.completionTime = DateTime.now();
      _user.completedTodos++;
    }
    await _todoDao.writeTodos(_todos);
    await _userDao.writeUser(_user);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter a new todo',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addTodo,
            child: Text('Add Todo'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return ListTile(
                  title: Text(todo.description),
                  leading: Checkbox(
                    value: todo.status == 'completed',
                    onChanged: (_) => _toggleTodoStatus(index),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteTodo(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Total Todos: ${_user.totalTodos}, Completed Todos: ${_user.completedTodos}'),
          ),
        ],
      ),
    );
  }
}
