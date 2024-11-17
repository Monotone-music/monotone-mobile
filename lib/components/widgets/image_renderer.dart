import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageRenderer extends StatelessWidget {
  final dynamic imageUrl;
  final double? height;
  final double? width;
  final String altImage = 'assets/image/not_available.png';

  ImageRenderer({Key? key, required this.imageUrl, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildImage(imageUrl);
  }

  /// Build image according to .svg, .png, .jpg, or network
  Widget _buildImage(dynamic imageUrl) {
    if (imageUrl == null) {
      print('Run into error image');
      return _buildAltImage();
    } else if (imageUrl is ImageProvider) {
      return Image(
        image: imageUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          print('Error loading asset image: $error');
          return _buildAltImage();
        },
      );
    } else if (imageUrl is String) {
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
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              print('Error loading asset image: $error');
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
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              print('Error loading asset image: $error');
              return _buildAltImage();
            },
          );
        }
      }
    } else {
      return Image.asset(
        imageUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          print('Error loading asset image: $error');
          return _buildAltImage();
        },
      );
    }
  }

  /// Build alternative image
  Widget _buildAltImage() {
    return Image.asset(
      altImage,
      height: height,
      width: width,
      fit: BoxFit.cover,
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        print('Error loading asset image: $error');
        return _buildAltImage();
      },
    );
  }
}
