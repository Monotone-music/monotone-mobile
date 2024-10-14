class ProfileItems {
  final String name;
  final String identifier;
  final String avatar;
  final int follower;
  final int following;
  final bool member;
  final List<String> fren;

  ProfileItems({
    required this.name,
    required this.identifier,
    required this.avatar,
    required this.follower,
    required this.following,
    required this.member,
    required this.fren,
  });
}