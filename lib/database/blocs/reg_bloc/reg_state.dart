import 'package:alena/models/user.dart';
import 'package:flutter/material.dart';

@immutable
abstract class RegState {}

class RegInitial extends RegState{}

class RegLoading extends RegState{}

class RegLoadError extends RegState{}

class RegUserLoaded extends RegState{
 final AppUser appUser;

  RegUserLoaded(this.appUser);
}