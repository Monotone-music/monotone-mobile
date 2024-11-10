import 'package:monotone_flutter/components/models/profile_items.dart';

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
      membership_price_unit:'year',
    );
  }
}
