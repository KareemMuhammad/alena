import 'dart:ui';
import 'package:alena/database/blocs/favorite_bloc/favorite_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/models/product.dart';
import 'package:alena/utils/shared.dart';
import 'package:alena/widgets/product/large_screen_description.dart';
import 'package:alena/widgets/product/large_screen_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class FavoritesWidget extends StatelessWidget {
  final Product product;
  final UserCubit userCubit;
  final FavoriteCubit favoriteCubit;

  const FavoritesWidget({Key key, this.product, this.userCubit, this.favoriteCubit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 4,
        color: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: SizeConfig.screenHeight * 0.3,
                  width: SizeConfig.screenWidth,
                  child: Swiper(
                    loop: false,
                    itemCount: product.images.length,
                    pagination: new SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      builder: new DotSwiperPaginationBuilder(
                          color: Colors.grey[600], activeColor: button),
                    ),
                    itemBuilder: (BuildContext context, int imageIndex) {
                      return GestureDetector(
                        onTap: ()async{
                          await showDialog(context: context, builder: (_){
                            return new BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child:  LargeScreenImage(image: product.images,)
                            );
                          });
                        },
                        child: CachedNetworkImage(
                          imageBuilder: (context, imageProvider) =>
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: imageProvider,
                                  ),
                                ),
                              ),
                          width: double.maxFinite,
                          height: double.maxFinite,
                          imageUrl: product.images[imageIndex],
                          progressIndicatorBuilder: (context, url, downloadProgress) => Image.asset('assets/image-not-found.png'),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: white,
                    child: IconButton(
                      onPressed: ()async{
                        await favoriteCubit.updateFavoritesList(product.id, 1);
                        userCubit.loadUserData();
                      },
                      icon: const Icon(Icons.delete),
                      color: button,
                      iconSize: 28,
                    ),
                  ),
                  top: 10,
                  right: 10,
                ),
                Positioned(
                  child: Container(
                    width: 120,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[800])
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('${product.vendor.brand}',style: TextStyle(fontSize: 20,color: black,),
                          textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                  top: 10,
                  left: 10,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${product.deviceName}',
                style: TextStyle(color: Colors.grey[800], fontSize: 21,fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,maxLines: 1,),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15,5,15,0),
              child: Row(mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child: Text('${product.description}',
                    style: TextStyle(color: Colors.grey[800],fontSize: 17),maxLines: 2,
                    overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,)),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton.icon(
                  icon: Icon(Icons.arrow_back, size: 18,),
                  onPressed: () async {
                    await showDialog(context: context, builder: (_) {
                      return LargeScreenDescription(
                        text: product.description,
                        title: product.deviceName,);
                    });
                  },
                  label: Text('المزيد', style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      fontFamily: ''),),),

                const SizedBox(width: 15,),

                Text('${product.price.toInt()} LE',
                  style: TextStyle(color: Colors.grey[900], fontSize: 24, fontWeight: FontWeight.bold),),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                color: button,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 4,
                onPressed: () {

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('اطلب الان',style: TextStyle(fontSize: 19,color: white,fontFamily: 'AA-GALAXY',letterSpacing: 1),
                    textAlign: TextAlign.center,),
                ),
              ),
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}
