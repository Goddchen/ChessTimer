import 'package:chess_timer/blocs/bloc.dart';
import 'package:chess_timer/blocs/events.dart';
import 'package:chess_timer/blocs/state.dart';
import 'package:chess_timer/common/app_colors.dart';
import 'package:chess_timer/common/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class PlayersArea extends StatelessWidget {
  final PlayerState _player;
  final int _gameTimeSeconds;

  const PlayersArea({
    PlayerState player,
    int gameTimeSeconds,
  })  : _player = player,
        _gameTimeSeconds = gameTimeSeconds;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: RaisedButton(
        padding: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: _player.timerIsRunning
            ? AppColors.player_area_active
            : AppColors.player_area_inactive,
        onPressed: () => BlocProvider.of<ChessTimerBloc>(context)
            .add(PlayerStoppedEvent(_player.id)),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                playerLeftTime(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 64,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Transform.rotate(
                angle: pi,
                child: Text(
                  playerLeftTime(),
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                '${AppLocalizations.of(context).get('total_time')}: ' +
                    '${NumberFormat('00').format(((_gameTimeSeconds ?? 0) / 60).floor())}:' +
                    '${NumberFormat('00').format(((_gameTimeSeconds ?? 0) % 60))}\n' +
                    '${AppLocalizations.of(context).get('turns')}: ${_player.numberOfTurns ?? 0}\n' +
                    '${AppLocalizations.of(context).get('avg_turn')}: ${NumberFormat('0.0').format(_player.averageTurnSeconds)}s',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String playerLeftTime() {
    int minutesLeft = ((_player.turnTimeLeft ?? 10) / 60).floor();
    int secondsLeft = ((_player.turnTimeLeft ?? 10) % 60);
    return '${_formatTimeLeft(minutesLeft)}:${_formatTimeLeft(secondsLeft)}';
  }

  String _formatTimeLeft(int timeLeft) {
    return NumberFormat('00').format(timeLeft);
  }
}
