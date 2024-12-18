///============ GENERAL CONSTRUCTORS ===================////
class Advertisement {
  final dynamic data;

  Advertisement({
    required this.data,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];
    switch (dataJson['type']) {
      case 'banner_ad':
        return Advertisement(
          data: AdvertisementBannerData.fromJson(dataJson),
        );
      case 'player_ad':
        return Advertisement(
          data: AdvertisementMediaData.fromJson(dataJson),
        );
      default:
        return Advertisement(
          data: AdvertisementMediaData.fromJson(dataJson),
        );
    }
  }
}

class Media {
  final String id;
  final String filename;
  final String originalName;
  final String extension;
  final int size;
  final String mimetype;
  final String hash;
  final DateTime createdAt;
  final DateTime updatedAt;

  Media({
    required this.id,
    required this.filename,
    required this.originalName,
    required this.extension,
    required this.size,
    required this.mimetype,
    required this.hash,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['_id'],
      filename: json['filename'],
      originalName: json['originalName'],
      extension: json['extension'],
      size: json['size'],
      mimetype: json['mimetype'],
      hash: json['hash'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
  final DateTime createdAt;
  final DateTime updatedAt;

  ImageData({
    required this.dimensions,
    required this.id,
    required this.type,
    required this.filename,
    required this.mimetype,
    required this.size,
    required this.hash,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      dimensions: Dimensions.fromJson(json['dimensions']),
      id: json['_id'],
      type: json['type'],
      filename: json['filename'],
      mimetype: json['mimetype'],
      size: json['size'],
      hash: json['hash'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
      width: json['width'],
      height: json['height'],
    );
  }
}

////=========== MODEL FOR PLAYER AD ====================/////
class AdvertisementMediaData {
  final String status;
  final String id;
  final String title;
  final Media media;
  final ImageData image;
  final String type;
  final int view;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdvertisementMediaData({
    required this.status,
    required this.id,
    required this.title,
    required this.media,
    required this.image,
    required this.type,
    required this.view,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdvertisementMediaData.fromJson(Map<String, dynamic> json) {
    return AdvertisementMediaData(
      status: json['status'],
      id: json['_id'],
      title: json['title'],
      media: Media.fromJson(json['media']),
      image: ImageData.fromJson(json['image']),
      type: json['type'],
      view: json['view'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

////=========== MODEL FOR BANNER AD ====================/////
class AdvertisementBannerData {
  final String id;
  final String title;
  final ImageData image;
  final String type;
  final String status;
  final int view;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdvertisementBannerData({
    required this.id,
    required this.title,
    required this.image,
    required this.type,
    required this.status,
    required this.view,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdvertisementBannerData.fromJson(Map<String, dynamic> json) {
    return AdvertisementBannerData(
      id: json['_id'],
      title: json['title'],
      image: ImageData.fromJson(json['image']),
      type: json['type'],
      status: json['status'],
      view: json['view'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
