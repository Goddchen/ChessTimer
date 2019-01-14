import 'package:flutter/material.dart';
import 'players_area.dart';
import 'middle_area.dart';
import 'dart:math';
import 'package:quiver/async.dart';
import 'package:flutter/animation.dart';
import 'package:preferences/preferences.dart';
import 'package:vibrate/vibrate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localizations.dart';
import 'package:screen/screen.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  await PrefService.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChessTimerState();
}

class ChessTimerState extends State<MyApp> with SingleTickerProviderStateMixin {
  static final defaultPlayersTime = 20;

  int _turnTimeSeconds;
  int _playerAtTurn = 0;
  var _playersTime = [0, 0, 0];
  var _playerScale = [0, 1.0, 1.0];
  int _turnCounter;
  CountdownTimer _timer;
  Stopwatch _stopwatch = Stopwatch();
  Animation<double> animation;
  AnimationController animationController;

  void reset() {
    setState(() {
      _timer?.cancel();
      _playerAtTurn = 0;
      _turnTimeSeconds = PrefService.getInt('turn_time') ?? defaultPlayersTime;
      _playersTime = [0, _turnTimeSeconds, _turnTimeSeconds];
      _turnCounter = 0;
      _stopwatch?.reset();
    });
  }

  void setNewTurnTime(int timeInSeconds) {
    setState(() {
      _turnTimeSeconds = timeInSeconds;
      _playersTime = [0, _turnTimeSeconds, _turnTimeSeconds];
    });
  }

  void pause() {
    _stopwatch?.stop();
    if (_timer?.isRunning == true) {
      _timer.cancel();
      setState(() {});
    }
  }

  void resume() {
    _stopwatch?.start();
    if (_timer?.isRunning == false) {
      _startTimerForCurrentPlayer();
    }
  }

  void _setPlayerAtTurn(int triggeringPlayer) {
    setState(() {
      if (_playerAtTurn == 0) {
        _playerAtTurn = triggeringPlayer;
        _turnCounter = 0;
        _stopwatch?.reset();
      } else {
        _playersTime[_playerAtTurn] += _turnTimeSeconds;
        _playerAtTurn = triggeringPlayer == 1 ? 2 : 1;
        _turnCounter++;
      }
    });
  }

  void _startTimerForCurrentPlayer() {
    _timer?.cancel();
    _timer = CountdownTimer(
      Duration(seconds: _playersTime[_playerAtTurn], milliseconds: 500),
      Duration(seconds: 1),
    );
    _timer.listen((timer) {
      if (!timer.remaining.isNegative) {
        setState(() {
          _playersTime[_playerAtTurn] = timer.remaining.inSeconds;
        });
        if (timer.remaining.inMilliseconds > 0 &&
            timer.remaining.inSeconds < 5) {
          if (PrefService.getBool('animate_last_seconds') ?? true) {
            _startAnimation();
          }
          if (PrefService.getBool('vibrate_last_seconds') ?? true) {
            Vibrate.feedback(FeedbackType.medium);
          }
        }
        if (timer.remaining.inSeconds == 0) {
          if (PrefService.getBool('vibrate_on_time_up') ?? true) {
            Vibrate.feedback(FeedbackType.error);
          }
        }
      }
    });
    _stopwatch.start();
  }

  void _playerStopped(int triggeringPlayer) {
    if (_playerAtTurn == triggeringPlayer || _playerAtTurn == 0) {
      _setPlayerAtTurn(triggeringPlayer);
      _startTimerForCurrentPlayer();
      if (PrefService.getBool('vibrate_on_end') == true) {
        Vibrate.feedback(FeedbackType.heavy);
      }
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
    _turnTimeSeconds = PrefService.getInt('turn_time') ?? defaultPlayersTime;
    _playersTime = [0, _turnTimeSeconds, _turnTimeSeconds];
    Screen.keepOn(true);
    Timer.periodic(Duration(milliseconds: 500), (timer) => setState(() {}));
  }

  @override
  void dispose() {
    animationController.dispose();
    Screen.keepOn(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('de'),
        ],
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
                            gameTime: _stopwatch.elapsed.inSeconds,
                            turnCounter: _turnCounter,
                          ),
                        ),
                      ),
                    ),
                  ),
                  MiddleArea(_stopwatch?.isRunning == true),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Transform.scale(
                        scale: _playerScale[2],
                        child: PlayersArea(
                          isActive: _playerAtTurn == 2,
                          time: _playersTime[2],
                          clickedCallback: () => _playerStopped(2),
                          gameTime: _stopwatch.elapsed.inSeconds,
                          turnCounter: _turnCounter,
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
