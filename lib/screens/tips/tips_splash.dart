import 'package:alena/screens/tips/tips_screen.dart';
import 'package:flutter/material.dart';
import '../../utils/shared.dart';

class TipsSplashScreen extends StatefulWidget {

  @override
  _TipsSplashScreenState createState() => _TipsSplashScreenState();
}

class _TipsSplashScreenState extends State<TipsSplashScreen> {
  @override
  void initState() {
    new Future.delayed(
        const Duration(seconds: 2),
            () =>  navigatorKey.currentState.pushReplacement(MaterialPageRoute(builder: (_) => TipsScreen()))
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Center(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: button,
            image: DecorationImage(
                image: AssetImage("assets/splash.png"),
                fit: BoxFit.cover
            )
        ),
      ),
    );
  }
}