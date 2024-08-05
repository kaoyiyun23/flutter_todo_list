//user的屬性要有總共幾個todo,  目前完成幾個todo

class User {
  //User屬性
  int totalTodos;
  int completedTodos;

  //建構子
  User({
    required this.totalTodos,
    required this.completedTodos,
  });

  //建構子，將json轉為json
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      totalTodos: json['totalTodos'],
      completedTodos: json['completedTodos'],
    );
  }

  //將User轉為json
  Map<String, dynamic> toJson() {
    return {
      'totalTodos': totalTodos,
      'completedTodos': completedTodos,
    };
  }
}
