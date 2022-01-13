import 'package:alena/database/blocs/vendor_bloc/vendor_state.dart';
import 'package:alena/database/repositories/product_repository.dart';
import 'package:alena/database/repositories/vendors_repository.dart';
import 'package:alena/models/product.dart';
import 'package:alena/models/vendors.dart';
import 'package:bloc/bloc.dart';

class VendorCubit extends Cubit<VendorState>{
  final VendorsRepository vendorRepo;
  final ProductRepository productRepo;

  VendorCubit({this.productRepo, this.vendorRepo}) : super(VendorInitial());

  List<Vendors> _vendorsList;
  List<Product> _deviceProducts;
  Vendors _vendor;

  List<Vendors> get getAllVendors => _vendorsList;

  Future loadVendorsOfDevice(String category)async{
    try {
      emit(VendorLoading());
      _vendorsList = await vendorRepo.getAllVendorsOfProduct(category);
      if(_vendorsList != null) {
        emit(VendorsLoaded(_vendorsList));
      }else{
        emit(VendorLoadError());
      }
    }catch(e){
      print(e.toString());
      emit(VendorLoadError());
    }
  }

  Future<List<Product>> filterVendorsOfDevice(String category)async{
    try {
      _deviceProducts = await productRepo.getAllCategoryProducts(category);
      if(_deviceProducts != null) {
       return _deviceProducts;
      }else{
       return [];
      }
    }catch(e){
      print(e.toString());
      return [];
    }
  }

  Future getVendor(String id)async{
    try{
      emit(VendorLoading());
      _vendor = await vendorRepo.getVendorById(id);
      if(_vendor != null){
        emit(VendorSingleLoaded(_vendor));
      }else{
        emit(VendorLoadError());
      }
    }catch(e){
      print(e.toString());
      emit(VendorLoadError());
    }
  }

}