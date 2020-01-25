import 'package:chess_timer/blocs/bloc.dart';
import 'package:chess_timer/blocs/events.dart';
import 'package:chess_timer/common/localizations.dart';
import 'package:chess_timer/model/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class PlayersArea extends StatelessWidget {
  final Player _player;
  final int _gameTimeSeconds;

  const PlayersArea({
    Key key,
    Player player,
    int gameTimeSeconds,
  })  : _player = player,
        _gameTimeSeconds = gameTimeSeconds,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: RaisedButton(
        padding: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: _player.timerIsRunning ? Colors.green[300] : Colors.grey[400],
        onPressed: () => BlocProvider.of<ChessTimerBloc>(context)
            .add(PlayerStoppedEvent(_player.id)),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                '${NumberFormat('00').format(((_player.turnTimeLeft ?? 10) / 60).floor())}:${NumberFormat('00').format(((_player.turnTimeLeft ?? 10) % 60))}',
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
                  '${NumberFormat('00').format(((_player.turnTimeLeft ?? 10) / 60).floor())}:${NumberFormat('00').format(((_player.turnTimeLeft ?? 10) % 60))}',
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
}