import 'package:flutter/material.dart';
import 'players_area.dart';
import 'middle_area.dart';
import 'dart:math';
import 'package:quiver/async.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChessTimerState();
}

class _ChessTimerState extends State<MyApp> {
  static int _turnTimeSeconds = 10;
  int _playerAtTurn = 0;
  var _playersTime = [0, _turnTimeSeconds, _turnTimeSeconds]; // 0 is for pause
  CountdownTimer _timer;

  void setPlayerAtTurn(int triggeringPlayer) {
      setState(() {
        if (_playerAtTurn == 0) {
          _playerAtTurn = triggeringPlayer;
        } else {
          _playersTime[_playerAtTurn] += _turnTimeSeconds;
          _playerAtTurn = triggeringPlayer == 1 ? 2 : 1;
        }
      });
  }

  void startTimerForCurrentPlayer() {
    _timer?.cancel();
      _timer = CountdownTimer(
          Duration(seconds: _playersTime[_playerAtTurn], milliseconds: 500), Duration(seconds: 1));
      _timer.listen((timer) {
        setState(() {
          _playersTime[_playerAtTurn] = timer.remaining.inSeconds;
        });
      });
  }

  void playerStopped(int triggeringPlayer) {
    if (_playerAtTurn == triggeringPlayer || _playerAtTurn == 0) {
      setPlayerAtTurn(triggeringPlayer);
      startTimerForCurrentPlayer();
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
                          time: _playersTime[1],
                          clickedCallback: () => playerStopped(1),
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
                        time: _playersTime[2],
                        clickedCallback: () => playerStopped(2),
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
