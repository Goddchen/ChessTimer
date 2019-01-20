import 'package:flutter/material.dart';
import 'package:chess_timer/players_area.dart';
import 'package:chess_timer/middle_area.dart';
import 'dart:math';
import 'package:flutter/animation.dart';
import 'package:preferences/preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:chess_timer/localizations.dart';
import 'package:screen/screen.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:chess_timer/blocs/bloc.dart';
import 'package:chess_timer/interfaces.dart';
import 'package:soundpool/soundpool.dart';

void main() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  await PrefService.init();
  BlocSupervisor().delegate = LogAllBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: ChessTimerBloc(PrefServiceImpl(),
          Soundpool(streamType: StreamType.music), rootBundle, VibrateImpl()),
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('de'),
        ],
        title: AppLocalizations.of(context)?.get('app_name') ?? 'Chess Timer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainWidget(),
      ),
    );
  }
}

class MainWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainState();
}

class MainState extends State<MainWidget> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;

  List<double> _playerScale = [0.0, 1.0, 1.0];
  StreamSubscription _animationSubscription;

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
            _playerScale[index] = index ==
                    BlocProvider.of<ChessTimerBloc>(context)
                        .currentState
                        .playerAtTurn
                ? animation.value
                : 1.0;
          });
        });
      });
    _animationSubscription = BlocProvider.of<ChessTimerBloc>(context)
        .animationStream
        .listen((_) => _startAnimation());
  }

  @override
  void initState() {
    super.initState();
    _initAnimations();
    Screen.keepOn(true);
  }

  @override
  void dispose() {
    animationController.dispose();
    _animationSubscription?.cancel();
    BlocProvider.of(context).dispose();
    Screen.keepOn(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Material(
          child: Container(
            child: BlocBuilder<ChessTimerEvent, ChessTimerState>(
              bloc: BlocProvider.of<ChessTimerBloc>(context),
              builder: (context, state) => Column(
                    children: <Widget>[
                      Expanded(
                        child: Transform.rotate(
                          angle: pi,
                          child: Container(
                            margin: EdgeInsets.all(8),
                            child: Transform.scale(
                              scale: _playerScale[1],
                              child: PlayersArea(
                                isActive: state.playerAtTurn == 1,
                                time: state.playerTime[1],
                                clickedCallback: () =>
                                    BlocProvider.of<ChessTimerBloc>(context)
                                        .dispatch(PlayerStoppedEvent(1)),
                                gameTime: state.stopwatches
                                    .map((sw) => sw.elapsed.inSeconds)
                                    .reduce((a, b) => a + b),
                                turnCounter: state.turnCounter[1],
                                playerTimeSeconds:
                                    state.stopwatches[1].elapsed.inSeconds,
                              ),
                            ),
                          ),
                        ),
                      ),
                      MiddleArea(
                        state.stopwatches.any((sw) => sw.isRunning) == true,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: Transform.scale(
                            scale: _playerScale[2],
                            child: PlayersArea(
                              isActive: state.playerAtTurn == 2,
                              time: state.playerTime[2],
                              clickedCallback: () =>
                                  BlocProvider.of<ChessTimerBloc>(context)
                                      .dispatch(PlayerStoppedEvent(2)),
                              gameTime: state.stopwatches
                                  .map((sw) => sw.elapsed.inSeconds)
                                  .reduce((a, b) => a + b),
                              turnCounter: state.turnCounter[2],
                              playerTimeSeconds:
                                  state.stopwatches[2].elapsed.inSeconds,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
            ),
          ),
        ),
      );
}
