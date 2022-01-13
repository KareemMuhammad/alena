import 'package:alena/database/blocs/menu_bloc/menu_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/models/menu.dart';
import 'package:alena/screens/categories/main_categories.dart';
import 'package:alena/screens/navigation/products_nav/vendors_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../utils/shared.dart';

class CheckWidget extends StatefulWidget {
  final Map<String,dynamic> values;
  final String menuId;
  final String menuCategory;

  const CheckWidget({Key key, this.values, this.menuId, this.menuCategory}) : super(key: key);
  @override
  _CheckWidgetState createState() => _CheckWidgetState();
}

class _CheckWidgetState extends State<CheckWidget> {
  int positiveIndex = 0;

  @override
  void initState() {
    super.initState();
    if(widget.values != null && widget.values.isNotEmpty) {
      widget.values.forEach((key, value) {
        if(value == true) {
          positiveIndex++;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final MenuCubit menuCubit = BlocProvider.of<MenuCubit>(context);
    final UserCubit userCubit = BlocProvider.of<UserCubit>(context);
    return widget.values == null || widget.values.isEmpty ?
    Center(child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('القائمة فارغة',style:
          TextStyle(color: button,fontFamily: 'AA-GALAXY',fontSize: 19,),textAlign: TextAlign.center,),
        ),
        RaisedButton(
          color: button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 4,
          onPressed: () {
              navigatorKey.currentState.push(MaterialPageRoute(builder: (_) => MainCategories()));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text('يلا بينا',style: TextStyle(letterSpacing: 1,fontSize: 19,color: white,fontFamily: 'AA-GALAXY'),
              textAlign: TextAlign.center,),
          ),
        ),
        const SizedBox(height: 10,),
      ],
    ))
    : Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SingleChildScrollView(
        child: Column(
           children: [

             Text('علمى على الى جبتيه فى جهازك', style: TextStyle(fontSize: 18, color: button, fontFamily: 'AA-GALAXY'),),

             Padding(
               padding: const EdgeInsets.all(5.0),
               child: Text('$positiveIndex / ${widget.values.length}',style: TextStyle(letterSpacing: 1,fontSize: 20,color: button,fontFamily: 'AA-GALAXY'),
                 textAlign: TextAlign.center,),
             ),

             ...(widget.values.keys).map((String key) {
             return Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                alignment: Alignment.centerRight,
                width: SizeConfig.screenWidth * 0.6,
                child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.5,
                  actions: <Widget>[
                    RaisedButton(
                      color: button,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 4,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => VendorsScreen(title: key,)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 2),
                        child: const Text('الترشيحات',style: TextStyle(fontSize: 18,color: white,fontFamily: 'AA-GALAXY'),
                          textAlign: TextAlign.center,),
                      ),
                    ),
                  ],
                  secondaryActions: <Widget>[
                    RaisedButton(
                      color: button,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 4,
                      onPressed: () {
                        removeSingle(userCubit, menuCubit,key);
                      },
                      child: const Text('حذف',style: TextStyle(fontSize: 18,color: white,fontFamily: 'AA-GALAXY'),
                          textAlign: TextAlign.center,),
                    ),
                  ],
                  child: new CheckboxListTile(
                    checkColor: white,
                    activeColor: button,
                    title: new Text(key,style: TextStyle(color: button,fontFamily: 'AA-GALAXY',fontSize: 22,),textAlign: TextAlign.end,),
                    value: widget.values[key],
                    onChanged: (bool value) {
                      setState(() {
                          if(value == true){
                            positiveIndex++;
                          }else{
                            positiveIndex--;
                          }
                          widget.values[key] = value;
                      });
                    },
                  ),
                ),
              ),
            );
          }).toList(),

                    Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: RaisedButton(
                         color: button,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(30.0),
                         ),
                         elevation: 4,
                         onPressed: () {
                               addSingle(userCubit,menuCubit);
                         },
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: const Text('تأكيد',style: TextStyle(fontSize: 22,color: white,fontFamily: 'AA-GALAXY'),
                             textAlign: TextAlign.center,),
                         ),
                       ),
                     ),

             Padding(
               padding: const EdgeInsets.all(5.0),
               child: Center(child: Text('اسحبى العنصر للشمال للحذف او لليمين للترشيحات', style: TextStyle(fontSize: 17, color: container, fontFamily: 'AA-GALAXY'),)),
             ),
             const SizedBox(height: 8,),
          ]
        ),
      ),
    );
  }

  Menu getSingleMenu(String category,List<Menu> list) {
    var exist = list.any((menu) => menu.category == category);
    if(exist) {
      Menu singleMenu = list.firstWhere((menu) => menu.category == category);
      return singleMenu;
    }else{
      return Menu();
    }
  }

  void addSingle(UserCubit userCubit,MenuCubit menuCubit){
    if(widget.values.isNotEmpty) {
      for (String key in widget.values.keys) {
        if (widget.values[key] == true) {
          userCubit.updateDoneList(key, 0);
        } else {
          userCubit.updateDoneList(key, 1);
        }
      }
      menuCubit.updateMenu(widget.values, widget.menuId);
      userCubit.loadUserData();
    }
  }

  void removeSingle(UserCubit userCubit,MenuCubit menuCubit,String key){
    if(widget.values.isNotEmpty) {
      widget.values.remove(key);
      userCubit.updateDoneList(key, 1);
      if(widget.values.length > 0) {
        menuCubit.updateMenu(widget.values, widget.menuId);
      }else{
        menuCubit.deleteMenuById(widget.menuId);
      }
      userCubit.loadUserData();
    }
  }

}
