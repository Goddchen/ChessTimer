import 'package:flutter/material.dart';
import 'players_area.dart';
import 'middle_area.dart';
import 'dart:math';
import 'package:quiver/async.dart';
import 'package:flutter/animation.dart';
import 'package:preferences/preferences.dart';

void main() async {
  await PrefService.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChessTimerState();
}

class ChessTimerState extends State<MyApp>
    with SingleTickerProviderStateMixin {
  int _turnTimeSeconds;
  int _playerAtTurn = 0;
  var _playersTime = [0, 0, 0];
  var _playerScale = [0, 1.0, 1.0];
  CountdownTimer _timer;
  Animation<double> animation;
  AnimationController animationController;

  void setNewTurnTime(int timeInSeconds) {
    setState(() {
          _turnTimeSeconds = timeInSeconds;
          _playersTime = [0, _turnTimeSeconds, _turnTimeSeconds];
        });
  }

  void _setPlayerAtTurn(int triggeringPlayer) {
    setState(() {
      if (_playerAtTurn == 0) {
        _playerAtTurn = triggeringPlayer;
      } else {
        _playersTime[_playerAtTurn] += _turnTimeSeconds;
        _playerAtTurn = triggeringPlayer == 1 ? 2 : 1;
      }
    });
  }

  void _startTimerForCurrentPlayer() {
    _timer?.cancel();
    _timer = CountdownTimer(
        Duration(seconds: _playersTime[_playerAtTurn], milliseconds: 500),
        Duration(seconds: 1));
    _timer.listen((timer) {
      setState(() {
        _playersTime[_playerAtTurn] = timer.remaining.inSeconds;
      });
      if (timer.remaining.inMilliseconds > 0 && timer.remaining.inSeconds < 5)
        _startAnimation();
    });
  }

  void _playerStopped(int triggeringPlayer) {
    if (_playerAtTurn == triggeringPlayer || _playerAtTurn == 0) {
      _setPlayerAtTurn(triggeringPlayer);
      _startTimerForCurrentPlayer();
    }
  }

  void _startAnimation() {
    animationController.reset();
    animationController.forward();
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      }
    });
  }

  void _initAnimations() {
    animationController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    animation = Tween(begin: 1.0, end: 0.95).animate(animationController)
      ..addListener(() {
        setState(() {
          _playerScale.asMap().forEach((index, value) {
            _playerScale[index] =
                index == _playerAtTurn ? animation.value : 1.0;
          });
        });
      });
  }

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _turnTimeSeconds = PrefService.getInt('turn_time');
    _playersTime = [0, _turnTimeSeconds, _turnTimeSeconds];
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
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
                        child: Transform.scale(
                          scale: _playerScale[1],
                          child: PlayersArea(
                            isActive: _playerAtTurn == 1,
                            time: _playersTime[1],
                            clickedCallback: () => _playerStopped(1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  MiddleArea(),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Transform.scale(
                        scale: _playerScale[2],
                        child: PlayersArea(
                          isActive: _playerAtTurn == 2,
                          time: _playersTime[2],
                          clickedCallback: () => _playerStopped(2),
                        ),
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
