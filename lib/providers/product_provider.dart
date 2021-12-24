//import 'dart';
import 'dart:convert'; // to convert data

import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import '../models/HttpException.dart';

//import 'package:json_'

class Products with ChangeNotifier {
  String token;
  String userId;
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  Products();
  Products.already(this.userId, this.token, this._items);
  List<Product> get getItems {
    //print("get items");
    print("length : ${_items.length}");
    return [..._items];
  }

  List<Product> get getFavoriteItems {
    //print("get f items");
    // List<String> ids = [];
    // Uri url = Uri.https(
    //     'shop-app-bb1f7-default-rtdb.asia-southeast1.firebasedatabase.app',
    //     '/favorites.json');
    // http.get(url).then((response) {
    //   print(response.body);
    //   var map = json.decode(response.body);
    //   map.forEach((key, val) {
    //     ids.add(val["id"]);
    //   });
    //   print("IDS");
    //   ids.forEach((element) {
    //     print(element);
    //   });

    // }).catchError((err) {
    //   print(err);
    //   return [];
    // });
    // return [];
    return _items.where((product) => product.isFavorite).toList();
  }

  Future<void> addProduct(Product prod) async {
    var url = Uri.parse(
        'https://shop-app-bb1f7-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=${this.token}');
    //if you add https you will get this error -> Invalid radix-10 number (at character 1)
//shop-app-bb1f7-default-rtdb.asia-southeast1.firebasedatabase.app bcz it will try to convert url to
// a ip address and it will fail.

    // Uri uri = Uri(path: url);
    try {
      var reponse = await http.post(
        url,
        body: json.encode(
          {
            'title': prod.title,
            'description': prod.description,
            'imageUrl': prod.imageUrl,
            'price': prod.price,
            'creatorId': this.userId
          },
        ),
      );
      // using then to add product is not necessary
      // but we do it so that we can use the id created by firebase\
      var respBody = json.decode(reponse.body);
      print(respBody);

      Product newProduct = Product(
          id: respBody['name'],
          description: prod.description,
          imageUrl: prod.imageUrl,
          title: prod.title,
          price: prod.price);
      _items.add(newProduct);
      notifyListeners();
    } catch (err) {
      print(err.toString());
      throw err;
    }
    //  notifyListeners(); -> will notify even before product is added in database,
    // so you will see no difference on screen, add it in then section.
  }

  Product getItemById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(Product prod) async {
    print("title: " + prod.title);
    var url = Uri.parse(
        'https://shop-app-bb1f7-default-rtdb.asia-southeast1.firebasedatabase.app/products/${prod.id}.json?auth=${this.token}');
    await http.patch(url,
        body: json.encode({
          "title": prod.title,
          "description": prod.description,
          "imageUrl": prod.imageUrl,
        }));
    //var ind = _items.indexWhere((product) => product.id == prod.id);
    //_items.removeAt(ind);
    //_items.insert(ind, prod);
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    var url = Uri.parse(
        'https://shop-app-bb1f7-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=${this.token}');
    int index = _items.indexWhere((element) => id == element.id);
    var prod =
        _items[index]; // reference to the item; so the item will be deleted
    // from the list but not from the memory
    // if the reference to item is not there that means no one is using that item and it will
    // be deleted from memory too
    _items.removeAt(index);
    //notifyListeners();
    var response = await http.delete(url);
    if (response.statusCode >= 400) {
      print(response.statusCode);
      _items.insert(index, prod);
      //notifyListeners();
      throw HttpException("Could not delete the item");
    }
    prod = null;
    //_items.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  Future<http.Response> fetchProducts({bool load = false}) async {
    var response;
    try {
      print("token " + this.token);
      var filterString = '';
      if (load == true) {
        print("load " + load.toString());
        filterString = '&orderBy="creatorId"&equalTo="${this.userId}"';
      }
      print(filterString);
      var url = Uri.parse(
          'https://shop-app-bb1f7-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=${this.token}$filterString');
      response = await http.get(url);
      var reponseMap = json.decode(response.body) as Map<String, dynamic>;
      print("Response Body : ${response.body}");
      print("userId " + this.userId);
      var favouriteUrl = Uri.parse(
          'https://shop-app-bb1f7-default-rtdb.asia-southeast1.firebasedatabase.app/favourites/${this.userId}.json?auth=${this.token}');
      var favouriteResponse = await http.get(favouriteUrl);
      print("favourite response body " + favouriteResponse.body);
      var favResponseMap = json.decode(favouriteResponse.body);
      List<Product> productsList = [];
      reponseMap.forEach((id, value) {
        print("Hello1");
        print("value : ${value}");
        print("description : ${value["description"]}");
        //value = json.decode(value) as Map<String, Object>;
        //print("Hello2");
        //print("description : ${value["description"]}");
        productsList.add(Product(
            // always initialize the list otherwise noSuchMethodError
            id: id,
            description: value["description"],
            imageUrl: value["imageUrl"],
            price: value["price"],
            title: value["title"],
            isFavorite: favResponseMap == null
                ? false
                : favResponseMap[id] ??
                    false // ?? => checks is the value is null , if it is puts false there
            ));
      });
      _items = productsList;
      notifyListeners();
    } catch (err) {
      print(err);
    }
    return response;
  }
}
