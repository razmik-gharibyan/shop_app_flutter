import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/cart_provider.dart';

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

  List<Order> get orders{
    return [..._orders];
  }

  void addOrder(List<CartModel> cartProducts,double total) {
    _orders.add(Order(id: DateTime.now().toString(), amount: total, products: cartProducts, dateTime: DateTime.now()));
    notifyListeners();
  }
}