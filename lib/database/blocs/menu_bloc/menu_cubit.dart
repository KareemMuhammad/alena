import 'package:alena/database/blocs/menu_bloc/menu_state.dart';
import 'package:alena/database/repositories/menu_repository.dart';
import 'package:alena/models/menu.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class MenuCubit extends Cubit<MenuState>{
  final MenuRepository menuRepo;

  MenuCubit({this.menuRepo}) : super(MenuInitial());

  List<Menu> _menu;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future loadUserMenu()async{
    try {
      emit(MenuLoading());
      _menu = await menuRepo.getAllMenus(_auth.currentUser.uid);
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

  Future addMenu(Map<String,dynamic> values,String category)async{
    try{
      print('add menu');
      String id = Uuid().v4();
      emit(MenuLoading());
      Menu menu = Menu(id: id,list: values,category: category,userId: _auth.currentUser.uid);
      await menuRepo.addNewMenu(menu.toMap(),id);
      emit(MenuAdded());
    }catch(e){
      emit(MenuAddError());
      print(e.toString());
    }
  }

  Future checkMenuExistence(String category)async{
    try {
      print('check exist');
      bool menuBool = await menuRepo.authenticateMenu(_auth.currentUser.uid,category);
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

  Future deleteSingleMenu(String category)async{
    try {
       for(Menu mn in _menu){
         if(mn.category == category) {
           await menuRepo.deleteMenu(mn.id);
         }
       }
       print('delete menu');
       emit(MenuDeleted());
    }catch(e){
      print(e.toString());
      emit(MenuDeleteError());
    }
  }

  Future deleteMenuById(String id)async{
    try {
      await menuRepo.deleteMenu(id);
      print('delete menu');
      emit(MenuDeleted());
    }catch(e){
      print(e.toString());
      emit(MenuDeleteError());
    }
  }

  Future updateMenu(Map<String,dynamic> values,String id)async{
    try {
      print('menu update');
      await menuRepo.updateUserMenu(values, id);
      emit(MenuUpdated());
    }catch(e){
      print(e.toString());
      emit(MenuNotUpdated());
    }
  }

}