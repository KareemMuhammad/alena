import 'package:alena/models/order.dart';
import 'package:alena/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRepository{
  static const String ORDERS_COLLECTION = "Orders";

  final _ordersCollection = FirebaseFirestore.instance.collection(OrderRepository.ORDERS_COLLECTION);

  Future saveOrderToDb(Map<String,dynamic> userMap,String id)async{
    await _ordersCollection.doc(id).set(userMap);
  }

  Future<List<OrderModel>> getAllOrdersOfUser(AppUser user)async{
    QuerySnapshot snapshot = await _ordersCollection.where(OrderModel.ORDER_USER, isEqualTo: user.toMap()).orderBy(OrderModel.ORDER_DATE,descending: true).get()
        .catchError((e) {
      print(e.toString());
    });
    return snapshot.docs.map((doc) {
      return OrderModel.fromSnapshot(doc);
    }).toList();
  }

  Future<OrderModel> getOrderById(String id){
    return _ordersCollection.doc(id).get().then((doc){
      return OrderModel.fromSnapshot(doc);
    });
  }


  Future<bool> updateOrderInfo(OrderModel product,String id)async{
    try {
      await _ordersCollection.doc(id).update(product.toMap());
      return true;
    }catch (e){
      print(e.toString());
      return false;
    }
  }
}