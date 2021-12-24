import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/HttpException.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:global_configuration/global_configuration.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer authTimer;
  var api_key = GlobalConfiguration().getValue("API_KEY");
  final signupUrl = Uri.parse(
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${GlobalConfiguration().getValue('API_KEY')}");
  final signinUrl = Uri.parse(
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${GlobalConfiguration().getValue('API_KEY')}");
  void signup(var email, var password) async {
    Map<String, Map<String, dynamic>> errorResponse;
    var response = await http.post(signupUrl,
        body: json.encode(
            {"email": email, "password": password, "returnSecureToken": true}));
    print(response.body);
    if (response.body.contains("error")) {
      errorResponse =
          json.decode(response.body).cast < Map<String, Map<String, dynamic>>();
      if (errorResponse["error"]["code"] == 400) {
        throw HttpException(errorResponse["error"]["message"]);
      }
    }
  }

  void signin(var email, var password) async {
    var response = await http.post(signinUrl,
        body: json.encode(
            {"email": email, "password": password, "returnSecureToken": true}));
    // print(response.body);
    //if(response.body.contains("Token")){
    var reponseDate = json.decode(response.body);
    _token = reponseDate["idToken"];
    _userId = reponseDate["localId"];
    _expiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(reponseDate["expiresIn"]),
      ),
    );
    print(_token);
    print(_expiryDate);
    autoLogout();
    notifyListeners();
    var userData = json.encode({
      "token": _token,
      "userId": _userId,
      "expiryDate": _expiryDate.toIso8601String()
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("userData", userData);
    // }
    print("inside login");
    print(userData);
  }

  Future<void> logout() async {
    this._token = null;
    this._userId = null;
    this._expiryDate = null;
    if (authTimer != null) {
      authTimer.cancel();
      authTimer = null;
    }
    notifyListeners();
    var prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");
    //prefs.clear(); //to clear everything
  }

  void autoLogout() {
    if (authTimer != null) {
      authTimer.cancel();
    }
    authTimer = Timer(
        Duration(
            seconds: this._expiryDate.difference(DateTime.now()).inSeconds),
        logout);
  }

  Future<bool> autoLogin() async {
    // print("inside auto login");
    var prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      print("No key");
      return false;
    }
    print("contains key");
    var userDataString = prefs.getString("userData");
    // print(userDataString);
    var userDataMap = json.decode(userDataString) as Map<String, Object>;
    // print("Mapppppppppp");
    // print(userDataMap);
    // userDataMap.forEach((k, v) => {print(k + " " + v.toString())});
    print(userDataMap["token"]);
    print(userDataMap["expiryDate"]);
    print(userDataMap["userId"]);
    this._token = userDataMap["token"];
    print("token " + this._token);
    this._expiryDate = DateTime.parse(userDataMap[
        "expiryDate"]); // it was failing without error when dataTime parse was not used
    print("expiry date " + this._expiryDate.toString());
    this._userId = userDataMap["userId"];
    print("user id " + this._userId);
    print("inside auato login");
    print(this._token);
    print(this._expiryDate);
    print(this._userId);

    if (this._expiryDate.isAfter(DateTime.now())) {
      notifyListeners();
      return true;
    } else {
      prefs.remove("userData");
      return false;
    }
  }

  bool get validToken {
    if (_token != null) {
      if (_expiryDate.isAfter(DateTime.now())) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  String get token {
    return _token;
  }

  String get userId {
    return _userId;
  }
}
