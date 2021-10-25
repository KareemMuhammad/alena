import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_state.dart';
import 'package:alena/models/user.dart';
import 'package:alena/widgets/helpers/check_device.dart';
import '../../utils/constants.dart';
import '../../utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HouseDevice extends StatefulWidget {
  final String category;
  final int index;
  final AppUser appUser;

  const HouseDevice({Key key, this.category, this.index, this.appUser}) : super(key: key);
  @override
  _HouseDeviceState createState() => _HouseDeviceState();
}

class _HouseDeviceState extends State<HouseDevice> {
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
          ...(Utils.HOUSE_LIST).map((device) {
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
                BlocBuilder<UserCubit,UserState>(
                  builder: (BuildContext context, state) {
                    if(state is UserInitial){
                      return Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              device == Utils.HOUSE_LIST[0] ? CheckDevice(devices: getFirstHouse(widget.appUser.doneList),):

                              CheckDevice(devices: getSecondHouse(widget.appUser.doneList),)
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
                              device == Utils.HOUSE_LIST[0] ? CheckDevice(devices: getFirstHouse(state.appUser.doneList),):

                              CheckDevice(devices: getSecondHouse(state.appUser.doneList),)
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

  List<String> getFirstHouse(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.HOUSE_LIST_CLEANING.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }

  List<String> getSecondHouse(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.HOUSE_LIST_STORE.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }

}