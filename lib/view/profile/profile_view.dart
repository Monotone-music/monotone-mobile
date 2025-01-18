import 'dart:io';
import 'package:mime/mime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monotone_flutter/common/api_url.dart';
import 'dart:math';
import 'package:provider/provider.dart';

import 'package:monotone_flutter/auth/login/logout_button.dart';
import 'package:monotone_flutter/controller/payment/subscription_controller.dart';
import 'package:monotone_flutter/controller/profile/profile_data_services.dart';
import 'package:monotone_flutter/controller/profile/profile_loader.dart';
import 'package:monotone_flutter/view/payment/transaction_status.dart';
import 'package:monotone_flutter/widgets/image_widgets/image_renderer.dart';
import 'package:monotone_flutter/auth/login/logout_button.dart';
import 'package:monotone_flutter/widgets/image_widgets/image_renderer.dart';
import 'package:monotone_flutter/models/profile_items.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';

class ProfileView extends StatefulWidget {
  final Map<String, String> profile;
  final String? bitrate;

  ProfileView({required this.profile, required this.bitrate});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool isEditing = false;
  bool isLoading = false;
  TextEditingController displayNameController = TextEditingController();
  final _profileDataService = ProfileDataService();
  File? _selectedImage;
  File? _placeHolderImage;

  @override
  void initState() {
    super.initState();
    displayNameController.text = widget.profile['displayName'] ?? '';
  }

// MAKE A REQUEST TO THE API
  Future<void> updateDisplayName(String newName) async {
    try {
      if (newName.trim().isEmpty) {
        Fluttertoast.showToast(
          msg: 'Your display name cannot be empty',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      final result = await _profileDataService.changeDisplayName(newName);

      if (result == '200') {
        setState(() {
          widget.profile['displayName'] = newName;
          isEditing = false;
        });
        Fluttertoast.showToast(
          msg: 'Name updated successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to update display name',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error updating display name',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
  }

  Future<void> updateProfileImage(File? imageFile) async {
    try {
      if (imageFile == null) {
        Fluttertoast.showToast(
          msg: 'Please choose a file',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      final result = await _profileDataService.changeAvatar(imageFile);

      if (result == '200') {
        setState(() {
          _placeHolderImage = imageFile;
          _selectedImage = null;
          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: 'Profile image updated successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: 'Failed to update profile image',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }
    } catch (e) {
      print('Error updating profile image: $e');
      Fluttertoast.showToast(
        msg: 'Error updating profile image',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
  }

// HANDLE CALL IN UI
  void _showEditDisplayNameDialog() {
    String tempName = widget.profile['displayName'] ?? '';
    displayNameController.text = tempName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Display Name'),
          content: TextField(
            controller: displayNameController,
            decoration: InputDecoration(
                labelText: 'Display Name',
                labelStyle: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                )),
            onSubmitted: (newValue) {
              updateDisplayName(newValue);
              Navigator.of(context).pop();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                displayNameController.text = tempName;
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                updateDisplayName(displayNameController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImageFromGallery(StateSetter setState) async {
    setState(() {
      isLoading = true;
    });

    final ImagePicker _picker = ImagePicker();
    final XFile? returnImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (returnImage != null) {
      // print(returnImage.path);

      setState(() {
        _selectedImage = File(returnImage.path);
        isLoading = false;
      });
    }
  }

  void _showEditAvatarDialog() {
    const _nullImage = null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Choose an Image'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isLoading
                      ? const CircularProgressIndicator()
                      : _selectedImage != null
                          ? GestureDetector(
                              onTap: () => _pickImageFromGallery(setState),
                              child: Image.file(_selectedImage!),
                            )
                          : IconButton(
                              icon: const Icon(Icons.file_upload_outlined),
                              color: Colors.white.withOpacity(0.3),
                              iconSize: 200,
                              onPressed: () => _pickImageFromGallery(setState),
                            ),
                ],
              ),

              ///
              actions: [
                TextButton(
                  onPressed: () {
                    _selectedImage = _nullImage; // Revert to the original image
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    updateProfileImage(_selectedImage);
                    // Handle image submission here
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final bitrate = widget.bitrate;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();
    final SubscriptionController _subscriptionController =
        SubscriptionController();

    return SafeArea(
        child: SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 25, bottom: 25, left: 10, right: 10),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage(
                    'assets/image/dark_theme_music_background.jpg'), // Replace with your image path
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
                        child: _placeHolderImage != null
                            ? Image.file(
                                _placeHolderImage!,
                                height: min(
                                    MediaQuery.sizeOf(context).height * 0.13,
                                    100),
                                width: min(
                                    MediaQuery.sizeOf(context).width * 0.25,
                                    100),
                                fit: BoxFit.cover,
                              )
                            : ImageRenderer(
                                imageUrl: profile['filename'] == null ||
                                        profile['filename']!
                                            .endsWith('blank_avatar.png')
                                    ? 'assets/image/blank_avatar.png'
                                    : '$BASE_URL/image/${profile['filename']}',
                                height: min(
                                    MediaQuery.sizeOf(context).height * 0.13,
                                    100),
                                width: min(
                                    MediaQuery.sizeOf(context).width * 0.25,
                                    100),
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
                                  profile['displayName'] ?? 'User Name',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(
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
                                  _showEditDisplayNameDialog();
                                },
                              ),

                              ///
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
                                  _showEditAvatarDialog();
                                },
                              ),
                            ]),

                        const SizedBox(
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
                                      height: 20,
                                      // child: Text(
                                      //   // profile.identifier,
                                      //   'User ID: 123456',
                                      //   style: TextStyle(
                                      //       fontSize: 17,
                                      //       color:
                                      //           changePrimary.withOpacity(0.6)),
                                      //   maxLines: 1,
                                      //   overflow: TextOverflow.ellipsis,
                                      // ),
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
          if (bitrate == '192')
            Container(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 50, left: 10, right: 10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage(
                        'assets/image/dark_theme_membership_background.jpg'), // Replace with your image path
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      changePrimary.withOpacity(0.7),
                      BlendMode.dstOut,
                    ),
                  ),
                  border: Border.all(
                    color: const Color.fromARGB(255, 70, 69, 69),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),

                ///
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ///
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
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
                        SizedBox(
                          child: Text(
                            'Current plan: ${profile['membershipType'] ?? 'free'}',
                            style: const TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                        )

                        ///
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    ///
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Expanded(
                          child: Text(
                            'Enjoy quality music with 5\$',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        ToggleButtons(
                          isSelected: [true, false],
                          onPressed: (int index) {
                            if (index == 1) {
                              GoRouter.of(context)
                                  .go('/transaction-status', extra: {
                                'subscriptionController':
                                    _subscriptionController,
                                'amount': 500,
                                'currency': 'usd',
                                'membershipType': 'membership',
                              });
                            }
                          },
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: const Text('Free'),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: const Text('Upgrade'),
                            ),
                          ],
                        ),
                      ],
                    )

                    ///
                  ],
                )

                ///
                )
          else
            Container(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 50, left: 10, right: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(
                      'assets/image/green_theme_membership_background.jpg'), // Replace with your image path
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.green.withOpacity(0.5),
                    BlendMode.dstOut,
                  ),
                ),
                border: Border.all(
                  color: const Color.fromARGB(255, 70, 69, 69),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(bottom: 10.0, left: 10.0)),
                      ImageRenderer(
                        imageUrl: 'assets/image/term_and_service_icon.svg',
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        child: Text(
                          'Current plan: ${profile['membershipType'] ?? 'basic'}',
                          style: const TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Text(
                          'Thank you for your support, please enjoy the upgraded content',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],

                    ///
                  ),
                ],
              ),
            ),

          ///
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
          ),

          /// THE ROW OF LISTENING HISTORY, TERMS AND SERVICE AND SETTINGS AND PRIVACY
          Column(
            children: [
              //     Row(
              //       children: [
              //         const Padding(padding: EdgeInsets.all(0)),
              //         SizedBox(
              //           width: MediaQuery.of(context).size.width * 0.98,
              //           height: MediaQuery.of(context).size.height * 0.06,
              //           child: ListTile(
              //             leading: ImageRenderer(
              //                 imageUrl: 'assets/image/history_icon.svg',
              //                 width: 40,
              //                 height: 40),
              //             title: const Text(
              //               "Listening history",
              //               style: TextStyle(
              //                   fontSize: 20, fontWeight: FontWeight.normal),
              //             ),
              //             trailing: ImageRenderer(
              //                 imageUrl: 'assets/image/expand_arrow_icon.svg'),
              //             onTap: () {
              //               print('Listening history pressed');
              //             },
              //           ),
              //         )

              //         ///
              //       ],
              //     ),

              //     ///
              //     Padding(
              //       padding: const EdgeInsets.only(
              //           left: 20, right: 20, top: 10, bottom: 10),
              //       child: Divider(
              //         color: Colors.grey.withOpacity(0.3),
              //         thickness: 1.0, // Line thickness
              //         height: 10,
              //       ),
              //     ),

              //     ///
              //     Row(
              //       children: [
              //         const Padding(padding: EdgeInsets.all(0)),
              //         SizedBox(
              //           width: MediaQuery.of(context).size.width * 0.98,
              //           height: MediaQuery.of(context).size.height * 0.06,
              //           child: ListTile(
              //             leading: SizedBox(
              //               width: 40,
              //               height: 40,
              //               child: Padding(
              //                 padding: const EdgeInsets.all(7),
              //                 child: ImageRenderer(
              //                     imageUrl: 'assets/image/setting_icon.svg',
              //                     width: 30,
              //                     height: 30),
              //               ),
              //             ),
              //             title: const Text(
              //               "Settings and privacy",
              //               style: TextStyle(
              //                   fontSize: 20, fontWeight: FontWeight.normal),
              //             ),
              //             trailing: ImageRenderer(
              //               imageUrl: 'assets/image/expand_arrow_icon.svg',
              //             ),
              //             onTap: () {
              //               print('Settings');
              //             },
              //           ),
              //         ),

              //         ///
              //       ],
              //     ),

              //     ///
              //     Padding(
              //       padding: const EdgeInsets.only(
              //           left: 20, right: 20, top: 10, bottom: 10),
              //       child: Divider(
              //         color: Colors.grey.withOpacity(0.3),
              //         thickness: 1.0, // Line thickness
              //         height: 10,
              //       ),
              //     ),

              //     ///
              //     Row(
              //       children: [
              //         const Padding(padding: EdgeInsets.all(0)),
              //         SizedBox(
              //           width: MediaQuery.of(context).size.width * 0.98,
              //           height: MediaQuery.of(context).size.height * 0.06,
              //           child: ListTile(
              //             leading: SizedBox(
              //               width: 40,
              //               height: 40,
              //               child: ImageRenderer(
              //                   imageUrl: 'assets/image/term_and_service_icon.svg'),
              //             ),
              //             title: const Text(
              //               "Our terms and services",
              //               style: TextStyle(
              //                   fontSize: 20, fontWeight: FontWeight.normal),
              //             ),
              //             trailing: ImageRenderer(
              //                 imageUrl: 'assets/image/expand_arrow_icon.svg'),
              //             onTap: () {
              //               print('Term and services pressed');
              //             },
              //           ),
              //         ),

              //         ///
              //       ],
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(
              //           left: 20, right: 20, top: 10, bottom: 10),
              //       child: Divider(
              //         color: Colors.grey.withOpacity(0.3),
              //         thickness: 1.0, // Line thickness
              //         height: 10,
              //       ),
              //     ),
              //     SizedBox(height: 16.0),
              LogoutButton(
                onPressed: () async {
                  final logoutButton = LogoutButton(onPressed: () {});
                  await logoutButton.logout(context);
                },
              ),
              SizedBox(height: 16.0),

              ///
            ],
          )

          ///
        ],
      ),

      ///
    ));
  }
}
