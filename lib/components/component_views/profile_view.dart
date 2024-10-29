import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';

import 'package:monotone_flutter/components/widgets/image_renderer.dart';
import 'package:monotone_flutter/components/models/profile_items.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';

class ProfileView extends StatelessWidget {
  final ProfileItems profile;

  ProfileView({required this.profile});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();

    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  const Color.fromARGB(255, 101, 98, 98)
                      .withOpacity(0.3), // Faded color at the top
                  const Color.fromARGB(255, 101, 98, 98)
                      .withOpacity(0.0), // Fully transparent at the bottom
                ],
              ),
              border: Border.all(
                color: const Color.fromARGB(255, 70, 69, 69),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Column(
                  children: [
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
                          imageUrl: profile.avatar,
                          height: min(
                              MediaQuery.sizeOf(context).height * 0.13, 100),
                          width:
                              min(MediaQuery.sizeOf(context).width * 0.25, 200),
                        ),
                      ),
                    ),
                  ],
                ),

                const Column(
                  children: [
                    SizedBox(
                      width: 15,
                    )
                  ],
                ),

                Column(
                  children: [
                    const Padding(padding: EdgeInsets.only(bottom: 10.0),),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Text(
                        profile.name,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),

                 const Column(
                  children: [
                    SizedBox(
                      width: 15,
                    )
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Padding(padding: EdgeInsets.only(right: 5)),
                        IconButton(
                            icon: ImageRenderer(
                            imageUrl:'assets/image/profile_adjust_icon.svg',
                            width: min(MediaQuery.sizeOf(context).height * 0.035, 35),
                            height: min(MediaQuery.sizeOf(context).height * 0.035, 35),
                            ),
                            color: changePrimary.withOpacity(0.6),
                            onPressed: () {
                              // Handle edit action
                              print('Edit button pressed');
                            },
                          ),
                        IconButton(
                            icon: ImageRenderer(
                            imageUrl:'assets/image/profile_avatar_upload_icon.svg',
                            width: min(MediaQuery.sizeOf(context).height * 0.035, 35),
                            height: min(MediaQuery.sizeOf(context).height * 0.035, 35),
                            ),
                            color: changePrimary.withOpacity(0.6),
                            onPressed: () {
                              // Handle edit action
                              print('Edit button pressed');
                            },
                          ),
                    ],
                  )
                ],)


              ],
            ),
          ),
        ],
      ),
    );
  }
}
