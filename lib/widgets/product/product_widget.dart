import 'dart:ui';
import 'package:alena/database/blocs/favorite_bloc/favorite_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_state.dart';
import 'package:alena/models/product.dart';
import 'package:alena/models/user.dart';
import 'package:alena/utils/shared.dart';
import 'package:alena/widgets/product/large_screen_description.dart';
import 'package:alena/widgets/product/large_screen_image.dart';
import 'package:alena/widgets/sheets/order_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final AppUser appUser;
  final FavoriteCubit favoriteCubit;
  final UserCubit userCubit;

  const ProductWidget({Key key, this.product, this.favoriteCubit, this.appUser, this.userCubit}) : super(key: key);
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
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      );
                    },
                  ),
                ),
                BlocBuilder<UserCubit,UserState>(
                    builder: (ctx,state){
                    if(state is UserLoaded){
                      return Positioned(
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: white,
                          child: IconButton(
                            onPressed: (){
                              if(state.appUser.favorites.contains(product.id)) {
                                favoriteCubit.updateFavoritesList(product.id, 1);
                              }else{
                                favoriteCubit.updateFavoritesList(product.id, 0);
                              }
                              userCubit.loadUserData();
                            },
                            icon: Icon(state.appUser.favorites.contains(product.id)? Icons.favorite : Icons.favorite_border),
                            color: state.appUser.favorites.contains(product.id)? button : black,
                            iconSize: 23,
                          ),
                        ),
                        top: 10,
                        right: 10,
                      );
                    }else{
                      return Positioned(
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: white,
                          child: IconButton(
                            onPressed: (){
                              if(appUser.favorites.contains(product.id)) {
                                favoriteCubit.updateFavoritesList(product.id, 1);
                              }else{
                                favoriteCubit.updateFavoritesList(product.id, 0);
                              }
                              userCubit.loadUserData();
                            },
                            icon: Icon(appUser.favorites.contains(product.id)? Icons.favorite : Icons.favorite_border),
                            color: appUser.favorites.contains(product.id)? button : black,
                            iconSize: 23,
                          ),
                        ),
                        top: 10,
                        right: 10,
                      );
                    }
                }),
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
                 _showMySheet(context);
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

  void _showMySheet(BuildContext context) {
    showModalBottomSheet(context: context, builder: (_){
      return Wrap(
        children: [
          new OrderSheet(product: product,),
        ],
      );
    },
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30))
      ),
    );
  }
}
