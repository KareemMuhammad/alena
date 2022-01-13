import 'package:alena/database/auth_bloc/auth_cubit.dart';
import 'package:alena/database/auth_bloc/auth_state.dart';
import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_state.dart';
import 'package:alena/utils/constants.dart';
import '../../database/blocs/reg_bloc/reg_cubit.dart';
import '../../database/blocs/reg_bloc/reg_state.dart';
import '../../widgets/helpers/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/shared.dart';

class SignUpAlena extends StatefulWidget {
  @override
  _SignUpAlenaState createState() => _SignUpAlenaState();
}

class _SignUpAlenaState extends State<SignUpAlena> {
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController confirmPasswordController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  String _userNotFound = 'البريد الالكترونى موجود بالفعل';
  String _name;
  bool isUnCover = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: white,
            image: DecorationImage(
                image: AssetImage("assets/app-screen.png"),
                fit: BoxFit.cover,
            )
        ),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: bar,
            leading: IconButton(
              color: black,
              iconSize: 25,
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                BlocProvider.of<AuthCubit>(context).emit(AuthFailure());
              },
            ),
            title: Text('سجل مستخدم جديد',style: TextStyle(fontSize: 25,color: black,
                fontFamily: 'AA-GALAXY'),),
          ),
          backgroundColor: Colors.transparent,
          body: BlocConsumer<RegCubit,RegState>(
              listener: (ctx,state){
                if(state is RegUserLoaded){
                  BlocProvider.of<UserCubit>(context).emit(UserLoaded(state.appUser));
                  BlocProvider.of<AuthCubit>(context).emit(AuthSuccessful(state.appUser));
                }
              },
              builder: (ctx,state){
                if( state is RegInitial ){
                  return initialUi(state);
                }else if( state is RegLoading ){
                  return spinKit;
                }else if( state is RegLoadError ){
                  return failureUi(state);
                }else {
                  return Container();
                }
              },
            ),
      ),
    );
  }

  Widget initialUi(RegState state){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40,),
          Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
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
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                      child: TextFormField(
                        style: TextStyle(color: black,fontSize: 18,),
                        textDirection: Utils.isRTL(_name.isNotEmpty ? _name : nameController.text) ? TextDirection.rtl : TextDirection.ltr,
                        onChanged: (value){
                          setState(() {
                            _name = value;
                          });
                        },
                        decoration: textInputDecorationSign('اسم المستخدم',Icons.person),
                        controller: nameController,
                        validator: (val){
                          return val.isNotEmpty ? null : 'من فضلك ادخل اسم المستخدم';
                        },
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                    child: TextFormField(
                      style: TextStyle(color: black,fontSize: 18,),
                      decoration: customDecore('كلمة المرور'),
                      controller: passwordController,
                      obscureText: isUnCover ? false : true,
                      validator: (val) {
                        return val.isEmpty || val.length < 6 ? 'كلمة مرور خاطئة' : null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                    child: TextFormField(
                      style: TextStyle(color: black,fontSize: 18,),
                      decoration: customDecore('تأكيد كلمة المرور'),
                      controller: confirmPasswordController,
                      obscureText: isUnCover ? false : true,
                      validator: (val) {
                        return val.isEmpty || val != passwordController.text ? 'كلمة مرور غير متشابهة' : null;
                      },
                    ),
                  ),

                ],
              )
          ),
          const SizedBox(height: 30,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30,vertical: 1),
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              color: button,
              elevation: 2,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                onPressed: () async{
                  if(formKey.currentState.validate()) {
                    BlocProvider.of<RegCubit>(context).signUpUserWithEmailPass(
                        emailController.text, passwordController.text,'',nameController.text);
                  }
                },
                child: Text('تسجيل',style: TextStyle(fontSize: 22,color: white,
                    fontFamily: 'AA-GALAXY'),),
              ),
            ),
          ),
          const SizedBox(height: 40,),
          InkWell(
            onTap: (){
              BlocProvider.of<AuthCubit>(context).emit(AuthFailure());
            },
            child: RichText(textAlign: TextAlign.center,
              text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'لديك حساب',
                        style: TextStyle(color: black,fontSize: 22,fontFamily: 'AA-GALAXY')
                    ),
                    TextSpan(
                        text: '   سجل الدخول',
                        style: TextStyle(color: Colors.grey[700],fontSize: 22,fontFamily: 'AA-GALAXY'
                            ,decoration: TextDecoration.underline)
                    ),
                  ]),
            ),
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }

  Widget failureUi(RegState state){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40,),
          Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
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
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                      child: TextFormField(
                        style: TextStyle(color: black,fontSize: 18,),
                        decoration: textInputDecorationSign('اسم المستخدم',Icons.person),
                        controller: nameController,
                        validator: (val){
                          return val.isNotEmpty ? null : 'من فضلك ادخل اسم المستخدم';
                        },
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                    child: TextFormField(
                      style: TextStyle(color: black,fontSize: 18,),
                      decoration: customDecore('كلمة المرور'),
                      controller: passwordController,
                      obscureText: isUnCover ? false : true,
                      validator: (val) {
                        return val.isEmpty || val.length < 6 ? 'كلمة مرور خاطئة' : null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                    child: TextFormField(
                      style: TextStyle(color: black,fontSize: 18,),
                      decoration: customDecore('تأكيد كلمة المرور'),
                      controller: confirmPasswordController,
                      obscureText: isUnCover ? false : true,
                      validator: (val) {
                        return val.isEmpty || val != passwordController.text ? 'كلمة مرور غير متشابهة' : null;
                      },
                    ),
                  ),
                ],
              )
          ),
          Text(_userNotFound, style: TextStyle(color: Colors.red[700], fontSize: 17.0),),
          const SizedBox(height: 30,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30,vertical: 1),
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              color: button,
              elevation: 2,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                onPressed: () async{
                  if(formKey.currentState.validate()) {
                    BlocProvider.of<RegCubit>(context).signUpUserWithEmailPass(
                        emailController.text, passwordController.text,'',nameController.text);
                  }
                },
                child: Text('تسجيل',style: TextStyle(fontSize: 22,color: white,
                    fontFamily: 'AA-GALAXY'),),
              ),
            ),
          ),
          const SizedBox(height: 40,),
          InkWell(
            onTap: (){
              BlocProvider.of<AuthCubit>(context).emit(AuthFailure());
            },
            child: RichText(textAlign: TextAlign.center,
              text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'لديك حساب',
                        style: TextStyle(color: black,fontSize: 22,fontFamily: 'AA-GALAXY')
                    ),
                    TextSpan(
                        text: '   سجل الدخول',
                        style: TextStyle(color: Colors.grey[700],fontSize: 22,fontFamily: 'AA-GALAXY'
                            ,decoration: TextDecoration.underline)
                    ),
                  ]),
            ),
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }

  InputDecoration customDecore(String hint){
    return InputDecoration(
      filled: true,
      fillColor: white,
      hintTextDirection: TextDirection.rtl,
      hintText: hint,
      hintStyle: TextStyle(fontSize: 18,color: button,fontFamily: 'AA-GALAXY'),
      border: InputBorder.none,
      errorStyle: TextStyle(color: Colors.grey[700],fontSize: 16),
      contentPadding: EdgeInsets.all(8),
      prefixIcon: IconButton(
        icon: Icon(isUnCover ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,size: 20,color: container,),
        onPressed: (){
          setState(() {
            isUnCover = !isUnCover;
          });
        },
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: white, width: 2.0),
          borderRadius: BorderRadius.circular(20)
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: white, width: 2.0),
          borderRadius: BorderRadius.circular(20)
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

}
