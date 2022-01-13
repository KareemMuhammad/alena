import 'dart:ui';
import 'package:alena/screens/navigation/products_nav/vendors_screen.dart';
import 'package:alena/utils/constants.dart';
import 'package:alena/utils/shared.dart';
import 'package:flutter/material.dart';

class NominationsScreen extends StatefulWidget {
  final List<String> list;
  final String category;
  final int index;

  const NominationsScreen({Key key, this.list, this.category, this.index}) : super(key: key);
  @override
  _NominationsScreenState createState() => _NominationsScreenState();
}

class _NominationsScreenState extends State<NominationsScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(alignment: Alignment.center,
        children: [
          Positioned.fill(child: Image.asset(Utils.SUB_CATEGORIES_IMAGES[widget.index],fit: BoxFit.cover,)),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: _blurUpperContainer(),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                color: widget.index == 0 ? white : black,
                iconSize: 30,
                icon: Icon(Icons.arrow_back_ios),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _bottomContainers(),
          ),
        ],
      ),
    );
  }

  Widget _blurUpperContainer() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
          ),
          height: 50,
          width: SizeConfig.screenWidth,
          child: Center(
            child: Text(widget.category,style: TextStyle(fontFamily: 'AA-GALAXY',fontSize: 25,
              color: widget.index == 0 ? white : black,letterSpacing: 1,fontWeight: FontWeight.bold,),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomContainers(){
    return Container(
      height: SizeConfig.screenHeight * 0.85,
      child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1.8),
            itemCount: widget.list.length,
            itemBuilder: (context,index){
              return Container(
                padding: const EdgeInsets.all(8.0),
                width: 160,
                child: RaisedButton(
                  color: button,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 2,
                  onPressed: () async{
                    Navigator.push(context, MaterialPageRoute(builder: (_) => VendorsScreen(title: widget.list[index],)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(widget.list[index],
                      style: TextStyle(letterSpacing: 1,fontSize: 3.3 * SizeConfig.blockSizeVertical,color: white,fontFamily: 'AA-GALAXY'),
                      textAlign: TextAlign.center,),
                  ),
                ),
              );
            }
      ),
    );
  }
}
