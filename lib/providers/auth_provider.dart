import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier{

  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if(_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signUp(String email,String password) async {
    try {
      const url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAo9jf0HWYaI59EEqrHZfWUenHLi5Eu3eM";
      final response = await http.post(url, body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true
      }));
      final responsedData = json.decode(response.body);
      if(responsedData["error"] != null) {
        throw HTTPException(responsedData["error"]["message"]);
      }
      _token = responsedData["idToken"];
      _userId = responsedData["localId"];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responsedData["expiresIn"])));
      notifyListeners();
      autoLogOut();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate.toIso8601String()
      });
      prefs.setString("userData", userData);
    } catch(error) {
      throw (error);
    }
  }

  Future<void> logIn(String email,String password) async {
    try {
      const url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAo9jf0HWYaI59EEqrHZfWUenHLi5Eu3eM";
      final response = await http.post(url, body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true
      }));
      final responsedData = json.decode(response.body);
      if(responsedData["error"] != null) {
        throw HTTPException(responsedData["error"]["message"]);
      }
      _token = responsedData["idToken"];
      _userId = responsedData["localId"];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responsedData["expiresIn"])));
      autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate.toIso8601String()
      });
      prefs.setString("userData", userData);
    }catch(error) {
      throw (error);
    }
  }

  Future<void> logOut() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if(_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogOut() {
    if(_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logOut);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("userData")) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString("userData")) as Map<String,dynamic>;
    final expiryDate = DateTime.parse(extractedUserData["expiryDate"]);
    if(expiryDate.isBefore(DateTime.now())) {
      //Token is not valid
      return false;
    }
    _token = extractedUserData["token"];
    _expiryDate = expiryDate;
    _userId = extractedUserData["userId"];
    notifyListeners();
    autoLogOut();
    return true;
  }

}