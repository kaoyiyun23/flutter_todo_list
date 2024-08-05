import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';

class UserDaoLocalFile {
  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getLocalFile() async {
    final path = await _getLocalPath();
    return File('$path/user.json');
  }

  Future<User> readUser() async {
    try {
      final file = await _getLocalFile();
      final contents = await file.readAsString();
      final jsonData = jsonDecode(contents);
      return User.fromJson(jsonData);
    } catch (e) {
      return User(totalTodos: 0, completedTodos: 0);
    }
  }

  Future<File> writeUser(User user) async {
    final file = await _getLocalFile();
    return file.writeAsString(jsonEncode(user.toJson()));
  }
}
