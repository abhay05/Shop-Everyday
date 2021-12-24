import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/orders_provider.dart';
import '../widgets/order_item.dart';
import '../widgets/appdrawer.dart';

class OrdersScreen extends StatefulWidget {
  static const route = '/orders-screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = false;
  Future<void> _orgFuture;
  void getFuture() {
    _orgFuture =
        Provider.of<OrderProvider>(context, listen: false).fetchAndSet();
  }

  @override
  void initState() {
    getFuture(); // runs only once during init, so we will have same even if there is a rebuild
    // i.e. no unnecessary http requests.
    // setState(() {
    //   _isLoading = true;
    // });
    // Future.delayed(Duration(seconds: 0)).then((value) async {
    //   await Provider.of<OrderProvider>(context, listen: false).fetchAndSet();
    //   // since we are using listen:false ; we dont' need to use Future.delayed
    //   // sidenote -> we can't convert initState to async
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }); // runs after super.initState() so context is available
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //var ordersProvider = Provider.of<OrderProvider>(context);
    // since we are listening here this will cause a infinite loop with
    //FutureBuilder waiting again after each rebuild for future to resolve and
    // causing a build after getting new products from server; use consumer instead
    // fetchandSet notify listeners and listener is set here, so we will enter an
    // infinite loop
    //var orders = ordersProvider.getOrders;
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders Screen"),
      ),
      body: FutureBuilder(
        future: _orgFuture,
        builder: (ctx, dataSnapshot) {
          Widget widget;
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            widget = Center(child: CircularProgressIndicator());
          } else if (dataSnapshot.connectionState == ConnectionState.done) {
            if (dataSnapshot.error != null) {
              widget = Center(child: Text("An error occurred"));
            } else {
              widget = Consumer<OrderProvider>(builder: (ctx, provider, child) {
                var orders = provider.getOrders;
                widget = ListView.builder(
                  itemBuilder: (ctx, ind) {
                    return OrderItem(orders[ind]);
                  },
                  itemCount: orders.length,
                );
                return widget;
              });
            }
          }
          return widget;
        },
      ),
      drawer:
          AppDrawer(), // since there is no backbutton as this is the only page in the stack,
      // add a drawer
    );
  }
}
