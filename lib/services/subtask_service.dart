import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class SubTaskService {
  final String _baseUrl = "http://172.20.10.3:8080/api";

  Future<Map<String, dynamic>> fetchSubTasks(User user, int taskId) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/tasks/$taskId/subtask"),
        headers: {'Authorization': user.token},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data['data'],
        };
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['errors']};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> addSubTask(User user, int taskId,
      String taskData, String deadline, String status) async {
    try {
      final date = convertFrontendToBackendDate(deadline);
      final response = await http.post(
        Uri.parse("$_baseUrl/tasks/$taskId/subtask"),
        headers: {
          'Authorization': user.token,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'taskData': taskData,
          'deadline': date,
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data['data'],
        };
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['errors']};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateSubTask(User user, int taskId,
      int subTaskId, String taskData, String deadline, String status) async {
    try {
      final date = convertFrontendToBackendDate(deadline);
      final response = await http.patch(
        Uri.parse("$_baseUrl/tasks/$taskId/$subTaskId"),
        headers: {
          'Authorization': user.token,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'taskData': taskData,
          'deadline': date,
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data['data'],
        };
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['errors']};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> fetchDeletedSubTasks(User user) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/trash"),
        headers: {'Authorization': user.token},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data['data'],
        };
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['errors']};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteSubTask(User user, int taskId, int subTaskId) async {
    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/tasks/$taskId/$subTaskId"),
        headers: {'Authorization': user.token},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': "Subtask moved to trash successfully"
        };
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['errors']};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }


  Future<Map<String, dynamic>> restoreSubTask(User user, int subTaskId) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/trash/$subTaskId/restore"),
        headers: {
          'Authorization': user.token
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data['data'],
        };
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['errors']};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteSubTaskPermanently(
      User user, int subTaskId) async {
    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/trash/$subTaskId"),
        headers: {'Authorization': user.token},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('TEST: $data');
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['errors']};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  String convertFrontendToBackendDate(String frontendDate) {
    List<String> parts = frontendDate.split('/');
    if (parts.length != 3) {
      throw FormatException("Invalid date format. Expected dd/mm/yyyy");
    }

    String day = parts[0].padLeft(2, '0');
    String month = parts[1].padLeft(2, '0');
    String year = parts[2];

    return '$year-$month-$day';
  }

}
