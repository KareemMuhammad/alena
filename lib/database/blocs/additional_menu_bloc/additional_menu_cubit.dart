import 'package:alena/database/blocs/additional_menu_bloc/additional_menu_state.dart';
import 'package:alena/database/repositories/menu_repository.dart';
import 'package:alena/models/menu.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class AdditionalMenuCubit extends Cubit<AdditionalMenuState>{
  final MenuRepository menuRepo;

  AdditionalMenuCubit({this.menuRepo}) : super(MenuInitial());

  List<Menu> _menu;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future loadUserAdditionalMenu()async{
    try {
      emit(MenuLoading());
      _menu = await menuRepo.getAllAdditionalMenus(_auth.currentUser.uid);
      if(_menu != null) {
        emit(MenuLoaded(_menu));
      }else{
        emit(MenuLoadError());
      }
    }catch(e){
      print(e.toString());
      emit(MenuLoadError());
    }
  }

  Future addAdditionalMenu(Map<String,dynamic> values,String category)async{
    try{
      print('add menu');
      String id = Uuid().v4();
      emit(MenuLoading());
      Menu menu = Menu(id: id,list: values,category: category,userId: _auth.currentUser.uid);
      await menuRepo.addNewAdditionalMenu(menu.toMap(),id);
      emit(MenuAdded());
    }catch(e){
      emit(MenuAddError());
      print(e.toString());
    }
  }

  Future checkAdditionalMenuExistence(String category)async{
    try {
      print('check exist');
      bool menuBool = await menuRepo.authenticateAdditionalMenu(_auth.currentUser.uid,category);
      print(menuBool);
      if(menuBool) {
        emit(MenuNotExisted());
      }else{
        emit(MenuExisted());
      }
    }catch(e){
      print(e.toString());
      emit(MenuExisted());
    }
  }

  Future deleteAdditionalSingleMenu(String category)async{
    try {
       for(Menu mn in _menu){
         if(mn.category == category) {
           await menuRepo.deleteAdditionalMenu(mn.id);
         }
       }
       print('delete menu');
       emit(MenuDeleted());
    }catch(e){
      print(e.toString());
      emit(MenuDeleteError());
    }
  }

  Future deleteAdditionalMenuById(String id)async{
    try {
      await menuRepo.deleteAdditionalMenu(id);
      print('delete menu');
      emit(MenuDeleted());
    }catch(e){
      print(e.toString());
      emit(MenuDeleteError());
    }
  }

  Future updateAdditionalMenu(Map<String,dynamic> values,String id)async{
    try {
      print('menu update');
      await menuRepo.updateUserAdditionalMenu(values, id);
      emit(MenuUpdated());
    }catch(e){
      print(e.toString());
      emit(MenuNotUpdated());
    }
  }

}