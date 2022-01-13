import 'package:alena/models/product.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ProductState {}

class ProductInitial extends ProductState{}

class ProductLoading extends ProductState{}

class ProductUpdated extends ProductState{}

class ProductNotUpdated extends ProductState{}

class ProductLoadError extends ProductState{}

class ProductLoaded extends ProductState{
  final List<Product> products;
  final double max;
  final double min;

  ProductLoaded(this.products, this.max, this.min);
}