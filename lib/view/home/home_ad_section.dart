import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/controller/media/advertisment/advertisement_loader.dart';
import 'package:monotone_flutter/models/advertisement_items.dart';
import 'package:monotone_flutter/widgets/image_widgets/image_renderer.dart';

class HomeAdSection extends StatefulWidget {
  @override
  _HomeAdSectionState createState() => _HomeAdSectionState();
}

class _HomeAdSectionState extends State<HomeAdSection> {
  late Future<Advertisement> _adFuture;

  @override
  void initState() {
    super.initState();
    _adFuture = AdvertisementLoader().fetchRandomAdvertisement('banner');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Advertisement>(
      future: _adFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 500,
              height: 200,
              color: Colors.white,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final ad = snapshot.data!;
          return Container(
            width: 500,
            height: 200,
            child: ImageRenderer(
              imageUrl: '$BASE_URL/image/${ad.data.image.filename}',
            ),
          );
        } else {
          return Center(child: Text('No ad available'));
        }
      },
    );
  }
}
