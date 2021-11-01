import 'package:alena/utils/shared.dart';
import 'package:flutter/material.dart';

class NominationScreen extends StatefulWidget {
  final String title;

  const NominationScreen({Key key, this.title}) : super(key: key);
  @override
  _NominationScreenState createState() => _NominationScreenState();
}

class _NominationScreenState extends State<NominationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: button,
        elevation: 2,
        title: Text('${widget.title}',style: TextStyle(fontSize: 27,color: white,fontFamily: 'AA-GALAXY')
          ,textAlign: TextAlign.center,),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}
