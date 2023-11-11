import 'package:flutter/foundation.dart';
import 'package:hejposta/models/order_model.dart';

class ClientOrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  final List<OrderModel> _ordersFilter = [];

  bool fetchingPendingOrders = false;

  Iterable<OrderModel>? getOrders(status){
    if(status == "all") {
      return _orders;
    }
    else {
      return _orders.where((element){
        return element.status == status;
      });
    }
  }

  Iterable<OrderModel>? getOrdersByState(state,status,DateTime? from,to){

        var a =_orders.where((element){


          var hasState = element.receiver!.state == state || state == "Te gjitha";
          if(element.status == "delivered_to_client" && status == "rejected"){
            return   hasState;
          }
          return element.status == status && hasState;
        });

        return a;

  }


  OrderModel? getOrder(id) =>
      _orders.firstWhere((element) => element.orderNumber == id);

  getSpecificOrders(status) =>
      _orders.where((element) => element.status == status);

  addOrders(List<OrderModel>? orders) {
    _ordersFilter.clear();
    _orders.clear();
    _orders.addAll(orders!);
    _ordersFilter.addAll(orders);
    notifyListeners();
  }

  addOrder(OrderModel? order) {
    _orders.insert(0,order!);
    notifyListeners();
  }

  editOrder(OrderModel? order) {
    for(int i=0;i<_orders.length;i++){
     if(_orders[i].id == order!.id){
       _orders[i] = order!;
     }
    }
    notifyListeners();
  }

  deleteOrder(orderNumber) {
    _orders.removeWhere((element) => element.orderNumber == orderNumber);
    notifyListeners();
  }

  deleteOrderById(id) {
    print(id);
    _orders.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  isFetchingPendingOrders() => fetchingPendingOrders;

  startFetchingPendingOrders() {
    fetchingPendingOrders = true;
    notifyListeners();
  }

  stopFetchingPendingOrders() {
    fetchingPendingOrders = false;
    notifyListeners();
  }

  filtro(emri) {
    _orders = [];

    for (int i = 0; i < _ordersFilter.length; i++) {
      if (_ordersFilter[i]
          .orderNumber!
          .toUpperCase()
          .contains(emri.toUpperCase())) {
          _orders.add(_ordersFilter[i]);
      }
      else if (_ordersFilter[i]
          .receiver!.fullName!
          .toUpperCase()
          .contains(emri.toUpperCase())) {

        _orders.add(_ordersFilter[i]);

      }
    }
    notifyListeners();
  }
}
