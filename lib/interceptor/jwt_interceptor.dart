import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/auth/login/services/maintain_session_service.dart';
import 'package:monotone_flutter/widgets/routes/routes.dart';

class JwtInterceptor implements InterceptorContract {
  final _storage = const FlutterSecureStorage();
  final BASE_URL = 'https://api2.ibarakoi.online';

  ///REQUIRED FUNCTION
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    if (request.url.path == '/auth/login') {
      return request;
    }

    ///
    String? accessToken = await readToken('accessToken');
    if (accessToken != null) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }
    print(request.url);
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    int statusCode = response.statusCode;
    print('RESPONSE: ${response.request}');
    if (response.request?.url.path == '/auth/login' ||
        response.request?.url.path == '/auth/refresh') {
      ///
      if (response is Response) {
        var body = jsonDecode(response.body);
        switch (statusCode) {
          case 200:
            await saveToken('accessToken', body['data']['accessToken']);
            await saveToken('refreshToken', body['data']['refreshToken']);
            break;
          case 401:
            print('Refresh failed');
            break;
        }
        ///
      }
    }
    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() async {
    return true;
  }

  @override
  Future<bool> shouldInterceptResponse() async {
    return true;
  }

  /// LOGIC FUNCTION
  Future<String?> readToken(String tokenType) async {
    var token;
    try {
      switch (tokenType) {
        case 'accessToken':
          token = await _storage.read(key: tokenType);
          break;
        case 'refreshToken':
          token = await _storage.read(key: tokenType);
          break;
      }
      return token;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> saveToken(String tokenType, String value) async {
    switch (tokenType) {
      case 'accessToken':
        await _storage.write(key: tokenType, value: value);
        break;
      case 'refreshToken':
        await _storage.write(key: tokenType, value: value);
        break;
    }
  } 
}

class ExpiredTokenRetryPolicy extends RetryPolicy {
  final MaintainSessionService _refreshTokenService = MaintainSessionService();

  @override
  bool shouldAttemptRetryOnException(Exception reason, BaseRequest request) {
    return true;
  }

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    if (response.statusCode == 401) {
      print('Retrying...');
     final newToken = await _refreshTokenService.refreshToken(
        onRefreshFailed: () {
          AppRoutes().router.go('/login');
        },
      );;
      if (newToken != null) {
        // Add the new token to the request headers
        response.request?.headers['Authorization'] = 'Bearer $newToken';
        return true;
      }
    }
    return false;
  }
}
