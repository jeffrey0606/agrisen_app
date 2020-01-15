import 'package:flutter/material.dart';

class MyCustomBadge extends StatelessWidget {
  final Color color;
  final Widget child;
  final String value;

  MyCustomBadge(
      {Key key, @required this.child, this.color, @required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        child,
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(2),
            constraints: BoxConstraints(minHeight: 14, minWidth: 14),
            decoration: BoxDecoration(
                color: color == null ? Theme.of(context).accentColor : color,
                borderRadius: BorderRadius.circular(6)),
            child:
                FittedBox(child: Text(value,textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: Colors.white))),
          ),
        )
      ],
    );
  }
}
