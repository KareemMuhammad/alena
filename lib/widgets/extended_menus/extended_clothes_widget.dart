import '../../utils/constants.dart';
import 'package:alena/database/blocs/menu_bloc/menu_cubit.dart';
import 'package:alena/database/blocs/menu_bloc/menu_state.dart';
import 'package:alena/models/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../utils/shared.dart';
import '../helpers/check_widget.dart';

class ExtendedClothesWidget extends StatefulWidget {
  final String category;
  final int index;

  const ExtendedClothesWidget({Key key, this.category, this.index}) : super(key: key);
  @override
  _ExtendedClothesWidgetState createState() => _ExtendedClothesWidgetState();
}

class _ExtendedClothesWidgetState extends State<ExtendedClothesWidget> {
  bool isCollapse = false;
  bool isCollapseExtend = false;
  List<Menu> _dummyMenu;

  @override
  Widget build(BuildContext context) {
    final MenuCubit menuCubit = BlocProvider.of<MenuCubit>(context);
    return Padding(
      padding: EdgeInsets.all(10),
      child: ExpansionTile(
        title: Text('${widget.category}', style: TextStyle(
            fontSize: 25, color: isCollapse ? black : white, fontFamily: 'AA-GALAXY'),
          textAlign: TextAlign.center,),
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
          ...(Utils.CLOTHES).map((device) {
            return ExpansionTile(
              title: Text(device, style: TextStyle(
                  fontSize: 22, color: isCollapseExtend ? black : white, fontFamily: 'AA-GALAXY'),
                textAlign: TextAlign.center,),
              textColor: black,
              backgroundColor: white,
              collapsedBackgroundColor: button,
              iconColor: black,
              onExpansionChanged: (extend){
                setState(() {
                  isCollapseExtend = extend;
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
                    }
                    if(state is MenuLoaded){
                      _dummyMenu = state.menu;
                      return Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CheckWidget(values: getSingleMenu(device, state.menu).list ?? {},
                            menuId: getSingleMenu(device, state.menu).id ?? '',menuCategory: device,),
                        ],);
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
                    }else{
                      return const SizedBox();
                    }
                  },
                ),
              ],
            );
          }),
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
