import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class SubTaskService {
  final String _baseUrl = "http://192.168.18.11:8080/api";

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
        return {'success': false, 'error': error['message']};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> addSubTask(
      User user, int taskId, String taskData, String deadline, String status) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/tasks/$taskId/subtask"),
        headers: {
          'Authorization': user.token,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'taskData': taskData,
          'deadline': deadline,
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
        return {'success': false, 'error': error['message']};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateSubTask(
      User user, int taskId, int subTaskId, String? taskData, String? deadline, String? status) async {
    try {
      final response = await http.patch(
        Uri.parse("$_baseUrl/tasks/$taskId/$subTaskId"),
        headers: {
          'Authorization': user.token,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'taskData': taskData,
          'deadline': deadline,
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
        return {'success': false, 'error': error['message']};
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
          'message': data['message'],
        };
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['message']};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
