import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser{

  static const String ID = "id";
  static const String FULL_NAME = "name";
  static const String EMAIL = "email";
  static const String PASSWORD = "password";
  static const String GENDER = "gender";
  static const String TOKEN = "token";
  static const String WEDDING_DATE = "weddingDate";
  static const String DONE_LIST = "doneList";

   String id;
   String name;
   String email;
   String password;
   String gender;
   String weddingDate;
   String token;
   List<dynamic> doneList;

  AppUser({
      this.id,
      this.name,
      this.email,
      this.password,
      this.gender,
      this.weddingDate,
      this.token,
      this.doneList});

  Map<String,dynamic> toMap()=>{
    ID : id ??'',
    FULL_NAME : name ??'',
    EMAIL : email ??'',
    PASSWORD : password ??'',
    GENDER : gender ??'',
    TOKEN : token ?? '',
    WEDDING_DATE : weddingDate ?? '',
    DONE_LIST : doneList ?? [],
  };

  AppUser.fromSnapshot(DocumentSnapshot doc){
    id = (doc.data() as Map)[ID] ?? '';
    name = (doc.data() as Map)[FULL_NAME] ?? '';
    email = (doc.data() as Map)[EMAIL] ?? '';
    password = (doc.data() as Map)[PASSWORD] ?? '';
    gender = (doc.data() as Map)[GENDER] ?? '';
    token = (doc.data() as Map)[TOKEN] ?? '';
    weddingDate = (doc.data() as Map)[WEDDING_DATE] ?? '';
    doneList = (doc.data() as Map)[DONE_LIST] ?? [];
  }

}