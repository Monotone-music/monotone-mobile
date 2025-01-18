class ProfileItems {
  final String displayName;
  final String membershipType;
  final String filename;
  final String bitrate;

  ProfileItems({
    required this.displayName,
    required this.membershipType,
    required this.filename,
    required this.bitrate,
  });

  factory ProfileItems.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final membership = data['membership'] ?? {};
    final image = data['image'] ?? {};
    
   return ProfileItems(
      displayName: data['displayName'] ?? 'Unknown',
      membershipType: membership['type'] ?? 'Unknown',
      filename: image['filename'] ?? 'assets/image/blank_avatar.png',
      bitrate: (membership['quality'] ?? '0kbps').replaceAll('kbps', '').trim(),
    );
  }
}