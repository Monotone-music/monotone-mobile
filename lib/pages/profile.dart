import 'package:flutter/material.dart';

import 'package:monotone_flutter/components/logic_components/profile_data_services.dart'; 
import 'package:monotone_flutter/components/models/profile_items.dart';
import 'package:monotone_flutter/components/logic_components/profile_loader.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(),
      body: ProfileBody(),
    );
  }
}

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('DMC5'),
      actions: [
        IconButton(
          icon: const Icon(Icons.brightness_6),
          onPressed: () {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class ProfileBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch the profile data from the service
    Future<ProfileItems> fetchProfile() async {
      // Simulate a network call or data fetching
      await Future.delayed(Duration(seconds: 1));
      return ProfileDataService().getProfileData();
    }

    return ProfileLoader(fetchProfileData: fetchProfile);
  }
}