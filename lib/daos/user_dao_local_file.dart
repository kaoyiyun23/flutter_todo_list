import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';

//會讀寫更新本地users.json

class UserDaoLocalFile {
  //找出檔案路徑
  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //找出user.json檔案
  Future<File> _getLocalFile() async {
    final path = await _getLocalPath();
    return File('$path/user.json');
  }

  //讀取user.json檔案
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

  //寫入user.json檔案
  Future<File> writeUser(User user) async {
    final file = await _getLocalFile();
    return file.writeAsString(jsonEncode(user.toJson()));
  }
}
