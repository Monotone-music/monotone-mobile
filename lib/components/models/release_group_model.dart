class Track {
  final int position;
  final String title;
  final double duration;
  final List<String> artistNames;
  final String imageUrl;

  Track({
    required this.position,
    required this.title,
    required this.duration,
    required this.artistNames,
    required this.imageUrl,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    List<String> artistNames = [];
    if (json['artist'] != null) {
      for (var artist in json['artist']) {
        artistNames.add(artist['name']);
      }
    }

    return Track(
      position: json['position']['no'],
      title: json['title'],
      duration: (json['duration'] as num).toDouble(),
      artistNames: artistNames,
      imageUrl: json['image']['filename'],
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
