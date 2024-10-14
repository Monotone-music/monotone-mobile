import 'package:monotone_flutter/components/models/profile_items.dart';

class ProfileDataService {
  String? name;
  String? identifier;
  String? avatar;
  int? follower;
  int? following;
  bool? member;
  List<String>? fren;

  ProfileDataService({
    this.name,
    this.identifier,
    this.avatar,
    this.follower,
    this.following,
    this.member,
    this.fren,
  });

  ProfileItems getProfileData() {
    return ProfileItems(
      name: 'Siuuu',
      identifier: '10298302803802',
      avatar: 'assets/image/rajang.jpg', // Replace with your image asset
      follower: 3,
      following: 5,
      member: false,
      fren: ['asidnosdns', 'osdhosjdpsjpdosjpds'],
    );
  }
}