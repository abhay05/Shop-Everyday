import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  int prodCnt;
  Widget child;
  Badge(this.prodCnt, this.child);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              style: BorderStyle.solid,
              width: 1,
              color: Theme.of(context).accentColor,
            ),
            color: Theme.of(context).accentColor,
          ),
          child: Text("${this.prodCnt}",
              style: TextStyle(
                color: Colors.black,
              )),
          margin: EdgeInsets.only(
            top: 5,
            left: 10,
          ),
          padding: EdgeInsets.all(2),
          constraints: BoxConstraints(
            maxHeight: 30,
            maxWidth: 30,
          ),
        ),
      ],
    );
  }
}
