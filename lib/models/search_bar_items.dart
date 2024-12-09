class Source {
  final String? value;
  final String? type;
  final DateTime? createdAt;
  final AlbumInfo? albumInfo;
  final RecordingInfo? recordingInfo;
  final ArtistInfo? artistInfo;

  Source({
    this.value,
    this.type,
    this.createdAt,
    this.albumInfo,
    this.recordingInfo,
    this.artistInfo,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      value: json['value'],
      type: json['type'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      albumInfo: json['info'] != null && json['info']['releaseEvent'] != null ? AlbumInfo.fromJson(json['info']) : null,
      recordingInfo: json['info'] != null && json['info']['recording'] != null ? RecordingInfo.fromJson(json['info']['recording']) : null,
      artistInfo: json['info'] != null && json['info']['artist'] != null ? ArtistInfo.fromJson(json['info']['artist']) : null,
    );
  }
}

class AlbumInfo {
  final ReleaseEvent releaseEvent;
  final String id;
  final String mbid;
  final String albumArtist;
  final List<String> release;
  final String releaseType;
  final String title;
  final mediaImage image;

  AlbumInfo({
    required this.releaseEvent,
    required this.id,
    required this.mbid,
    required this.albumArtist,
    required this.release,
    required this.releaseType,
    required this.title,
    required this.image,
  });

  factory AlbumInfo.fromJson(Map<String, dynamic> json) {
    var releaseList = json['release'] as List? ?? [];
    List<String> releases = releaseList.map((i) => i.toString()).toList();

    return AlbumInfo(
      releaseEvent: ReleaseEvent.fromJson(json['releaseEvent']),
      id: json['_id'],
      mbid: json['mbid'],
      albumArtist: json['albumArtist'],
      release: releases,
      releaseType: json['releaseType'],
      title: json['title'],
      image: mediaImage.fromJson(json['image']),
    );
  }
}

class ReleaseEvent {
  final DateTime date;
  final String country;

  ReleaseEvent({
    required this.date,
    required this.country,
  });

  factory ReleaseEvent.fromJson(Map<String, dynamic> json) {
    return ReleaseEvent(
      date: DateTime.parse(json['date']),
      country: json['country'],
    );
  }
}

class mediaImage {
  final int width;
  final int height;
  final String id;
  final String type;
  final String filename;
  final String mimetype;
  final int size;
  final String hash;

  mediaImage({
    required this.width,
    required this.height,
    required this.id,
    required this.type,
    required this.filename,
    required this.mimetype,
    required this.size,
    required this.hash,
  });

  factory mediaImage.fromJson(Map<String, dynamic> json) {
    return mediaImage(
      width: json['width']?? 500,
      height: json['height']?? 500,
      id: json['_id'],
      type: json['type'],
      filename: json['filename'],
      mimetype: json['mimetype'],
      size: json['size'],
      hash: json['hash'],
    );
  }
}

class RecordingInfo {
  final Position position;
  final String id;
  final String mbid;
  final String acoustid;
  final List<Artist> artists;
  final String displayedArtist;
  final double duration;
  final String title;
  final mediaImage image;
  final Media media;

  RecordingInfo({
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
  });

  factory RecordingInfo.fromJson(Map<String, dynamic> json) {
    var artistList = json['artist'] as List? ?? [];
    List<Artist> artists = artistList.map((i) => Artist.fromJson(i)).toList();

    return RecordingInfo(
      position: Position.fromJson(json['position']),
      id: json['_id'],
      mbid: json['mbid'],
      acoustid: json['acoustid'],
      artists: artists,
      displayedArtist: json['displayedArtist'],
      duration: (json['duration'] as num).toDouble(),
      title: json['title'],
      image: mediaImage.fromJson(json['image']),
      media: Media.fromJson(json['media']),
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
      no: json['no'],
      of: json['of'],
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
      id: json['_id'],
      name: json['name'],
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
      id: json['_id'],
      filename: json['filename'],
      originalName: json['originalName'],
      extension: json['extension'],
      size: json['size'],
      mimetype: json['mimetype'],
    );
  }
}

class ArtistInfo {
  final String id;
  final String name;
  final List<String> featuredIn;
  final List<ReleaseGroup> releaseGroup;

  ArtistInfo({
    required this.id,
    required this.name,
    required this.featuredIn,
    required this.releaseGroup,
  });

  factory ArtistInfo.fromJson(Map<String, dynamic> json) {
    var featuredInList = json['featuredIn'] as List? ?? [];
    List<String> featuredIn = featuredInList.map((i) => i.toString()).toList();

    var releaseGroupList = json['releaseGroup'] as List? ?? [];
    List<ReleaseGroup> releaseGroups = releaseGroupList.map((i) => ReleaseGroup.fromJson(i)).toList();

    return ArtistInfo(
      id: json['_id'],
      name: json['name'],
      featuredIn: featuredIn,
      releaseGroup: releaseGroups,
    );
  }
}

class ReleaseGroup {
  final ReleaseEvent releaseEvent;
  final String id;
  final String mbid;
  final String albumArtist;
  final List<String> release;
  final String releaseType;
  final String title;
  final String image;

  ReleaseGroup({
    required this.releaseEvent,
    required this.id,
    required this.mbid,
    required this.albumArtist,
    required this.release,
    required this.releaseType,
    required this.title,
    required this.image,
  });

  factory ReleaseGroup.fromJson(Map<String, dynamic> json) {
    var releaseList = json['release'] as List? ?? [];
    List<String> releases = releaseList.map((i) => i.toString()).toList();

    return ReleaseGroup(
      releaseEvent: ReleaseEvent.fromJson(json['releaseEvent']),
      id: json['_id'],
      mbid: json['mbid'],
      albumArtist: json['albumArtist'],
      release: releases,
      releaseType: json['releaseType'],
      title: json['title'],
      image: json['image'],
    );
  }
}

class SearchItem {
  final String id;
  final double score;
  final Source source;

  SearchItem({
    required this.id,
    required this.score,
    required this.source,
  });

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
      id: json['id'],
      score: (json['score'] as num).toDouble(),
      source: Source.fromJson(json['source']),
    );
  }
}

class SearchResults {
  final List<SearchItem> albums;
  final List<SearchItem> recordings;
  final List<SearchItem> artists;

  SearchResults({
    required this.albums,
    required this.recordings,
    required this.artists,
  });

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    var albumList = json['album'] as List? ?? [];
    var recordingList = json['recording'] as List? ?? [];
    var artistList = json['artist'] as List? ?? [];

    List<SearchItem> albums = albumList.map((i) => SearchItem.fromJson(i)).toList();
    List<SearchItem> recordings = recordingList.map((i) => SearchItem.fromJson(i)).toList();
    List<SearchItem> artists = artistList.map((i) => SearchItem.fromJson(i)).toList();

    return SearchResults(
      albums: albums,
      recordings: recordings,
      artists: artists,
    );
  }
}