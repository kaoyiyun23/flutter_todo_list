class User {
  int totalTodos;
  int completedTodos;

  User({
    required this.totalTodos,
    required this.completedTodos,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      totalTodos: json['totalTodos'],
      completedTodos: json['completedTodos'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalTodos': totalTodos,
      'completedTodos': completedTodos,
    };
  }
}
