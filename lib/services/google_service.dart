import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:listify/services/user_service.dart';

import '../models/user_model.dart';

class GoogleService {
  final UserService _userService = UserService();
  final _baseUrl = "http://192.168.18.11:8080/api";
  final _googleSignIn =
      GoogleSignIn(clientId: dotenv.env["GOOGLE_WEB_CLIENT_ID"], scopes: [
    'https://www.googleapis.com/auth/userinfo.profile',
    'https://www.googleapis.com/auth/userinfo.email',
  ]);

  Future<Map<String, dynamic>> login() async {
    try {
      GoogleSignInAccount? user = await _googleSignIn.signIn();
      if (user != null) {
        final GoogleSignInAuthentication googleAuth = await user.authentication;
        final idToken = googleAuth.idToken;
        final accessToken = googleAuth.accessToken;

        if (accessToken != null && idToken != null) {
          final response = await _sendTokensToBackend(
              accessToken, idToken, _googleSignIn.clientId!, user);
          return response;
        }
      }
      return {'success': false, 'message': 'User login failed'};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> _sendTokensToBackend(String accessToken,
      String idToken, String clientId, GoogleSignInAccount user) async {
    final requestBody = <String, dynamic>{
      "access_token": accessToken,
      "id_token": idToken,
      "client_id": clientId
    };

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/users/google'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final user = body['data'];
        final token = user['token'];

        final responseUser = await http.get(
          Uri.parse('$_baseUrl/users/current'),
          headers: {'Authorization': token},
        );

        if (responseUser.statusCode == 200) {
          final userBody = json.decode(responseUser.body);
          final userData = userBody['data'];

          final user = User(
            id: userData['id'],
            username: userData['username'],
            email: userData['email'],
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
      } else {
        return {
          'success': false,
          'error': 'Failed to authenticate with backend: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Error: $e'};
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
  }

  GoogleSignInAccount? getCurrentUser() => _googleSignIn.currentUser;

  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  Future<void> disconnect() async {
    await _googleSignIn.disconnect();
  }
}
