import 'package:flutter/material.dart';

import 'package:monotone_flutter/controller/profile/profile_data_services.dart';
import 'package:monotone_flutter/models/profile_items.dart';
import 'package:monotone_flutter/controller/profile/profile_loader.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: ProfileAppBar(),
      body: ProfileBody(),
    );
  }
}

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      // title: const Text('DMC5'),
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
    final fetchProfile = () => ProfileDataService().fetchProfileApi(context);
    return ProfileLoader(fetchProfileData: fetchProfile);
  }
}
