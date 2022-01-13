import 'package:alena/database/blocs/additional_menu_bloc/additional_menu_cubit.dart';
import 'package:alena/database/blocs/additional_menu_bloc/additional_menu_state.dart';
import 'package:alena/screens/navigation/new_category_screen.dart';
import 'package:alena/widgets/extended_menus/additional_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../utils/constants.dart';
import '../../utils/shared.dart';
import 'package:alena/widgets/slide_panel/single_menu_widget.dart';
import 'package:flutter/material.dart';

class MyMenuWidget extends StatefulWidget {
  @override
  _MyMenuWidgetState createState() => _MyMenuWidgetState();
}

class _MyMenuWidgetState extends State<MyMenuWidget> {

  @override
  Widget build(BuildContext context) {
    final AdditionalMenuCubit menuCubit = BlocProvider.of<AdditionalMenuCubit>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 70,
        backgroundColor: white,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('قائمتى',style: TextStyle(fontSize: 30,color: button,fontFamily: 'AA-GALAXY')
                ,textAlign: TextAlign.center,),
              Image.asset('assets/arrow-down.png',height: 25,width: 25,),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
           ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: Utils.MAIN_CATEGORIES_LIST.length,
                        itemBuilder: (context,index){
                          return SingleMenuWidget(category: Utils.MAIN_CATEGORIES_LIST[index],index: index);
                        }),

          BlocConsumer<AdditionalMenuCubit,AdditionalMenuState>(
              listener: (ctx,state){
                if(state is MenuUpdated){
                  menuCubit.loadUserAdditionalMenu();
                }else if(state is MenuExisted){
                  menuCubit.loadUserAdditionalMenu();
                }else if(state is MenuDeleted){
                  menuCubit.loadUserAdditionalMenu();
                }
            },
            builder: (ctx,state){
                if(state is MenuLoaded){
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.menu.length,
                      itemBuilder: (context,index){
                        return Column(
                          children: [
                            Center(child: Text('القائمة الاضافية', style: TextStyle(
                                fontSize: 18, color: button, fontFamily: 'AA-GALAXY'),
                              textAlign: TextAlign.center,),),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AdditionalExtension(menu: state.menu[index],),
                            ),
                          ],
                        );
                      });
                }else if(state is MenuLoading){
                  return Center(child: SpinKitCircle(color: button,size: 35,),);
                }else if(state is MenuLoadError){
                  return Center(child: Text('حدث خطأ فى تحميل البيانات!', style: TextStyle(
                      fontSize: 25, color: black, fontFamily: 'AA-GALAXY'),
                    textAlign: TextAlign.center,),);
                }  if(state is MenuDeleteError){
                  return Center(child: Text('حدث خطأ فى حذف البيانات!', style: TextStyle(
                      fontSize: 25, color: black, fontFamily: 'AA-GALAXY'),
                    textAlign: TextAlign.center,),);
                }
                if(state is MenuExisted){
                  return Center(child: SpinKitCircle(color: button,size: 35,),);
                }
                if(state is MenuInitial){
                  return Center(child: SpinKitCircle(color: button,size: 35,),);
                }else if(state is MenuNotUpdated){
                  return Center(child: Text('حدث خطأ فى تحديث البيانات!', style: TextStyle(
                      fontSize: 25, color: black, fontFamily: 'AA-GALAXY'),
                    textAlign: TextAlign.center,),);
                }else{
                  return Container();
                }
            }),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: button,
              child: IconButton(
                color: white,
                iconSize: 30,
                icon: Icon(Icons.add),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => NewCategoryScreen()));
                },
              ),
            ),
          ),
          Text('اضافة قسم جديد',style: TextStyle(fontSize: 17,color: button,fontFamily: 'AA-GALAXY')
            ,textAlign: TextAlign.center,),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }
}
