import 'package:flutter/material.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import '../screens/orders_screen.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xff0F2F57),
        child: Column(
          children: [
            // AppBar(
            //   title: Text("Go To"),
            //   automaticallyImplyLeading:
            //       false, // if you don't want a back button on the widget
            // ),
            Container(
              height: 130,
              child: DrawerHeader(
                padding:
                    EdgeInsets.only(top: 30, bottom: 0, left: 20, right: 0),
                margin: EdgeInsets.all(0),
                child: Container(
                  width: double.infinity,
                  child: Text(
                    "Go To",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.grey,
              ),
              title: Text(
                "Home",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.payment,
                color: Colors.grey,
              ),
              title: Text(
                "Orders",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(OrdersScreen.route);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.shop,
                color: Colors.grey,
              ),
              title: Text(
                "Your Products",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UProductsScreen.route);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.grey,
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onTap: () {
                // Navigator.of(context).pushReplacementNamed(UProductsScreen.route);
                Navigator.of(context).pop();
                Provider.of<AuthProvider>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
