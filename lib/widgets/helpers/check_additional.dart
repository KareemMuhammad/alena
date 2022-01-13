import 'package:alena/database/blocs/additional_menu_bloc/additional_menu_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CheckAdditional extends StatefulWidget {
  final Map<String,dynamic> values;
  final String menuId;
  final String menuCategory;

  const CheckAdditional({Key key, this.values, this.menuId, this.menuCategory}) : super(key: key);
  @override
  _CheckAdditionalState createState() => _CheckAdditionalState();
}

class _CheckAdditionalState extends State<CheckAdditional> {
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
    final AdditionalMenuCubit menuCubit = BlocProvider.of<AdditionalMenuCubit>(context);
    final UserCubit userCubit = BlocProvider.of<UserCubit>(context);
    return  Padding(
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
                      actionPane: SlidableStrechActionPane(),
                      actionExtentRatio: 0.25,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'حذف',
                          color: button,
                          icon: Icons.delete,
                          onTap: () {
                            removeSingle(userCubit, menuCubit,key);
                          },
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
                    child: const Text('تأكيد',style: TextStyle(fontSize: 23,color: white,fontFamily: 'AA-GALAXY'),
                      textAlign: TextAlign.center,),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Center(child: Text('اسحبى العنصر للشمال للحذف', style: TextStyle(fontSize: 17, color: container, fontFamily: 'AA-GALAXY'),)),
              ),
              const SizedBox(height: 8,),
            ]
        ),
      ),
    );
  }

  void addSingle(UserCubit userCubit,AdditionalMenuCubit menuCubit){
    if(widget.values.isNotEmpty) {
      for (String key in widget.values.keys) {
        if (widget.values[key] == true) {
          userCubit.updateAdditionalList(key, 0);
        } else {
          userCubit.updateAdditionalList(key, 1);
        }
      }
      menuCubit.updateAdditionalMenu(widget.values, widget.menuId);
      userCubit.loadUserData();
    }
  }

  void removeSingle(UserCubit userCubit,AdditionalMenuCubit menuCubit,String key){
    if(widget.values.isNotEmpty) {
      widget.values.remove(key);
      userCubit.updateAdditionalList(key, 1);
      if(widget.values.length > 0) {
        menuCubit.updateAdditionalMenu(widget.values, widget.menuId);
      }else{
        menuCubit.deleteAdditionalMenuById(widget.menuId);
      }
      userCubit.loadUserData();
    }
  }
}
