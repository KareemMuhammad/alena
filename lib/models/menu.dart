import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {

  static const String ID = "id";
  static const String USER_ID = "userId";
  static const String LIST = "list";
  static const String CATEGORY = "category";

   Map<String,dynamic> list;
   String id, category, userId;

  Menu({
    this.list,
    this.id,
    this.category,
    this.userId
  });

  Menu.fromSnapshot(DocumentSnapshot doc){
    id = (doc.data() as Map)[ID] ?? '';
    userId = (doc.data() as Map)[USER_ID] ?? '';
    category = (doc.data() as Map)[CATEGORY] ?? '';
    list = (doc.data() as Map)[LIST] ?? {};
  }

  Menu.fromMap(Map<String,dynamic> map){
    id = map[ID] ?? '';
    list = map[LIST] ?? {};
    category = map[CATEGORY] ?? '';
    userId = map[USER_ID] ?? '';
  }

  Map<String,dynamic> toMap()=>{
    ID : id ??'',
    USER_ID : userId ??'',
    LIST : list ?? {},
    CATEGORY : category ??'',
  };
}



