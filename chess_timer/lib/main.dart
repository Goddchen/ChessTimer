import 'package:flutter/material.dart';
import 'players_area.dart';
import 'middle_area.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chess Timer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SafeArea(
          child: Material(
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Transform.rotate(
                      angle: pi,
                      child: Container(
                        margin: EdgeInsets.all(8),
                        child: PlayersArea(
                          f: () => debugPrint("Clicked"),
                        ),
                      ),
                    ),
                  ),
                  MiddleArea(),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: PlayersArea(
                        f: () => debugPrint("Clicked"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
