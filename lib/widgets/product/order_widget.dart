import 'package:alena/models/order.dart';
import 'package:alena/utils/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel orderModel;

  const OrderWidget({Key key, this.orderModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 4,
        color: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${orderModel.getProduct.deviceName}',style: TextStyle(fontFamily: 'AA-GALAXY',
                  fontSize: 17, color: black,letterSpacing: 1),),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                height: SizeConfig.screenHeight * 0.3,
                child: Theme(
                  data: ThemeData(
                    colorScheme: Theme.of(context).colorScheme.copyWith(primary: button),
                  ),
                  child: Stepper(
                    controlsBuilder: (BuildContext context, { VoidCallback onStepContinue, VoidCallback onStepCancel }) {
                      return const SizedBox();
                    },
                      steps: getSteps(),
                      type: StepperType.horizontal,
                      currentStep: orderModel.getOrderStep,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

 List<Step> getSteps() =>
     [
       Step(
           isActive: orderModel.getOrderStep >= 0,
           state: orderModel.getOrderStep > 0 ? StepState.complete : StepState.indexed,
           title: Text('أرسلت',style: TextStyle(fontWeight: FontWeight.bold,
               fontSize: 16, color: black,letterSpacing: 1),),
           content: _contentWidget()
       ),
       Step(
           isActive: orderModel.getOrderStep >= 1,
           state: orderModel.getOrderStep > 1 ? StepState.complete : StepState.indexed,
           title: Text('تم التواصل',style: TextStyle(fontWeight: FontWeight.bold,
               fontSize: 16, color: black,letterSpacing: 1),),
           content: _contentWidget()
       ),
 ];

  Widget _contentWidget() {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('التاجر',style: TextStyle(fontSize: 17, color: black,letterSpacing: 1),),
            Text('${orderModel.getProduct.vendor.brand}',style: TextStyle(fontSize: 17,
                color: black,letterSpacing: 1,fontFamily: 'AA-GALAXY',),),
          ],
        ),
        const SizedBox(height: 10,),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('المنتج',style: TextStyle(fontSize: 17, color: black,letterSpacing: 1),),
            Text('${orderModel.getProduct.productName}',style: TextStyle(fontSize: 17,
                  color: black,letterSpacing: 1,fontFamily: 'AA-GALAXY',),maxLines: 1,overflow: TextOverflow.ellipsis,),
          ],
        ),
        const SizedBox(height: 10,),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('التاريخ',style: TextStyle(fontSize: 17, color: black,letterSpacing: 1),),
            Text('${orderModel.getDate.split(' ')[0]}',style: TextStyle(fontSize: 17,
                color: black,letterSpacing: 1,fontFamily: 'AA-GALAXY',),),
          ],
        ),
      ],
    );
  }
}
