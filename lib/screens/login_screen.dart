import 'package:flutter/material.dart';

//登入頁面

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, "/todolist");
        },
        child: Text("登入")
      )
    );
  }
}