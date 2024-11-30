import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//COULD BE A CLASS, PROVIDER ... BASED ON YOUR INTENTIONS
class DioClient {
  Dio dioInter = Dio();
  String BASE_URL = 'https://api2.ibarakoi.online';
  String? accessToken;

  final _storage = const FlutterSecureStorage();

  DioClient() {
    dioInter.interceptors.add(getInterceptor());
  }

// InterceptorsWrapper
  InterceptorsWrapper getInterceptor() {
    return InterceptorsWrapper(
        //
        onRequest: (options, handler) async {
      String? accessToken = await readAccessToken();
      options.headers['Authorization'] = 'Bearer $accessToken';
      return handler.next(options);

      ///
    }, onResponse: (response, handler) async {
      if (response.statusCode == 200) {
        var newPath = response.requestOptions.uri.path;
        //CHECK THE PATH
        if (newPath == '/auth/login' || newPath == '/auth/refresh') {
          await _storage.write(
              key: 'accessToken', value: response.data['data']['accessToken']);
          await _storage.write(
              key: 'refreshToken',
              value: response.data['data']['refreshToken']);
        }
        // print(response.requestOptions.uri.path);
      }
      return handler.next(response);
    },
        // RETURN ERROR IF ENCOUNTER
        onError: (DioException error, handler) async {
      //CHECK IF ACCESS TOKEN IS EXPIRED
      if ((error.response?.statusCode == 400 &&
          error.response?.data['message'] == 'Invalid JWT')) {
        // CHECK IF REFRESH TOKEN IS AVAILABLE
        if (await _storage.containsKey(key: 'refreshToken')) {
          //TAKE A NEW REFRESH TOKEN AND RETRY
          await refreshToken();
          return handler.resolve(await _retry(error.requestOptions));
        }
      }
      return handler.next(error);
    });
  }

  Future<void> refreshToken() async {
//TAKE THE REFRESH TOKEN FROM THE URL
    final refreshTokenUrl = '/auth/refresh';
    final refreshToken = await _storage.read(key: 'refreshToken');
    final response = await dioInter
        .post(refreshTokenUrl, data: {'refreshToken': refreshToken});
// TAKE A NEW ACCESS TOKEN AND DELETE OLD TOKEN
    if (response.statusCode == 200) {
      accessToken = response.data;
    } else {
      accessToken = null;
      _storage.deleteAll();
    }
  }

  ///RETRY THE REQUEST
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options =
        Options(method: requestOptions.method, headers: requestOptions.headers);
    return dioInter.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  ////// READ ACCESSTOKEN FROM STORAGE
  Future<String?> readAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  /// READ REFRESH TOKEN FROM STORAGE
  Future<String?> readRefreshToken() async {
    return await _storage.read(key: 'refreshToken');
  }

  Future<Response> get(String path) async {
    try {
      final response = await dioInter.get(path);
      return response;
    } catch (e) {
      print('Error during GET request: $e');
      rethrow;
    }
  }

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
      final response = await dioInter.get(BASE_URL + '/keepalive/');
      print(response);
      return response;
    } catch (e) {
      print('Error during keepAlive request: $e');
      return null; // Return null or a default Response object
    }
  }
}
