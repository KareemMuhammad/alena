import 'package:alena/models/product.dart';
import 'package:alena/models/user.dart';
import 'package:flutter/material.dart';

@immutable
abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState{}

class FavoriteLoading extends FavoriteState{}

class FavoriteUpdateError extends FavoriteState{}

class FavoriteUpdated extends FavoriteState{
  final AppUser appUser;

  FavoriteUpdated(this.appUser);
}

class FavoritesLoadError extends FavoriteState{}

class FavoritesLoaded extends FavoriteState{
  final List<Product> favoritesList;

  FavoritesLoaded(this.favoritesList);
}