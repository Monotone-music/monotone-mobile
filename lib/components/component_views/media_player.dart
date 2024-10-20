import 'package:flutter/material.dart';
import 'package:monotone_flutter/components/logic_components/media_player_provider.dart';
import 'package:monotone_flutter/components/widgets/image_renderer.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class MediaPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Consumer<MediaPlayerProvider>(
      builder: (context, mediaPlayerProvider, child) {
        // final mediaUrl = mediaPlayerProvider.currentMediaUrl;
        return Scaffold(
          backgroundColor: isDarkMode
              ? const Color(0xFF333842)
              : const Color(0xFFAAB3C6), // Set the background color here
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(80.0), // Set the height of the AppBar
            child: AppBar(
              backgroundColor: isDarkMode
                  ? const Color(0xFF333842)
                  : const Color(0xFFAAB3C6),
              elevation: 0,
              toolbarHeight: 140.0,
              leading: Padding(
                padding: const EdgeInsets.only(
                    top: 20.0), // Add padding above the icon
                child: IconButton(
                  icon:
                      Icon(Icons.keyboard_arrow_down, color: Color(0xFF898989)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(
                    top: 20.0), // Add padding above the text
                child: Text(
                  'Now Playing',
                  style: TextStyle(color: Color(0xFFE0E0E0)),
                ),
              ),
              centerTitle: true,
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: PageController(initialPage: 1),
                  children: [
                    _buildPlaylist(context),
                    _buildMainPlayer(context, mediaPlayerProvider),
                    _buildLyrics(context),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight:
                        1.0, // Set the track height to make the slider thinner
                    thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 5.0), // Customize the thumb size
                    overlayShape: RoundSliderOverlayShape(
                        overlayRadius: 5.0), // Customize the overlay size
                  ),
                  child: Slider(
                    value: mediaPlayerProvider.position.inSeconds.toDouble(),
                    max: mediaPlayerProvider.duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      mediaPlayerProvider
                          .seek(Duration(seconds: value.toInt()));
                    },
                    activeColor: Colors.white,
                    inactiveColor: Colors.white24,
                  ),
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(mediaPlayerProvider.position),
                      style: TextStyle(color: Color(0xFF898989)),
                    ),
                    Text(
                      _formatDuration(mediaPlayerProvider.duration),
                      style: TextStyle(color: Color(0xFF898989)),
                    ),
                  ],
                ),
              ),

              // SizedBox(height: 5),
              // Playback Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.shuffle, color: Color(0xFF898989)),
                    onPressed: () {
                      // Implement shuffle functionality
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_previous,
                        color: Color(0xFF898989), size: 36),
                    onPressed: () {
                      // Implement skip previous functionality
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      mediaPlayerProvider.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: Colors.white,
                      size: 64,
                    ),
                    onPressed: () {
                      if (mediaPlayerProvider.isPlaying) {
                        mediaPlayerProvider.pause();
                      } else {
                        mediaPlayerProvider.play();
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next,
                        color: Color(0xFF898989), size: 36),
                    onPressed: () {
                      // Implement skip next functionality
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.repeat, color: Color(0xFF898989)),
                    onPressed: () {
                      // Implement repeat functionality
                    },
                  ),
                ],
              ),
              // SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.devices, color: Color(0xFF898989)),
                    onPressed: () {
                      // Implement change sound input functionality
                    },
                  ),
                  IconButton(
                    icon:
                        Icon(Icons.ios_share_rounded, color: Color(0xFF898989)),
                    onPressed: () {
                      // Implement download media functionality
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.queue_music, color: Color(0xFF898989)),
                    onPressed: () {
                      // Implement queue functionality
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.queue_outlined, color: Color(0xFF898989)),
                    onPressed: () {
                      // Implement queue functionality
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz_outlined,
                        color: Color(0xFF898989)),
                    onPressed: () {
                      // Implement share functionality
                    },
                  ),
                ],
              ),
              // Spacer(),
              // Close Button
              // TextButton(
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              //   child: Text('Close',
              //       style: TextStyle(fontSize: 18, color: Colors.white)),
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainPlayer(
      BuildContext context, MediaPlayerProvider mediaPlayerProvider) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(1.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Album Cover
          Container(
              width: 350,
              // height: 350,
              child: ImageRenderer(
                imageUrl: 'assets/image/album_1.png',
              )),
          SizedBox(height: 10),
          // Song Title and Artist
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0), // Add padding to both sides
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Song TitleSong TitleSong Title', // Replace with actual song title
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFFDBDBDB),
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Artist Name', // Replace with actual artist name
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF898989)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.favorite_border, color: Color(0xFF898989)),
                  onPressed: () {
                    // Implement favorite functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.playlist_add, color: Color(0xFF898989)),
                  onPressed: () {
                    // Implement add to playlist functionality
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylist(BuildContext context) {
    return Center(
      child: Text(
        'Playlist', // Replace with actual playlist content
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }

  Widget _buildLyrics(BuildContext context) {
    return Center(
      child: Text(
        'Lyrics', // Replace with actual lyrics content
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
