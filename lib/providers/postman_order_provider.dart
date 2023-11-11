import 'package:flutter/foundation.dart';
import 'package:hejposta/models/order_model.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class PostmanOrderProvider extends ChangeNotifier {

  List<OrderModel> _onDeliveryOrders = [];
  final List<OrderModel> _onDeliveryOrdersFilter = [];

  final List<OrderModel> _onEqualizeOrders = [];
  final List<OrderModel> _onEqualizeOrdersFilter = [];

  Map<String, List<OrderModel>> ordersBySender = {};
  Map<String, List<OrderModel>> ordersBySenderFilter = {};

  String? _zone = "all";

  bool fetchingPendingOrders = false;

  Map<String, List<OrderModel>> getOrders() => ordersBySender;

  int porosiNePritje() {
      return ordersBySender.values
          .expand((orders) => orders)
          .where((order) => order.status == "pending").length;
  }

  int porosiPerDepo() {
      return ordersBySender.values
          .expand((orders) => orders)
          .where((order) => order.status == "accepted").length;
  }

  int porosiNeDepo() {
      return ordersBySender.values
          .expand((orders) => orders)
          .where((order) => order.status == "in_warehouse").length;
  }

  int porosiNeDergese() => _onDeliveryOrders
      .where((element) => element.status == "delivering")
      .length;
  int porosiTeSuksesshme() => _onDeliveryOrders
      .where((element) => element.status == "delivered")
      .length;
  int porosiTeAnuluara() => _onDeliveryOrders
      .where((element) => element.status == "rejected")
      .length;
  int porosiTeRikthyera() => _onDeliveryOrders
      .where((element) => element.status == "returned")
      .length;

  int porosiNPerBarazim() => _onEqualizeOrders
      .where((element) =>
  element.status == "delivered" &&
      element.barazimiAdministrat == true &&
      element.barazimiKlient == false)
      .length;

  Map<String, List<OrderModel>> groupBySender(String status) {
    Map<String, List<OrderModel>> ordersByStatus = {};

    ordersBySender.forEach((key, value) {
      List<OrderModel> ordersWithStatus =
      value.where((order) => order.status == status).toList();

      if (ordersWithStatus.isNotEmpty) {
        ordersByStatus[key] = ordersWithStatus;
      }
    });

    return ordersByStatus;
  }


  getZone() => _zone;

  addZone(zone){
    _zone = zone;
    notifyListeners();
  }

  OrderModel? getOrderById(String id) {
    return ordersBySender.values.expand((orders) => orders)
        .firstWhere((order) => order.orderNumber == id);
  }

  Iterable<OrderModel> getSpecificOrders(String status) {
    return ordersBySender.values.expand((orders) => orders.where((order) => order.status == status));
  }



  Iterable<OrderModel> getOnDeliveryOrders(status) {
    if(_zone == "all"){
      return _onDeliveryOrders.where((element) => element.status == status);
    }
    return _onDeliveryOrders.where((element) {
      print(element);
      if(status == "rejected" || element.status == "delivered_to_client"){
        return true && element.zone.toString().trim() == _zone.toString().trim();
      }
      return element.status == status && element.zone.toString().trim() == _zone.toString().trim();
    });
  }

  Iterable<OrderModel> getOnEqualizeOrders(status) =>
      _onDeliveryOrders.where((element) =>
      element.status == "delivered" &&
          element.barazimiAdministrat == true &&
          element.barazimiKlient == false);

  addOrders(List<OrderModel>? orders) {
    ordersBySender = groupBy(orders!,
            (OrderModel orderModel) => orderModel.sender!.businessName).map(
          (senderId, orders) => MapEntry(
        orders.first.sender!.businessName!,
        orders,
      ),
    );
    ordersBySenderFilter = groupBy(orders,
            (OrderModel orderModel) => orderModel.sender!.businessName).map(
          (senderId, orders) => MapEntry(
        orders.first.sender!.businessName!,
        orders,
      ),
    );

    notifyListeners();
  }

  addOnDeliveryOrders(List<OrderModel>? orders) {
    _onDeliveryOrders.clear();
    _onDeliveryOrdersFilter.clear();

    _onDeliveryOrders.addAll(orders!);
    _onDeliveryOrdersFilter.addAll(orders);

    notifyListeners();
  }

  addOnEqualizeOrders(List<OrderModel>? orders) {
    _onEqualizeOrders.clear();
    _onEqualizeOrdersFilter.clear();

    _onEqualizeOrders.addAll(orders!);
    _onEqualizeOrdersFilter.addAll(orders);

    notifyListeners();
  }

  void moveOrder(String orderNumber, status) {
    ordersBySender.forEach((sender, orders) {
      for (int i = 0; i < orders.length; i++) {
        print(orders.elementAt(i).status);
        if (orders[i].orderNumber == orderNumber) {
          orders.elementAt(i).status = status;
          return; // Exit the method after removing the order
        }
      }
    });
    notifyListeners();
  }

  addOrder(OrderModel order) {
    String senderBusinessName = order.sender!.businessName!;

    // Get the sender's list of orders, or create a new list if it doesn't exist yet
    List<OrderModel> senderOrders = ordersBySender[senderBusinessName] ?? [];

    // Add the order to the sender's list of orders
    senderOrders.add(order);

    // Update the ordersBySender map with the modified list
    ordersBySender[senderBusinessName] = senderOrders;

    // Notify listeners that the ordersBySender map has changed
    notifyListeners();
  }

  setOrderDelivered(orderNumber) {
    print("order number: $orderNumber");
    for (int i = 0; i < _onDeliveryOrders.length; i++) {
      if (_onDeliveryOrders[i].orderNumber == orderNumber) {
        _onDeliveryOrders[i].status = "delivered";
      }
    }
    notifyListeners();
  }

  setOrderRejected(orderNumber) {
    for (int i = 0; i < _onDeliveryOrders.length; i++) {
      if (_onDeliveryOrders[i].orderNumber == orderNumber) {
        _onDeliveryOrders[i].status = "rejected";
      }
    }
    notifyListeners();
  }

  setOrderReturned(orderNumber) {
    for (int i = 0; i < _onDeliveryOrders.length; i++) {
      if (_onDeliveryOrders[i].orderNumber == orderNumber) {
        _onDeliveryOrders[i].status = "returned";
      }
    }
    notifyListeners();
  }
  setOrderLoaded(orderNumber) {
    print("ordernumber: $orderNumber");
    for (int i = 0; i < _onDeliveryOrders.length; i++) {
      if (_onDeliveryOrders[i].orderNumber == orderNumber) {
        _onDeliveryOrders[i].status = "delivering";
      }
    }
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

  filter(String sender) {
    if (sender.isNotEmpty) {
      ordersBySender = {};
      ordersBySender = Map.fromEntries(ordersBySenderFilter.entries
          .where((entry) {
        return entry.key.toString().toLowerCase().contains(sender.toLowerCase());
      }));
    } else {
      ordersBySender = ordersBySenderFilter;
    }
    notifyListeners();
  }

  filtroNeDergese(emri,status) {
    _onDeliveryOrders = [];


    for (int i = 0; i < _onDeliveryOrdersFilter.length; i++) {
      if(status == "delivering"){
        if (_onDeliveryOrdersFilter[i]
            .orderNumber!
            .toUpperCase()
            .contains(emri.toUpperCase()) && _onDeliveryOrdersFilter[i].status == "delivering") {
          _onDeliveryOrders.add(_onDeliveryOrdersFilter[i]);
        }
        else if (_onDeliveryOrdersFilter[i]
            .receiver!
            .fullName!
            .toUpperCase()
            .contains(emri.toUpperCase()) && _onDeliveryOrdersFilter[i].status == "delivering") {
          _onDeliveryOrders.add(_onDeliveryOrdersFilter[i]);
        }
        else if (_onDeliveryOrdersFilter[i]
            .orderName!
            .toUpperCase()
            .contains(emri.toUpperCase()) && _onDeliveryOrdersFilter[i].status == "delivering") {
          _onDeliveryOrders.add(_onDeliveryOrdersFilter[i]);
        }
      }
      else if(status == "delivered"){
        if (_onDeliveryOrdersFilter[i]
            .orderNumber!
            .toUpperCase()
            .contains(emri.toUpperCase()) && _onDeliveryOrdersFilter[i].status == "delivered") {
          _onDeliveryOrders.add(_onDeliveryOrdersFilter[i]);
        } else if (_onDeliveryOrdersFilter[i]
            .receiver!
            .fullName!
            .toUpperCase()
            .contains(emri.toUpperCase()) && _onDeliveryOrdersFilter[i].status == "delivered") {
          _onDeliveryOrders.add(_onDeliveryOrdersFilter[i]);
        }
        else if (_onDeliveryOrdersFilter[i]
            .orderName!
            .toUpperCase()
            .contains(emri.toUpperCase()) && _onDeliveryOrdersFilter[i].status == "delivered") {
          _onDeliveryOrders.add(_onDeliveryOrdersFilter[i]);
        }
      }
      else if(status == "rejected"){
        if (_onDeliveryOrdersFilter[i]
            .orderNumber!
            .toUpperCase()
            .contains(emri.toUpperCase()) && _onDeliveryOrdersFilter[i].status == "rejected") {
          _onDeliveryOrders.add(_onDeliveryOrdersFilter[i]);
        } else if (_onDeliveryOrdersFilter[i]
            .receiver!
            .fullName!
            .toUpperCase()
            .contains(emri.toUpperCase()) && _onDeliveryOrdersFilter[i].status == "rejected") {
          _onDeliveryOrders.add(_onDeliveryOrdersFilter[i]);
        }
        else if (_onDeliveryOrdersFilter[i]
            .orderName!
            .toUpperCase()
            .contains(emri.toUpperCase()) && _onDeliveryOrdersFilter[i].status == "rejected") {
          _onDeliveryOrders.add(_onDeliveryOrdersFilter[i]);
        }
      }
      else if(status == "returned"){
        if (_onDeliveryOrdersFilter[i]
            .orderNumber!
            .toUpperCase()
            .contains(emri.toUpperCase()) && _onDeliveryOrdersFilter[i].status == "returned") {
          _onDeliveryOrders.add(_onDeliveryOrdersFilter[i]);
        } else if (_onDeliveryOrdersFilter[i]
            .receiver!
            .fullName!
            .toUpperCase()
            .contains(emri.toUpperCase()) && _onDeliveryOrdersFilter[i].status == "returned") {
          _onDeliveryOrders.add(_onDeliveryOrdersFilter[i]);
        }
        else if (_onDeliveryOrdersFilter[i]
            .orderName!
            .toUpperCase()
            .contains(emri.toUpperCase()) && _onDeliveryOrdersFilter[i].status == "returned") {
          _onDeliveryOrders.add(_onDeliveryOrdersFilter[i]);
        }
      }

    }
    notifyListeners();
  }
}