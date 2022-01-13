import 'package:alena/models/menu.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AdditionalMenuState {}

class MenuInitial extends AdditionalMenuState{}

class MenuLoading extends AdditionalMenuState{}

class MenuLoadError extends AdditionalMenuState{}

class MenuDeleted extends AdditionalMenuState{}

class MenuDeleteError extends AdditionalMenuState{}

class MenuAdded extends AdditionalMenuState{}

class MenuAddError extends AdditionalMenuState{}

class MenuExisted extends AdditionalMenuState{}

class MenuNotExisted extends AdditionalMenuState{}

class MenuUpdated extends AdditionalMenuState{}

class MenuNotUpdated extends AdditionalMenuState{}

class MenuLoaded extends AdditionalMenuState{
  final List<Menu> menu;

  MenuLoaded(this.menu);
}