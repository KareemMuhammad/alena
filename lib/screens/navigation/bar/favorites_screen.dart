import 'package:alena/database/blocs/favorite_bloc/favorite_cubit.dart';
import 'package:alena/database/blocs/favorite_bloc/favorite_state.dart';
import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/models/user.dart';
import 'package:alena/utils/shared.dart';
import 'package:alena/widgets/helpers/shared_widgets.dart';
import 'package:alena/widgets/product/favorites_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatefulWidget {
  final AppUser appUser;

  const FavoritesScreen({Key key, this.appUser}) : super(key: key);
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FavoriteCubit>(context).getAllFavorites(widget.appUser.favorites);
  }

  @override
  Widget build(BuildContext context) {
    final FavoriteCubit favoriteCubit = BlocProvider.of<FavoriteCubit>(context);
    final UserCubit userCubit = BlocProvider.of<UserCubit>(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: button,
        elevation: 2,
        title: Text('الأجهزة المفضلة',style: TextStyle(fontSize: 22,color: white,fontFamily: 'AA-GALAXY')
          ,textAlign: TextAlign.center,),
      ),
      body: BlocConsumer<FavoriteCubit,FavoriteState>(
        listener: (BuildContext context, state){
          if(state is FavoriteUpdated){
            favoriteCubit.getAllFavorites(state.appUser.favorites);
          }
        },
        builder: (BuildContext context, state) {
          if(state is FavoritesLoaded){
             return state.favoritesList.isEmpty?
             Center(child: Text('قائمة الأجهزة المفضلة فارغة', style: TextStyle(
                 fontSize: 22, color: black, fontFamily: 'AA-GALAXY'),
               textAlign: TextAlign.center,),)
                 : ListView.builder(
                     itemCount: state.favoritesList.length,
                     itemBuilder: (ctx,index){
                     return FavoritesWidget(product: state.favoritesList[index],userCubit: userCubit,favoriteCubit: favoriteCubit,);
             });
          }else if(state is FavoritesLoadError){
            return Center(child: Text('حدث خطأ فى جلب البيانات! اعد المحاولة', style: TextStyle(
                fontSize: 20, color: black, fontFamily: 'AA-GALAXY'),
              textAlign: TextAlign.center,),);
          }else{
            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (ctx,index){
                  return loadProductShimmer();
                });
          }
      },
      ),
    );
  }
}
