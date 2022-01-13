import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_state.dart';
import 'package:alena/models/user.dart';
import 'package:alena/utils/constants.dart';
import 'package:alena/widgets/extended_devices/clothes_device.dart';
import 'package:alena/widgets/extended_devices/electric_device.dart';
import 'package:alena/widgets/extended_devices/house_device.dart';
import 'package:alena/widgets/extended_devices/kitchen_device.dart';
import 'package:alena/widgets/extended_devices/personal_device.dart';
import 'package:alena/widgets/helpers/check_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../utils/shared.dart';

class SingleDeviceWidget extends StatefulWidget {
  final String category;
  final int index;
  final AppUser appUser;

  const SingleDeviceWidget({Key key, this.category, this.index, this.appUser}) : super(key: key);
  @override
  _SingleDeviceWidgetState createState() => _SingleDeviceWidgetState();
}

class _SingleDeviceWidgetState extends State<SingleDeviceWidget> {
  bool isCollapse = false;
  int selectedRadio;

  @override
  Widget build(BuildContext context) {
    return widget.index == 1 ?
    ElectricDevice(index: widget.index,category: widget.category,appUser: widget.appUser,) :
    widget.index == 3 ?
    KitchenDevice(index: widget.index,category: widget.category,appUser: widget.appUser,) :
    widget.index == 7  ?
    PersonalDevice(index: widget.index,category: widget.category,appUser: widget.appUser,) :
    widget.index == 8  ?
    ClothesDevice(index: widget.index,category: widget.category,appUser: widget.appUser,) :
    widget.index == 9 ?
    HouseDevice(index: widget.index,category: widget.category,appUser: widget.appUser,)
        : Padding(
           padding: const EdgeInsets.all(10.0),
           child: ExpansionTile(
            title: Text('${widget.category}', style: TextStyle(fontSize: 25, color: isCollapse ? black : white,
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
                if(state is UserInitial){
                  return Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.index == 0 ? CheckDevice(devices: getSingleFurniture(widget.appUser.doneList),):

                          widget.index == 2 ? CheckDevice(devices: getSingleMafroshat(widget.appUser.doneList),):

                          widget.index == 4 ? CheckDevice(devices: getSingleAccessories(widget.appUser.doneList),):

                          widget.index == 5 ? CheckDevice(devices: getSinglePlastics(widget.appUser.doneList),):

                          CheckDevice(devices: getSingleCleaning(widget.appUser.doneList),),

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
                         widget.index == 0 ? CheckDevice(devices: getSingleFurniture(state.appUser.doneList),):

                         widget.index == 2 ? CheckDevice(devices: getSingleMafroshat(state.appUser.doneList),):

                         widget.index == 4 ? CheckDevice(devices: getSingleAccessories(state.appUser.doneList),):

                         widget.index == 5 ? CheckDevice(devices: getSinglePlastics(state.appUser.doneList),):

                         CheckDevice(devices: getSingleCleaning(state.appUser.doneList),),

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
                  return Container();
                }
              },
            ),

          ],
      ),
    );
  }

  List<String> getSingleFurniture(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.FURNITURE_LIST.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }

  List<String> getSingleMafroshat(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.MAFROSHAT_LIST.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }

  List<String> getSingleCleaning(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.CLEANING_STAFF_LIST.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }

  List<String> getSinglePlastics(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.PLASTICS_LIST.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }

  List<String> getSingleAccessories(List<dynamic> list) {
    List<String> furniture = [];
    for(String device in list){
      if(Utils.ACCESSORIES_LIST.contains(device)){
        furniture.add(device);
      }
    }
    return furniture;
  }

}