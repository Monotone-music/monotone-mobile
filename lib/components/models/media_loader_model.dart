class MediaLoaderModel {
  final String url;

  MediaLoaderModel({required this.url});

  factory MediaLoaderModel.fromJson(Map<String, dynamic> json) {
    return MediaLoaderModel(
      url: json['url'],
    );
  }
}
