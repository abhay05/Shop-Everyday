import 'package:shop_app/providers/product.dart';

import 'package:flutter/material.dart';
import '../screens/edit_item_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class UProductsItem extends StatelessWidget {
  final Product product;
  UProductsItem(this.product);

  @override
  Widget build(BuildContext context) {
    var scaffoldMessenger = ScaffoldMessenger.of(context);
    print(product.id);
    return ListTile(
      minLeadingWidth: 5,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          // Row was causing the has size error, bcz ListTile doesn't restricts it to any size
          // and row takes as much as it wants
          children: [
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditItemScreen.route, arguments: product.id);
                }),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(product.id);
                } catch (err) {
                  // var scaffoldMessenger=ScaffoldMessenger.of(context); -> this code in this catch block
                  // will cause error bcz while resolving error it doesn't exactly know what is the context

                  scaffoldMessenger.showSnackBar(SnackBar(
                    content: Text("Error Occurred"),
                  ));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
