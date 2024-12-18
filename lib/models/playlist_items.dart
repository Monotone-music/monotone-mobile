class PlaylistItem {
  final String id;
  final String name;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int trackCount;

  PlaylistItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.trackCount,
  });

  factory PlaylistItem.fromJson(Map<String, dynamic> json) {
    return PlaylistItem(
      id: json['_id'],
      name: json['name']?? '',
      imageUrl: json['image']?['filename']?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      updatedAt: DateTime.parse(json['updatedAt']?? ''),
      trackCount: json['recording'].length,
    );
  }
}
