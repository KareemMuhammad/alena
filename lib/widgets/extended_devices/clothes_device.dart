import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_state.dart';
import 'package:alena/models/user.dart';
import 'package:alena/widgets/helpers/check_device.dart';
import '../../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../utils/shared.dart';

class ClothesDevice extends StatefulWidget {
  final String category;
  final int index;
  final AppUser appUser;

  const ClothesDevice({Key key, this.category, this.index, this.appUser}) : super(key: key);
  @override
  _ClothesDeviceState createState() => _ClothesDeviceState();
}

class _ClothesDeviceState extends State<ClothesDevice> {
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
                BlocBuilder<UserCubit,UserState>(
                  builder: (BuildContext context, state) {
                    if(state is UserInitial){
                      return Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              device == Utils.CLOTHES[0] ? CheckDevice(devices: getFirstClothes(widget.appUser.doneList),):

                              device == Utils.CLOTHES[1] ? CheckDevice(devices: getSecondClothes(widget.appUser.doneList),):

                              device == Utils.CLOTHES[2] ? CheckDevice(devices: getThirdClothes(widget.appUser.doneList),):

                              CheckDevice(devices: getFourthClothes(widget.appUser.doneList),)
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
                              device == Utils.CLOTHES[0] ? CheckDevice(devices: getFirstClothes(state.appUser.doneList),):

                              device == Utils.CLOTHES[1] ? CheckDevice(devices: getSecondClothes(state.appUser.doneList),):

                              device == Utils.CLOTHES[2] ? CheckDevice(devices: getThirdClothes(state.appUser.doneList),):

                              CheckDevice(devices: getFourthClothes(state.appUser.doneList),)
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

  List<String> getFirstClothes(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.CLOTHES_OUTING.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }

  List<String> getSecondClothes(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.CLOTHES_HOME.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }

  List<String> getThirdClothes(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.CLOTHES_LANGERY.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }
  List<String> getFourthClothes(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.CLOTHES_TOOLS.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }

}