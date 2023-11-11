import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:hejposta/models/order_model.dart';

class EqualizationProvier extends ChangeNotifier {


  Map<String, List<OrderModel>> orders = {};
  Map<String, List<OrderModel>> ordersFilter = {};

  bool isFetching = false;

  Map<String, List<OrderModel>> getEqualizations() {
    return orders;
  }

  addEqualizations(List<OrderModel> equalizations) {
    orders = groupBy(equalizations,
            (OrderModel orderModel) => orderModel.sender!.username).map(
          (senderId, orders) => MapEntry(
        orders.first.sender!.businessName!,
        orders,
      ),
    );
    ordersFilter = groupBy(equalizations,
            (OrderModel orderModel) => orderModel.sender!.username).map(
          (senderId, orders) => MapEntry(
        orders.first.sender!.businessName!,
        orders,
      ),
    );

    notifyListeners();
  }


  isFetchingPendingOrders() => isFetching;

  startFetchingPendingOrders() {
    isFetching = true;
    notifyListeners();
  }

  stopFetchingPendingOrders() {
    isFetching = false;
    notifyListeners();
  }

  filter(String sender) {
    if (sender.isNotEmpty) {
      orders = {};
      orders = Map.fromEntries(ordersFilter.entries
          .where((entry) {
        return entry.key.toString().toLowerCase().contains(sender.toLowerCase());
      }));
    } else {
      orders = ordersFilter;
    }
    notifyListeners();
  }
}

class EqualizedOrdersProvier extends ChangeNotifier {

  Map<String, List<OrderModel>> orders = {};
  Map<String, List<OrderModel>> ordersFilter = {};

  bool isFetching = false;

  Map<String, List<OrderModel>> getEqualizations() {
    return orders;
  }

  addEqualizations(List<OrderModel> equalizations) {
    orders = groupBy(equalizations,
            (OrderModel orderModel) => orderModel.sender!.username).map(
          (senderId, orders) => MapEntry(
        orders.first.sender!.businessName!,
        orders,
      ),
    );
    ordersFilter = groupBy(equalizations,
            (OrderModel orderModel) => orderModel.sender!.username).map(
          (senderId, orders) => MapEntry(
        orders.first.sender!.businessName!,
        orders,
      ),
    );

    notifyListeners();
  }



  isFetchingPendingOrders() => isFetching;

  startFetchingPendingOrders() {
    isFetching = true;
    notifyListeners();
  }

  stopFetchingPendingOrders() {
    isFetching = false;
    notifyListeners();
  }

  filter(String sender) {
    if (sender.isNotEmpty) {
      orders = {};
      orders = Map.fromEntries(ordersFilter.entries
          .where((entry) {
            return entry.key.toString().toLowerCase().contains(sender.toLowerCase());
      }));
    } else {
      orders = ordersFilter;
    }
    notifyListeners();
  }
}
