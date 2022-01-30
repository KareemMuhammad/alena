import 'package:alena/database/blocs/order_bloc/order_state.dart';
import 'package:alena/database/repositories/order_repository.dart';
import 'package:alena/models/order.dart';
import 'package:alena/models/user.dart';
import 'package:bloc/bloc.dart';

class OrderCubit extends Cubit<OrderState>{
  final OrderRepository orderRepository;
  OrderCubit({this.orderRepository}) : super(OrderInitial());

  List<OrderModel> _ordersList;

  Future saveOrder(OrderModel orderModel)async{
    try{
      emit(OrderLoading());
      await orderRepository.saveOrderToDb(orderModel.toMap(), orderModel.getOrderId);
      emit(OrderAdded());
    }catch(e){
      print(e.toString());
      emit(OrderNotAdded());
    }
  }

  Future loadMyOrders(AppUser user)async{
    try {
      emit(OrderLoading());
      _ordersList = await orderRepository.getAllOrdersOfUser(user);
      if(_ordersList != null) {
        emit(OrdersLoaded(_ordersList));
      }else{
        emit(OrderLoadError());
      }
    }catch(e){
      print(e.toString());
      emit(OrderLoadError());
    }
  }

}