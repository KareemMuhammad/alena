import 'package:alena/screens/extended_screens/extended_house.dart';
import 'package:alena/screens/extended_screens/extended_kitchen.dart';
import 'package:alena/screens/extended_screens/extended_personal.dart';
import '../extended_screens/extended_clothes.dart';
import '../extended_screens/extended_electric.dart';
import 'sub_categories_screen.dart';
import '../../utils/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class MainCategories extends StatefulWidget {

  @override
  _MainCategoriesState createState() => _MainCategoriesState();
}

class _MainCategoriesState extends State<MainCategories> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: button,
        elevation: 2,
        title: Text('الأقسام',style: TextStyle(fontSize: 30,color: white,fontFamily: 'AA-GALAXY')
          ,textAlign: TextAlign.center,),
      ),
      body: ListView.builder(
        itemCount: Utils.MAIN_CATEGORIES_LIST.length,
        itemBuilder: (BuildContext context, int index) {
         return _containerLayout(Utils.MAIN_CATEGORIES_LIST[index],index);
       },
      ),
    );
  }

  Widget _containerLayout(String category,int index){
    return GestureDetector(
      onTap: (){
        _switchCategories(category,index);
      },
      child: Column(
        children: [
         const SizedBox(height: 20,),
          Container(
            width: SizeConfig.screenWidth,
            height: 70,
            margin: EdgeInsets.only(left: 45),
            decoration: BoxDecoration(
              color: button,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25)),
            ),
            child: Center(child: _customText('$category')),
          ),
          Image.asset(Utils.MAIN_CATEGORIES_IMAGES[index],width: double.maxFinite,height: 230,fit: BoxFit.fitWidth,),
        ],
      ),
    );
  }

  Widget _customText(String text){
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Text('$text',style: TextStyle(fontSize: 30,color: white,fontFamily: 'AA-GALAXY')
        ,textAlign: TextAlign.end,),
    );
  }

  void _switchCategories(String category,int index) {
    switch (category){
      case 'أثاث':
        navigatorKey.currentState.push(
            MaterialPageRoute(builder: (_) => SubCategories(category: category,list: Utils.FURNITURE_LIST,index: index,)));
        break;
      case 'مفروشات':
        navigatorKey.currentState.push(
            MaterialPageRoute(builder: (_) => SubCategories(category: category,list: Utils.MAFROSHAT_LIST,index: index,)));
        break;
      case 'اكسسوارات':
        navigatorKey.currentState.push(
            MaterialPageRoute(builder: (_) => SubCategories(category: category,list: Utils.ACCESSORIES_LIST,index: index,)));
        break;
      case 'مستلزمات تنظيف':
        navigatorKey.currentState.push(
            MaterialPageRoute(builder: (_) => SubCategories(category: category,list: Utils.CLEANING_STAFF_LIST,index: index,)));
        break;
      case 'رفائع و بلاستيكات':
        navigatorKey.currentState.push(
            MaterialPageRoute(builder: (_) => SubCategories(category: category,list: Utils.PLASTICS_LIST,index: index,)));
        break;
      case 'أجهزة كهربائية':
        navigatorKey.currentState.push(
            MaterialPageRoute(builder: (_) => ExtendedElectricCategory(category: category,list: Utils.ELECTRIC_DEVICES,index: index,)));
        break;
      case 'ملابس':
        navigatorKey.currentState.push(
            MaterialPageRoute(builder: (_) => ExtendedClothesCategory(category: category,list: Utils.CLOTHES,index: index,)));
        break;
      case 'أدوات مطبخ':
        navigatorKey.currentState.push(
            MaterialPageRoute(builder: (_) => ExtendedKitchenCategory(category: category,list: Utils.KITCHEN_DEVICES,index: index,)));
        break;
      case 'مستلزمات شخصية':
        navigatorKey.currentState.push(
            MaterialPageRoute(builder: (_) => ExtendedPersonalCategory(category: category,list: Utils.PERSONAL_ACCESSORIES,index: index,)));
        break;
      case 'مستلزمات المنزل':
        navigatorKey.currentState.push(
            MaterialPageRoute(builder: (_) => ExtendedHouseCategory(category: category,list: Utils.HOUSE_LIST,index: index,)));
        break;
      default:
    }
  }

}
