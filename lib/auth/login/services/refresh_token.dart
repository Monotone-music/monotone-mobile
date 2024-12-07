import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';

class RefreshTokenService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String BASE_URL = 'https://api2.ibarakoi.online';

  Future<void> refreshToken() async {
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

    print('Refresh token response body: ${response.body}');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final newAccessToken = body['data']['accessToken'];
      final newRefreshToken = body['data']['refreshToken'];
      await _storage.write(key: 'accessToken', value: newAccessToken);
      await _storage.write(key: 'refreshToken', value: newRefreshToken);
    } else {
      // print('Failed to refresh token: ${response.body}');
      // Handle refresh token failure (e.g., log out the user)
    }
  }
}
