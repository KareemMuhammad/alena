import 'package:alena/models/menu.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MenuState {}

class MenuInitial extends MenuState{}

class MenuLoading extends MenuState{}

class MenuLoadError extends MenuState{}

class MenuDeleted extends MenuState{}

class MenuDeleteError extends MenuState{}

class MenuAdded extends MenuState{}

class MenuAddError extends MenuState{}

class MenuExisted extends MenuState{}

class MenuNotExisted extends MenuState{}

class MenuUpdated extends MenuState{}

class MenuNotUpdated extends MenuState{}

class MenuLoaded extends MenuState{
  final List<Menu> menu;

  MenuLoaded(this.menu);
}