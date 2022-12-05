import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final color;
  final child;
  final function;

  MyButton({this.color, this.child, this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(1),
        child: GestureDetector(
          onTap: function,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
                color: color,
                height: 50,
                width: 50,
                child: Center(
                  child: child,
                )),
          ),
        ));
  }
}
