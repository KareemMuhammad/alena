import 'dart:ui';
import 'package:alena/database/auth_bloc/auth_cubit.dart';
import 'package:alena/database/blocs/reg_bloc/reg_cubit.dart';
import 'package:alena/database/blocs/reg_bloc/reg_state.dart';
import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_state.dart';
import 'package:alena/main.dart';
import 'package:alena/models/user.dart';
import 'package:alena/screens/navigation/devices_screen.dart';
import 'package:alena/screens/navigation/profile_screen.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../widgets/helpers/shared_widgets.dart';
import 'package:alena/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/shared.dart';

class HomeScreen extends StatefulWidget {
  final AppUser appUser;

  const HomeScreen({Key key, this.appUser}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if(panelController.isPanelOpen) {
          panelController.close();
          return Future.value(false);
        }else{
          return Future.value(true);
        }
      },
      child: Scaffold(
        endDrawer: SafeArea(
          child: Drawer(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListTile(
                      leading: Icon(Icons.person,size: 25,color: button,),
                      title: Text('الملف الشخصى', style: TextStyle(
                          fontSize: 20,
                          color: button,
                          fontFamily: 'AA-GALAXY'
                      ),),
                      onTap: (){
                        Navigator.pop(context);
                        navigatorKey.currentState.push(MaterialPageRoute(builder: (_) => ProfileScreen(appUser: widget.appUser,)));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Divider(height: 1,color: black,),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListTile(
                      leading: Icon(Icons.favorite,size: 25,color: button,),
                      title: Text('جهازى', style: TextStyle(
                          fontSize: 20,
                          color: button,
                          fontFamily: 'AA-GALAXY'
                      ),),
                      onTap: (){
                        Navigator.pop(context);
                        navigatorKey.currentState.push(MaterialPageRoute(builder: (_) => MyDevicesScreen(appUser: widget.appUser,)));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Divider(height: 1,color: black,),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListTile(
                      leading: Icon(Icons.logout,size: 25,color: button,),
                      title: Text('تسجيل خروج', style: TextStyle(
                          fontSize: 20,
                          color: button,
                          fontFamily: 'AA-GALAXY'
                      ),),
                      onTap: (){
                        Navigator.pop(context);
                        BlocProvider.of<AuthCubit>(context).signOut();
                        BlocProvider.of<UserCubit>(context).emit(UserInitial());
                        BlocProvider.of<RegCubit>(context).emit(RegInitial());
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Divider(height: 1,color: black,),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListTile(
                      leading: Icon(Icons.all_inclusive,color: button,size: 25,),
                      trailing: RaisedButton(
                        color: button,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 2,
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: const Text('قريبا',style: TextStyle(letterSpacing: 1,fontSize: 17,color: white,fontFamily: 'AA-GALAXY'),
                            textAlign: TextAlign.center,),
                        ),
                      ),
                      title: Text('الترشيحات', style: TextStyle(
                          fontSize: 20,
                          color: button,
                          fontFamily: 'AA-GALAXY',
                      ),),
                      onTap: ()async{

                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        appBar: customAppBar(context),
        backgroundColor: white,
        bottomNavigationBar: ShowCaseWidget(
          builder: Builder(
            builder: (_) => CustomBottomBar(appUser: widget.appUser,panelController: panelController,remoteConfigService: remoteConfigService,),
          ),
        ),
      ),
    );
  }
}
