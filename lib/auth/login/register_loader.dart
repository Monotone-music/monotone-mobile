import 'package:dio/dio.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';

class RegisterLoader {
  final String apiUrl = 'https://api2.ibarakoi.online/account/register';

  Future<String> register(
      String username, String password, String email) async {
    final dioInterceptor = DioClient();
    try {
      final response = await dioInterceptor.post(
        apiUrl,
        {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        // Parse the JSON response
        final Map<String, dynamic> jsonResponse = response.data;
        final String message = jsonResponse['message'];

        // Print the message
        print('Message: $message');

        // Return the message
        return 'Login successful';
      } else {
        // Handle other status codes here if needed
        print('Unexpected status code: ${response.statusCode}');
        return 'Unexpected status code';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle specific status codes
        if (e.response!.statusCode == 400) {
          print(e.response!);
          return '400';
        } else if (e.response!.statusCode == 401) {
          return '401';
        } else {
          // Handle other status codes
          print('Unexpected error: ${e.response!.statusCode}');
          return 'Unexpected error';
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
