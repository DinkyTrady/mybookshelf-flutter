import 'package:web_flut/models/user.dart';

class AuthService {
  final List<User> _users = [
    User(username: 'admin', password: 'admin'),
  ];

  Future<User?> login(String username, String password) async {
    // In a real app, you'd have more robust validation and error handling
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    for (var user in _users) {
      if (user.username == username && user.password == password) {
        return user;
      }
    }
    return null;
  }

  Future<bool> register(String username, String password) async {
    // In a real app, you'd have more robust validation and error handling
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    for (var user in _users) {
      if (user.username == username) {
        return false; // Username already exists
      }
    }
    _users.add(User(username: username, password: password));
    return true;
  }
}
