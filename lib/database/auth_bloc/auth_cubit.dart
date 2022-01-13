import 'package:alena/database/auth_bloc/auth_state.dart';
import 'package:alena/database/repositories/user_repository.dart';
import 'package:alena/models/user.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthCubit extends Cubit<AuthState>{
  final UserRepository userRepository;

  AuthCubit({this.userRepository}) : super(AuthInitial());

  AppUser _user;
  User _fireUser ;

  AppUser get getUser => _user;

  final GoogleSignIn _googleUser = GoogleSignIn();
  final FacebookAuth _facebookLogin = FacebookAuth.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future loadUserData()async{
    try {
        _fireUser = await userRepository.getCurrentUser();
        _user = await userRepository.getUserById(_fireUser.uid);
        if(_user != null) {
          emit(AuthSuccessful(_user));
        }else{
          emit(AuthFailure());
        }
    }catch(e){
      print(e.toString());
      emit(AuthFailure());
    }
 }

  Future authUser()async{
    try {
      _fireUser = await userRepository.getCurrentUser();
      if(_fireUser != null) {
       await loadUserData();
      }else{
        emit(AuthFailure());
      }
    }catch(e){
      print(e.toString());
      emit(AuthFailure());
    }
  }

  Future signOut()async{
    try{
      if(_googleUser.currentUser != null) {
        await _googleUser.signOut();
      }
      if (_facebookLogin.accessToken != null) {
        _facebookLogin.logOut();
      }
      if(_auth.currentUser != null) {
        await _auth.signOut();
      }
      emit(AuthFailure());
    }catch(e){
      emit(AuthFailure());
      print(e.toString());
    }
  }

}