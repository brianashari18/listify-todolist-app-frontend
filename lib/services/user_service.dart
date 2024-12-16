import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class UserService {
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', user.id);
    prefs.setString('username', user.username);
    prefs.setString('email', user.email);
    prefs.setString('token', user.token);
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    final username = prefs.getString('username');
    final email = prefs.getString('email');
    final token = prefs.getString('token');

    if (id != null && username != null && email != null && token != null) {
      return User(id: id, username: username, email: email, token: token);
    }

    return null;
  }

  Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('id');
    prefs.remove('username');
    prefs.remove('email');
    prefs.remove('token');
  }
}
