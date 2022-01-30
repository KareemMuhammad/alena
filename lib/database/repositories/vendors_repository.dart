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

 Future updateOrdersOfVendorNumber(String id,int no)async{
  await _adminsCollection.doc(id).update({Vendors.ORDERS_NO: FieldValue.increment(no)});
 }

 Future<List<Vendors>> queryVendorsOfProduct(String category)async{
  QuerySnapshot snapshot = await _adminsCollection.where(Vendors.DEVICES,arrayContains: category).get()
      .catchError((e) {
   print(e.toString());
  });
  return snapshot.docs.map((doc) {
   return Vendors.fromSnapshot(doc);
  }).toList();
 }

}