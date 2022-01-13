import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/main.dart';
import 'package:alena/models/user.dart';
import 'package:alena/screens/categories/main_categories.dart';
import 'package:alena/screens/navigation/bar/favorites_screen.dart';
import 'package:alena/utils/constants.dart';
import 'package:alena/widgets/helpers/categories_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'bar/devices_screen.dart';
import 'bar/profile_screen.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../widgets/helpers/shared_widgets.dart';
import 'package:alena/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
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
  void initState() {
    super.initState();
    BlocProvider.of<UserCubit>(context).loadUserData();
  }

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
                      leading: Icon(Icons.widgets,size: 25,color: button,),
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
                      leading: Icon(Icons.favorite,size: 25,color: button,),
                      title: Text('الأجهزة المفضلة', style: TextStyle(
                          fontSize: 20,
                          color: button,
                          fontFamily: 'AA-GALAXY'
                      ),),
                      onTap: ()async{
                        Navigator.pop(context);
                        navigatorKey.currentState.push(MaterialPageRoute(builder: (_) => FavoritesScreen(appUser: Utils.getCurrentUser(context),)));
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
                      title: Text('الترشيحات', style: TextStyle(
                          fontSize: 20,
                          color: button,
                          fontFamily: 'AA-GALAXY',
                      ),),
                      onTap: (){
                        navigatorKey.currentState.push(
                            MaterialPageRoute(builder: (_) => MainCategories(nomination: Nomination.NOM,)));
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
                      leading: Icon(Icons.rate_review_outlined,color: button,size: 25,),
                      title: Text('صنف التطبيق', style: TextStyle(
                        fontSize: 20,
                        color: button,
                        fontFamily: 'AA-GALAXY',
                      ),),
                      onTap: ()async{
                        await launch(APP_LINK);
                      },
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: button,
                        child: Center(
                          child: Text('علينا',style: TextStyle(fontSize: 35,color: white,
                              fontFamily: 'AA-GALAXY'),),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text('${packageInfo.version}',style: TextStyle(fontSize: 20,color: button,
                        fontFamily: 'AA-GALAXY',fontWeight: FontWeight.bold),),
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
