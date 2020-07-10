import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Order {
  final String id;
  final double amount;
  final List<CartModel> products;
  final DateTime dateTime;

  Order({
   @required this.id,
   @required this.amount,
   @required this.products,
   @required this.dateTime
  });
}

class Orders with ChangeNotifier{
  List<Order> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this._orders,this.userId);

  List<Order> get orders{
    return [..._orders];
  }

  Future<void> addOrder(List<CartModel> cartProducts,double total) async {
    final url = "https://flutter-shop-app-5d0ca.firebaseio.com/orders/$userId.json?auth=$authToken";
    final timestamp = DateTime.now();
    final response = await http.post(url, body: json.encode({
      "amount": total,
      "dateTime": timestamp.toIso8601String(),
      "products": cartProducts.map((cp) => {
        "id": cp.id,
        "title": cp.title,
        "quantity": cp.quantity,
        "price": cp.price
      }).toList(),
    }));
    _orders.add(Order(
      id: json.decode(response.body)["name"],
      amount: total,
      products: cartProducts,
      dateTime: timestamp,)
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = "https://flutter-shop-app-5d0ca.firebaseio.com/orders/$userId.json?auth=$authToken";
    final response = await http.get(url);
    final List<Order> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String,dynamic>;
    if(extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(Order(
        id: orderId,
        amount: orderData["amount"],
        dateTime: DateTime.parse(orderData["dateTime"]),
        products: (orderData["products"] as List<dynamic>).map((items) => CartModel(
          id: items["id"],
          price: items["price"],
          quantity: items["quantity"],
          title: items["title"]
        )).toList(),
      ));
    });
    _orders = loadedOrders;
    notifyListeners();
  }

}