class Artist {
  final String artistName;
  final String displayImage;
  final String monthlyListener;

  Artist({
    required this.artistName,
    required this.displayImage,
    required this.monthlyListener,
  });
}

///
class Album {
  final String imageUrl;
  final String albumName;
  final String albumId;
  final String albumImage;
  final String listener;
  final List<ArtistInfo> artists;

  Album({
    required this.imageUrl,
    required this.albumName,
    required this.albumId,
    required this.albumImage,
    required this.listener,
    required this.artists,
  });
}

///
class ArtistInfo {
  final String id;
  final String name;

  ArtistInfo({
    required this.id,
    required this.name,
  });
}

///
class ArtistProduct {
  final List<Album> albums;
  final List<Album> singles;
  final List<Album> featuredIn;

  ArtistProduct({
    required this.albums,
    required this.singles,
    required this.featuredIn,
  });
}
