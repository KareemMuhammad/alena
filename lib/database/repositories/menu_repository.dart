import 'package:alena/models/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/shared.dart';

class MenuRepository{
  final CollectionReference _menusCollection = FirebaseFirestore.instance
      .collection(MENUS_COLLECTION);

  Future<List<Menu>> getAllMenus(String id)async{
    QuerySnapshot snapshot = await _menusCollection.where(Menu.USER_ID,isEqualTo: id).get()
        .catchError((e) {
      print(e.toString());
    });
    return snapshot.docs.map((doc) {
      return Menu.fromSnapshot(doc);
    }).toList();
  }

  Future addNewMenu(Map<String,dynamic> map,String id)async{
    await _menusCollection.doc(id).set(map);
  }

  Future deleteMenu(String id)async{
    await _menusCollection.doc(id).delete();
  }

  Future<bool> authenticateMenu(String id,String category) async {
    QuerySnapshot result = await _menusCollection
        .where(Menu.USER_ID, isEqualTo: id)
        .where(Menu.CATEGORY, isEqualTo: category)
        .get();
    final List<DocumentSnapshot> docs = result.docs;
    print(docs.length);
    return docs.length == 0 || docs.isEmpty ? true : false;
  }

  Future updateUserMenu(Map<String,dynamic> map,String id)async{
    await _menusCollection.doc(id).update({Menu.LIST: map});
  }

}