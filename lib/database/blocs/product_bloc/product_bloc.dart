import 'package:alena/database/blocs/product_bloc/product_state.dart';
import 'package:alena/database/repositories/product_repository.dart';
import 'package:alena/models/product.dart';
import 'package:bloc/bloc.dart';

class ProductCubit extends Cubit<ProductState>{
  final ProductRepository productRepo;

  ProductCubit({this.productRepo}) : super(ProductInitial());

  List<Product> _products;
  List<Product> _vendorProducts;

  Future loadCategoryProducts(String category)async{
    try {
      emit(ProductLoading());
      _products = await productRepo.getAllCategoryProducts(category);
      if(_products != null) {
        double max = _products.reduce((value, element) => value.price > element.price ? value : element).price;
        double min = _products.reduce((value, element) => value.price < element.price ? value : element).price;
        emit(ProductLoaded(_products,max,min));
      }else{
        emit(ProductLoadError());
      }
    }catch(e){
      print(e.toString());
      emit(ProductLoadError());
    }
  }

  Future loadVendorProducts(String category,String vendorId)async{
    try {
      emit(ProductLoading());
      _vendorProducts = await productRepo.getAllVendorProducts(category,vendorId);
      if(_vendorProducts != null) {
        double max = _vendorProducts.reduce((value, element) => value.price > element.price ? value : element).price;
        double min = _vendorProducts.reduce((value, element) => value.price < element.price ? value : element).price;
        emit(ProductLoaded(_vendorProducts,max,min));
      }else{
        emit(ProductLoadError());
      }
    }catch(e){
      print(e.toString());
      emit(ProductLoadError());
    }
  }

  Future<double> getMaxPriceOfDevice(String device)async{
    try {
      List<Product> pro = await productRepo.getAllCategoryProducts(device);
      if (pro != null || pro.isNotEmpty) {
        double max = pro.reduce((value, element) => value.price > element.price ? value : element).price;
        return max;
      } else {
        return 0;
      }
    }catch(e){
      print(e.toString());
      return 0;
    }
  }

  Future<double> getMinPriceOfDevice(String device)async{
    try {
      List<Product> pro = await productRepo.getAllCategoryProducts(device);
      if (pro != null || pro.isNotEmpty) {
        double min = pro.reduce((value, element) => value.price < element.price ? value : element).price;
        return min;
      } else {
        return 0;
      }
    }catch(e){
      print(e.toString());
      return 0;
    }
  }

}