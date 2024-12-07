import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/auth/login/services/refresh_token.dart';

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
    print(request.url.data);

    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    int statusCode = response.statusCode;

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
    }
  }

<<<<<<< HEAD
  Future<Response> post(String path, dynamic data) async {
    try {
      final response = await dioInter.post(path, data: data);
      // print(response);
      return response;
    } catch (e) {
      print('Error during POST request: $e');
      rethrow;
    }
  }

  Future<Response?> keepAlive() async {
    try {
      final response = await dioInter.post(BASE_URL + '/auth/keep-alive/');
      print(response);
      return response;
    } catch (e) {
      print('Error during keepAlive request: $e');
      return null; // Return null or a default Response object
=======
  Future<void> saveToken(String tokenType, String value) async {
    switch (tokenType) {
      case 'accessToken':
        await _storage.write(key: tokenType, value: value);
        break;
      case 'refreshToken':
        await _storage.write(key: tokenType, value: value);
        break;
>>>>>>> af87226b49359c090f6dd48b3d81f21b81352b2a
    }
  }
}

class ExpiredTokenRetryPolicy extends RetryPolicy {
  final RefreshTokenService _refreshTokenService = RefreshTokenService();

  @override
  bool shouldAttemptRetryOnException(Exception reason, BaseRequest request) {
    return true;
  }

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    if (response.statusCode == 401) {
      _refreshTokenService.refreshToken();
      print('Retry again');
      return true;
    }
    return false;
  }
}
