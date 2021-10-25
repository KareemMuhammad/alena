import 'package:alena/models/user.dart';
import 'package:alena/widgets/extended_devices/main_device.dart';
import '../../utils/constants.dart';
import '../../utils/shared.dart';
import 'package:flutter/material.dart';

class MyDevicesScreen extends StatefulWidget {
  final AppUser appUser;

  const MyDevicesScreen({Key key, this.appUser}) : super(key: key);
  @override
  _MyDevicesScreenState createState() => _MyDevicesScreenState();
}

class _MyDevicesScreenState extends State<MyDevicesScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: button,
        title: Text('جهازى',style: TextStyle(fontSize: 30,color: white,fontFamily: 'AA-GALAXY')
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
          ],
        ),
      ),
    );
  }
}