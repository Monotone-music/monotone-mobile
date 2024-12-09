import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';

class LoginLoader {
  final Uri apiUrl = Uri.parse('https://api2.ibarakoi.online/auth/login');
  final storage = const FlutterSecureStorage();
  Future<String> login(String username, String password) async {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ]);
    try {
      var body = jsonEncode({'username': username, 'password': password});
      final response = await httpClient.post(
        apiUrl,
        body: body,
        headers: {"Content-Type": "application/json"},
      );

      ///
      if (response.statusCode == 200) {
        //SAVE THE BITRATE
        final responseBody = jsonDecode(response.body);
        var fullBitrate =
            responseBody['data']['bitrate'].replaceAll('kbps', '').trim();
        await storage.write(key: 'bitrate', value: fullBitrate);
        // Return the message
        return '200';
      } else {
        // Handle other status codes here if needed
        return '${response.statusCode}';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle specific status codes
        if (e.response!.statusCode == 400) {
          return '400';
        } else if (e.response!.statusCode == 401) {
          return '401';
        } else if (e.response!.statusCode == 404) {
          return '404';
        } else {
          // Handle other status codes
          return 'Unexpected error: ${e.response!.statusCode}';
        }
      } else {
        // Handle other errors
        print('Error during login request: $e');
        return '502';
      }
    } catch (e) {
      print('Error during login request: $e');
      return '500';
    }
  }
}
