import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';

class MaintainSessionService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String BASE_URL = 'https://api2.ibarakoi.online';

  Future<String?> refreshToken() async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    if (refreshToken == null) {
      print('No refresh token found');
    }

    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ],);

    final response = await httpClient.post(
      Uri.parse('$BASE_URL/auth/refresh'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'refreshToken': refreshToken}),
    );


    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final newAccessToken = body['data']['accessToken'];
      final newRefreshToken = body['data']['refreshToken'];
      await _storage.write(key: 'accessToken', value: newAccessToken);
      await _storage.write(key: 'refreshToken', value: newRefreshToken);
      return newAccessToken;
    } else {
      print('Failed to refresh token: ${response.body}');
      return null;
      // Handle refresh token failure (e.g., log out the user)
    }
  }

  Future<bool> keepAlive() async {
     final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ],retryPolicy: ExpiredTokenRetryPolicy());
    ///
    final accessToken = await _storage.read(key: 'accessToken');
    if (accessToken == null) {
      return false;
    }

    final response = await httpClient.post(
      Uri.parse('$BASE_URL/auth/keep-alive'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    print(response.statusCode == 200);
    return response.statusCode == 200;
  }
}
