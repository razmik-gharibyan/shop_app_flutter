import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier{

  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false
  });

  Future<void> toggleFavoriteStatus(String token,String userId) async {
    final url = "https://flutter-shop-app-5d0ca.firebaseio.com/userFavorites/$userId/$id.json?auth=$token";
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(url, body: json.encode(
        isFavorite,
      ));
      if(response.statusCode >= 400) {
        _returnOldValue(oldStatus);
      }
    } catch (error) {
      _returnOldValue(oldStatus);
    }
  }

  void _returnOldValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

}