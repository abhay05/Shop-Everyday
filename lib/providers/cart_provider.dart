import 'package:flutter/material.dart';

class CartItem {
  final String itemId;
  final String itemTitle;
  final int itemQty;
  final double itemPrice;

  CartItem({
    @required this.itemId,
    @required this.itemPrice,
    @required this.itemQty,
    @required this.itemTitle,
  });
}

class Cart extends ChangeNotifier {
  Map<String, CartItem> _cartItems = {};
  //int prodCnt = 0;

  Map<String, CartItem> get getCartItems {
    return {..._cartItems};
  }

  int get getCartCnt {
    return _cartItems.length;
  }

  double get getTotalPrice {
    double total = 0;
    _cartItems.forEach(
      (key, value) {
        total += value.itemPrice * value.itemQty;
      },
    );
    return total;
  }

  void addItem(String itemId, String itemTitle, int itemQty, double itemPrice) {
    if (this._cartItems.isNotEmpty && _cartItems.containsKey(itemId)) {
      this._cartItems.update(
          itemId,
          (value) => CartItem(
                itemId: value.itemId,
                itemTitle: value.itemTitle,
                itemQty: itemQty + value.itemQty,
                itemPrice: value.itemPrice,
              ));
    } else {
      this._cartItems.putIfAbsent(
          itemId,
          () => CartItem(
                itemId: itemId,
                itemTitle: itemTitle,
                itemQty: itemQty,
                itemPrice: itemPrice,
              ));
      // prodCnt += 1;
    }
//     The method 'containsKey' was called on null. -> bcz the map is not initialized or the map isempty.
// Receiver: null
    notifyListeners();
  }

  void removeItem(String id) {
    _cartItems.remove(id);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void undoAdd(String id) {
    if (_cartItems.containsKey(id)) {
      if (_cartItems[id].itemQty > 1) {
        _cartItems.update(
            id,
            (item) => CartItem(
                itemId: item.itemId,
                itemPrice: item.itemPrice,
                itemQty: item.itemQty - 1,
                itemTitle: item.itemTitle));
      } else {
        _cartItems.remove(id);
      }
      notifyListeners();
    }
  }
}
