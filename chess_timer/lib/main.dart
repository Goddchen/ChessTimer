import 'package:flutter/material.dart';
import 'players_area.dart';
import 'middle_area.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
    State<StatefulWidget> createState() => _ChessTimerState();
}

class _ChessTimerState extends State<MyApp> {
  int _playerAtTurn = 0;
  var _playersTime = [0, 10, 10];  // 0 is for pause
  
  void firstPlayerStarted(int remainingTime) {
    if (_playerAtTurn != 1) {
      debugPrint("First Player started");
      setState(() {
        _playersTime[_playerAtTurn] = remainingTime;
        _playerAtTurn = 1;
      });
    }
  }

  void secondPlayerStarted(int remainingTime) {
    if (_playerAtTurn != 2) {
      debugPrint("Second Player started");
      setState(() {
        _playersTime[_playerAtTurn] = remainingTime;
        _playerAtTurn = 2;
      });
    }
  }

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
                          isActive: _playerAtTurn == 1,
                          playersTimeStart: _playersTime[1],
                          clickedCallback: firstPlayerStarted,
                        ),
                      ),
                    ),
                  ),
                  MiddleArea(),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: PlayersArea(
                        isActive: _playerAtTurn == 2,
                        playersTimeStart: _playersTime[2],
                        clickedCallback: secondPlayerStarted,
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
