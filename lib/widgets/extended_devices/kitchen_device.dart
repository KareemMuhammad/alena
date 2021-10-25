import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_state.dart';
import 'package:alena/models/user.dart';
import 'package:alena/widgets/helpers/check_device.dart';
import '../../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../utils/shared.dart';

class KitchenDevice extends StatefulWidget {
  final String category;
  final AppUser appUser;
  final int index;

  const KitchenDevice({Key key, this.category, this.index, this.appUser}) : super(key: key);
  @override
  _KitchenDeviceState createState() => _KitchenDeviceState();
}

class _KitchenDeviceState extends State<KitchenDevice> {
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
          ...(Utils.KITCHEN_DEVICES).map((device) {
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
                              device == Utils.KITCHEN_DEVICES[0] ? CheckDevice(devices: getFirstKitchen(widget.appUser.doneList),):

                              device == Utils.KITCHEN_DEVICES[1] ? CheckDevice(devices: getSecondKitchen(widget.appUser.doneList),):

                              device == Utils.KITCHEN_DEVICES[2] ? CheckDevice(devices: getThirdKitchen(widget.appUser.doneList),):

                              device == Utils.KITCHEN_DEVICES[3] ? CheckDevice(devices: getFourthKitchen(widget.appUser.doneList),):

                              device == Utils.KITCHEN_DEVICES[4] ? CheckDevice(devices: getFifthKitchen(widget.appUser.doneList),):

                              device == Utils.KITCHEN_DEVICES[5] ? CheckDevice(devices: getSixthKitchen(widget.appUser.doneList),):

                              CheckDevice(devices: getSeventhKitchen(widget.appUser.doneList),)
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
                              device == Utils.KITCHEN_DEVICES[0] ? CheckDevice(devices: getFirstKitchen(state.appUser.doneList),):

                              device == Utils.KITCHEN_DEVICES[1] ? CheckDevice(devices: getSecondKitchen(state.appUser.doneList),):

                              device == Utils.KITCHEN_DEVICES[2] ? CheckDevice(devices: getThirdKitchen(state.appUser.doneList),):

                              device == Utils.KITCHEN_DEVICES[3] ? CheckDevice(devices: getFourthKitchen(state.appUser.doneList),):

                              device == Utils.KITCHEN_DEVICES[4] ? CheckDevice(devices: getFifthKitchen(state.appUser.doneList),):

                              device == Utils.KITCHEN_DEVICES[5] ? CheckDevice(devices: getSixthKitchen(state.appUser.doneList),):

                              CheckDevice(devices: getSeventhKitchen(state.appUser.doneList),)
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

  List<String> getFirstKitchen(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.KITCHEN_DISTRIBUTION.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }

  List<String> getSecondKitchen(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.KITCHEN_AWANY.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }

  List<String> getThirdKitchen(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.KITCHEN_SAWANY.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }
  List<String> getFourthKitchen(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.KITCHEN_DISHES.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }

  List<String> getFifthKitchen(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.KITCHEN_DRINKS.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }

  List<String> getSixthKitchen(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.KITCHEN_PROVIDERS.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }

  List<String> getSeventhKitchen(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.KITCHEN_TOOLS.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }

}