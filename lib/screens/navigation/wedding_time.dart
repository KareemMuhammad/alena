import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_state.dart';
import '../categories/main_categories.dart';
import '../../widgets/helpers/shared_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../../utils/shared.dart';

class WeddingDate extends StatefulWidget {
  @override
  _WeddingDateState createState() => _WeddingDateState();
}

class _WeddingDateState extends State<WeddingDate> {
  String dateTime = '';
  DateTime notificationDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      backgroundColor: white,
      body: Column(
         children: [
           const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('معاد فرحك امتى؟',style: TextStyle(fontSize: 40,color: button,fontFamily: 'AA-GALAXY')
                ,textAlign: TextAlign.center,),
            ),
            dateTime.isNotEmpty ?
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: white
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text('${dateTime.split(' ')[0]}',style: TextStyle(fontSize: 30,color: button,fontFamily: 'AA-GALAXY')
                        ,textAlign: TextAlign.center,),
                      Text('${dateTime.split(' ')[1]}',style: TextStyle(fontSize: 30,color: button,fontFamily: 'AA-GALAXY')
                        ,textAlign: TextAlign.center,),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      dateTime = '';
                    });
                  },
                  child: CircleAvatar(
                      backgroundColor: button,
                      radius: 18,
                      child: Icon(Icons.close,size: 25,color: white,)
                  ),),
              ],
            )
            :Padding(
              padding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: button,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: MaterialButton(
                  onPressed: () async{
                    DatePicker.showDateTimePicker(context,
                        theme: DatePickerTheme(backgroundColor: white, itemStyle: TextStyle(color: black),
                            doneStyle: TextStyle(color: button,fontSize: 17)),
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2050, 12, 30),
                        onConfirm: (date) {
                          setState(() {
                            notificationDate = date;
                            dateTime = date.toLocal().toString().split('.000')[0];
                          });
                        },
                        currentTime: DateTime.now(),
                        locale: LocaleType.ar);
                  },
                  child: Text('اختارى',style: TextStyle(fontSize: 25,color: white,fontFamily: 'AA-GALAXY'),),
                ),
              ),
            ),
            BlocConsumer<UserCubit,UserState>(
              builder: (ctx,state){
                return state is UserLoading ? spinKit
                : Padding(
                  padding: const EdgeInsets.all(10),
                  child: RaisedButton(
                    color: white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 2,
                    onPressed: () {
                      if(dateTime.isNotEmpty) {
                        BlocProvider.of<UserCubit>(context).updateDateOfWedding(dateTime);
                        Utils.showScheduleNotification(notificationDate);
                      }else{
                        Utils.showToast('اختار معاد فرحك عشان تكمل!');
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('تأكيد',style: TextStyle(letterSpacing: 1,fontSize: 35,color: button,
                          fontFamily: 'AA-GALAXY'),
                        textAlign: TextAlign.center,),
                    ),
                  ),
                );
              },
              listener: (ctx,state){
                if(state is UserLoaded){
                  navigatorKey.currentState.pushReplacement(MaterialPageRoute(builder: (_) => MainCategories()));
                }
              },
            ),
          ],
        ),
    );
  }
}
