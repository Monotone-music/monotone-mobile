import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageRenderer extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final String altImage = 'assets/image/not_available.png';

  ImageRenderer({Key? key, required this.imageUrl,this.height,this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildImage(imageUrl);
  }

  /// Build image according to .svg, .png, .jpg, or network
  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      if (imageUrl.endsWith('.svg')) {
        return SvgPicture.network(
          imageUrl,
          height: height,
          width: width,
          semanticsLabel: 'My SVG Image',
          fit: BoxFit.cover,
          placeholderBuilder: (BuildContext context) => _buildAltImage(),
        );
      } else {
        return Image.network(
          imageUrl,
          height: height,
          width: width,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            }
          },
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            print('Error loading network image: $error');
            return _buildAltImage();
          },
        );
      }
    } else {
      if (imageUrl.endsWith('.svg')) {
        return SvgPicture.asset(
          imageUrl,
          height: height,
          width: width,
          semanticsLabel: 'My SVG Image',
          fit: BoxFit.cover,
          placeholderBuilder: (BuildContext context) => _buildAltImage(),
        );
      } else {
        return Image.asset(
          imageUrl,
          height: height,
          width: width,
          fit: BoxFit.cover,
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            print('Error loading asset image: $error');
            return _buildAltImage();
          },
        );
      }
    }
  }

  /// Build alternative image
  Widget _buildAltImage() {
    return Image.asset(
      altImage,
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }
}