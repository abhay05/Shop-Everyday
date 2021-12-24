import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import './orders_screen.dart';

class CartScreen extends StatelessWidget {
  static const route = '/cart';
  Future<bool> promptUser(BuildContext ctx) {
    //Widget prompt =
    return showDialog(
      // showDialog is not attacted to any context, but needs context of screen
      //showDialog returns Future
      builder: (ctx1) {
        return AlertDialog(
          title: Text("Confirm"),
          content: Text("Do you want to delete this product?"),
          actions: [
            RaisedButton(
              child: Text("Yes"),
              onPressed: () {
                return Navigator.of(ctx1).pop(true);
              },
            ),
            RaisedButton(
                child: Text("No"),
                onPressed: () {
                  return Navigator.of(ctx1).pop(false);
                }),
          ],
        );
      },
      context: ctx,
    );
  }

  @override
  Widget build(BuildContext context) {
    var cartItemsProvider = Provider.of<Cart>(context);
    var cartItems = cartItemsProvider.getCartItems.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Column(
        children: [
          Card(
            child: Row(
              children: [
                Text("Total"),
                Spacer(),
                Chip(
                  label: Text(
                    "\$${cartItemsProvider.getTotalPrice}",
                    style: TextStyle(
                      //backgroundColor: Colors.green,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor:
                      Theme.of(context).primaryColor, //Colors.blueGrey,
                ),
                OrderButton(
                    cartItems: cartItems, cartItemsProvider: cartItemsProvider),
              ],
              //Colors.green,
            ),
          ),

          Card(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    // Text widget takes the size of it's parent
                    "ID",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "Product",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "Quantity",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "Price",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                    child: Chip(
                  label: Text("Cost"),
                )),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              // we can also use ListTile
              //Error -> Vertical viewport was given unbounded height
              // Reason -> Column and GridView/ListView both are scrollable widgets by default
              // Nesting a scrollable widget inside another scrollable widget gives the
              // viewport an unlimited amount of vertical space in which to expand
              // this makes it ambiguous to child scrollable on how to apply scroll property
              // i.e. what fixed does child actually has, using Expanded widget solves this problem
              // bcz takes all the available height.

              itemBuilder: (ctx, ind) {
                var item = cartItems[ind];
                return Dismissible(
                  key:
                      Key(item.itemId), // bcz Dismissable is a statefull widget
                  onDismissed: (DismissDirection dir) {
                    cartItemsProvider.removeItem(item.itemId);
                  },
                  confirmDismiss: (DismissDirection dir) {
                    return promptUser(context);
                  },
                  // confirmDismiss: (DismissDirection dir) {},
                  background: Container(
                    color: Theme.of(context).errorColor,
                    child: Icon(
                      Icons.delete,
                    ),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10),
                  ),
                  direction: DismissDirection.startToEnd,
                  child: Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            // Text widget takes the size of it's parent
                            item.itemId,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item.itemTitle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${item.itemQty}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "\$${item.itemPrice}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                            child: Chip(
                          label: Text("\$${item.itemPrice * item.itemQty}"),
                        )),
                      ],
                    ),
                  ),
                );
              },
              itemCount: cartItems.length,
            ),
          ),
          // Row(
          //   children: [
          //     Spacer(),
          //     FlatButton(
          //       onPressed: () {},
          //       child: Text("Checkout"),

          //       textColor: Theme.of(context).primaryColor, //Colors.green,
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartItems,
    @required this.cartItemsProvider,
  }) : super(key: key);

  final List<CartItem> cartItems;
  final Cart cartItemsProvider;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cartItemsProvider.getTotalPrice <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<OrderProvider>(context, listen: false)
                  .addOrders(
                      widget.cartItems, widget.cartItemsProvider.getTotalPrice);
              setState(() {
                _isLoading = false;
              });
              widget.cartItemsProvider.clearCart();
              //Navigator.pushNamed(context, OrdersScreen.route);
            },
      child: Text("Checkout"),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
