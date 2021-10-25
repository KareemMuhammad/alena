import 'package:alena/database/blocs/user_bloc/user_state.dart';
import 'package:alena/database/repositories/user_repository.dart';
import 'package:alena/models/user.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserCubit extends Cubit<UserState>{
  final UserRepository userRepository;

  UserCubit({this.userRepository}) : super(UserInitial());

  AppUser _user;
  User _fireUser ;

  final GoogleSignIn _googleUser = GoogleSignIn();
  final FacebookAuth _facebookLogin = FacebookAuth.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future loadUserData()async{
    try {
      emit(UserLoading());
        _fireUser = await userRepository.getCurrentUser();
        _user = await userRepository.getUserById(_fireUser.uid);
        print(_user.name);
        if(_user != null) {
          emit(UserLoaded(_user));
        }else{
          emit(UserLoadError());
        }
    }catch(e){
      print(e.toString());
      emit(UserLoadError());
    }
 }

  Future<bool> signInEmailAndPassword(String email, String password) async {
    try {
      emit(UserLoading());
      var authresult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      bool newUser = await userRepository.authenticateUser(authresult.user);
      if(newUser){
        emit(UserLoadError());
      }else{
        loadUserData();
      }
      return newUser;
    } catch (e) {
      emit(UserLoadError());
      print(e.toString());
      return true;
    }
  }

  Future<bool> signUpFacebook() async{
    try {
      emit(UserLoading());
      final LoginResult loginResult = await _facebookLogin.login(permissions: ['email', 'public_profile', 'user_gender',],);
      if(loginResult.status == LoginStatus.success) {
        final OAuthCredential credential = FacebookAuthProvider.credential(loginResult.accessToken.token);
        final Map<String, dynamic> data = await FacebookAuth.i.getUserData(
          fields: "name,email,birthday,gender",
        );
        final result = await _auth.signInWithCredential(credential);
        User user = result.user;
        bool newUser = await userRepository.authenticateFacebookAndGoogle(user);
        print(newUser);
        if (newUser == true) {
          AppUser appUser = AppUser(id: user.uid,
              email: data[AppUser.EMAIL] ?? '',
              password: '',
              name: data[AppUser.FULL_NAME] ?? '',
              gender: data["user_gender"] ?? '',
              token: '',
              doneList: [],
              weddingDate: '');
          await userRepository.saveUserToDb(appUser.toMap(), user.uid);
          loadUserData();
          return true;
        } else {
          loadUserData();
          return false;
        }
      }else{
        emit(UserLoadError());
        return false;
      }
    }catch(e){
      emit(UserLoadError());
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUpGoogle() async {
    try {
      emit(UserLoading());
      final credentialUser = await _googleUser.signIn();
      if(credentialUser != null) {
        final auth = await credentialUser.authentication;
        final credential = GoogleAuthProvider.credential(
            accessToken: auth.accessToken,
            idToken: auth.idToken
        );
        final result = await _auth.signInWithCredential(credential);
        User user = result.user;
        bool newUser = await userRepository.authenticateFacebookAndGoogle(user);
        print(newUser);
        if (newUser == true) {
          AppUser appUser = AppUser(id: user.uid,
              email: user.email ?? '',
              password: '',
              name: user.displayName ?? '',
              gender: '',
              doneList: [],
              token: '',
          weddingDate: '');
          await userRepository.saveUserToDb(appUser.toMap(), user.uid);
          loadUserData();
          return true;
        } else {
          loadUserData();
          return false;
        }
      }else{
        emit(UserLoadError());
        return false;
      }
    }catch(e){
      emit(UserLoadError());
      print(e.toString());
      return false;
    }
  }

  Future resetPassword(String email)async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
      emit(UserPasswordReset());
    }catch(e){
      emit(UserLoadError());
      print(e.toString());
    }
  }

  Future updateDateOfWedding(String date)async{
    try {
      await userRepository.updateUserWeddingDate(date, _auth.currentUser.uid);
      loadUserData();
    }catch(e){
      emit(UserLoadError());
      print(e.toString());
    }
  }

  Future updateName(String name)async{
    try {
      await userRepository.updateUserName(name, _auth.currentUser.uid);
      loadUserData();
    }catch(e){
      emit(UserLoadError());
      print(e.toString());
    }
  }

  Future updateDoneList(String device,int index)async{
    try {
      if(index == 0) {
        await userRepository.updateUserDoneList(device, _auth.currentUser.uid);
      }else{
        await userRepository.removeFromUserDoneList(device, _auth.currentUser.uid);
      }
    }catch(e){
      emit(UserLoadError());
      print(e.toString());
    }
  }

  Future removeAllDoneOfDeletedMenu(List<String> list)async{
    try {
       AppUser newUser = await userRepository.getUserById(_auth.currentUser.uid);
        for(String device in list) {
          if (newUser.doneList.contains(device)) {
            await userRepository.removeFromUserDoneList(device, _auth.currentUser.uid);
          }
        }
    }catch(e){
      emit(UserLoadError());
      print(e.toString());
    }
  }

  Future updateEmail(String email)async{
    try {
      _fireUser = await userRepository.getCurrentUser();
      _user = await userRepository.getUserById(_fireUser.uid);
      var credential = EmailAuthProvider.credential(email: _fireUser.email, password: _user.password);
      await _fireUser.reauthenticateWithCredential(credential);
      await _auth.currentUser.updateEmail(email);
      await userRepository.updateUserEmail(email, _auth.currentUser.uid);
      loadUserData();
    }on PlatformException catch (e){
      emit(UserLoadError());
      print(e.message);
    }
  }

}