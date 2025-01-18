import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';

import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/controller/media/notifiers/bitrate_notifier.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';

class ProfileDataService {
  String? name;
  String? identifier;
  String? avatar;
  int? follower;
  int? following;
  bool? member;
  String? member_type;
  String? membership_price_amount;
  String? membership_price_unit;

  ProfileDataService({
    this.name,
    this.identifier,
    this.avatar,
    this.follower,
    this.following,
    this.member,
    this.member_type,
    this.membership_price_amount,
    this.membership_price_unit,
  });

  Future<String> changeDisplayName(String newDisplayName) async {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ]);

    try {
      final Uri apiUrl = Uri.parse('$BASE_URL/listener/name');

      var body = jsonEncode({'displayName': newDisplayName});
      final response = await httpClient.patch(
        apiUrl,
        body: body,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        // print(response);

        // Print the message

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
          print('${e.response!}');
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
    }
  }

  Future<String> changeAvatar(File? avatarFile) async {
    try {
      final httpClient = InterceptedClient.build(interceptors: [
        JwtInterceptor(),
      ]);

      final Uri apiUrl = Uri.parse('$BASE_URL/listener/image');

      var request = http.MultipartRequest('PATCH', apiUrl)
        ..files.add(await http.MultipartFile.fromPath('file', avatarFile!.path,
            contentType: MediaType('image', 'jpeg')))
        ..headers.addAll({"Content-Type": "multipart/form-data"});

      final response = await httpClient.send(request);
      if (response.statusCode == 200) {
        // Parse the JSON response
        // print(response);

        // Print the message

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
          print('${e.response!}');
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
    }
  }

  Future<Map<String, String>> fetchProfileApi(BuildContext context) async {
    const _storage = FlutterSecureStorage();
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ]);
    const api = '$BASE_URL/listener/profile';
    print('current api: $api');
    print('Fetching profile data...');

    try {
      final response = await httpClient.get(Uri.parse(api));
      if (response.statusCode == 200) {
        print('Profile data fetched successfully.');
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final data = responseBody['data'];
        final String displayName = data['displayName'];
        final String membershipType = data['membership']['type'];
        final String filename = data['image']['filename'];

        final String bitrate =
            data['membership']['quality'].replaceAll('kbps', '').trim();
        await _storage.write(key: 'bitrate', value: bitrate);
        print('Profile data: $displayName, $membershipType');

        // Notify the BitrateProvider to update its state
        Provider.of<BitrateProvider>(context, listen: false)
            .setBitrate(bitrate);

        return {
          'displayName': displayName,
          'filename': filename,
          'membershipType': membershipType,
        };
      } else {
        print(
            'Failed to fetch profile data. Status code: ${response.statusCode}');
        print('Failed to fetch profile data. ${response.body}');
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
    return {};
  }
}
