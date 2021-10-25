import '../categories/sub_categories_screen.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/shared.dart';

class ExtendedKitchenCategory extends StatefulWidget {
  final List<String> list;
  final String category;
  final int index;

  const ExtendedKitchenCategory({Key key, this.list, this.category, this.index}) : super(key: key);
  @override
  _ExtendedKitchenCategoryState createState() => _ExtendedKitchenCategoryState();
}

class _ExtendedKitchenCategoryState extends State<ExtendedKitchenCategory> {

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
                      case 'أدوات المطبخ':
                        navigatorKey.currentState.push(
                            MaterialPageRoute(builder: (_) => SubCategories(category: device,list: Utils.KITCHEN_TOOLS,index: widget.index,)));
                        break;
                      case 'أدوات التقديم':
                        navigatorKey.currentState.push(
                            MaterialPageRoute(builder: (_) => SubCategories(category: device,list: Utils.KITCHEN_PROVIDERS,index: widget.index,)));
                        break;
                      case 'أطقم المشروبات':
                        navigatorKey.currentState.push(
                            MaterialPageRoute(builder: (_) => SubCategories(category: device,list: Utils.KITCHEN_DRINKS,index: widget.index,)));
                        break;
                      case 'الأطباق':
                        navigatorKey.currentState.push(
                            MaterialPageRoute(builder: (_) => SubCategories(category: device,list: Utils.KITCHEN_DISHES,index: widget.index,)));
                        break;
                      case 'الصوانى و الطواجن':
                        navigatorKey.currentState.push(
                            MaterialPageRoute(builder: (_) => SubCategories(category: device,list: Utils.KITCHEN_SAWANY,index: widget.index,)));
                        break;
                      case 'الأوانى':
                        navigatorKey.currentState.push(
                            MaterialPageRoute(builder: (_) => SubCategories(category: device,list: Utils.KITCHEN_AWANY,index: widget.index,)));
                        break;
                      case 'الحلل و التوزيع':
                        navigatorKey.currentState.push(
                            MaterialPageRoute(builder: (_) => SubCategories(category: device,list: Utils.KITCHEN_DISTRIBUTION,index: widget.index,)));
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