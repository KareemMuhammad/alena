import 'package:alena/database/blocs/order_bloc/order_cubit.dart';
import 'package:alena/database/blocs/order_bloc/order_state.dart';
import 'package:alena/utils/constants.dart';
import 'package:alena/utils/shared.dart';
import 'package:alena/widgets/helpers/shared_widgets.dart';
import 'package:alena/widgets/product/order_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<OrderCubit>(context).loadMyOrders(Utils.getCurrentUser(context));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: button,
        elevation: 2,
        title: Text('طلباتى',style: TextStyle(fontSize: 22,color: white,fontFamily: 'AA-GALAXY')
          ,textAlign: TextAlign.center,),
      ),
      body: BlocBuilder<OrderCubit,OrderState>(
          builder: (BuildContext context, state) {
            if(state is OrdersLoaded){
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                    itemCount: state.orders.length,
                    itemBuilder: (ctx,index){
                  return OrderWidget(orderModel: state.orders[index],);
                }),
              );
            }else{
              return ListView.builder(
                  itemCount: 5,
                  itemBuilder: (ctx,index){
                    return loadProductShimmer();
                  });
            }
           },

      ),
    );
  }
}
