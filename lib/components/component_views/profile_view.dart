import 'package:flutter/material.dart';
import 'package:monotone_flutter/components/models/profile_items.dart';

class ProfileView extends StatelessWidget {
  final ProfileItems profile;

  ProfileView({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
     padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                const Color.fromARGB(255, 101, 98, 98).withOpacity(0.3), // Faded color at the top
                const Color.fromARGB(255, 101, 98, 98).withOpacity(0.0), // Faded color at the top
              ],
            ),            border: Border.all(color: const Color.fromARGB(255, 70, 69, 69), width: 1.0, ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(profile.avatar), // Replace with your image asset
              ),
              SizedBox(width: 20), // Increased width for more space
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name, style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10), // Increased height for more space
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(profile.follower.toString(), style: TextStyle(fontSize: 16)),
                            SizedBox(width: 5),
                            Text('Followers', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(width: 20), // Increased width for more space
                        Row(
                          children: [
                            Text(profile.following.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(width: 5),
                            Text('Following', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // Increased height for more space
                    Text(profile.identifier, style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
      )],
      ),
    );
  }
}