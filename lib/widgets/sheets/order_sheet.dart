import 'package:alena/utils/shared.dart';
import 'package:flutter/material.dart';

class OrderSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.7,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.end,
          children: [

          ],
        ),
      ),
    );
  }
}
