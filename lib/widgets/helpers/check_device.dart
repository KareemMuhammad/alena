import 'package:alena/utils/shared.dart';
import 'package:flutter/material.dart';

class CheckDevice extends StatelessWidget {
  final List<String> devices;

  const CheckDevice({Key key, this.devices}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return devices.isEmpty || devices == null ?
    Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('القائمة دى لسة متمتش',style: TextStyle(fontSize: 18,color: button,fontFamily: 'AA-GALAXY')
          ,textAlign: TextAlign.center,),
      ),
    )
    :Column(
      children: [
        ...(devices).map((dev) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.done,color: button,),
                SizedBox(width: 5,),
                Text('$dev',style: TextStyle(fontSize: 20,color: button,fontFamily: 'AA-GALAXY')
                  ,textAlign: TextAlign.center,),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
