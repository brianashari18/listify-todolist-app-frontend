import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:listify/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthService {
  final _baseUrl = "http://192.168.18.11:8080/api/users";
  final UserService _userService = UserService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final responseLogin = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (responseLogin.statusCode == 200) {
        final body = json.decode(responseLogin.body);
        final user = body['data'];
        final token = user['token'];

        final responseUser = await http.get(
          Uri.parse('$_baseUrl/current'),
          headers: {'Authorization': token},
        );

        if (responseUser.statusCode == 200) {
          final userBody = json.decode(responseUser.body);
          final userData = userBody['data'];

          final user = User(
            id: userData['id'],
            username: userData['username'],
            email: email,
            token: token,
          );
          await _userService.saveUser(user);

          return {
            'success': 'true',
            'user': user
          };
        } else if (responseUser.statusCode == 400) {
          final body = json.decode(responseUser.body);
          return {'success': false, 'error': body['errors']};
        } else {
          final body = json.decode(responseUser.body);
          return {'success': false, 'error': body['errors']};
        }
      } else if (responseLogin.statusCode == 401) {
        return {'success': false, 'error': 'Wrong username or password'};
      } else {
        return {
          'success': false,
          'error': 'Failed to login. Please try again.'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> register(String email, String username,
      String password, String confirmPassword) async {
    try {
      final responseRegister = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'username': username,
          'password': password,
          'confirmPassword': confirmPassword
        }),
      );

      if (responseRegister.statusCode == 200) {
        final body = json.decode(responseRegister.body);
        return {
          'success': 'true',
          'id': body['data']['id'],
          'email': email,
          'username': username,
        };
      } else if (responseRegister.statusCode == 400) {
        final body = json.decode(responseRegister.body);
        return {'success': false, 'error': body['errors']};
      } else {
        final body = json.decode(responseRegister.body);
        return {'success': false, 'error': body['errors']};
      }
    } catch (e) {
      return {'success': false, 'error': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return {
          'success': 'true',
          'message': body['message'],
        };
      } else if (response.statusCode == 400) {
        final body = json.decode(response.body);
        return {'success': false, 'error': body['errors']};
      } else {
        final body = json.decode(response.body);
        return {'success': false, 'error': body['errors']};
      }
    } catch (e) {
      return {'success': false, 'error': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> validateOTP(int otp) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/validateOtp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'otp': otp}),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return {
          'success': 'true',
          'message': body['message'],
        };
      } else if (response.statusCode == 400) {
        final body = json.decode(response.body);
        return {'success': false, 'error': body['errors']};
      } else {
        final body = json.decode(response.body);
        return {'success': false, 'error': body['errors']};
      }
    } catch (e) {
      return {'success': false, 'error': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> resetPassword(
      String newPassword, String confirmPassword, String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
          'email': email
        }),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return {
          'success': 'true',
          'message': body['message'],
        };
      } else if (response.statusCode == 400) {
        final body = json.decode(response.body);
        return {'success': false, 'error': body['errors']};
      } else {
        final body = json.decode(response.body);
        return {'success': false, 'error': body['errors']};
      }
    } catch (e) {
      return {'success': false, 'error': 'Error: $e'};
    }
  }

  Future<http.Response> getTask(String url) {
    return http.get(Uri.parse('$_baseUrl$url'));
  }

  Future<http.Response> addTask(String url, Map<String, dynamic> body) {
    return http.post(Uri.parse('$_baseUrl$url'),
        headers: {'Content-type': 'application/json'}, body: body);
  }
}
