import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart' as http;

import '../models/task_model.dart';
import '../models/user_model.dart';

class WorkspaceService {
  final _baseUrl = "http://192.168.18.11:8080/api";

  Future<Map<String, dynamic>> loadTasks(User user) async {
    try {
      // Debugging: print sebelum request API
      print('Fetching tasks for user ID: ${user.id}');

      final response = await http.get(
        Uri.parse('$_baseUrl/workspace/${user.id}/tasks'),
        headers: {'Authorization': user.token},
      );

      // Debugging: print status code dan response body
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        // Debugging: print data yang diterima
        print('Data received: ${body['data']}');

        return {
          'success': 'true',
          'tasks': body['data'],
        };
      } else if (response.statusCode == 400) {
        final body = json.decode(response.body);

        // Debugging: print error message
        print('Error response: ${body['errors']}');

        return {'success': false, 'error': body['errors']};
      } else {
        final body = json.decode(response.body);

        // Debugging: print general error message
        print('Unexpected error response: ${body['errors']}');

        return {'success': false, 'error': body['errors']};
      }
    } catch (e) {
      // Debugging: print error yang terjadi
      print('Error occurred: $e');

      return {'success': false, 'error': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> add(User user, String title, Color color) async {
    try {
      // Debugging: print data yang dikirimkan
      print('Sending data to API:');
      print('Title: $title');
      print(
          'Color: ${color.value.toRadixString(16)}'); // Will print the Color as a string representation

      final response = await http.post(Uri.parse('$_baseUrl/workspace/tasks'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': user.token
          },
          body: json
              .encode({'name': title, 'color': color.value.toRadixString(16)}));

      // Debugging: print status code dan response body
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        // Debugging: print data yang diterima dari response
        print('Data received: ${body['data']}');

        return {
          'success': 'true',
          'data': body['data'],
        };
      } else if (response.statusCode == 400) {
        final body = json.decode(response.body);

        // Debugging: print error dari response
        print('Error response (400): ${body['errors']}');

        return {'success': false, 'error': body['errors']};
      } else {
        final body = json.decode(response.body);

        // Debugging: print general error dari response
        print('Unexpected error response: ${body['errors']}');

        return {'success': false, 'error': body['errors']};
      }
    } catch (e) {
      // Debugging: print error jika terjadi exception
      print('Error caught: $e');

      return {'success': false, 'error': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> edit(
      User user, Task task, String title, Color color) async {
    try {
      // Debugging: print data yang dikirimkan
      print('Editing task ID: ${task.id}');
      print('New Title: $title');
      print('New Color: ${color.value.toRadixString(16)}');  // Print the color as string representation

      final response = await http.patch(
          Uri.parse('$_baseUrl/workspace/${user.id}/tasks/${task.id}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': user.token
          },
          body: json.encode({'name': title, 'color': color.value.toRadixString(16)}) // Send color as string
      );

      // Debugging: print status code dan response body
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        // Debugging: print data yang diterima dari response
        print('Data received: ${body['data']}');

        return {
          'success': 'true',
          'data': body['data'],
        };
      } else if (response.statusCode == 400) {
        final body = json.decode(response.body);

        // Debugging: print error dari response
        print('Error response (400): ${body['errors']}');

        return {'success': false, 'error': body['errors']};
      } else {
        final body = json.decode(response.body);

        // Debugging: print general error message
        print('Unexpected error response: ${body['errors']}');

        return {'success': false, 'error': body['errors']};
      }
    } catch (e) {
      // Debugging: print exception error
      print('Error: $e');
      return {'success': false, 'error': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> delete(User user, Task task) async {
    try {
      // Debugging: print data yang akan dihapus
      print('Deleting task ID: ${task.id}');

      final response = await http.delete(
        Uri.parse('$_baseUrl/workspace/${user.id}/tasks/${task.id}'),
        headers: {'Authorization': user.token},
      );

      // Debugging: print status code dan response body
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        // Debugging: print data yang diterima setelah penghapusan
        print('Data received after delete: ${body['data']}');

        return {
          'success': 'true',
          'data': body['data'],
        };
      } else if (response.statusCode == 400) {
        final body = json.decode(response.body);

        // Debugging: print error dari response 400
        print('Error response (400): ${body['errors']}');

        return {'success': false, 'error': body['errors']};
      } else {
        final body = json.decode(response.body);

        // Debugging: print error dari response lainnya
        print('Unexpected error response: ${body['errors']}');

        return {'success': false, 'error': body['errors']};
      }
    } catch (e) {
      // Debugging: print error jika terjadi exception
      print('Exception occurred: $e');
      return {'success': false, 'error': 'Error: $e'};
    }
  }
}