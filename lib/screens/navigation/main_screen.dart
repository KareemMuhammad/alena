import 'dart:ui';
import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_state.dart';
import 'package:alena/models/user.dart';
import 'package:alena/widgets/helpers/love_animation.dart';
import 'package:alena/widgets/helpers/shared_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import '../categories/main_categories.dart';
import 'wedding_time.dart';
import '../../widgets/dialogs/edit_wedding_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import '../../utils/constants.dart';
import '../../utils/shared.dart';

class MainScreen extends StatefulWidget {
  final AppUser appUser;
  final GlobalKey globalKey;

  const MainScreen({Key key, this.appUser, this.globalKey,}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int date;

  @override
  void initState() {
    super.initState();
    if(widget.appUser.weddingDate.isNotEmpty) {
      date = Utils.dateDifference(widget.appUser.weddingDate.split(' ')[0],
          widget.appUser.weddingDate.split(' ')[1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocBuilder<UserCubit,UserState>(
      builder: (ctx,state){
        return state is UserLoaded ?
      SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                state.appUser.weddingDate.isNotEmpty?
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('معاد فرحك',style: TextStyle(color: button,fontSize: 22,fontFamily: 'AA-GALAXY')
                    ,textAlign: TextAlign.end,),
                ): const SizedBox(),
                state.appUser.weddingDate.isNotEmpty?
                Container(
                  width: 1,
                  height: 15,
                  color: button,
                ) : const SizedBox(),
                state.appUser.weddingDate.isNotEmpty ?
                Padding(
                  padding: const EdgeInsets.only(left: 8,right: 8,),
                  child: Center(
                    child: CountdownTimer(
                      widgetBuilder: (_, CurrentRemainingTime time) {
                        if (time == null) {
                          return Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoveAnimation(),
                              SizedBox(width: 10,),
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Text('مبروك',style: TextStyle(fontSize: 35,color: button,fontFamily: 'AA-GALAXY'),textAlign: TextAlign.center,),
                              ),
                            ],
                          );
                        }
                        return Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buttonLayout('${time.days ?? ''}'),
                            buttonLayout('${time.hours ?? ''}'),
                            buttonLayout('${time.min ?? ''}'),
                            buttonLayout('${time.sec ?? ''}'),
                          ],
                        );
                      },
                      endTime: Utils.dateDifference(state.appUser.weddingDate.split(' ')[0], state.appUser.weddingDate.split(' ')[1]),
                      endWidget: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoveAnimation(),
                          const SizedBox(width: 10,),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Text('مبروك',style: TextStyle(fontSize: 17,color: button),textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                      textStyle: TextStyle(color: button,fontSize: 22,fontFamily: 'AA-GALAXY'),
                    ),
                  ),
                ) : const SizedBox(),
                state.appUser.weddingDate.isNotEmpty ?
                Container(
                  width: 1,
                  height: 15,
                  color: button,
                ) : const SizedBox(),
                state.appUser.weddingDate.isNotEmpty ?
                RaisedButton(
                  color: white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 4,
                  onPressed: () async{
                    dynamic result = await showDialog(context: context, builder: (_){
                      return new BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                            backgroundColor: white,
                            child: new EditWeddingDialog(),
                          )
                      );
                    });
                    if(result == 'done'){
                      navigatorKey.currentState.push(MaterialPageRoute(builder: (_) => WeddingDate()));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('تعديل',style: TextStyle(fontSize: 22,color: button,fontFamily: 'AA-GALAXY'),
                      textAlign: TextAlign.center,),
                  ),
                ): const SizedBox(),
                const SizedBox(height: 10,),
                state.appUser.weddingDate.isEmpty ?
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('إبدئى جهازك',style: TextStyle(color: button,fontSize: 55,letterSpacing: 1,fontFamily: 'AA-GALAXY')
                    ,textAlign: TextAlign.end,),
                ):
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('كملى جهازك',style: TextStyle(color: button,fontSize: 55,letterSpacing: 1,fontFamily: 'AA-GALAXY')
                    ,textAlign: TextAlign.end,),
                ),

                Showcase(
                  key: widget.globalKey,
                  description: 'اختارى قائمتك من هنا',
                  textColor: button,
                  descTextStyle: TextStyle(color: button,fontSize: 20,letterSpacing: 1,fontFamily: 'AA-GALAXY'),
                  shapeBorder: CircleBorder(),
                  overlayPadding: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.3,vertical: 0),
                    child: MaterialButton(
                      color: button,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 4,
                      onPressed: () {
                        if(state.appUser.weddingDate.isEmpty) {
                          navigatorKey.currentState.push(
                              MaterialPageRoute(builder: (_) => WeddingDate()));
                        }else{
                          navigatorKey.currentState.push(
                              MaterialPageRoute(builder: (_) => MainCategories()));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back_ios,color: white,),
                            const Text('يلا بينا',style: TextStyle(letterSpacing: 1,fontSize: 30,color: white,fontFamily: 'AA-GALAXY'),
                              textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
              ],
            ),
        ) : state is UserInitial ?
     SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.appUser.weddingDate.isNotEmpty ?
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('معاد فرحك',style: TextStyle(color: button,fontSize: 22,fontFamily: 'AA-GALAXY')
                    ,textAlign: TextAlign.end,),
                ): const SizedBox(),
                widget.appUser.weddingDate.isNotEmpty ?
                Container(
                  width: 1,
                  height: 15,
                  color: button,
                ) : const SizedBox(),
                widget.appUser.weddingDate.isNotEmpty ?
                Padding(
                  padding: const EdgeInsets.only(left: 8,right: 8,),
                  child: Center(
                    child: CountdownTimer(
                      widgetBuilder: (_, CurrentRemainingTime time) {
                        if (time == null) {
                          return Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoveAnimation(),
                              SizedBox(width: 10,),
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Text('مبروك',style: TextStyle(fontSize: 35,color: button,fontFamily: 'AA-GALAXY'),textAlign: TextAlign.center,),
                              ),
                            ],
                          );
                        }
                        return Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buttonLayout('${time.days ?? ''}'),
                            buttonLayout('${time.hours ?? ''}'),
                            buttonLayout('${time.min ?? ''}'),
                            buttonLayout('${time.sec ?? ''}'),
                          ],
                        );
                      },
                      endTime: date,
                      endWidget: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoveAnimation(),
                          SizedBox(width: 10,),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Text('مبروك',style: TextStyle(fontSize: 17,color: button),textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                      textStyle: TextStyle(color: button,fontSize: 22,fontFamily: 'AA-GALAXY'),
                    ),
                  ),
                ) : const SizedBox(),
                widget.appUser.weddingDate.isNotEmpty ?
                Container(
                  width: 1,
                  height: 15,
                  color: button,
                ) : const SizedBox(),
                widget.appUser.weddingDate.isNotEmpty ?
                RaisedButton(
                  color: white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 4,
                  onPressed: () async{
                    dynamic result = await showDialog(context: context, builder: (_){
                      return new BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                            backgroundColor: white,
                            child: new EditWeddingDialog(),
                          )
                      );
                    });
                    if(result == 'done'){
                      navigatorKey.currentState.push(MaterialPageRoute(builder: (_) => WeddingDate()));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('تعديل',style: TextStyle(fontSize: 22,color: button,fontFamily: 'AA-GALAXY'),
                      textAlign: TextAlign.center,),
                  ),
                ): const SizedBox(),
                const SizedBox(height: 10,),
                widget.appUser.weddingDate.isEmpty ?
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('إبدئى جهازك',style: TextStyle(color: button,fontSize: 55,letterSpacing: 1,fontFamily: 'AA-GALAXY')
                    ,textAlign: TextAlign.end,),
                ):
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('كملى جهازك',style: TextStyle(color: button,fontSize: 55,letterSpacing: 1,fontFamily: 'AA-GALAXY')
                    ,textAlign: TextAlign.end,),
                ),
                Showcase(
                  key: widget.globalKey,
                  description: 'إبدئى اختارى قائمتك من هنا',
                  textColor: button,
                  descTextStyle: TextStyle(color: button,fontSize: 20,letterSpacing: 1,fontFamily: 'AA-GALAXY'),
                  shapeBorder: CircleBorder(),
                  overlayPadding: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.3,vertical: 0),
                    child: MaterialButton(
                      color: button,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 4,
                      onPressed: () {
                        if(widget.appUser.weddingDate.isEmpty) {
                          navigatorKey.currentState.push(
                              MaterialPageRoute(builder: (_) => WeddingDate()));
                        }else{
                          navigatorKey.currentState.push(
                              MaterialPageRoute(builder: (_) => MainCategories()));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back_ios,color: white,),
                            const Text('يلا بينا',style: TextStyle(letterSpacing: 1,fontSize: 30,color: white,fontFamily: 'AA-GALAXY'),
                              textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
              ],
            ),
        ) : state is UserLoading ?
         spinKit : const SizedBox();
      },
    );
  }

  Widget buttonLayout(String text){
    return text == null || text.isEmpty ?
   const SizedBox():
    Flexible(
          child: Card(
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text('$text',style: TextStyle(fontSize: 22,color: button,fontFamily: 'AA-GALAXY'),
                    textAlign: TextAlign.center,),
                ),
              ),
            ),
          ),
    );
  }

}
