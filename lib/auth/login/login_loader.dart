import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginLoader {
  final String apiUrl='https://api2.ibarakoi.online/auth/login';

  LoginLoader();

  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Assuming the response body contains the token or success message
      return response.body;
    } else if (response.statusCode == 401) {
      // Unauthorized
      return 'Invalid username or password';
    } else {
      // Other errors
      return 'Failed to load data';
    }
  }
}