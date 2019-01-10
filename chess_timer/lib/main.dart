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
              color: Colors.red,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: PlayersArea(),
                  ),
                  MiddleArea(),
                  Expanded(
                    child: Transform.rotate(
                      angle: pi,
                      child: PlayersArea(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
