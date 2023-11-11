import 'package:flutter/foundation.dart';
import 'package:hejposta/models/order_model.dart';

class ClientOrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  final List<OrderModel> _ordersFilter = [];

  bool fetchingPendingOrders = false;

  Iterable<OrderModel>? getOrders(status){
    if(status == "all"){
      return _orders;
    }
    else {
      return _orders.where((element){
        return element.status == status;
      });
    }
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

  deleteOrder(orderNumber) {
    _orders.removeWhere((element) => element.orderNumber == orderNumber);
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
          .sender!.businessName!
          .toUpperCase()
          .contains(emri.toUpperCase())) {

        _orders.add(_ordersFilter[i]);

      }
    }
    notifyListeners();
  }
}
