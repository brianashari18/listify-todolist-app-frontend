class SubTask {
  final int id;
  final String taskData;
  final String deadline;
  final String status;
  final int taskId;

  SubTask({
    required this.id,
    required this.taskData,
    required this.deadline,
    required this.status,
    required this.taskId
  });

  factory SubTask.fromJson(Map<String, dynamic> json) {
    String date;
    try {
      String isoDate = json['deadline'];

      DateTime dateTime = DateTime.parse(isoDate);

      String day = dateTime.day.toString().padLeft(2, '0');
      String month = dateTime.month.toString().padLeft(2, '0');
      String year = dateTime.year.toString();
      date = '$day/$month/$year';
    } catch (e) {
      throw FormatException("Invalid ISO date format: ${json['deadline']}");
    }

    print('json: $json');

    return SubTask(
      id: json['subTaskId'] ?? json['id'],
      taskData: json['taskData'],
      deadline: date,
      status: json['status'],
      taskId: json['taskId']
    );
  }


  // Convert SubTask object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskData': taskData,
      'deadline': deadline,
      'status': status,
      'taskId': taskId
    };
  }

  String convertISOToFrontendDate(String isoDate) {
    try {
      DateTime dateTime = DateTime.parse(isoDate);

      String day = dateTime.day.toString().padLeft(2, '0');
      String month = dateTime.month.toString().padLeft(2, '0');
      String year = dateTime.year.toString();

      return '$day/$month/$year';
    } catch (e) {
      throw FormatException("Invalid ISO date format: $isoDate");
    }
  }
}
