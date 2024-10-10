import 'package:monotone_flutter/components/models/playlist_items.dart';

class DataService {
  Future<List<PlaylistItem>> fetchPlaylistItems() async {
    // Simulate a delay for fetching data from the database
    await Future.delayed(Duration(seconds: 0));

    // Simulated data
    return [
      PlaylistItem(
        title: 'Song 1',
        artist: 'Artist 1',
        picture: 'assets/image/rajang.jpg',
        amount: '12',
      ),
      PlaylistItem(
        title: 'UrnaCacti',
        artist: 'Artist 333333',
        picture: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTy8Xkz9aPYcCsmw0fLnK96-Whkqm5Oyl2CxA&s',
        amount: '15',
      ),
      // Add more items as needed
    ];
  }

  Future<List<PlaylistItem>> fetchAnotherPlaylistItems() async {
    // Simulate a delay for fetching data from the database
    await Future.delayed(Duration(seconds: 0));

    // Simulated data
    return [
      // PlaylistItem(
      //   title: 'Another Song 1',
      //   artist: 'Another Artist 1',
      //   picture: 'assets/image/rajang.jpg',
      //   amount: '20',
      // ),
      // PlaylistItem(
      //   title: 'UrnaCacti',
      //   artist: ' 333333',
      //   picture: 'assets/image/rajang.jpg',
      //   amount: '25',
      // ),
      // // Add more items as needed
    ];
  }

Future<List<PlaylistItem>> fetchAnotherNotherPlaylistItems() async {
    // Simulate a delay for fetching data from the database
    await Future.delayed(Duration(seconds: 0));

    // Simulated data
    return [
      PlaylistItem(
        title: 'Diddy',
        artist: 'Artist 333333',
        picture: 'assets/image/rajang.jpg',
        amount: '35',
      ),
      PlaylistItem(
        title: 'Diddy',
        artist: 'Artist 333333',
        picture: 'assets/image/rajang.jpg',
        amount: '35',
      ),
      // Add more items as needed
    ];
  }
  // Add more methods for fetching different types of data as needed
}
