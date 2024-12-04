import 'package:flutter/material.dart';
import 'package:monotone_flutter/view/payment/payment.dart';
import 'package:monotone_flutter/widgets/image_widgets/image_renderer.dart';
import 'dart:math';
import 'package:provider/provider.dart';

import 'package:monotone_flutter/models/profile_items.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';

class ProfileView extends StatelessWidget {
  final ProfileItems profile;

  ProfileView({required this.profile});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 25, bottom: 25, left: 10, right: 10),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    profile.avatar), // Replace with your image path
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  changePrimary.withOpacity(0.8),
                  BlendMode.dstOut,
                ),
              ),
              border: Border.all(
                color: const Color.fromARGB(255, 70, 69, 69),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ///
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
                              min(MediaQuery.sizeOf(context).width * 0.25, 100),
                        ),
                      ),
                    ),
                  ],
                ),
                //
                const Column(
                  children: [
                    SizedBox(
                      width: 15,
                    )
                  ],
                ),

                ///
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(padding: EdgeInsets.only(bottom: 10.0)),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
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
                              SizedBox(
                                width: 25,
                              ),
                              IconButton(
                                icon: ImageRenderer(
                                  imageUrl:
                                      'assets/image/profile_adjust_icon.svg',
                                  width: min(
                                      MediaQuery.sizeOf(context).height * 0.035,
                                      35),
                                  height: min(
                                      MediaQuery.sizeOf(context).height * 0.035,
                                      35),
                                ),
                                color: changePrimary.withOpacity(1),
                                onPressed: () {
                                  // Handle edit action
                                  print('Edit button pressed');
                                },
                              ),
                              IconButton(
                                icon: ImageRenderer(
                                  imageUrl:
                                      'assets/image/profile_avatar_upload_icon.svg',
                                  width: min(
                                      MediaQuery.sizeOf(context).height * 0.03,
                                      35),
                                  height: min(
                                      MediaQuery.sizeOf(context).height * 0.03,
                                      35),
                                ),
                                color: changePrimary.withOpacity(1),
                                onPressed: () {
                                  // Handle edit action
                                  print('Edit button pressed');
                                },
                              ),
                            ]),

                        ///
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: Text.rich(TextSpan(children: [
                                    TextSpan(
                                      text: '${profile.follower}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: changePrimary),
                                    ),
                                    TextSpan(
                                      text: '  followers',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              changePrimary.withOpacity(0.6)),
                                    ),
                                  ]))),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: Text.rich(TextSpan(children: [
                                    TextSpan(
                                      text: '${profile.following}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: changePrimary),
                                    ),
                                    TextSpan(
                                      text: '  following',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              changePrimary.withOpacity(0.6)),
                                    ),
                                  ])))
                            ]),
                        //
                        SizedBox(
                          height: 10,
                        ),
                        //
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        profile.identifier,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color:
                                                changePrimary.withOpacity(0.6)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                )
                              ])
                            ])

                        ///
                      ],
                    )
                  ],
                )
              ],
            ),
          ),

          ///
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
          ),

          ///
          Container(
              padding:
                  const EdgeInsets.only(top: 20, bottom: 50, left: 5, right: 5),
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

              ///
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(bottom: 10.0, left: 10.0)),

                      ///
                      ImageRenderer(
                        imageUrl: 'assets/image/term_and_service_icon.svg',
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),

                      ///
                      const SizedBox(
                        width: 5,
                      ),

                      ///
                      const SizedBox(
                        child: Text(
                          'Plan',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      )

                      ///
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  ///
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PaymentPage()),
                      );
                    },
                    child: Row(
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(bottom: 10.0, left: 15.0)),

                        ///
                        const SizedBox(
                          height: 20,
                        ),

                        ///
                        Text(
                          profile.member ? 'Premium - Member' : 'Free',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.normal,
                          ),
                        ),

                        ///
                      ],
                    ),
                  ),

                  ///
                  const SizedBox(
                    height: 10,
                  ),

                  ///
                  Row(
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(bottom: 10.0, left: 15.0)),
                      Text(
                        '${profile.member_type}: ${profile.membership_price_amount}\$ /${profile.membership_price_unit}',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    ],
                  )

                  ///
                ],
              )),

          ///
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
          ),

          ///
          Column(
            children: [
              Row(
                children: [
                  const Padding(padding: EdgeInsets.all(0)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.98,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: ListTile(
                      leading: ImageRenderer(
                          imageUrl: 'assets/image/history_icon.svg'),
                      title: const Text(
                        "Listening history",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.normal),
                      ),
                      trailing: ImageRenderer(
                          imageUrl: 'assets/image/expand_arrow_icon.svg'),
                      onTap: () {
                        print('Listening history pressed');
                      },
                    ),
                  )

                  ///
                ],
              ),

              ///
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  color: Colors.grey.withOpacity(0.3),
                  thickness: 1.0, // Line thickness
                  height: 10,
                ),
              ),

              ///
              Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.97,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: ListTile(
                      leading: ImageRenderer(
                          imageUrl: 'assets/image/setting_icon.svg'),
                      title: const Text(
                        "Settings and privacy",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.normal),
                      ),
                      trailing: ImageRenderer(
                          imageUrl: 'assets/image/expand_arrow_icon.svg'),
                      onTap: () {
                        print('Settings');
                      },
                    ),
                  ),

                  ///
                ],
              ),

              ///
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  color: Colors.grey.withOpacity(0.3),
                  thickness: 1.0, // Line thickness
                  height: 10,
                ),
              ),

              ///
              Row(
                children: [
                  const Padding(padding: EdgeInsets.all(0)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.98,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: ListTile(
                      leading: ImageRenderer(
                          imageUrl: 'assets/image/term_and_service_icon.svg'),
                      title: const Text(
                        "Our terms and services",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.normal),
                      ),
                      trailing: ImageRenderer(
                          imageUrl: 'assets/image/expand_arrow_icon.svg'),
                      onTap: () {
                        print('Term and services pressed');
                      },
                    ),
                  )

                  ///
                ],
              ),

              ///
            ],
          )

          ///
        ],
      ),

      ///
    );
  }
}
