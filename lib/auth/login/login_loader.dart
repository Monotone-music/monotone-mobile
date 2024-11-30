import 'package:dio/dio.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';

class LoginLoader {
  final String apiUrl = 'https://api2.ibarakoi.online/auth/login';

 LoginLoader();
  
  Future<String> login(String username, String password) async {
    final dioInterceptor = DioClient();
    try {
      final response = await dioInterceptor.post(
        apiUrl,
         {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> jsonResponse = response.data;
        final String message = jsonResponse['message'];

        // Print the message
        print('Message: $message');

        // Return the message
        return 'Login successful';
      } else if (response.statusCode == 401) {
        // Unauthorized
        return 'Invalid username or password';
      } else {
        // Other errors
        return 'Failed to load data';
      }
    } catch (e) {
      print('Error during login request: $e');
      return 'Failed to load data';
    }
  }
}
