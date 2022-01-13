import 'package:alena/database/blocs/menu_bloc/menu_cubit.dart';
import 'package:alena/database/blocs/menu_bloc/menu_state.dart';
import 'package:alena/models/menu.dart';
import 'package:alena/widgets/extended_menus/extended_clothes_widget.dart';
import 'package:alena/widgets/extended_menus/extended_electric_widget.dart';
import 'package:alena/widgets/extended_menus/extended_house_widget.dart';
import 'package:alena/widgets/extended_menus/extended_kitchen_widget.dart';
import 'package:alena/widgets/extended_menus/extended_personal_widget.dart';
import 'package:alena/widgets/helpers/check_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../utils/shared.dart';

class SingleMenuWidget extends StatefulWidget {
  final String category;
  final int index;

  const SingleMenuWidget({Key key, this.category, this.index}) : super(key: key);
  @override
  _SingleMenuWidgetState createState() => _SingleMenuWidgetState();
}

class _SingleMenuWidgetState extends State<SingleMenuWidget> {
  bool isCollapse = false;
  List<Menu> _dummyMenu;

  @override
  Widget build(BuildContext context) {
    final MenuCubit menuCubit = BlocProvider.of<MenuCubit>(context);
    return widget.index == 1 ?
    ExtendedElectricWidget(index: widget.index,category: widget.category,) :
    widget.index == 3 ?
    ExtendedKitchenWidget(index: widget.index,category: widget.category,) :
    widget.index == 7  ?
    ExtendedPersonalWidget(index: widget.index,category: widget.category,) :
    widget.index == 8  ?
    ExtendedClothesWidget(index: widget.index,category: widget.category,) :
    widget.index == 9 ?
    ExtendedHouseWidget(index: widget.index,category: widget.category,) :
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: ExpansionTile(
        title: Text('${widget.category}', style: TextStyle(fontSize: 25, color: isCollapse ? black : white,
            fontFamily: 'AA-GALAXY'), textAlign: TextAlign.center,),
        textColor: black,
        backgroundColor: white,
        collapsedBackgroundColor: button,
        iconColor: black,
        onExpansionChanged: (extend){
          setState(() {
            isCollapse = extend;
          });
        },
        children: [
          BlocConsumer<MenuCubit,MenuState>(
            listener: (BuildContext context, state){
              if(state is MenuUpdated){
                menuCubit.loadUserMenu();
              }else if(state is MenuExisted){
                menuCubit.loadUserMenu();
              }else if(state is MenuDeleted){
                menuCubit.loadUserMenu();
              }
            },
            builder: (BuildContext context, state) {
              if(state is MenuDeleteError){
              return Center(child: Text('حدث خطأ فى حذف البيانات!', style: TextStyle(
                    fontSize: 25, color: black, fontFamily: 'AA-GALAXY'),
                  textAlign: TextAlign.center,),);
              }
              if(state is MenuExisted){
                return Center(child: SpinKitCircle(color: button,size: 35,),);
              }
              if(state is MenuInitial){
               return Center(child: SpinKitCircle(color: button,size: 35,),);
              } else if(state is MenuLoaded){
                _dummyMenu = state.menu;
               return Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CheckWidget(values: getSingleMenu(widget.category, state.menu).list,
                                  menuId: getSingleMenu(widget.category, state.menu).id,menuCategory: widget.category,),
                              ],
                            );
              }else if(state is MenuLoading){
                return _dummyMenu == null ? Center(child: SpinKitCircle(color: button,size: 35,),):
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CheckWidget(values: getSingleMenu(widget.category, _dummyMenu).list,
                      menuId: getSingleMenu(widget.category, _dummyMenu).id,menuCategory: widget.category,),
                  ],
                );
              }else if(state is MenuLoadError){
                return Center(child: Text('حدث خطأ فى تحميل البيانات!', style: TextStyle(
                    fontSize: 25, color: black, fontFamily: 'AA-GALAXY'),
                  textAlign: TextAlign.center,),);
              }else if(state is MenuNotUpdated){
                return Center(child: Text('حدث خطأ فى تحديث البيانات!', style: TextStyle(
                    fontSize: 25, color: black, fontFamily: 'AA-GALAXY'),
                  textAlign: TextAlign.center,),);
              }else{
                return Container();
              }
            },
          ),
        ],
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

}
