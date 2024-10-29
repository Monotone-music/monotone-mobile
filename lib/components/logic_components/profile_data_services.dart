import 'package:monotone_flutter/components/models/profile_items.dart';

class ProfileDataService {
  String? name;
  String? identifier;
  String? avatar;
  int? follower;
  int? following;
  bool? member;

  ProfileDataService({
    this.name,
    this.identifier,
    this.avatar,
    this.follower,
    this.following,
    this.member,
  });

  ProfileItems getProfileData() {
    return ProfileItems(
      name: '123as1d54sdlkfopdfpodopf',
      identifier: '10298302803802',
      avatar: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbfe6jVBKeEynH9EtUr5gnN927eTZUJiuV8Q&s',
      follower: 3,
      following: 5,
      member: false,
    );
  }
}