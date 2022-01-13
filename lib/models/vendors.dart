import 'package:alena/models/vendor_locations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Vendors{
  static const String ID = "id";
  static const String USER_NAME = "username";
  static const String PASSWORD = "password";
  static const String LOGO = "logo";
  static const String CONTACTS = "contacts";
  static const String CITY = "city";
  static const String BRAND = "brand";
  static const String PRODUCTS_NO = "productsNo";
  static const String WAITING_NO = "waitingNo";
  static const String TOKEN = "token";
  static const String DEVICES = "devices";
  static const String REGIONS = "regions";
  static const String LOCATIONS = "locations";

  String username;
  String password;
  String id;
  String logo;
  List<VendorLocations> locations;
  String city;
  String brand;
  String token;
  int productNo, waitingNo;
  List<dynamic> contacts;
  List<dynamic> devices;
  List<dynamic> regions;

  Vendors({this.username, this.password, this.id,this.logo,this.locations,this.contacts,this.city,this.brand,this.waitingNo,
    this.productNo,this.token,this.regions,this.devices});

  Map<String,dynamic> toMap()=>{
    ID : id ?? '',
    USER_NAME : username ?? '',
    PASSWORD : password ?? '',
    LOGO : logo ?? '',
    CITY : city ?? '',
    CONTACTS : contacts.map((e) => e.toString()).toList() ?? [],
    DEVICES : devices.map((e) => e.toString()).toList() ?? [],
    REGIONS : regions.map((e) => e.toString()).toList() ?? [],
    LOCATIONS : locations.map((e) => e.toMap()).toList() ?? [],
    BRAND : brand ?? '',
    TOKEN : token ?? '',
    WAITING_NO : waitingNo ?? 0,
    PRODUCTS_NO : productNo ?? 0,
  };

  Vendors.fromSnapshot(DocumentSnapshot doc){
    id = (doc.data() as Map)[ID] ?? '';
    username = (doc.data() as Map)[USER_NAME] ?? '';
    logo = (doc.data() as Map)[LOGO] ?? '';
    password = (doc.data() as Map)[PASSWORD] ?? '';
    locations = locationsList((doc.data() as Map)[LOCATIONS] ?? []);
    contacts = (doc.data() as Map)[CONTACTS] ?? [];
    regions = (doc.data() as Map)[REGIONS] ?? [];
    devices = (doc.data() as Map)[DEVICES] ?? [];
    city = (doc.data() as Map)[CITY] ?? '';
    brand = (doc.data() as Map)[BRAND] ?? '';
    token = (doc.data() as Map)[TOKEN] ?? '';
    waitingNo = (doc.data() as Map)[WAITING_NO] ?? 0;
    productNo = (doc.data() as Map)[PRODUCTS_NO] ?? 0;
  }

  Vendors.fromMap(Map<String,dynamic> map){
    logo = map[LOGO] ?? '';
    contacts = map[CONTACTS] ?? [];
    brand = map[BRAND] ?? '';
    token = map[TOKEN] ?? '';
  }

  List<VendorLocations> locationsList (List<dynamic> locations){
    List<VendorLocations> convertedList = [];
    for(Map item in locations){
      convertedList.add(VendorLocations.fromMap(item));
    }
    return convertedList;
  }

}