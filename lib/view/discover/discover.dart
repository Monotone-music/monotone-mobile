import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'package:monotone_flutter/auth/login/login_form.dart';
import 'package:monotone_flutter/widgets/image_widgets/image_renderer.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/view/artist_detail/artist_detail.dart';
import 'package:monotone_flutter/view/search/search_bar_view.dart';

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

                  _buildPanel(),
                  // _searchPanel(),
                  // _loginPanel(),

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

// //
//   Widget _loginPanel() {
//     return LoginForm();
//   }

//
  Widget _buildPanel() {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ]);
    final baseUrl =
        'https://api2.ibarakoi.online/image/091d57bd-5799-4f26-916d-b510fe1e5f96';

    return FutureBuilder<Response>(
      future: _fetchImage(httpClient, baseUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No data found'));
        } else {
          final imageUrl = snapshot
              .data?.bodyBytes; // Assuming the URL is in the 'url' field
          // print(imageUrl);
          if (imageUrl != null) {
            return SizedBox(
              child: ImageRenderer(
                imageUrl: imageUrl,
                height: 200,
                width: 200,
              ),
            );
          } else
            return SizedBox(
              child: ImageRenderer(
                height: 200,
                width: 200,
                imageUrl: 'assets/image/not_available.png',
              ),
            );

          ///
        }
      },

      ///
    );
  }

  Future<Response> _fetchImage(dioInterceptor, String baseUrl) async {
    await Future.delayed(Duration(seconds: 1));
    final httpClient = InterceptedClient.build(
      interceptors: [
        JwtInterceptor(),
      ],
      retryPolicy: ExpiredTokenRetryPolicy(),
    );
    final response = await httpClient.get(
      Uri.parse(baseUrl),
    );
    return response;
  }
}
