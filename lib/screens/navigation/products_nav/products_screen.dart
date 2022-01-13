import 'package:alena/database/blocs/favorite_bloc/favorite_cubit.dart';
import 'package:alena/database/blocs/product_bloc/product_bloc.dart';
import 'package:alena/database/blocs/product_bloc/product_state.dart';
import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/models/user.dart';
import 'package:alena/models/vendors.dart';
import 'package:alena/utils/constants.dart';
import 'package:alena/utils/shared.dart';
import '../../../widgets/product/product_widget.dart';
import 'package:alena/widgets/helpers/shared_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductsScreen extends StatefulWidget {
  final Vendors vendor;
  final String category;

  const ProductsScreen({Key key, this.category, this.vendor}) : super(key: key);
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductCubit>(context).loadVendorProducts(widget.category,widget.vendor.id);
  }

  @override
  Widget build(BuildContext context) {
    final FavoriteCubit favoriteCubit = BlocProvider.of<FavoriteCubit>(context);
    final UserCubit userCubit = BlocProvider.of<UserCubit>(context);
    final AppUser user = Utils.getCurrentUser(context);
    return Scaffold(
      backgroundColor: white,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(
              delegate: SliverChildListDelegate(
             [
              BlocBuilder<ProductCubit,ProductState>(
                builder: (BuildContext ctx, ProductState state){
                  if(state is ProductLoaded) {
                    return state.products.isEmpty ?
                    Center(child: Text('مفيش اعلانات ل${widget.vendor.brand}  حاليا', style: TextStyle(
                        fontSize: 22, color: button, fontFamily: 'AA-GALAXY'), textAlign: TextAlign.center,),)
                        : Column(
                          children: [
                            _headerWidget(state.max,state.min),
                            ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: state.products.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return ProductWidget(product: state.products[index],favoriteCubit: favoriteCubit,
                                            userCubit: userCubit,appUser: user,);
                                        },
                                      ),
                          ],
                        );
                  }else  if(state is ProductInitial){
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (ctx,index){
                          return loadProductShimmer();
                        });
                  }else if(state is ProductLoading){
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (ctx,index){
                          return loadProductShimmer();
                        });
                  }else if(state is ProductLoadError){
                    return Center(child: Text('حدث خطأ فى جلب البيانات! اعد المحاولة', style: TextStyle(
                        fontSize: 22, color: black, fontFamily: 'AA-GALAXY'),
                      textAlign: TextAlign.center,),);
                  }else{
                    return Container();
                  }
                },
              ),
            ]
          ))
        ],
      ),
    );
  }

  Widget buildSliverAppBar() {
    return SliverAppBar(
      actions: [
        PopupMenuButton(
          icon: CircleAvatar(
              radius: 30,
              backgroundColor: white,
              child: Icon(Icons.call,color: Colors.grey[800])),
          color: white,
          iconSize: 28,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          initialValue: widget.vendor.contacts.isEmpty ? '' : widget.vendor.contacts.first,
          onSelected: (val)async{
            await launch("tel://$val");
          },
          itemBuilder: (BuildContext context) {
            return widget.vendor.contacts.map((choice) {
              return PopupMenuItem(
                value: choice,
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.call,color: Colors.black38,size: 18,),
                        Text(choice,style: TextStyle(color: black),),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    const Divider(height: 1,color: Colors.black38,)
                  ],
                ),
              );
            }).toList();
          },
        ),
        PopupMenuButton(
          icon: CircleAvatar(
              radius: 30,
              backgroundColor: white,
              child: Icon(Icons.location_on,color: Colors.grey[800])),
          color: white,
          iconSize: 28,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          initialValue: widget.vendor.locations.isEmpty ? '' : widget.vendor.locations.first.locationName,
          onSelected: (val)async{
            String lat = val.toString().split(' ')[1];
            String lon = val.toString().split(' ')[0];
            final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
            print(lat);
            await launch(url);
          },
          itemBuilder: (BuildContext context) {
            return widget.vendor.locations.map((choice) {
              return PopupMenuItem(
                value: '${choice.geoPoint.longitude.toString()} ' + '${choice.geoPoint.latitude.toString()}',
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.location_on,color: Colors.black38,size: 20,),
                        Flexible(child: Text(choice.locationName,style: TextStyle(color: black),)),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    const Divider(height: 1,color: Colors.black38,)
                  ],
                ),
              );
            }).toList();
          },
        ),

      ],
      expandedHeight: SizeConfig.screenWidth * 0.25,
      pinned: true,
      stretch: true,
      backgroundColor: button,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          widget.vendor.brand,
          style: TextStyle(color: white,fontSize: 22,fontFamily: 'AA-GALAXY',shadows: [
            Shadow(
              offset: Offset(0.0, 5.0),
              blurRadius: 3.0,
              color: Color.fromARGB(100, 0, 0, 0),
            ),
          ]),
        ),
        background: Hero(
          tag: widget.vendor.id,
          child: CachedNetworkImage(
            imageUrl: widget.vendor.logo,
            height: SizeConfig.screenWidth * 0.25,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

 Widget _headerWidget(double max,double min) {
    return  Wrap(alignment: WrapAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                )
              ]
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                Text('نطاق سعر  ${widget.category} عند  ${widget.vendor.brand}', style: TextStyle(color: button, fontSize: 18,fontFamily: 'AA-GALAXY'),),
                const SizedBox(height: 5,),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${min == null ? 0 : min.toInt()} EGP',
                      style: TextStyle(fontSize: 20,color: Colors.grey[800],fontFamily: 'AA-GALAXY',fontWeight: FontWeight.bold)
                      ,textAlign: TextAlign.center,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                      child: Icon(Icons.arrow_forward,color: button,size: 20,),
                    ),
                    Text('${max == null ? 0 : max.toInt()} EGP',
                      style: TextStyle(fontSize: 20,color: Colors.grey[800],fontFamily: 'AA-GALAXY',fontWeight: FontWeight.bold)
                      ,textAlign: TextAlign.center,),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
 }
}
