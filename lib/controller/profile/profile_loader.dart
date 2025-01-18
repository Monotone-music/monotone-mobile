import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:monotone_flutter/view/profile/profile_view.dart';

class ProfileLoader extends StatefulWidget {
  final Future<Map<String, String>> Function() fetchProfileData;

  ProfileLoader({required this.fetchProfileData});

  @override
  _ProfileLoaderState createState() => _ProfileLoaderState();
}

class _ProfileLoaderState extends State<ProfileLoader> {
  late Future<Map<String, String>> profileFuture;

  Future<Map<String, dynamic>> _loadProfileAndBitrate() async {
    const storage = FlutterSecureStorage();
    final profile = await profileFuture;
    final bitrate = await storage.read(key: 'bitrate');
    return {
      'profile': profile,
      'bitrate': bitrate,
    };
  }

  @override
  void initState() {
    super.initState();
    profileFuture = widget.fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadProfileAndBitrate(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final profile = snapshot.data!['profile'] as Map<String, String>;
          final bitrate = snapshot.data!['bitrate'] as String?;
          return ProfileView(profile: profile, bitrate: bitrate);
        } else {
          return Center(child: Text('No profile data available'));
        }
      },
    );
  }
}
