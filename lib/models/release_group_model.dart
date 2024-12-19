class Track {
  final String id;
  final int position;
  final String title;
  final double duration;
  final List<String> artistNames;
  final String imageUrl;
  final int view;

  Track({
    required this.id,
    required this.position,
    required this.title,
    required this.duration,
    required this.artistNames,
    required this.imageUrl,
    required this.view,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    List<String> artistNames = [];
    if (json['artist'] != null) {
      for (var artist in json['artist']) {
        artistNames.add(artist['name']);
      }
    }
    return Track(
      id: json['_id'] ?? 'unknown', // Ensure the id is correctly parsed
      position: json['position']['no'] ?? 0,
      title: json['title'] ?? 'unknown',
      duration: (json['duration'] as num?)?.toDouble() ?? 0.0,
      artistNames: artistNames,
      imageUrl: json['image']['filename'] ?? '',
      view: json['view'] ?? 0,
    );
  }
}

class ReleaseGroup {
  final String name;
  final String artistName;
  final String releaseYear;
  final String imageUrl;
  final List<Track> tracks;

  ReleaseGroup({
    required this.name,
    required this.artistName,
    required this.releaseYear,
    required this.imageUrl,
    required this.tracks,
  });

  factory ReleaseGroup.fromJson(Map<String, dynamic> json) {
    List<Track> tracks = [];

    if (json['release'] != null) {
      for (var release in json['release']) {
        if (release['recording'] != null) {
          for (var recording in release['recording']) {
            tracks.add(Track.fromJson(recording));
          }
        }
      }
    }

    // Sort tracks by position
    tracks.sort((a, b) => a.position.compareTo(b.position));

    String artistName = json['releaseType'] == 'compilation'
        ? 'Various Artists'
        : json['release'][0]['recording'][0]['artist'][0]['name'];
    return ReleaseGroup(
      name: json['title'],
      artistName: artistName,
      releaseYear: json['releaseEvent']['date'].substring(0, 4),
      imageUrl: json['release'][0]['recording'][0]['image']['filename'],
      tracks: tracks,
    );
  }
}
