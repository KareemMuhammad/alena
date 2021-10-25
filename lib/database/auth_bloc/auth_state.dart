import 'package:alena/models/user.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState{}

class AuthFailure extends AuthState{}

class AuthRegistration extends AuthState{}

class AuthPasswordReset extends AuthState{}

class AuthSuccessful extends AuthState{
 final AppUser appUser;

 AuthSuccessful(this.appUser);
}