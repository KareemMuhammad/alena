import '../categories/sub_categories_screen.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/shared.dart';

class ExtendedElectricCategory extends StatefulWidget {
  final List<String> list;
  final String category;
  final int index;

  const ExtendedElectricCategory({Key key, this.list, this.category, this.index}) : super(key: key);
  @override
  _ExtendedElectricCategoryState createState() => _ExtendedElectricCategoryState();
}

class _ExtendedElectricCategoryState extends State<ExtendedElectricCategory> {

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
        title: Text('${widget.category}',style: TextStyle(fontSize: 30,color: white,fontFamily: 'AA-GALAXY')
          ,textAlign: TextAlign.center,),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            ...(widget.list).map((device) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    switch (device){
                      case 'الأجهزة الكهربائية الأساسية':
                        navigatorKey.currentState.push(
                            MaterialPageRoute(builder: (_) => SubCategories(category: device,list: Utils.MAIN_ELECTRIC_DEVICES,index: widget.index,)));
                        break;
                      case 'الأجهزة الكهربائية الاضافية':
                        navigatorKey.currentState.push(
                            MaterialPageRoute(builder: (_) => SubCategories(category: device,list: Utils.ADDITIONAL_ELECTRIC_DEVICES,index: widget.index,)));
                        break;
                      case 'أجهزة كهربائية صغيره للمطبخ':
                        navigatorKey.currentState.push(
                            MaterialPageRoute(builder: (_) => SubCategories(category: device,list: Utils.ELECTRIC_SMALL_KITCHEN_DEV,index: widget.index,)));
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
      padding: const EdgeInsets.all(8.0),
      child: Text('$text',style: TextStyle(fontSize: 3.5 * SizeConfig.blockSizeVertical,color: white,fontFamily: 'AA-GALAXY')
        ,textAlign: TextAlign.end,),
    );
  }

}
