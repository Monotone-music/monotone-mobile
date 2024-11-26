import 'package:flutter/material.dart';
import 'package:monotone_flutter/auth/login/login_form.dart';
import 'package:monotone_flutter/pages/artist_detail.dart';
import 'package:monotone_flutter/components/component_views/search_bar_view.dart';

class DiscoverPage extends StatefulWidget {
  DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 20,
        ),
        body: Padding(
          padding: EdgeInsets.only(right: 16, left: 16, bottom: 30),
          child: Stack(
            children: [
              Column(
                children: [
                  // Container(
                  //   height: MediaQuery.of(context).size.height *
                  //       0.43, // Set a fixed height for the stack
                  //   child: Stack(
                  //     children: [
                  //       Positioned(
                  //         top: 100,
                  //         left: 0,
                  //         right: 0,
                  //         child: _buildPanel(),
                  //       ),
                  //       Positioned(
                  //         top: 0,
                  //         left: 0,
                  //         right: 0,
                  //         child: _searchPanel(),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // _buildPanel(),
                  // _searchPanel(),
                  _loginPanel(),

                  ///
                ],
              ),

              ///
            ],
          ),
        ));

    ///
  }

  Widget _searchPanel() {
    return Container(
      child: SearchBarView(hintText: 'Discover'),
      height: MediaQuery.of(context).size.height * 0.1,
    );
  }

//
  Widget _loginPanel() {
    return LoginForm();
  }

//
  Widget _buildPanel() {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            child: Text("Go to second page"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArtistDetailPage(
                    artistId: '',
                    focusOnTextField: false,
                  ),
                ),
              );
            }));
  }
}
