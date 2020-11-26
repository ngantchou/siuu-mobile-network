import 'dart:io';

import 'package:Siuu/provider.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OBCover extends StatelessWidget {
  final String coverUrl;
  final File coverFile;
  static const double largeSizeHeight = 230.0;
  static const double mediumSizedHeight = 190.0;
  static const double smallSizeHeight = 160.0;
  static const COVER_PLACEHOLDER = 'assets/images/fallbacks/cover-fallback.jpg';
  final OBCoverSize size;
  final bool isZoomable;

  OBCover(
      {this.coverUrl,
      this.coverFile,
      this.size = OBCoverSize.large,
      this.isZoomable = true});

  @override
  Widget build(BuildContext context) {
    Widget image;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    double coverHeight;

    switch (size) {
      case OBCoverSize.large:
        coverHeight = largeSizeHeight;
        break;
        case OBCoverSize.medium:
        coverHeight = mediumSizedHeight;
        break;
      case OBCoverSize.small:
        coverHeight = smallSizeHeight;
        break;
      default:
        break;
    }

    if (coverFile != null) {
      image = FadeInImage(
        placeholder: AssetImage(COVER_PLACEHOLDER),
        image: FileImage(coverFile),
        fit: BoxFit.cover,
        alignment: Alignment.center,
      );
    } else if (coverUrl == null) {
      image = _getCoverPlaceholder(coverHeight);
    } else {
      image = CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: coverUrl != null ? coverUrl : '',
        placeholder: (BuildContext context, String url) {
          return const Center(
            child: const CircularProgressIndicator(),
          );
        },
          imageBuilder: (context, imageProvider) => Container(
          alignment: Alignment.center,
            child:ClipOval(
            child: Image.network(
              coverUrl,
              fit: BoxFit.cover,
              height:coverHeight,
              width:coverHeight,
            ),
          ),
          ),
        errorWidget: (BuildContext context, String url, Object error) {
          return  SizedBox(
            child:  Center(
              child:  ClipOval(
                child:  Image.network(
                  'https://via.placeholder.com/150',
                  width: coverHeight,
                  height: coverHeight,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        alignment: Alignment.center,
      );

      if (isZoomable) {
        image = GestureDetector(
          child: image,
          onTap: () {
            OpenbookProviderState openbookProvider =
                OpenbookProvider.of(context);
            openbookProvider.dialogService
                .showZoomablePhotoBoxView(imageUrl: coverUrl, context: context);
          },
        );
      }
    }
    return image;
  }

  Widget _getCoverPlaceholder(double coverHeight) {
    return CircleAvatar(
      backgroundImage: AssetImage(COVER_PLACEHOLDER),
    );
  }
}

enum OBCoverSize { large, small , medium}
