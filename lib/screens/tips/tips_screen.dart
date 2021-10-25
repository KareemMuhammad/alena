import '../../utils/constants.dart';
import 'package:alena/main.dart';
import '../navigation/wrapper_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../../utils/shared.dart';

class TipsScreen extends StatefulWidget {
  @override
  _TipsScreenState createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  final List<String> images = ['assets/6.png','assets/5.png'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('علينا',style: TextStyle(fontSize: 60,color: button,fontFamily: 'AA-GALAXY')
                    ,textAlign: TextAlign.center,),
                ),

              SizedBox(
                height: SizeConfig.screenHeight * 0.8,
                child: IntroductionScreen(
                  dotsDecorator: DotsDecorator(color: container,activeColor: button),
                  pages: [
                    PageViewModel(
                      title: "",
                      bodyWidget: Container(
                        color: button,
                        padding: const EdgeInsets.fromLTRB(10,10,10,0),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('تجهيزات الجواز احنا عارفين انها كتير\n عشان كده قررنا نساعدك و نسهل عليكي شوية',
                                style: TextStyle(fontSize: 22,color: white,fontFamily: 'AA-GALAXY',letterSpacing: 2),textAlign: TextAlign.center,),
                            Image.asset(images[0],height: SizeConfig.screenHeight * 0.6,width: SizeConfig.screenWidth * 0.6,),
                          ],
                        ),
                      ),
                    ),
                    PageViewModel(
                        title: "",
                        bodyWidget: Column(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('هنا هتلاقي كل الحاجات اللي ممكن تتخيلي انك تحتاجيها في بيتك المستقبلي',
                                style: TextStyle(fontSize: 22,color: button,fontFamily: 'AA-GALAXY',letterSpacing: 2),textAlign: TextAlign.center,),
                            Image.asset('assets/gif1.gif',height: SizeConfig.screenHeight * 0.6,width: SizeConfig.screenWidth * 0.6,),
                          ],
                        ),
                    ),
                  ],
                  rtl: true,
                  onDone: () {
                      sharedPref.setBool(Utils.SHARED_KEY, true);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> WrapperScreen()));
                  },
                  next: Text('التالى',style: TextStyle(fontSize: 22,color: button,fontFamily: 'AA-GALAXY')
                    ,textAlign: TextAlign.center,),
                  showNextButton: true,
                  showSkipButton: true,
                  skip: Text('تخطى',style: TextStyle(fontSize: 22,color: button,fontFamily: 'AA-GALAXY')
                    ,textAlign: TextAlign.center,),
                  done: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: button
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('يلا بينا',style: TextStyle(letterSpacing: 1,fontSize: 22,color: white,fontFamily: 'AA-GALAXY'),
                          textAlign: TextAlign.center,),
                    ),
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
    );
  }
}
