import 'package:flutter/material.dart';
import '../../utils/shared.dart';

class EditWeddingDialog extends StatelessWidget {

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
              child: Text('عايزة تغيرى معاد فرحك؟',style: TextStyle(fontSize: 3.5 * SizeConfig.blockSizeVertical,color: button,fontFamily: 'AA-GALAXY')
                ,textAlign: TextAlign.center,),
            ),
           const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.all(10),
              child: RaisedButton(
                color: button,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 2,
                onPressed: () {
                  Navigator.pop(context, 'done');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('تأكيد',style: TextStyle(letterSpacing: 1,fontSize: 22,color: white,
                      fontFamily: 'AA-GALAXY'),
                    textAlign: TextAlign.center,),
                ),
              ),
            ),
          ],
      ),
    );
  }
}
