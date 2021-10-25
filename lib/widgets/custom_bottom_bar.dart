import 'dart:ui';
import 'package:alena/models/user.dart';
import 'package:alena/screens/navigation/main_screen.dart';
import 'package:alena/services/remote_config.dart';
import 'package:alena/utils/constants.dart';
import 'package:showcaseview/showcaseview.dart';
import '../main.dart';
import 'dialogs/allow_update_dialog.dart';
import 'slide_panel/my_menu_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../utils/shared.dart';

class CustomBottomBar extends StatefulWidget {
  final AppUser appUser;
  final PanelController panelController;
  final RemoteConfigService remoteConfigService;

  CustomBottomBar({Key key, this.appUser, this.panelController, this.remoteConfigService}) : super(key: key);

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  final BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),);
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();

  @override
  void initState() {
    super.initState();
    if(!sharedPref.getBool(Utils.SHARED_KEY)) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          ShowCaseWidget.of(context).startShowCase([_one, _two]));
    }

    if(widget.remoteConfigService != null && widget.remoteConfigService.checkUpdates()){
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          showDialog(context: context, builder: (_){
            return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  backgroundColor: white,
                  child: AllowUpdateDialog(),
                )
            );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return  SlidingUpPanel(
              controller: widget.panelController,
              panel: Showcase(
                  key: _two,
                  description: 'هنا هتلاقى القائمة الى اختارتيها من الاقسام',
                  textColor: button,
                  descTextStyle: TextStyle(color: button,fontSize: 20,letterSpacing: 1,fontFamily: 'AA-GALAXY'),
                  shapeBorder: CircleBorder(),
                  overlayPadding: EdgeInsets.all(10),
                  child: MyMenuWidget()
              ),
              collapsed: Container(
                decoration: BoxDecoration(
                    color: button,
                    borderRadius: radius
                ),
                child: Center(
                 child: InkWell(
                  onTap: (){
                    widget.panelController.open();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                    SizedBox(height: 8,),
                    Text('عليا',style: TextStyle(fontSize: 40,color: white,fontFamily: 'AA-GALAXY')
                      ,textAlign: TextAlign.center,),
                    Image.asset('assets/arrow-up.png',height: 25,width: 25,),
                  ],
                ),
              ),
            ),
          ),
              body: Center(child: MainScreen(appUser: widget.appUser,globalKey: _one,)),
              borderRadius: radius,
    );
  }
}