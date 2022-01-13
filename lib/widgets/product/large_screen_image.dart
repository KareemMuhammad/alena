import 'package:alena/utils/shared.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:photo_view/photo_view.dart';

class LargeScreenImage extends StatelessWidget {
  final List<dynamic> image;

  const LargeScreenImage({Key key, this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function())setState)
      {
        return WillPopScope(
          onWillPop: () {
            return Future.value(true);
          },
          child: Material(
            child: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                color: white,
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                child:  Column(
                  children: [
                    IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.keyboard_arrow_down, color: button,size: 40,)),
                    Container(
                      height: SizeConfig.screenHeight * 0.8,
                      width: SizeConfig.screenWidth,
                      child: Swiper(
                        loop: false,
                        itemCount: image.length,
                        pagination: new SwiperPagination(
                          alignment: Alignment.bottomCenter,
                          builder: new DotSwiperPaginationBuilder(
                              color: Colors.grey[600], activeColor: button),
                        ),
                        itemBuilder: (BuildContext context, int imageIndex) {
                          return CachedNetworkImage(
                              imageBuilder: (context, imageProvider) =>
                                  PhotoView(
                                    minScale: PhotoViewComputedScale.contained,
                                    enableRotation: false,
                                    backgroundDecoration: BoxDecoration(
                                      color: white,
                                    ),
                                    imageProvider: imageProvider,
                                  ),
                              width: double.maxFinite,
                              height: double.maxFinite,
                              imageUrl: image[imageIndex],
                              progressIndicatorBuilder: (context, url, downloadProgress) => Image.asset('assets/image-not-found.png'),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
