class Playlist {
  final String id;
  final String name;
  final List<Recording> recordings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ImageData image;

  Playlist({
    required this.id,
    required this.name,
    required this.recordings,
    required this.createdAt,
    required this.updatedAt,
    required this.image,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      recordings: List<Recording>.from(
          json['recording'].map((recording) => Recording.fromJson(recording))),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
      image: ImageData.fromJson(json['image'] ?? {}),
    );
  }
}

class Recording {
  final RecordingDetails recording;
  final int index;
  final String id;

  Recording({
    required this.recording,
    required this.index,
    required this.id,
  });

  factory Recording.fromJson(Map<String, dynamic> json) {
    return Recording(
      recording: RecordingDetails.fromJson(json['recording'] ?? {}),
      index: json['index'] ?? 0,
      id: json['_id'] ?? '',
    );
  }
}

class RecordingDetails {
  final Position position;
  final String id;
  final String mbid;
  final String acoustid;
  final List<Artist> artists;
  final String displayedArtist;
  final double duration;
  final String title;
  final ImageData image;
  final Media media;
  final DateTime updatedAt;
  final int view;

  RecordingDetails({
    required this.position,
    required this.id,
    required this.mbid,
    required this.acoustid,
    required this.artists,
    required this.displayedArtist,
    required this.duration,
    required this.title,
    required this.image,
    required this.media,
    required this.updatedAt,
    required this.view,
  });

  factory RecordingDetails.fromJson(Map<String, dynamic> json) {
    return RecordingDetails(
      position: Position.fromJson(json['position'] ?? {}),
      id: json['_id'] ?? '',
      mbid: json['mbid'] ?? '',
      acoustid: json['acoustid'] ?? '',
      artists: List<Artist>.from(
          json['artist'].map((artist) => Artist.fromJson(artist)) ?? []),
      displayedArtist: json['displayedArtist'] ?? '',
      duration: (json['duration'] as num?)?.toDouble() ?? 0.0,
      title: json['title'] ?? '',
      image: ImageData.fromJson(json['image'] ?? {}),
      media: Media.fromJson(json['media'] ?? {}),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
      view: json['view'] ?? 0,
    );
  }
}

class Position {
  final int no;
  final int of;

  Position({
    required this.no,
    required this.of,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      no: json['no'] ?? 0,
      of: json['of'] ?? 0,
    );
  }
}

class Artist {
  final String id;
  final String name;

  Artist({
    required this.id,
    required this.name,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Media {
  final String id;
  final String filename;
  final String originalName;
  final String extension;
  final int size;
  final String mimetype;

  Media({
    required this.id,
    required this.filename,
    required this.originalName,
    required this.extension,
    required this.size,
    required this.mimetype,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['_id'] ?? '',
      filename: json['filename'] ?? '',
      originalName: json['originalName'] ?? '',
      extension: json['extension'] ?? '',
      size: json['size'] ?? 0,
      mimetype: json['mimetype'] ?? '',
    );
  }
}

class ImageData {
  final Dimensions dimensions;
  final String id;
  final String type;
  final String filename;
  final String mimetype;
  final int size;
  final String hash;

  ImageData({
    required this.dimensions,
    required this.id,
    required this.type,
    required this.filename,
    required this.mimetype,
    required this.size,
    required this.hash,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      dimensions: Dimensions.fromJson(json['dimensions'] ?? {}),
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      filename: json['filename'] ?? '',
      mimetype: json['mimetype'] ?? '',
      size: json['size'] ?? 0,
      hash: json['hash'] ?? '',
    );
  }
}

class Dimensions {
  final int width;
  final int height;

  Dimensions({
    required this.width,
    required this.height,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }
}
