class SubTask {
  final int id;
  final String taskData;
  final String deadline;
  final String status;
  final bool done;

  SubTask({
    required this.id,
    required this.taskData,
    required this.deadline,
    required this.status,
    required this.done,
  });

  // Convert JSON to SubTask object
  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      id: json['id'],
      taskData: json['taskData'],
      deadline: json['deadline'],
      status: json['status'],
      done: json['done'] ?? false, // Default to false if null
    );
  }

  // Convert SubTask object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskData': taskData,
      'deadline': deadline,
      'status': status,
      'done': done,
    };
  }
}
