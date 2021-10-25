import 'package:alena/database/auth_bloc/auth_cubit.dart';
import 'package:alena/database/auth_bloc/auth_state.dart';
import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/helpers/shared_widgets.dart';
import 'package:flutter/material.dart';
import '../../utils/shared.dart';

class SignInAlena extends StatefulWidget {
  @override
  _SignInAlenaState createState() => _SignInAlenaState();
}

class _SignInAlenaState extends State<SignInAlena> {
  final TextEditingController emailController = new TextEditingController();

  final TextEditingController passwordController = new TextEditingController();

  final formKey = GlobalKey<FormState>();

  String userNotFound = 'البريد الالكترونى او كلمة السر غير صحيحة!';

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
          backgroundColor: Colors.transparent,
            body: BlocConsumer<UserCubit,UserState>(
                builder: (context, state) {
                  return loginScreen(state);
                },
                listener: (ctx,state){
                  if(state is UserLoaded){
                    BlocProvider.of<AuthCubit>(context).emit(AuthSuccessful(state.appUser));
                  }
                },
              ),
      ),
    );
  }

  Widget loginScreen(UserState state){
      if( state is UserInitial ){
        return initialUi(state);
      }else if( state is UserLoading ){
        return spinKit;
      }else if( state is UserLoadError ){
        return failureUi(state);
      }else if(state is UserLoaded){
        return Container();
      }else if(state is UserPasswordReset){
        return initialUi(state);
      }
  }

  Widget failureUi(UserState state){
   return SingleChildScrollView(
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.center,
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         const SizedBox(height: 100,),
         Text('تسجيل الدخول',style: TextStyle(fontSize: 30,color: black,
             fontFamily: 'AA-GALAXY'),),
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
                     decoration: textInputDecorationSign('كلمة المرور',Icons.lock),
                     controller: passwordController,
                     obscureText: true,
                     validator: (val) {
                       return val.isEmpty || val.length < 6 ? 'كلمة مرور ضعيفة' : null;
                     },
                   ),
                 ),
               ],
             )
         ),
         Align(
           alignment: Alignment.centerRight,
           child: InkWell(
               onTap: (){
                 BlocProvider.of<AuthCubit>(context).emit(AuthPasswordReset());
               },
               child: Padding(
                 padding: EdgeInsets.symmetric(horizontal: 18,vertical: 5),
                 child: Text('نسيت كلمة المرور',style: TextStyle(color: black,fontSize: 19,
                     decoration: TextDecoration.underline),),
               )
           ),
         ),
         Text(userNotFound, style: TextStyle(color: Colors.red[700], fontSize: 17.0),),
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
                 if(formKey.currentState.validate()){
                   BlocProvider.of<UserCubit>(context).signInEmailAndPassword(emailController.text, passwordController.text);
                 }
               },
               child: Text('دخول',style: TextStyle(fontSize: 22,color: white,
                   fontFamily: 'AA-GALAXY'),),
             ),
           ),
         ),
         const SizedBox(height: 25,),
         Text('أو عن طريق',style: TextStyle(fontSize: 22,color: black,
             fontFamily: 'AA-GALAXY'),),
         const SizedBox(height: 15,),
         Row(mainAxisAlignment: MainAxisAlignment.center,
           children: [
             InkWell(
                 onTap: ()async{
                   BlocProvider.of<UserCubit>(context).signUpGoogle();
                 },
                 child:Image.asset('assets/google.png',height: 50,width: 50,)
             ),
             const SizedBox(width: 15,),
             Padding(
               padding: EdgeInsets.symmetric(horizontal: 18,vertical: 5),
               child: Text('أو',style: TextStyle(color: black,fontSize: 22,
                   fontFamily: 'AA-GALAXY'),),
             ),
             const SizedBox(width: 15,),
             InkWell(
                 onTap: ()async{
                   BlocProvider.of<UserCubit>(context).signUpFacebook();
                 },
                 child: Image.asset('assets/facebook.png',height: 50,width: 50,)
             ),
           ],
         ),
         const SizedBox(height: 40,),
         InkWell(
           onTap: (){
             BlocProvider.of<AuthCubit>(context).emit(AuthRegistration());
           },
           child: RichText(textAlign: TextAlign.center,
             text: TextSpan(
                 children: [
                   TextSpan(
                       text: ' مستخدم جديد',
                       style: TextStyle(color: black,fontSize: 22,fontFamily: 'AA-GALAXY')
                   ),
                   TextSpan(
                       text: '  سجل الان',
                       style: TextStyle(color: Colors.grey[700],fontSize: 22,fontFamily: 'AA-GALAXY'
                           ,decoration: TextDecoration.underline)
                   ),
                 ]),
           ),
         ),
         const SizedBox(height: 15,),
       ],
     ),
   );
  }

  Widget initialUi(UserState state){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100,),
          Text('تسجيل الدخول',style: TextStyle(fontSize: 30,color: black,
              fontFamily: 'AA-GALAXY'),),
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
                      decoration: textInputDecorationSign('كلمة المرور',Icons.lock),
                      controller: passwordController,
                      obscureText: true,
                      validator: (val) {
                        return val.isEmpty || val.length < 6 ? 'كلمة مرور ضعيفة' : null;
                      },
                    ),
                  ),
                ],
              )
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
                onTap: (){
                  BlocProvider.of<AuthCubit>(context).emit(AuthPasswordReset());
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18,vertical: 5),
                  child: Text('نسيت كلمة المرور',style: TextStyle(color: black,fontSize: 19,
                      decoration: TextDecoration.underline),),
                )
            ),
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
                  if(formKey.currentState.validate()){
                    BlocProvider.of<UserCubit>(context).signInEmailAndPassword(emailController.text, passwordController.text);
                  }
                },
                child: Text('دخول',style: TextStyle(fontSize: 22,color: white,
                    fontFamily: 'AA-GALAXY'),),
              ),
            ),
          ),
          const SizedBox(height: 25,),
          Text('أو عن طريق',style: TextStyle(fontSize: 22,color: black,
              fontFamily: 'AA-GALAXY'),),
          const SizedBox(height: 15,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: ()async{
                    BlocProvider.of<UserCubit>(context).signUpGoogle();
                  },
                  child:Image.asset('assets/google.png',height: 50,width: 50,)
              ),
              const SizedBox(width: 15,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18,vertical: 5),
                child: Text('أو',style: TextStyle(color: black,fontSize: 22,
                    fontFamily: 'AA-GALAXY'),),
              ),
              const SizedBox(width: 15,),
              InkWell(
                  onTap: ()async{
                    BlocProvider.of<UserCubit>(context).signUpFacebook();
                  },
                  child: Image.asset('assets/facebook.png',height: 50,width: 50,)
              ),
            ],
          ),
          const SizedBox(height: 40,),
          InkWell(
            onTap: (){
              BlocProvider.of<AuthCubit>(context).emit(AuthRegistration());
            },
            child: RichText(textAlign: TextAlign.center,
              text: TextSpan(
                  children: [
                    TextSpan(
                        text: ' مستخدم جديد',
                        style: TextStyle(color: black,fontSize: 22,fontFamily: 'AA-GALAXY')
                    ),
                    TextSpan(
                        text: '  سجل الان',
                        style: TextStyle(color: Colors.grey[700],fontSize: 22,fontFamily: 'AA-GALAXY'
                            ,decoration: TextDecoration.underline)
                    ),
                  ]),
            ),
          ),
          const SizedBox(height: 15,),
        ],
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
