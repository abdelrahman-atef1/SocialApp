import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:social_app/shared/components/components.dart';

class ImageViewerScreen extends StatelessWidget {
  final String image;
  const ImageViewerScreen({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: defaultAppBar(
          backGroundColor: Colors.black,
          iconColor: Colors.white,
          context: context,
        ),
        body: SizedBox(
          child: PhotoView(
            heroAttributes: PhotoViewHeroAttributes(tag: image),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.contained * 10,
            imageProvider: CachedNetworkImageProvider(image),
          ),
        ));
  }
}
