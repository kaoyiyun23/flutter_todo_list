import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../models/user.dart';
import '../daos/todo_dao_local_file.dart';
import '../daos/user_dao_local_file.dart';
import '../service/work_note_service.dart';

//todo的一覽頁
//使用StatefulWidget來讓畫面可以刷新

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TodoDaoLocalFile _todoDao = TodoDaoLocalFile();
  final UserDaoLocalFile _userDao = UserDaoLocalFile();
  final WorkNoteService _workNoteService = WorkNoteService();

  //設定文字輸入框的控制器
  final TextEditingController _controller = TextEditingController();

  //設定初始值
  List<Todo> _todos = [];
  User _user = User(totalTodos: 0, completedTodos: 0);

  //每次刷新都去重新讀取todo.json和user.json
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  //讀取todo.json和user.json
  Future<void> _loadData() async {
    final todos = await _todoDao.readTodos();
    final user = await _userDao.readUser();
    setState(() {
      _todos = todos;
      _user = user;
    });
  }

  //新增todo
  //會去寫入todo.json和user.json
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
      _workNoteService.addTodo(newTodo);
      /* await _todoDao.writeTodos(_todos);
      await _userDao.writeUser(_user); */
      _controller.clear();
      setState(() {});
    }
  }

  //刪除todo
  //會去更新todo.json和user.json
  void _deleteTodo(int index) async {
    //判斷是否有加入已完成的todo數量
    if (_todos[index].status == 'completed') {
      _user.completedTodos--;
    }
    _todos.removeAt(index);
    _user.totalTodos--;
    _workNoteService.deleteTodoAtIndex(index);
    /* await _todoDao.writeTodos(_todos);
    await _userDao.writeUser(_user); */
    setState(() {});
  }

  //更新todo的狀態
  //會去更新todo.json和user.json
  void _toggleTodoStatus(int index) async {
    final todo = _todos[index];
    //判斷勾選與否，更新完成數量
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
                  title: Text(
                    todo.description,
                    style: (todo.status == true) ? TextStyle(decoration: TextDecoration.lineThrough): TextStyle(),
                  ),
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
