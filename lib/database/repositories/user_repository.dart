import 'package:alena/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/shared.dart';

class UserRepository{

  final CollectionReference _usersCollection = FirebaseFirestore.instance
      .collection(USERS_COLLECTION);

  Future<AppUser> getUserById(String id){
    return _usersCollection.doc(id).get().then((doc){
      return AppUser.fromSnapshot(doc);
    });
  }

  Future saveUserToDb(Map<String,dynamic> userMap,String id)async{
    await _usersCollection.doc(id).set(userMap);
  }

  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await _usersCollection
        .where(AppUser.EMAIL, isEqualTo: user.email)
        .get();
    final List<DocumentSnapshot> docs = result.docs;
    print(docs.length);
    return docs.length == 0 || docs.isEmpty ? true : false;
  }

  Future<bool> authenticateFacebookAndGoogle(User user) async {
    QuerySnapshot result = await _usersCollection
        .where(AppUser.ID, isEqualTo: user.uid)
        .get();
    final List<DocumentSnapshot> docs = result.docs;
    print(docs.length);
    return docs.length == 0 ? true : false;
  }

  Future<User> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  Future updateUserName(String name,String id)async{
    await _usersCollection.doc(id).update({AppUser.FULL_NAME : name });
  }

  Future updateUserEmail(String email,String id)async{
    await _usersCollection.doc(id).update({AppUser.EMAIL : email });
  }

  Future updateUserPassword(String password,String id)async{
    await _usersCollection.doc(id).update({AppUser.PASSWORD : password });
  }

  Future updateUserWeddingDate(String date,String id)async{
    await _usersCollection.doc(id).update({AppUser.WEDDING_DATE : date });
  }

  Future updateUserDoneList(String done,String id)async{
    await _usersCollection.doc(id).update({AppUser.DONE_LIST: FieldValue.arrayUnion([done])});
  }

  Future removeFromUserDoneList(String done,String id)async{
    await _usersCollection.doc(id).update({AppUser.DONE_LIST: FieldValue.arrayRemove([done])});
  }

  Future updateUserFavList(String done,String id)async{
    await _usersCollection.doc(id).update({AppUser.FAVORITES_LIST: FieldValue.arrayUnion([done])});
  }

  Future removeFromUserFavList(String done,String id)async{
    await _usersCollection.doc(id).update({AppUser.FAVORITES_LIST: FieldValue.arrayRemove([done])});
  }

  Future updateUserAdditionalList(String done,String id)async{
    await _usersCollection.doc(id).update({AppUser.ADDITIONAL_LIST: FieldValue.arrayUnion([done])});
  }

  Future removeFromUserAdditionalList(String done,String id)async{
    await _usersCollection.doc(id).update({AppUser.ADDITIONAL_LIST: FieldValue.arrayRemove([done])});
  }

}