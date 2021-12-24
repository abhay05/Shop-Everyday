import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/product_provider.dart';
import './screens/cart_screen.dart';
import './providers/cart_provider.dart';
import './providers/orders_provider.dart';
import './screens/edit_item_screen.dart';
import './providers/auth.dart';
import 'package:global_configuration/global_configuration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_settings");
  runApp(ShopApp());
}

class ShopApp extends StatelessWidget {
  Map<int, Color> color = {
    50: Color.fromRGBO(227, 82, 75, .1),
    100: Color.fromRGBO(227, 82, 75, .2),
    200: Color.fromRGBO(227, 82, 75, .3),
    300: Color.fromRGBO(227, 82, 75, .4),
    400: Color.fromRGBO(227, 82, 75, .5),
    500: Color.fromRGBO(227, 82, 75, .6),
    600: Color.fromRGBO(227, 82, 75, .7),
    700: Color.fromRGBO(227, 82, 75, .8),
    800: Color.fromRGBO(227, 82, 75, .9),
    900: Color.fromRGBO(227, 82, 75, 1),
  };

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, Products>(
          create: (_) => Products(),
          update: (ctx, authProvider, prevProvider) => Products.already(
              authProvider.userId,
              authProvider.token,
              prevProvider == null ? [] : prevProvider.getItems),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
            create: (ctx) => OrderProvider(),
            update: (ctx, authProvider, prevOrderProvider) =>
                OrderProvider.already(
                    authProvider.userId,
                    authProvider.token,
                    prevOrderProvider == null
                        ? []
                        : prevOrderProvider.getOrders)),
      ], // providers don't cause rebuilds, listeners cause rebuilds
      child: MaterialApp(
          title: "Shop App",
          theme: ThemeData(
            primarySwatch: MaterialColor(0xFFe34039, color),
            accentColor: Colors.white,
            fontFamily: 'Lato',
          ),
          home: Consumer<AuthProvider>(
            builder: (context, authProvider, _) => authProvider.validToken
                ? ProductsOverview()
                : FutureBuilder(
                    future: authProvider.autoLogin(),
                    builder: (ctx, authSnapshot) =>
                        authSnapshot.connectionState == ConnectionState.waiting
                            ? Scaffold(
                                body: Center(
                                  child: Text("Few moments..."),
                                ),
                              )
                            : AuthScreen(),
                  ),
          ), //ProductsOverview(),
          // initialRoute: '/',
          routes: {
            // '/': (ctx) => ProductsOverview(),
            ProductDetail.route: (ctx) => ProductDetail(),
            CartScreen.route: (ctx) => CartScreen(),
            OrdersScreen.route: (ctx) => OrdersScreen(),
            UProductsScreen.route: (cts) => UProductsScreen(),
            EditItemScreen.route: (ctx) => EditItemScreen(),
          }),
    );
  }
}
