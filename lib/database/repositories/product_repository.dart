import 'package:alena/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRepository{
  static const PRODUCTS_COLLECTION = "Products";

  final _productsCollection = FirebaseFirestore.instance.collection(ProductRepository.PRODUCTS_COLLECTION);

  Future<List<Product>> getAllCategoryProducts(String category)async{
    QuerySnapshot snapshot = await _productsCollection.where(Product.PRODUCT_NAME, isEqualTo: category).orderBy(Product.DATE,descending: true).get()
        .catchError((e) {
      print(e.toString());
    });
    return snapshot.docs.map((doc) {
      return Product.fromSnapshot(doc);
    }).toList();
  }

  Future<List<Product>> getAllVendorsOfProduct(String category)async{
    QuerySnapshot snapshot = await _productsCollection.where(Product.PRODUCT_NAME, isEqualTo: category).orderBy(Product.DATE,descending: true).get()
        .catchError((e) {
      print(e.toString());
    });
    return snapshot.docs.map((doc) {
      return Product.fromSnapshot(doc);
    }).toList();
  }

  Future<List<Product>> getAllVendorProducts(String category,String vendorId)async{
    QuerySnapshot snapshot = await _productsCollection.where(Product.PRODUCT_NAME, isEqualTo: category).where(Product.VENDOR_ID,isEqualTo: vendorId)
        .orderBy(Product.DATE,descending: true).get()
        .catchError((e) {
      print(e.toString());
    });
    return snapshot.docs.map((doc) {
      return Product.fromSnapshot(doc);
    }).toList();
  }

  Future<Product> getProductById(String id){
    return _productsCollection.doc(id).get().then((doc){
      return Product.fromSnapshot(doc);
    });
  }


  Future<bool> updateProductInfo(Product product,String id)async{
    try {
      await _productsCollection.doc(id).update(product.toMap());
      return true;
    }catch (e){
      print(e.toString());
      return false;
    }
  }


}