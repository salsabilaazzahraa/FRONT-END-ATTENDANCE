import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://localhost:8080';

  Future<bool> register(String username, String email, String password) async {
    try {
      final response = await _dio.post('$_baseUrl/register', data: {
        'username': username,
        'email': email,
        'password': password,
      });
      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await _dio.post('$_baseUrl/login', data: {
        'username': username,
        'password': password,
      });
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', response.data['user_id'].toString());
        await prefs.setString('username', response.data['username']);
        return true;
      }
      return false;
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    if (userId == null) return null;

    try {
      final response = await _dio.get('$_baseUrl/user/$userId');
      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }
}
