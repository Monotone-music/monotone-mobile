import 'dart:convert';

// Model class for Artist
class Artist {
  final String id;
  final String name;
  final List<FeaturedRelease> featuredIn;
  final List<ReleaseGroup> releaseGroup;
  final ImageData image;

  // Constructor for Artist
  Artist({
    required this.id,
    required this.name,
    required this.featuredIn,
    required this.releaseGroup,
    required this.image,
  });

  // Factory constructor to create an Artist instance from JSON
  factory Artist.fromJson(Map<String, dynamic> json) {
    var featuredInList = json['featuredIn'] as List? ?? [];
    var releaseGroupList = json['releaseGroup'] as List? ?? [];

    List<FeaturedRelease> featuredIn = featuredInList
        .where((i) => i != null)
        .map((i) => FeaturedRelease.fromJson(i))
        .toList();
    List<ReleaseGroup> releaseGroup = releaseGroupList
        .where((i) => i != null)
        .map((i) => ReleaseGroup.fromJson(i))
        .toList();

    return Artist(
      id: json['_id'],
      name: json['name'],
      featuredIn: featuredIn,
      releaseGroup: releaseGroup,
      image: ImageData.fromJson(json['image']),
    );
  }

  // Method to create an Artist instance from a JSON string
  factory Artist.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Artist.fromJson(json);
  }
}

// Model class for ImageData
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

// Model class for FeaturedRelease
class FeaturedRelease {
  final ReleaseEvent releaseEvent;
  final String id;
  final String mbid;
  final String releaseType;
  final String title;
  final String image;

  // Constructor for FeaturedRelease
  FeaturedRelease({
    required this.releaseEvent,
    required this.id,
    required this.mbid,
    required this.releaseType,
    required this.title,
    required this.image,
  });

  // Factory constructor to create a FeaturedRelease instance from JSON
  factory FeaturedRelease.fromJson(Map<String, dynamic> json) {
    var releaseEventJson = json['releaseEvent'] as Map<String, dynamic>? ?? {};

    return FeaturedRelease(
      releaseEvent: ReleaseEvent.fromJson(releaseEventJson),
      id: json['_id'],
      mbid: json['mbid'],
      releaseType: json['releaseType'] ?? '',
      title: json['title'] ?? '',
      image: json['image']['filename'] ?? '', // Handle null image field
    );
  }
}

// Model class for ReleaseGroup
class ReleaseGroup {
  final ReleaseEvent releaseEvent;
  final String id;
  final String mbid;
  final String releaseType;
  final String title;
  final String image;

  // Constructor for ReleaseGroup
  ReleaseGroup({
    required this.releaseEvent,
    required this.id,
    required this.mbid,
    required this.releaseType,
    required this.title,
    required this.image,
  });

  // Factory constructor to create a ReleaseGroup instance from JSON
  factory ReleaseGroup.fromJson(Map<String, dynamic> json) {
    var releaseEventJson = json['releaseEvent'] as Map<String, dynamic>? ?? {};

    return ReleaseGroup(
      releaseEvent: ReleaseEvent.fromJson(releaseEventJson),
      id: json['_id'],
      mbid: json['mbid'],
      releaseType: json['releaseType'] ?? '',
      title: json['title'] ?? '',
      image: json['image']?['filename'] ?? '', // Handle null image field
    );
  }
}

// Model class for ReleaseEvent
class ReleaseEvent {
  final String date;
  final String country;
  final String id;

  // Constructor for ReleaseEvent
  ReleaseEvent({
    required this.date,
    required this.country,
    required this.id,
  });

  // Factory constructor to create a ReleaseEvent instance from JSON
  factory ReleaseEvent.fromJson(Map<String, dynamic> json) {
    return ReleaseEvent(
      date: json['date'] ?? '',
      country: json['country'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}
