import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final _baseUrl = "http://192.168.18.11:8080/api";

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final responseLogin = await http.post(
        Uri.parse('$_baseUrl/users/login'),
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
          Uri.parse('$_baseUrl/users/current'),
          headers: {'Authorization': token},
        );

        if (responseUser.statusCode == 200) {
          final userBody = json.decode(responseUser.body);
          return {
            'success': 'true',
            'id': userBody['data']['id'],
            'email': email,
            'username': userBody['data']['username'],
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
        Uri.parse('$_baseUrl/users/register'),
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
        Uri.parse('$_baseUrl/users/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
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

  Future<Map<String, dynamic>> validateOTP(int otp) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/users/validateOtp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'otp': otp
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
}
