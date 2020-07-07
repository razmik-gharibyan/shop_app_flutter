import 'package:flutter/foundation.dart';

class CartModel {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartModel({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price});
}

class Cart with ChangeNotifier{
  Map<String,CartModel> _items = {};

  Map<String,CartModel> get items{
    return {..._items};
  }

  void addItem(String productId,double price,String title) {
    if(_items.containsKey(productId)) {
      _items.update(productId, (existingCartItem) => CartModel(
        id: existingCartItem.id,
        title: existingCartItem.title,
        price: existingCartItem.price,
        quantity: existingCartItem.quantity + 1,
      ));
    }else{
      _items.putIfAbsent(productId, () => CartModel(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1)
      );
    }
    notifyListeners();
  }

  int get itemCount {
    return _items.length;
  }

  double get totalSum {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if(!_items.containsKey(productId)) {
      return;
    }
    if(_items[productId].quantity > 1) {
      _items.update(productId, (existingCartItem) => CartModel(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1
      ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

}