import 'package:alena/screens/categories/main_categories.dart';
import 'package:alena/screens/navigation/bar/nominations.dart';

import '../categories/sub_categories_screen.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/shared.dart';

class ExtendedClothesCategory extends StatefulWidget {
  final List<String> list;
  final String category;
  final int index;
  final Nomination nomination;

  const ExtendedClothesCategory({Key key, this.list, this.category, this.index, this.nomination}) : super(key: key);
  @override
  _ExtendedClothesCategoryState createState() => _ExtendedClothesCategoryState();
}

class _ExtendedClothesCategoryState extends State<ExtendedClothesCategory> {

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: button,
        elevation: 2,
        title: Text('${widget.category}',style: TextStyle(fontSize: 25,color: white,fontFamily: 'AA-GALAXY')
          ,textAlign: TextAlign.center,),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            ...(widget.list).map((device) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    switch (device){
                      case 'مستلزمات الملابس':
                        widget.nomination == Nomination.NOM ?
                        navigatorKey.currentState.push(
                            MaterialPageRoute(builder: (_) => NominationsScreen(category: device,list: Utils.CLOTHES_TOOLS,index: widget.index,))):
                        navigatorKey.currentState.push(
                            MaterialPageRoute(builder: (_) => SubCategories(category: device,list: Utils.CLOTHES_TOOLS,index: widget.index,)));
                        break;
                      case 'اللانجيري':
                        widget.nomination == Nomination.NOM ?
                        navigatorKey.currentState.push(
                            MaterialPageRoute(builder: (_) => NominationsScreen(category: device,list: Utils.CLOTHES_LANGERY,index: widget.index,))):
                        navigatorKey.currentState.push(
                            MaterialPageRoute(builder: (_) => SubCategories(category: device,list: Utils.CLOTHES_LANGERY,index: widget.index,)));
                        break;
                      case 'ملابس البيت':
                        widget.nomination == Nomination.NOM ?
                        navigatorKey.currentState.push(
                            MaterialPageRoute(builder: (_) => NominationsScreen(category: device,list: Utils.CLOTHES_HOME,index: widget.index,))):
                        navigatorKey.currentState.push(
                            MaterialPageRoute(builder: (_) => SubCategories(category: device,list: Utils.CLOTHES_HOME,index: widget.index,)));
                        break;
                      case 'ملابس الخروج':
                        widget.nomination == Nomination.NOM ?
                        navigatorKey.currentState.push(
                            MaterialPageRoute(builder: (_) => NominationsScreen(category: device,list: Utils.CLOTHES_OUTING,index: widget.index,))):
                        navigatorKey.currentState.push(
                            MaterialPageRoute(builder: (_) => SubCategories(category: device,list: Utils.CLOTHES_OUTING,index: widget.index,)));
                        break;
                    }

                  },
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight * 0.13,
                    margin: EdgeInsets.only(left: 45),
                    decoration: BoxDecoration(
                      color: button,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25)),
                    ),
                    child: Center(child: _customText('$device')),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _customText(String text){
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Text('$text',style: TextStyle(fontSize: 3.5 * SizeConfig.blockSizeVertical,color: white,fontFamily: 'AA-GALAXY')
        ,textAlign: TextAlign.end,),
    );
  }
}