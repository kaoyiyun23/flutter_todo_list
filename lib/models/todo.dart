//todo的屬性要有狀態，描述，新增時間，完成時間
//前面三個屬性是必要的

class Todo {
  //Todo的屬性
  String status;
  String description;
  DateTime creationTime;
  DateTime? completionTime;

  //建構子
  Todo({
    required this.status,
    required this.description,
    required this.creationTime,
    this.completionTime,
  });

  //建構子，將json資料轉為Todo
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      status: json['status'],
      description: json['description'],
      creationTime: DateTime.parse(json['creationTime']),
      completionTime: json['completionTime'] != null ? DateTime.parse(json['completionTime']) : null,
    );
  }

  //將Todo轉為json
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'description': description,
      'creationTime': creationTime.toIso8601String(),
      'completionTime': completionTime?.toIso8601String(),
    };
  }
}
