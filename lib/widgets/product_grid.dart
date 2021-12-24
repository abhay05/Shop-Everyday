import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import '../providers/product.dart';
import './product_item.dart';
import '../providers/product_provider.dart';

class ProductGrid extends StatelessWidget {
  bool _isFavorites;
  ProductGrid(this._isFavorites);
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    // print("is favorites: ${_isFavorites}");
    final productData = Provider.of<Products>(context);
    final items =
        _isFavorites ? productData.getFavoriteItems : productData.getItems;
    return Stack(
      children: [
        Container(
          color: Color(0xfb2e1),
          height: deviceSize.height,
          width: deviceSize.width,
        ),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1 / 1),
          itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
            value: items[
                index], // we are providing this product to the ProductItem widget
            // when not instantiating i.e. using direct value, use ChangeNotifierProvider.value
            child: ProductItem(),
          ),
          itemCount: items.length,
        ),
      ],
    );
  }
}
