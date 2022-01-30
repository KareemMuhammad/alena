import 'package:alena/database/blocs/order_bloc/order_cubit.dart';
import 'package:alena/database/blocs/order_bloc/order_state.dart';
import 'package:alena/database/blocs/vendor_bloc/vendor_bloc.dart';
import 'package:alena/models/notification_model.dart';
import 'package:alena/models/order.dart';
import 'package:alena/models/product.dart';
import 'package:alena/utils/constants.dart';
import 'package:alena/utils/shared.dart';
import 'package:alena/widgets/dialogs/alert_dialog_widget.dart';
import 'package:alena/widgets/helpers/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:uuid/uuid.dart';

class OrderSheet extends StatefulWidget {
  final Product product;

  const OrderSheet({Key key, this.product}) : super(key: key);
  @override
  State<OrderSheet> createState() => _OrderSheetState();
}

class _OrderSheetState extends State<OrderSheet> {
  final TextEditingController emailController = new TextEditingController();

  final TextEditingController nameController = new TextEditingController();

  final TextEditingController phoneController = new TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameController.text = Utils.getCurrentUser(context).name;
    emailController.text = Utils.getCurrentUser(context).email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final OrderCubit orderCubit = BlocProvider.of<OrderCubit>(context);
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: SizeConfig.screenHeight * 0.6,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 5,),
                Row(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text('كملى بياناتك لارسال طلبك',style: TextStyle(color: black,fontSize: 17,fontWeight: FontWeight.bold),),
                      ),
                    IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, icon: const Icon(AntDesign.close),
                      color: Colors.grey[700],
                    )
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                    child: TextFormField(
                      enabled: false,
                      style: TextStyle(color: black,fontSize: 18,),
                      decoration: textInputDecorationOrder('${Utils.getCurrentUser(context).email}',Icons.email),
                      controller: emailController,
                      validator: (val){
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)
                            ? null : 'من فضلك ادخل بريد الكترونى صحيح';
                      },
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                    child: TextFormField(
                      enabled: false,
                      style: TextStyle(color: black,fontSize: 18,),
                      decoration: textInputDecorationOrder('${Utils.getCurrentUser(context).name}',Icons.person),
                      controller: nameController,
                      validator: (val){
                        return val.isNotEmpty
                            ? null : 'من فضلك ادخل اسمك';
                      },
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                    child: TextFormField(
                      style: TextStyle(color: black,fontSize: 18,),
                      decoration: textInputDecorationOrder('رقم الهاتف',Icons.phone_android),
                      controller: phoneController,
                      validator: (val){
                        return val.isNotEmpty || val.length > 11
                            ? null : 'من فضلك ادخل رقم للتواصل';
                      },
                    )
                ),
                 SizedBox(height: SizeConfig.screenHeight * 0.1,),
                BlocConsumer<OrderCubit,OrderState>(
                  listener: (context,state)async{
                    if(state is OrderAdded){
                      NotificationModel model = NotificationModel(id: '',
                          icon: Utils.APP_ICON,
                          title: '${widget.product.deviceName}',
                          body: 'تم وصول طلب جديد');
                      await Utils.sendPushMessage(model, widget.product.vendor.token);
                      BlocProvider.of<VendorCubit>(context).updateVendorOrderNo(1, widget.product.vendorId);
                      Navigator.pop(context);
                      showDialog(context: context, builder: (_){
                        return Dialog(
                            backgroundColor: white,
                            child: CustomAlertDialog(image: 'assets/good.png',text: 'تم ارسال طلبك ينجاح',));
                      },barrierDismissible: false);
                    }
                  },
                  builder: (context,state) {
                    if(state is OrderLoading){
                      return spinKit;
                    }
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton(
                        color: button,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 4,
                        onPressed: () async{
                         if(formKey.currentState.validate()){
                           final String id = Uuid().v1();
                           final String date  = DateTime.now().toString();
                           final OrderModel orderModel = OrderModel(id, date, Utils.getCurrentUser(context),
                               widget.product,phoneController.text,widget.product.vendorId,0);
                           await orderCubit.saveOrder(orderModel);
                         }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text('ارسال الطلب',style: TextStyle(fontSize: 18,color: white,
                              fontFamily: 'AA-GALAXY',letterSpacing: 1),
                            textAlign: TextAlign.center,),
                        ),
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
