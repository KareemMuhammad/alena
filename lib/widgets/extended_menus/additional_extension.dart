import 'package:alena/models/menu.dart';
import 'package:alena/utils/shared.dart';
import 'package:alena/widgets/helpers/check_additional.dart';
import 'package:flutter/material.dart';

class AdditionalExtension extends StatefulWidget {
  final Menu menu;

  const AdditionalExtension({Key key, this.menu}) : super(key: key);

  @override
  _AdditionalExtensionState createState() => _AdditionalExtensionState();
}

class _AdditionalExtensionState extends State<AdditionalExtension> {
  bool isCollapse = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ExpansionTile(
        title: Text('${widget.menu.category}', style: TextStyle(fontSize: 25, color: isCollapse ? black : white,
            fontFamily: 'AA-GALAXY'), textAlign: TextAlign.center,),
        textColor: black,
        backgroundColor: white,
        collapsedBackgroundColor: button,
        iconColor: black,
        onExpansionChanged: (extend){
          setState(() {
            isCollapse = extend;
          });
        },
        children: [
           Row(mainAxisAlignment: MainAxisAlignment.center,
             children: [
               CheckAdditional(values: widget.menu.list,menuId: widget.menu.id,menuCategory: widget.menu.category,)
             ],
           )
        ],
      ),
    );
  }

}
