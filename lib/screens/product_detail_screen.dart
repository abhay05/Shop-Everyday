import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/product.dart';

class ProductDetail extends StatelessWidget {
  static const route = '/product-detail';

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments as String;
    var item = Provider.of<Products>(context, listen: false).getItemById(id);
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color(0xff0F2F57), //Color(0xFF091C34),
      //   elevation: 0,
      // ),
      // slivers -> widgets that are scrollable
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Color(0xff0F2F57),
            elevation: 0,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Stack(
                  children: [
                    Container(
                      child: Hero(
                        tag: id,
                        child: Image.network(
                          item.imageUrl,
                        ),
                      ),
                    ),

                    // SizedBox(height: 10),
                    // Text(item.title),
                    // SizedBox(height: 10),
                    // Text("\$${item.price}"),
                    // SizedBox(height: 10),
                    // Text(item.description),

                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 30,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                            //child: Text("gjgj"),
                            ),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 20,
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Center(child: Text("\$${item.price}")),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 10,
                            left: 10,
                          ),
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                        Container(
                          child: Container(
                            margin: EdgeInsets.only(
                              bottom: 10,
                              left: 10,
                            ),
                            child: Text(
                              item.description,
                              style: TextStyle(
                                height: 2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Column(
      //   children: [
      //     Stack(
      //       children: [
      //         Container(
      //           child: Hero(
      //             tag: id,
      //             child: Image.network(
      //               item.imageUrl,
      //             ),
      //           ),
      //         ),

      //         // SizedBox(height: 10),
      //         // Text(item.title),
      //         // SizedBox(height: 10),
      //         // Text("\$${item.price}"),
      //         // SizedBox(height: 10),
      //         // Text(item.description),

      //         Positioned(
      //           bottom: 0,
      //           child: Container(
      //             height: 30,
      //             width: screenWidth,
      //             decoration: BoxDecoration(
      //               color: Colors.white,
      //               borderRadius: BorderRadius.only(
      //                 topLeft: Radius.circular(20),
      //                 topRight: Radius.circular(20),
      //               ),
      //             ),
      //             child: Center(
      //                 //child: Text("gjgj"),
      //                 ),
      //           ),
      //         ),
      //         Positioned(
      //           bottom: 5,
      //           right: 20,
      //           child: Container(
      //             height: 60,
      //             width: 60,
      //             decoration: BoxDecoration(
      //               color: Colors.green,
      //               shape: BoxShape.circle,
      //             ),
      //             child: Center(child: Text("\$${item.price}")),
      //           ),
      //         ),
      //       ],
      //     ),
      //     Expanded(
      //       child: Container(
      //         width: double.infinity,
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //         ),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Container(
      //               margin: EdgeInsets.only(
      //                 bottom: 10,
      //                 left: 10,
      //               ),
      //               child: Text(
      //                 item.title,
      //                 style: TextStyle(
      //                   fontSize: 25,
      //                 ),
      //               ),
      //             ),
      //             Expanded(
      //               child: Container(
      //                 margin: EdgeInsets.only(
      //                   bottom: 10,
      //                   left: 10,
      //                 ),
      //                 child: Text(
      //                   item.description,
      //                   style: TextStyle(
      //                     height: 1.5,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
