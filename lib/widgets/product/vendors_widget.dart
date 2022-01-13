import 'dart:ui';
import 'package:alena/models/vendors.dart';
import 'package:alena/screens/navigation/products_nav/products_screen.dart';
import 'package:alena/utils/shared.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VendorsWidget extends StatelessWidget {
  final Vendors vendor;
  final String category;

  const VendorsWidget({Key key, this.vendor, this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: (){
                  navigatorKey.currentState.push(MaterialPageRoute(builder: (_) => ProductsScreen(category: category,vendor: vendor,)));
                },
                child: Card(
                  elevation: 4,
                  color: white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  child: Stack(
                    children: [
                      Positioned.fill(
                          child: Hero(
                            tag: vendor.id,
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: vendor.logo,
                            ),
                          )
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: _blurBottomContainer(),
                      ),
                    ],
                  ),
                ),
              ),
            );
  }

  Widget _blurBottomContainer() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30)
          ),
          height: 50,
          width: SizeConfig.screenWidth,
          child: Center(
            child: Text('${vendor.brand}',style: TextStyle(fontFamily: 'AA-GALAXY',fontSize: 20,
              color: black,letterSpacing: 1,fontWeight: FontWeight.bold,),
            ),
          ),
        ),
      ),
    );
  }
}
