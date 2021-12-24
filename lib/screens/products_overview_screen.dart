import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import '../widgets/product_grid.dart';
import '../widgets/product_item.dart';
import 'package:flutter/foundation.dart';
import './cart_screen.dart';
import '../widgets/badge.dart';
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';
import './orders_screen.dart';
import '../widgets/appdrawer.dart';
import '../providers/product_provider.dart';

enum ProductSelection {
  ShowAll,
  OnlyFavorites,
}

class ProductsOverview extends StatefulWidget {
  static const String route = "/products-overview";
  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  bool _isFavorites = false;
  bool _initDone = false;
  bool _isLoading = false;

  void initState() {
    //Provider.of<Products>(context, listen: false).fetchProducts();
    // if listen:false, Provider can be used in init too.
    // Future.delayed(Duration.zero).then(_){
    //   Provider.of<Products>(context).fetchProducts()
    // }):
    //Future.delayed put the task in to do list even if wait time is zero, so
    // first init is done and then fetchProducts is called.
    super.initState();
  }

  void didChangeDependencies() {
    if (!_initDone) {
      Provider.of<Products>(context).fetchProducts().then((response) {
        // print(response.body);
        setState(() {
          _isLoading = false;
        });
      });
      setState(() {
        _isLoading = true;
      });
    }
    _initDone = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffDCE9F9),
      appBar: AppBar(
        backgroundColor: Color(0xff0F2F57), //Color(0xFF091C34),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xff0F2F57), //Color(0xFF091C34),
              //border:Border(left:20),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(40),
                bottomLeft: Radius.circular(40),
              ),
            ),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: EdgeInsets.all(20),
                        child: Text(
                          "Shop Everyday",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, CartScreen.route);
                          },
                          child: Consumer<Cart>(
                            builder: (ctx, cart, child) =>
                                Badge(cart.getCartCnt, child),
                            child: Container(
                                // helps to avoid constand part from rebuilt
                                margin: EdgeInsets.only(top: 16),
                                child: Icon(
                                  Icons.shopping_cart,
                                  color: Color(
                                      0xffA3A691), //Color(0xff5F97F1), //,Colors.white,
                                )),
                          ),
                        ),
                        PopupMenuButton(
                          onSelected: (ProductSelection selectedValue) {
                            if (selectedValue == ProductSelection.ShowAll) {
                              // print("Show all");
                              setState(() {
                                _isFavorites = false;
                              });
                              // print(_isFavorites);
                            } else {
                              // print("Favorites");
                              setState(() {
                                _isFavorites = true;
                              });
                              // print(_isFavorites);
                            }
                          },
                          icon: Icon(
                            Icons.more_vert,
                            color: Color(
                                0xffA3A691), //Color(0xff5F97F1), //Colors.white
                          ),
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              child: Text("Show All"),
                              value: ProductSelection.ShowAll,
                            ),
                            PopupMenuItem(
                              child: Text("Only Favorites"),
                              value: ProductSelection.OnlyFavorites,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    margin: EdgeInsets.only(
                      top: 10,
                    ),
                    child: ProductGrid(_isFavorites)),
          ),
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
