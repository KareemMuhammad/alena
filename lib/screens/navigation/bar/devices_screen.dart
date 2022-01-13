import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_state.dart';
import 'package:alena/models/user.dart';
import 'package:alena/widgets/extended_devices/main_device.dart';
import 'package:alena/widgets/helpers/check_device.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../utils/constants.dart';
import '../../../utils/shared.dart';
import 'package:flutter/material.dart';

class MyDevicesScreen extends StatefulWidget {
  final AppUser appUser;

  const MyDevicesScreen({Key key, this.appUser}) : super(key: key);
  @override
  _MyDevicesScreenState createState() => _MyDevicesScreenState();
}

class _MyDevicesScreenState extends State<MyDevicesScreen> {
  bool isCollapse = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: button,
        title: Text('جهازى',style: TextStyle(fontSize: 23,color: white,fontFamily: 'AA-GALAXY')
          ,textAlign: TextAlign.center,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('هنا هتلاقى كل الى جبتيه فى جهازك',style: TextStyle(fontSize: 18,color: button,fontFamily: 'AA-GALAXY')
                  ,textAlign: TextAlign.center,),
              ),

            ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
                itemCount: Utils.MAIN_CATEGORIES_LIST.length,
                itemBuilder: (context,index){
                  return SingleDeviceWidget(category: Utils.MAIN_CATEGORIES_LIST[index],index: index,appUser: widget.appUser,);
                }),

          widget.appUser.additionalList.isNotEmpty ?
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ExpansionTile(
              title: Text('الاضافية', style: TextStyle(fontSize: 25, color: isCollapse ? black : white,
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
              BlocBuilder<UserCubit,UserState>(
                  builder: (BuildContext context, state) {
                    if (state is UserInitial){
                      return Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              widget.appUser.additionalList.isNotEmpty?
                              CheckDevice(devices: getSingleAdditionalList(widget.appUser.additionalList),) : const SizedBox(),
                            ],
                          ),
                        ],
                      );
                    }else if (state is UserLoaded){
                      return Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              state.appUser.additionalList.isNotEmpty?
                              CheckDevice(devices: getSingleAdditionalList(state.appUser.additionalList),) : const SizedBox(),
                            ],
                          ),
                        ],
                      );
                    }
                    else if(state is UserLoading){
                      return Center(child: SpinKitCircle(color: button,size: 35,),);
                    }
                    else if(state is UserLoadError){
                      return Center(child: Text('حدث خطأ فى تحميل البيانات!', style: TextStyle(
                          fontSize: 25, color: white, fontFamily: 'AA-GALAXY'),
                        textAlign: TextAlign.center,),);
                    }else{
                      return const SizedBox();
                    }
                  }
              ),
            ],
          ),
         ) : const SizedBox(),
          ],
        ),
      ),
    );
  }

  List<String> getSingleAdditionalList(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      furniture.add(device);
    }
    return furniture;
  }
}