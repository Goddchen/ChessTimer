import 'package:flutter/material.dart';
import 'settings.dart';

class MiddleArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InkWell(
          child: Icon(
            Icons.settings,
            size: 48,
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsWidget()));
          },
        ),
      ],
    );
  }
}
