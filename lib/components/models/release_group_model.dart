class Track {
  final int position;
  final String title;
  final double duration;
  final String artistName;
  final String imageUrl;

  Track({
    required this.position,
    required this.title,
    required this.duration,
    required this.artistName,
    required this.imageUrl,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      position: json['position']['no'],
      title: json['title'],
      duration: (json['duration'] as num).toDouble(),
      artistName: json['artist'][0]['name'],
      imageUrl: json['image']['filename'],
    );
  }
}

class ReleaseGroup {
  final String name;
  final String imageUrl;
  final List<Track> tracks;

  ReleaseGroup({
    required this.name,
    required this.imageUrl,
    required this.tracks,
  });

  factory ReleaseGroup.fromJson(Map<String, dynamic> json) {
    List<Track> tracks = [];

    if (json['data'] != null && json['data']['releaseGroups'] != null) {
      for (var releaseGroup in json['data']['releaseGroups']) {
        if (releaseGroup['release'] != null) {
          for (var release in releaseGroup['release']) {
            if (release['recording'] != null) {
              for (var recording in release['recording']) {
                tracks.add(Track.fromJson(recording));
              }
            }
          }
        }
      }
    }

    // Sort tracks by position
    tracks.sort((a, b) => a.position.compareTo(b.position));

    return ReleaseGroup(
      name: json['data']['releaseGroups'][0]['title'],
      imageUrl: json['data']['releaseGroups'][0]['release'][0]['recording'][0]
          ['image']['filename'],
      tracks: tracks,
    );
  }
}
