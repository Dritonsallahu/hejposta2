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
  double getEqualizationsTotalPrice() {
    double totalPrice = 0.0; // initialize the total price to zero

    for (var entry in orders.entries) {
      String clientName = entry.key; // get the client name
      List<OrderModel> clientOrders = entry.value; // get the list of orders for this client

      double clientTotalPrice = 0.0; // initialize the total price for this client to zero

      for (var order in clientOrders) {
        clientTotalPrice += (order.price - order.offer['price']); // add the price of each order to the total price for this client
      }

      totalPrice += clientTotalPrice; // add the total price for this client to the overall total price
      print("Total price of orders for client $clientName: $clientTotalPrice"); // print the total price for this client
    }

    print("Total price of all orders: $totalPrice"); // print the total price of all orders
    return totalPrice; // return the total price of all orders
  }
  double getClientEqualizationsTotalPrice(id) {
    double totalPrice = 0.0; // initialize the total price to zero

    for (var entry in orders.entries) {
      String clientName = entry.key; // get the client name
      List<OrderModel> clientOrders = entry.value; // get the list of orders for this client

      double clientTotalPrice = 0.0; // initialize the total price for this client to zero

      for (var order in clientOrders) {
        if(order.sender!.id == id){
          clientTotalPrice += (order.price - order.offer['price']); // add the price of each order to the total price for this client
        }
      }

      totalPrice += clientTotalPrice; // add the total price for this client to the overall total price
      print("Total price of orders for client $clientName: $clientTotalPrice"); // print the total price for this client
    }

    print("Total price of all orders: $totalPrice"); // print the total price of all orders
    return totalPrice; // return the total price of all orders
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
