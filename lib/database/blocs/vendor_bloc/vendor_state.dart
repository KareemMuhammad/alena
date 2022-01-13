import 'package:alena/models/vendors.dart';
import 'package:flutter/material.dart';

@immutable
abstract class VendorState {}

class VendorInitial extends VendorState{}

class VendorLoading extends VendorState{}

class VendorUpdated extends VendorState{}

class VendorNotUpdated extends VendorState{}

class VendorLoadError extends VendorState{}

class VendorsLoaded extends VendorState{
  final List<Vendors> vendors;

  VendorsLoaded(this.vendors);
}

class VendorSingleLoaded extends VendorState{
  final Vendors vendor;

  VendorSingleLoaded(this.vendor);
}