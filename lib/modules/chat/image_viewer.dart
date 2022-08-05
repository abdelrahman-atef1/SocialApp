import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:photo_view/photo_view.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

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
            actions: [
              IconButton(
                  onPressed: () async {
                    try {
                      // Saved with this method.
                      var imageId = await ImageDownloader.downloadImage(image,
                          destination:
                              AndroidDestinationType.directoryDownloads);
                      if (imageId == null) {
                        showToast('Download Failed', ToastState.error);
                        return;
                      } else {
                        showToast('Image Saved Successfully in Downloads.',
                            ToastState.success);
                      }
                    } catch (e) {
                      print(e);
                      showToast('Download Failed', ToastState.error);
                    }
                  },
                  icon: const Icon(
                    IconBroken.Download,
                    color: Colors.white,
                  ))
            ]),
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
