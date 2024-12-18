import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/models/advertisement_items.dart';

class AdvertisementLoader {
  static const String baseUrl = '$BASE_URL/advertisement/random';

  Future<Advertisement> fetchRandomAdvertisement(String type) async {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ], retryPolicy: ExpiredTokenRetryPolicy());

    String adUrl;
    switch (type) {
      case 'banner':
        adUrl = '$baseUrl?type=banner_ad';
        break;
      case 'player':
        adUrl = '$baseUrl?type=player_ad';
        break;
      default:
        adUrl = baseUrl;
        break;
    }

    final response = await httpClient.get(Uri.parse(adUrl));
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final advertisement = Advertisement.fromJson(responseBody);
      // print('Gimme the $response');
      return advertisement;
    } else {
      throw Exception('Failed to load advertisement');
    }
  }
}
