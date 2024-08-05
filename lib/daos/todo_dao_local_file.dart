import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/todo.dart';

//會讀寫更新本地todos.json

class TodoDaoLocalFile {
  //找出檔案路徑
  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //找出todo.json檔案
  Future<File> _getLocalFile() async {
    final path = await _getLocalPath();
    return File('$path/todo.json');
  }

  //讀取todo.json檔案
  Future<List<Todo>> readTodos() async {
    try {
      final file = await _getLocalFile();
      final contents = await file.readAsString();
      List<dynamic> jsonData = jsonDecode(contents);
      return jsonData.map((json) => Todo.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  //寫入todo.json檔案
  Future<File> writeTodos(List<Todo> todos) async {
    final file = await _getLocalFile();
    return file.writeAsString(jsonEncode(todos.map((todo) => todo.toJson()).toList()));
  }
}
