class ProfileItems {
  final String name;
  final String identifier;
  final String avatar;
  final int follower;
  final int following;
  final bool member;
  final String member_type;
  final String membership_price_amount;
  final String membership_price_unit;

  ProfileItems({
    required this.name,
    required this.identifier,
    required this.avatar,
    required this.follower,
    required this.following,
    required this.member,
    required this.member_type,
    required this.membership_price_amount,
    required this.membership_price_unit,
  });
}