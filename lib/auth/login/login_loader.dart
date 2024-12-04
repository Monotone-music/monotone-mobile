import 'package:dio/dio.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';

class LoginLoader {
  final String apiUrl = 'https://api2.ibarakoi.online/auth/login';

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
      } else {
        // Handle other status codes here if needed
        return 'Unexpected status code: ${response.statusCode}';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle specific status codes
        if (e.response!.statusCode == 400) {
          return 'Bad Request';
        } else if (e.response!.statusCode == 401) {
          return 'Unauthorized';
        } else {
          // Handle other status codes
          return 'Unexpected error: ${e.response!.statusCode}';
        }
      } else {
        // Handle other errors
        print('Error during login request: $e');
        return 'Network error';
      }
    } catch (e) {
      print('Error during login request: $e');
      return 'Unexpected error';
    }
  }
}
