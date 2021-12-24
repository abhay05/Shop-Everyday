import 'package:flutter/cupertino.dart';
import 'dart:convert';
import './product.dart';
import './cart_provider.dart';

import 'package:http/http.dart' as http;

class Orders {
  final String orderId;
  final DateTime timeStamp;
  final List<CartItem> product;
  final double amount;

  Orders({
    this.orderId,
    this.timeStamp,
    this.product,
    this.amount,
  });
}

class OrderProvider extends ChangeNotifier {
  String userId;
  String token;
  List<Orders> _orders = [];
  OrderProvider();
  OrderProvider.already(this.userId, this.token, this._orders);

  double totalSum = 0;

  Future<void> fetchAndSet() async {
    var url = Uri.parse(
        'https://shop-app-bb1f7-default-rtdb.asia-southeast1.firebasedatabase.app/orders/${this.userId}.json?auth=${this.token}');

    var response = await http.get(url);
    print(response.body);
    List<Orders> loadedOrders = [];
    if (json.decode(response.body) == null) {
      return; // if there are no orders
    }
    json.decode(response.body).forEach((key, val) {
      loadedOrders.add(
        Orders(
          amount: val["amount"],
          orderId: key,
          timeStamp: DateTime.parse(val["timeStamp"]),
          product: (val["product"] as List<dynamic>).map((item) {
            var cartMap = item;
            //json.decode(item) as Map<String, dynamic>;
            return CartItem(
              itemId: cartMap["itemId"],
              itemPrice: cartMap["itemPrice"],
              itemQty: cartMap["itemQty"],
              itemTitle: cartMap["itemTitle"],
            );
          }).toList(),
        ),
      );
    });
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrders(List<CartItem> product, double amount) async {
    var url = Uri.parse(
        'https://shop-app-bb1f7-default-rtdb.asia-southeast1.firebasedatabase.app/orders/${this.userId}.json?auth=${this.token}');
    var time = DateTime.now();
    try {
      var response = await http.post(
        url,
        body: json.encode({
          "timeStamp": time.toIso8601String(),
          "product": product.map((cartItem) {
            return {
              "itemId": cartItem.itemId,
              "itemTitle": cartItem.itemTitle,
              "itemQty": cartItem.itemQty,
              "itemPrice": cartItem.itemPrice,
            };
          }).toList(),
          "amount": amount,
        }),
      );
      print("Orders");
      print(response.body);
      // _orders.add(Orders(
      //   orderId: json.decode(response.body)["name"],
      //   timeStamp: time,
      //   product: product,
      //   amount: amount,
      // ));
    } catch (err) {
      print(err);
    }

    notifyListeners();
  }

  List<Orders> get getOrders {
    return [..._orders];
  }

  double get getTotalSum {
    double sum = 0;
    _orders.forEach((element) {
      sum += element.amount;
    });
    return sum;
  }
}
