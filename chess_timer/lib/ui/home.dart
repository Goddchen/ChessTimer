import 'dart:async';
import 'dart:math';
import 'package:chess_timer/blocs/bloc.dart';
import 'package:chess_timer/blocs/state.dart';
import 'package:chess_timer/common/app_colors.dart';
import 'package:chess_timer/model/player.dart';
import 'package:chess_timer/ui/players_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock/wakelock.dart';
import 'middle_area.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;
  double _playerScale = 1;

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
          _playerScale = animation.value;
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
    Wakelock.enable();
  }

  @override
  void dispose() {
    animationController.dispose();
    _animationSubscription?.cancel();
    BlocProvider.of<ChessTimerBloc>(context).dispose();
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ));
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: BlocBuilder<ChessTimerBloc, ChessTimerState>(
            builder: (context, state) {
          int gameTimeSeconds = state.playerOne.totalTimeSeconds +
              state.playerTwo.totalTimeSeconds;
          return Column(
            children: <Widget>[
              buildPlayersArea(
                player: state.playerOne,
                gameTimeSeconds: gameTimeSeconds,
              ),
              MiddleArea(
                bloc: BlocProvider.of<ChessTimerBloc>(context),
                isRunning: state.playerOne.timerIsRunning ||
                    state.playerTwo.timerIsRunning,
              ),
              buildPlayersArea(
                player: state.playerTwo,
                gameTimeSeconds: gameTimeSeconds,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget buildPlayersArea({PlayerState player, int gameTimeSeconds}) {
    return Expanded(
      child: Transform.rotate(
        angle: player.id == PLAYER_ID.TWO ? 0 : pi,
        child: Container(
          margin: EdgeInsets.all(8),
          child: Transform.scale(
            scale: player.timerIsRunning ? _playerScale : 1,
            child: PlayersArea(
              player: player,
              gameTimeSeconds: gameTimeSeconds,
            ),
          ),
        ),
      ),
    );
  }
}
