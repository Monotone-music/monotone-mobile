import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';

class MaintainSessionService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String BASE_URL = 'https://api2.ibarakoi.online';

  Future<String?> refreshToken({required Function onRefreshFailed}) async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    if (refreshToken == null) {
      onRefreshFailed();
      print('No refresh token found');
    }

    final httpClient = InterceptedClient.build(
      interceptors: [
        JwtInterceptor(),
      ],
    );

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
      onRefreshFailed();
      return null;
      // Handle refresh token failure (e.g., log out the user)
    }
  }

}
