import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/appdrawer.dart';
import '../providers/product_provider.dart';
import '../widgets/user_products_item.dart';
import './edit_item_screen.dart';

class UProductsScreen extends StatelessWidget {
  static const route = '/user-products';

  Future<void> _loadProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchProducts(load: true);
  }

  @override
  Widget build(BuildContext context) {
    //var productsProvider = Provider.of<Products>(context);
    //var products = productsProvider.getItems;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditItemScreen.route);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _loadProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () {
                  // or () => _loadProducts(context)
                  return _loadProducts(context);
                  // return;
                },
                child: Consumer<Products>(
                  builder: (ctx, productProvider, _) => Column(
                    children: [
                      Expanded(
                        // Incorrect use of ParentDataWidget. -> Expanded widget must be a descendent of row,column,flex widgets
                        child: ListView.builder(
                          itemBuilder: (ctx, ind) {
                            return UProductsItem(productProvider.getItems[ind]);
                          },
                          itemCount: productProvider.getItems.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      drawer: AppDrawer(),
    );
  }
}
