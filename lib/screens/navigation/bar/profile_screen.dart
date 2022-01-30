import 'package:alena/database/auth_bloc/auth_cubit.dart';
import 'package:alena/database/blocs/reg_bloc/reg_cubit.dart';
import 'package:alena/database/blocs/reg_bloc/reg_state.dart';
import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_state.dart';
import 'package:alena/models/user.dart';
import 'package:alena/screens/navigation/bar/my_orders_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'edit_info.dart';
import '../../../widgets/helpers/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/shared.dart';

class ProfileScreen extends StatelessWidget {
  final AppUser appUser;

  const ProfileScreen({Key key, this.appUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: button,
        elevation: 2,
        title: Text('الملف الشخصى',style: TextStyle(fontSize: 22,color: white,fontFamily: 'AA-GALAXY')
          ,textAlign: TextAlign.center,),
      ),
      body: BlocBuilder<UserCubit,UserState>(
        builder: (BuildContext context, state) {
          if(state is UserInitial){
           return SingleChildScrollView(
             child: Column(
                children: [
                  const SizedBox(height: 40,),
                  _customWidget('الاسم', appUser.name,0,appUser),
                  _customWidget('البريد الالكترونى', appUser.email,1,appUser),
                  GestureDetector(
                    onTap: (){
                      navigatorKey.currentState.push(MaterialPageRoute(builder: (_) => MyOrdersScreen()));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(13.0),
                      padding: const EdgeInsets.all(13.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: button,
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(AntDesign.inbox,color: white,size: 25,),
                            const SizedBox(width: 8,),
                            Text('طلباتى',style: TextStyle(color: white,fontSize: 21,fontFamily: 'AA-GALAXY'),)
                          ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      BlocProvider.of<AuthCubit>(context).signOut();
                      BlocProvider.of<UserCubit>(context).emit(UserInitial());
                      BlocProvider.of<RegCubit>(context).emit(RegInitial());
                    },
                    child: Container(
                      margin: const EdgeInsets.all(13.0),
                      padding: const EdgeInsets.all(13.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: button,
                      ),
                      child:  Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout,color: white,size: 20,),
                            const SizedBox(width: 5,),
                            Text('تسجيل خروج',style: TextStyle(color: white,fontSize: 18,fontFamily: 'AA-GALAXY'),)
                          ],
                        ),
                    ),
                  ),
                ],
              ),
           );
          }
          if(state is UserLoaded){
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40,),
                  _customWidget('الاسم', state.appUser.name,0,state.appUser),
                  _customWidget('البريد الالكترونى', state.appUser.email,1,state.appUser),
                  GestureDetector(
                    onTap: (){
                      navigatorKey.currentState.push(MaterialPageRoute(builder: (_) => MyOrdersScreen()));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(13.0),
                      padding: const EdgeInsets.all(13.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: button,
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(AntDesign.inbox,color: white,size: 25,),
                            const SizedBox(width: 8,),
                            Text('طلباتى',style: TextStyle(color: white,fontSize: 21,fontFamily: 'AA-GALAXY'),)
                          ],
                        ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      BlocProvider.of<AuthCubit>(context).signOut();
                      BlocProvider.of<UserCubit>(context).emit(UserInitial());
                      BlocProvider.of<RegCubit>(context).emit(RegInitial());
                    },
                    child: Container(
                      margin: const EdgeInsets.all(13.0),
                      padding: const EdgeInsets.all(13.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: button,
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout,color: white,size: 20,),
                            const SizedBox(width: 5,),
                            Text('تسجيل خروج',style: TextStyle(color: white,fontSize: 18,fontFamily: 'AA-GALAXY'),)
                          ],
                        ),
                    ),
                  ),
                ],
              ),
            );
          }else if(state is UserLoading){
            return spinKit;
          }else if(state is UserLoadError){
            return Center(
              child: Text('حدث خطأ فى جلب البيانات',style: TextStyle(fontSize: 20,color: black,fontFamily: 'AA-GALAXY')
                ,textAlign: TextAlign.center,),
            );
          }else{
            return Container();
          }
        },
      ),
    );
  }

  Widget _customWidget(String title,String info,int load,AppUser appUser){
    return GestureDetector(
      onTap: (){
        navigatorKey.currentState.push(MaterialPageRoute(builder: (_) => EditInfoScreen(load: load,title: title,appUser: appUser,)));
      },
      child: Container(
        margin: const EdgeInsets.all(13.0),
        padding: const EdgeInsets.all(13.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: button,
        ),
        child: Row(
            children: [
              Icon(Icons.arrow_back_ios,color: white,size: 20,),
              const SizedBox(width: 10,),
              Expanded(child: Text(info,style: TextStyle(color: white,fontSize: 17,fontFamily: 'AA-GALAXY'),
                maxLines: 1,overflow: TextOverflow.ellipsis,)),
              const Spacer(),
              Text(title,style: TextStyle(color: white,fontSize: 18,fontFamily: 'AA-GALAXY'),)
            ],
          ),
      ),
    );
  }
}
