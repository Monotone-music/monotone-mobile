import 'dart:convert';

import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/models/profile_items.dart';

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
      avatar:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbfe6jVBKeEynH9EtUr5gnN927eTZUJiuV8Q&s',
      follower: 3,
      following: 5,
      member: true,
      member_type: 'Aloha',
      membership_price_amount: '21',
      membership_price_unit: 'year',
    );
  }

  Future<Map<String, String>> fetchProfileApi() async {
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
        print('Profile data: $displayName, $membershipType');

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
