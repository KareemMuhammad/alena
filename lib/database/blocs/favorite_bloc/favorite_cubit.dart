import 'package:alena/database/blocs/favorite_bloc/favorite_state.dart';
import 'package:alena/database/repositories/product_repository.dart';
import 'package:alena/database/repositories/user_repository.dart';
import 'package:alena/models/product.dart';
import 'package:alena/models/user.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteCubit extends Cubit<FavoriteState>{
  final UserRepository userRepository;
  final ProductRepository productRepository;

  FavoriteCubit({this.productRepository, this.userRepository}) : super(FavoriteInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future getAllFavorites(List<dynamic> list)async{
    try{
      List<Product> _favoritesList = [];
      emit(FavoriteLoading());
      for(String id in list){
       Product product = await productRepository.getProductById(id);
       _favoritesList.add(product);
      }
      emit(FavoritesLoaded(_favoritesList));
    }catch(e){
      emit(FavoritesLoadError());
      print(e.toString());
    }
  }

  Future updateFavoritesList(String fav,int index)async{
    try {
      if(index == 0) {
        await userRepository.updateUserFavList(fav, _auth.currentUser.uid);
      }else{
        await userRepository.removeFromUserFavList(fav, _auth.currentUser.uid);
      }
      AppUser user = await userRepository.getUserById(_auth.currentUser.uid);
      emit(FavoriteUpdated(user));
    }catch(e){
      emit(FavoriteUpdateError());
      print(e.toString());
    }
  }

}