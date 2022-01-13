import 'package:alena/models/vendors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorsRepository{
 static const String ADMINS_COLLECTION = "Admins";

 final _adminsCollection = FirebaseFirestore.instance.collection(VendorsRepository.ADMINS_COLLECTION);

 Future<Vendors> getVendorById(String id){
  return _adminsCollection.doc(id).get().then((doc){
   return Vendors.fromSnapshot(doc);
  });
 }

 Future<List<Vendors>> getAllVendorsOfProduct(String category)async{
  QuerySnapshot snapshot = await _adminsCollection.where(Vendors.DEVICES,arrayContains: category).get()
      .catchError((e) {
   print(e.toString());
  });
  return snapshot.docs.map((doc) {
   return Vendors.fromSnapshot(doc);
  }).toList();
 }

 Future<List<Vendors>> queryVendorsOfProduct(String category)async{
   final allQuery = _adminsCollection.where(Vendors.DEVICES,arrayContains: category).where(Vendors.CITY,isEqualTo: category)
       .where(Vendors.LOCATIONS,arrayContains: category);
  QuerySnapshot snapshot = await _adminsCollection.where(Vendors.DEVICES,arrayContains: category).get()
      .catchError((e) {
   print(e.toString());
  });
  return snapshot.docs.map((doc) {
   return Vendors.fromSnapshot(doc);
  }).toList();
 }

}