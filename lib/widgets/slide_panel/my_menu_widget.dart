import '../../utils/constants.dart';
import '../../utils/shared.dart';
import 'package:alena/widgets/slide_panel/single_menu_widget.dart';
import 'package:flutter/material.dart';

class MyMenuWidget extends StatefulWidget {
  @override
  _MyMenuWidgetState createState() => _MyMenuWidgetState();
}

class _MyMenuWidgetState extends State<MyMenuWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 70,
        backgroundColor: white,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('قائمتى',style: TextStyle(fontSize: 30,color: button,fontFamily: 'AA-GALAXY')
                ,textAlign: TextAlign.center,),
              Image.asset('assets/arrow-down.png',height: 25,width: 25,),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
                  itemCount: Utils.MAIN_CATEGORIES_LIST.length,
                  itemBuilder: (context,index){
                    return SingleMenuWidget(category: Utils.MAIN_CATEGORIES_LIST[index],index: index);
                  }),
      ),
    );
  }
}
