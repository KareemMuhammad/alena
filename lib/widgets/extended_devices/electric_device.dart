import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_state.dart';
import 'package:alena/models/user.dart';
import 'package:alena/widgets/helpers/check_device.dart';
import '../../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../utils/shared.dart';

class ElectricDevice extends StatefulWidget {
  final String category;
  final int index;
  final AppUser appUser;

  const ElectricDevice({Key key, this.category, this.index, this.appUser}) : super(key: key);
  @override
  _ElectricDeviceState createState() => _ElectricDeviceState();
}

class _ElectricDeviceState extends State<ElectricDevice> {
  bool isCollapse = false;
  bool isCollapseExtend = false;

  @override
  Widget build(BuildContext context) {

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
          ...(Utils.ELECTRIC_DEVICES).map((device) {
            return ExpansionTile(
              title: Text(device, style: TextStyle(fontSize: 22, color: isCollapseExtend ? black : white,
                  fontFamily: 'AA-GALAXY'), textAlign: TextAlign.center,),
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
                BlocBuilder<UserCubit,UserState>(
                  builder: (BuildContext context, state) {
                    if(state is UserInitial){
                      return Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              device == Utils.ELECTRIC_DEVICES[0] ? CheckDevice(devices: getFirstElectric(widget.appUser.doneList),):

                              device == Utils.ELECTRIC_DEVICES[1] ? CheckDevice(devices: getSecondElectric(widget.appUser.doneList),):

                              CheckDevice(devices: getThirdElectric(widget.appUser.doneList),)
                            ],
                          ),
                        ],
                      );
                    }
                    else if(state is UserLoaded){
                      return Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                             device == Utils.ELECTRIC_DEVICES[0] ? CheckDevice(devices: getFirstElectric(state.appUser.doneList),):

                             device == Utils.ELECTRIC_DEVICES[1] ? CheckDevice(devices: getSecondElectric(state.appUser.doneList),):

                             CheckDevice(devices: getThirdElectric(state.appUser.doneList),)
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

  List<String> getFirstElectric(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.MAIN_ELECTRIC_DEVICES.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }

  List<String> getSecondElectric(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.ADDITIONAL_ELECTRIC_DEVICES.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }

  List<String> getThirdElectric(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.ELECTRIC_SMALL_KITCHEN_DEV.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }

}