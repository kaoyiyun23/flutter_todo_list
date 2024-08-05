class Todo {
  String status;
  String description;
  DateTime creationTime;
  DateTime? completionTime;

  Todo({
    required this.status,
    required this.description,
    required this.creationTime,
    this.completionTime,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      status: json['status'],
      description: json['description'],
      creationTime: DateTime.parse(json['creationTime']),
      completionTime: json['completionTime'] != null ? DateTime.parse(json['completionTime']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'description': description,
      'creationTime': creationTime.toIso8601String(),
      'completionTime': completionTime?.toIso8601String(),
    };
  }
}
