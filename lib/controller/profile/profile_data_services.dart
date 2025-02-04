import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/controller/media/notifiers/bitrate_notifier.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/models/profile_items.dart';
import 'package:provider/provider.dart';

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

  ProfileItems getProfileData() {
    return ProfileItems(
      name: '123as1d54sdlkfopdfpodopf',
      identifier: '1029830280380',
      avatar: 'assets/image/blank_avatar.png',
      follower: 3,
      following: 5,
      member: true,
      member_type: 'Aloha',
      membership_price_amount: '21',
      membership_price_unit: 'year',
    );
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
        final String bitrate =
            data['membership']['quality'].replaceAll('kbps', '').trim();
        await _storage.write(key: 'bitrate', value: bitrate);
        print('Profile data: $displayName, $membershipType');

        // Notify the BitrateProvider to update its state
        Provider.of<BitrateProvider>(context, listen: false).setBitrate(bitrate);

        return {
          'displayName': displayName,
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
