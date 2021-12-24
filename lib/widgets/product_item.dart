import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var product = Provider.of<Product>(context, listen: false);
    var auth = Provider.of<AuthProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Card(
        //  shape:ShapeBorder.lerp(a, b, t)
        elevation: 10,
        color: Color(0xffEEF4FC), //Color(0xFFe34039),
        child: Column(
          children: [
            Expanded(
              child: GridTile(
                child: Container(
                  width: double.infinity,
                  //height: 200,
                  margin: EdgeInsets.all(2),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (ctx) => ProductDetail(this.price),
                      //   ),
                      // );
                      Navigator.of(context).pushNamed(ProductDetail.route,
                          arguments: product.id);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Hero(
                        tag: product.id,
                        child: FadeInImage.assetNetwork(
                          placeholder: "assets/images/placeholder.jpg",
                          image: product.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                // footer: GridTileBar(
                //   leading: Consumer<Product>(
                //     //Consumer can be used instead of Provider.of or it can be used
                //     //with Provider.of to build complete widget initially and only part
                //     // of that widget in successive builds.
                //     builder: (ctx, product, child) => IconButton(
                //       icon: product.isFavorite
                //           ? Icon(Icons.favorite)
                //           : Icon(Icons.favorite_border),
                //       color: Theme.of(context).accentColor,
                //       onPressed: () async {
                //         await product.toggleFavorite(auth.token, auth.userId);
                //         print("done");
                //       },
                //     ),
                //   ),
                //   title: Text(product.title),
                //   trailing: Consumer<Cart>(
                //     builder: (ctx, cart, child) => IconButton(
                //       icon: Icon(Icons.shopping_cart),
                //       color: Theme.of(context).accentColor,
                //       onPressed: () {
                //         cart.addItem(
                //             product.id, product.title, 1, product.price);
                //         ScaffoldMessenger.of(context)
                //             .hideCurrentSnackBar(); // to hide current snackbar
                //         // as soon as the next snackbar triggers
                //         // is usefull when two items are added to cart in
                //         //quick succession
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           SnackBar(
                //             content: Text("Item added to cart"),
                //             duration: Duration(seconds: 2),
                //             action: SnackBarAction(
                //               label: "Undo",
                //               onPressed: () {
                //                 cart.undoAdd(product.id);
                //               },
                //             ),
                //           ),
                //         );
                //       },
                //     ),
                //   ),
                //   backgroundColor: Colors.black54,
                // ),
              ),
            ),
            Container(
              height: 40,
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
                    child: Consumer<Product>(
                      //Consumer can be used instead of Provider.of or it can be used
                      //with Provider.of to build complete widget initially and only part
                      // of that widget in successive builds.
                      builder: (ctx, product, child) => IconButton(
                        icon: product.isFavorite
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                        color:
                            Color(0xff2C69C3), //Theme.of(context).accentColor,
                        onPressed: () async {
                          await product.toggleFavorite(auth.token, auth.userId);
                          print("done");
                        },
                      ),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    product.title,
                    style: TextStyle(
                      color: Color(0xff2C69C3), //Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                    child: Consumer<Cart>(
                      builder: (ctx, cart, child) => IconButton(
                        icon: Icon(Icons.shopping_cart),
                        color:
                            Color(0xff2C69C3), //Theme.of(context).accentColor,
                        onPressed: () {
                          cart.addItem(
                              product.id, product.title, 1, product.price);
                          ScaffoldMessenger.of(context)
                              .hideCurrentSnackBar(); // to hide current snackbar
                          // as soon as the next snackbar triggers
                          // is usefull when two items are added to cart in
                          //quick succession
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Item added to cart"),
                              duration: Duration(seconds: 2),
                              action: SnackBarAction(
                                label: "Undo",
                                onPressed: () {
                                  cart.undoAdd(product.id);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
