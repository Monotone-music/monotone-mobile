import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:monotone_flutter/components/models/artist_detail_items.dart'; // Import the Artist model
import 'package:monotone_flutter/components/logic_components/artist_detail_loader.dart';
import 'package:monotone_flutter/components/widgets/image_renderer.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';

// Define the ArtistDetailView widget
class ArtistDetailView extends StatelessWidget {
  final Artist artist;

  ArtistDetailView({required this.artist});

  @override
  Widget build(BuildContext context) {
    double height;
    double width;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
        child: Container(
      child: Column(
        children: [
          _avatarBuild(context),
          // _buildPanel()

          ///
        ],
      ),
    ));
  }

  // Widget _buildPanel() {
  //   return Container();
  // }

  ///
  Widget _avatarBuild(context) {
    double height;
    double width;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: height * 0.4,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.blue, width: 2)),

          ///
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),

              ///
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: changePrimary, // Border color
                    width: 1.0, // Border width
                  ),
                ),
                child: ClipOval(
                  child: ImageRenderer(
                    imageUrl: 'assets/image/rajang.jpg',
                    height: (height * 0.17),
                    width: (width * 0.4),
                  ),
                ),
              ),

              ///
              SizedBox(
                height: 20,
              ),

              ///
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(artist.name,
                        style: TextStyle(
                          color: changePrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        )),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        print('Artist Detail Play Button Pressed');
                        
                      },
                      icon: ImageRenderer(
                          height: height * 0.05,
                          width: width * 0.05,
                          imageUrl: 'assets/image/play_button_icon.svg')),
                ], 
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all()
                    ),
                  )
                ],
              )

              ///
            ],
          ),
        )
      ],
    );
  }

  ///
}
