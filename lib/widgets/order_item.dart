import 'package:flutter/material.dart';
import '../providers/orders_provider.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final Orders orderItem;
  OrderItem(this.orderItem);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expandedState = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text("${widget.orderItem.amount}"),
            subtitle: Text(
                "${DateFormat.yMMMd().format(widget.orderItem.timeStamp)}"),
            trailing: _expandedState
                ? IconButton(
                    icon: Icon(Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        _expandedState = !_expandedState;
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.expand_less),
                    onPressed: () {
                      setState(() {
                        _expandedState = !_expandedState;
                      });
                    },
                  ),
          ),
          if (_expandedState)
            Container(
              height: min(
                  widget.orderItem.product.length * 20.toDouble() +
                      100.toDouble(),
                  180),
              child: ListView(
                children: [
                  Text("Title ${widget.orderItem.product}"),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
