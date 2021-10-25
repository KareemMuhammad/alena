import 'package:alena/database/auth_bloc/auth_cubit.dart';
import 'package:alena/database/auth_bloc/auth_state.dart';
import 'splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../authentication/reset_password.dart';
import '../authentication/sign_in.dart';
import '../authentication/sign_up.dart';
import 'home.dart';

class WrapperScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit,AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return SplashScreen();
        }else if (state is AuthFailure){
          return SignInAlena();
        }else if (state is AuthSuccessful){
          return HomeScreen(appUser: state.appUser);
        }else if (state is AuthRegistration){
          return SignUpAlena();
        }else if (state is AuthPasswordReset){
          return PasswordReset();
        }
      },
    );
  }
}
