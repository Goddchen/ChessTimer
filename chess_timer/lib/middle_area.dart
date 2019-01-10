import 'package:flutter/material.dart';

class MiddleArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InkWell(
          child: SizedBox.fromSize(
            size: Size.square(48),
            child: Icon(Icons.photo_album),
          ),
          onTap: () {},
        ),
        InkWell(
          child: SizedBox.fromSize(
            size: Size.square(48),
            child: Icon(Icons.photo_album),
          ),
          onTap: () {},
        ),InkWell(
          child: SizedBox.fromSize(
            size: Size.square(48),
            child: Icon(Icons.photo_album),
          ),
          onTap: () {},
        ),InkWell(
          child: SizedBox.fromSize(
            size: Size.square(48),
            child: Icon(Icons.photo_album),
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
