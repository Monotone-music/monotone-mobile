import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:http_parser/http_parser.dart';
import 'package:monotone_flutter/models/profile_items.dart';
import 'package:provider/provider.dart';

import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/controller/media/notifiers/bitrate_notifier.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';

class ProfileDataService {
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
        // print('Profile data fetched successfully.');
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        // print('Response Body: $responseBody'); // Debug print

        if (responseBody.containsKey('data')) {
          final profile = ProfileItems.fromJson(responseBody);
          // print('Parsed Profile: $profile'); // Debug print
          await _storage.write(key: 'bitrate', value: profile.bitrate);
          // print('Profile data: ${profile.displayName}, ${profile.membershipType}');

          // Notify the BitrateProvider to update its state
          Provider.of<BitrateProvider>(context, listen: false)
              .setBitrate(profile.bitrate);

          return {
            'displayName': profile.displayName,
            'filename': profile.filename,
            'membershipType': profile.membershipType,
          };
        } else {
          print('Key "data" not found in response body.');
        }
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
