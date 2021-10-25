import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/shared.dart';

class AllowUpdateDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Column(
        children: [
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('لازم تحدث التطبيق عشان تستمتع بباقى المزايا',
              style: TextStyle(fontSize: 3.5 * SizeConfig.blockSizeVertical,color: button,fontFamily: 'AA-GALAXY')
              ,textAlign: TextAlign.center,),
          ),
          const SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  color: button,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 2,
                  onPressed: () {
                    Navigator.pop(context,'done');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('لاحقا',style: TextStyle(letterSpacing: 1,fontSize: 22,color: white,
                        fontFamily: 'AA-GALAXY'),
                      textAlign: TextAlign.center,),
                  ),
                ),
                RaisedButton(
                  color: button,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 2,
                  onPressed: () async{
                    await launch(APP_LINK);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('تحديث',style: TextStyle(letterSpacing: 1,fontSize: 22,color: white,
                        fontFamily: 'AA-GALAXY'),
                      textAlign: TextAlign.center,),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}