import 'dart:convert';

// Model class for Artist
class Artist {
  final String id;
  final String name;
  final List<FeaturedRelease> featuredIn;
  final List<ReleaseGroup> releaseGroup;

  // Constructor for Artist
  Artist({
    required this.id,
    required this.name,
    required this.featuredIn,
    required this.releaseGroup,
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
    );
  }

  // Method to create an Artist instance from a JSON string
  factory Artist.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Artist.fromJson(json);
  }
}

// Model class for FeaturedRelease
class FeaturedRelease {
  final ReleaseEvent releaseEvent;
  final String id;
  final String mbid;
  final List<String> release;
  final String releaseType;
  final String title;
  final String image;

  // Constructor for FeaturedRelease
  FeaturedRelease({
    required this.releaseEvent,
    required this.id,
    required this.mbid,
    required this.release,
    required this.releaseType,
    required this.title,
    required this.image,
  });

  // Factory constructor to create a FeaturedRelease instance from JSON
  factory FeaturedRelease.fromJson(Map<String, dynamic> json) {
    var releaseEventJson = json['releaseEvent'] as Map<String, dynamic>? ?? {};
    var releaseList = json['release'] as List? ?? [];
    List<String> release =
        releaseList.where((i) => i != null).map((i) => i.toString()).toList();

    return FeaturedRelease(
      releaseEvent: ReleaseEvent.fromJson(releaseEventJson),
      id: json['_id'],
      mbid: json['mbid'],
      release: release,
      releaseType: json['releaseType'],
      title: json['title'],
      image: json['image']['filename'], 
    );
  }
}

// Model class for ReleaseGroup
class ReleaseGroup {
  final ReleaseEvent releaseEvent;
  final String id;
  final String mbid;
  final List<String> release;
  final String releaseType;
  final String title;
  final String image;

  // Constructor for ReleaseGroup
  ReleaseGroup({
    required this.releaseEvent,
    required this.id,
    required this.mbid,
    required this.release,
    required this.releaseType,
    required this.title,
    required this.image,
  });

  // Factory constructor to create a ReleaseGroup instance from JSON
  factory ReleaseGroup.fromJson(Map<String, dynamic> json) {
    var releaseEventJson = json['releaseEvent'] as Map<String, dynamic>? ?? {};
    var releaseList = json['release'] as List? ?? [];
    List<String> release =
        releaseList.where((i) => i != null).map((i) => i.toString()).toList();

    return ReleaseGroup(
      releaseEvent: ReleaseEvent.fromJson(releaseEventJson),
      id: json['_id'],
      mbid: json['mbid'],
      release: release,
      releaseType: json['releaseType'],
      title: json['title'],
      image: json['image'], // Added imageId
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
