import 'package:alena/database/auth_bloc/auth_cubit.dart';
import 'package:alena/database/auth_bloc/auth_state.dart';
import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_state.dart';
import '../../widgets/helpers/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/constants.dart';
import '../../utils/shared.dart';

class PasswordReset extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  TextEditingController emailController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: white,
          image: DecorationImage(
              image: AssetImage("assets/app-screen.png"),
              fit: BoxFit.cover
          )
      ),
      child: BlocListener<UserCubit,UserState>(
          listener: (ctx,state){
            if(state is UserPasswordReset){
              Utils.showToast('${emailController.text}الرسالة اتبعتت ل');
              Future.delayed(const Duration(seconds: 1),() => BlocProvider.of<AuthCubit>(context).emit(AuthFailure()));
            }
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: bar,
              title: Text('استعادة كلمة السر',style: TextStyle(fontSize: 30,color: black,
                  fontFamily: 'AA-GALAXY'),),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: black,
                onPressed: (){
                  BlocProvider.of<AuthCubit>(context).emit(AuthFailure());
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text('مفيش مشكلة اكتب بريدك الالكترونى و هنبعتلك رسالة عشان تغير كلمة السر'
                      ,style: TextStyle(color: Colors.black54,fontSize: 19,fontFamily: 'AA-GALAXY'),textAlign: TextAlign.center,),
                  ),
                  SizedBox(height: 40,),
                  Form(
                      key: formKey,
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                          child: TextFormField(
                            style: TextStyle(color: black,fontSize: 18,),
                            decoration: textInputDecorationSign('البريد الالكترونى',Icons.email),
                            controller: emailController,
                            validator: (val){
                              return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)
                                  ? null : 'من فضلك ادخل بريد الكترونى صحيح';
                            },
                          )
                      ),
                  ),
                  SizedBox(height: 40,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30,vertical: 1),
                    child: Material(
                      borderRadius: BorderRadius.circular(10.0),
                      color: button,
                      elevation: 2,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        onPressed: () async{
                          if(formKey.currentState.validate()){
                            BlocProvider.of<UserCubit>(context).resetPassword(emailController.text);
                          }
                        },
                        child: Text('ارسال',style: TextStyle(fontSize: 22,color: white,
                            fontFamily: 'AA-GALAXY'),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
