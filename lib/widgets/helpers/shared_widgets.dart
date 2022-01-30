import 'package:alena/widgets/helpers/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../utils/shared.dart';

Widget customAppBar(BuildContext context){
  return AppBar(
      iconTheme: IconThemeData(
        color: white,
      ),
      backgroundColor: button,
      elevation: 2,
      centerTitle: true,
    title: Padding(
      padding: EdgeInsets.fromLTRB(2, 2, 6, 2),
      child: Image.asset("assets/logo.png",fit: BoxFit.cover,height: 70,width: 70,),
    ),
  );
}

Widget loadVendorShimmer(){
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: white,
      elevation: 4,
      child: MyShimmer.rectangular()
    ),
  );
}

Widget loadProductShimmer(){
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: white,
      elevation: 4,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
             MyShimmer.rectangular(height: 130,),
            const SizedBox(height: 10,),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: MyShimmer.rectangular(height: 13,width: 60,),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: MyShimmer.rectangular(height: 25,),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: MyShimmer.circular(width: 65,height: 65,),
             ),
          ],
        ),
      ),
    ),
  );
}

InputDecoration textInputDecorationSign(String hintText,IconData iconData){
  return InputDecoration(
    filled: true,
    fillColor: white,
    hintTextDirection: TextDirection.rtl,
    hintText: hintText,
    hintStyle: TextStyle(fontSize: 18,color: button,fontFamily: 'AA-GALAXY'),
    border: InputBorder.none,
    errorStyle: TextStyle(color: Colors.grey[700],fontSize: 16),
    contentPadding: EdgeInsets.all(8),
    prefixIcon: Icon(iconData,size: 20,color: container,),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: white, width: 2.0),
      borderRadius: BorderRadius.circular(20)
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: white, width: 2.0),
        borderRadius: BorderRadius.circular(20)
    ),
  );
}

InputDecoration textInputDecorationOrder(String hintText,IconData iconData){
  return InputDecoration(
    filled: true,
    fillColor: white,
    hintTextDirection: TextDirection.rtl,
    hintText: hintText,
    hintStyle: TextStyle(fontSize: 16,color: button,fontFamily: 'AA-GALAXY'),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    errorStyle: TextStyle(color: button,fontSize: 16),
    contentPadding: EdgeInsets.all(8),
    prefixIcon: Icon(iconData,size: 20,color: container,),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[700], width: 2.0),
        borderRadius: BorderRadius.circular(20)
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[700], width: 2.0),
        borderRadius: BorderRadius.circular(20)
    ),
  );
}

InputDecoration textInputDecoration2(String hint) => InputDecoration(
  fillColor: white,
  filled: true,
  hintTextDirection: TextDirection.rtl,
  errorStyle: TextStyle(color: white,fontSize: 16),
  contentPadding: EdgeInsets.all(12.0),
  hintText: hint,
  hintStyle: TextStyle(color: black,fontSize: 20,fontFamily: 'AA-GALAXY'),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey[600], width: 1.0),
    borderRadius: BorderRadius.circular(20)
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: white, width: 1.0),
      borderRadius: BorderRadius.circular(20)
  ),
);

final spinKit = Center(
  child: SpinKitThreeBounce(
    color: button,
    size: 50.0,
  ),
);



