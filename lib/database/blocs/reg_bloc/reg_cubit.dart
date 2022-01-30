import 'reg_state.dart';
import 'package:alena/database/repositories/user_repository.dart';
import 'package:alena/models/user.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegCubit extends Cubit<RegState>{
  final UserRepository userRepository;

  RegCubit({this.userRepository}) : super(RegInitial());

  AppUser _user;
  User fireUser ;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future loadUserData()async{
    try {
      emit(RegLoading());
        fireUser = await userRepository.getCurrentUser();
        _user = await userRepository.getUserById(fireUser.uid);
        print(_user.name);
        if(_user != null) {
          emit(RegUserLoaded(_user));
        }else{
          emit(RegLoadError());
        }
    }catch(e){
      print(e.toString());
      emit(RegLoadError());
    }
 }

  // sign up with email
  Future<bool> signUpUserWithEmailPass(String email, String pass,String gender,String name) async {
    try {
      emit(RegLoading());
      var authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      print("REPO : ${authResult.user.email}");
      bool newUser = await userRepository.authenticateUser(authResult.user);
      if(newUser == true){
        AppUser appUser = AppUser(id: authResult.user.uid,email: email,name: name,
            gender: gender,token: '',weddingDate: '',doneList: [], additionalList: [], favorites: []);
        await userRepository.saveUserToDb(appUser.toMap(), authResult.user.uid);
        loadUserData();
        return true;
      } else {
        emit(RegLoadError());
        return false;
      }
    }  catch (e) {
      emit(RegLoadError());
      print(e.toString());
      return false;
    }
  }

}