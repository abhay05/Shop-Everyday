import 'dart:core';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
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
    this.isFavorite = false,
  });

  void _setFavStatus(bool oldFavorite) {
    this.isFavorite = oldFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(var authToken, var userdId) async {
    bool oldFavorite = this.isFavorite;
    this.isFavorite = !this.isFavorite;
    notifyListeners();
    Uri url = Uri.parse(
        'https://shop-app-bb1f7-default-rtdb.asia-southeast1.firebasedatabase.app/favourites/$userdId/${this.id}.json?auth=$authToken');
    try {
      print("sending request");
      var response = await http.put(url,
          body: json.encode(this
              .isFavorite)); // this is same as sending a dict like this => {this.id:this.isFavorite,}
      print(response.body);
      if (response.statusCode >= 400) {
        _setFavStatus(oldFavorite);
      }
    } catch (err) {
      _setFavStatus(oldFavorite);
    }

    //notifyListeners();
  }
}
