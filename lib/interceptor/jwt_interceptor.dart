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
        onRequest: (request, handler) async {
      // print(request.path);
      String? accessToken = await readAccessToken();
      request.headers['Authorization'] = 'Bearer $accessToken';
      return handler.next(request);

      ///
    }, onResponse: (response, handler) async {
      if (response.statusCode == 200) {
        var path = response.requestOptions.uri.path;
        //CHECK THE PATH
        switch (path) {
          case ('/auth/login' || '/auth/refresh'):
            {
              saveToken(response);

              /// /USE THIS TO TEST THE AUTHENTICATION
              // await _storage.delete(key: 'accessToken');
              // await _storage.delete(key: 'refreshTokenToken');
              // print('theres nothting');
              // print(await _storage.read(key: 'accessToken'));
              break;
            }

          ///
        }

        // print(response.requestOptions.uri.path);
      }
      return handler.next(response);
    },
        // RETURN ERROR IF ENCOUNTER
        onError: (DioException error, handler) async {
      String errorMessage = error.response?.data['message'];

      if (error.response?.statusCode == 400) {
        // SWITCH CASE
        switch (errorMessage) {
          //CHECK AND REFRESH TOKEN
          case ('Invalid JWT' || 'Token expired'):
            {
              dynamic oldToken = readRefreshToken();
              if (oldToken != null) {
                //IF THE REFRESH LINK RETURN
                //ANYTHING APART FROM STATUS 200
                //DELETE EVERY TOKEN IN THE STORAGE
                dynamic newToken = refreshToken();
                dynamic checkExist = readAccessToken();
                if (checkExist != null) saveToken(newToken);
                return handler.resolve(await _retry(error.requestOptions));
              }
            }

          ///
        }
      }
      return handler.next(error);
    });
  }

  Future<Response> refreshToken() async {
//TAKE THE REFRESH TOKEN FROM THE URL
    const refreshTokenUrl = '/auth/refresh';
    final refreshToken = await _storage.read(key: 'refreshToken');
    final response = await dioInter
        .post(refreshTokenUrl, data: {'refreshToken': refreshToken});
// TAKE A NEW ACCESS TOKEN AND DELETE OLD TOKEN
    if (response.statusCode != 200) {
      await _storage.delete(key: 'accessToken');
      await _storage.delete(key: 'refreshTokenToken');
    }
    print(response.data);
    return response;
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

  Future<void> saveToken(response) async {
    await _storage.write(
        key: 'accessToken', value: response.data['data']['accessToken']);
    await _storage.write(
        key: 'refreshToken', value: response.data['data']['refreshToken']);
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
