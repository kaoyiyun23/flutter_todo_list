import '../models/todo.dart';
import '../models/user.dart';
import '../daos/todo_dao_local_file.dart';
import '../daos/user_dao_local_file.dart';

class WorkNoteService {
  final TodoDaoLocalFile _todoDao = TodoDaoLocalFile();
  final UserDaoLocalFile _userDao = UserDaoLocalFile();

  //新增todo
  //會去寫入todo.json和user.json
  Future<void> addTodo(Todo todo) async {
    final todos = await _todoDao.readTodos();
    todos.add(todo);
    await _todoDao.writeTodos(todos);

    final user = await _userDao.readUser();
    user.totalTodos++;
    await _userDao.writeUser(user);
  }

  //刪除todo
  //會去更新todo.json和user.json
  Future<void> deleteTodoAtIndex(int index) async {
    final todos = await _todoDao.readTodos();
    final todo = todos[index];
    todos.removeAt(index);
    await _todoDao.writeTodos(todos);

    final user = await _userDao.readUser();
    user.totalTodos--;
    if (todo.status == 'completed') {
      user.completedTodos--;
    }
    await _userDao.writeUser(user);
  }

  //更新todo的狀態
  //會去更新todo.json和user.json
  Future<void> updateTodoStatus(int index, String status) async {
    final todos = await _todoDao.readTodos();
    final todo = todos[index];
    todo.status = status;
    if (status == 'completed') {
      todo.completionTime = DateTime.now();
    }
    await _todoDao.writeTodos(todos);

    final user = await _userDao.readUser();
    if (status == 'completed') {
      user.completedTodos++;
    } else if (todo.status == 'pending') {
      user.completedTodos--;
    }
    await _userDao.writeUser(user);
  }
}
