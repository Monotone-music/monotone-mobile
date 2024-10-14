import 'package:flutter/material.dart';
import 'package:monotone_flutter/components/models/profile_items.dart';
import 'package:monotone_flutter/components/component_views/profile_view.dart';

class ProfileLoader extends StatefulWidget {
  final Future<ProfileItems> Function() fetchProfileData;

  ProfileLoader({required this.fetchProfileData});

  @override
  _ProfileLoaderState createState() => _ProfileLoaderState();
}

class _ProfileLoaderState extends State<ProfileLoader> {
  late Future<ProfileItems> profileFuture;

  @override
  void initState() {
    super.initState();
    profileFuture = widget.fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileItems>(
      future: profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return ProfileView(profile: snapshot.data!);
        } else {
          return Center(child: Text('No profile data available'));
        }
      },
    );
  }
}