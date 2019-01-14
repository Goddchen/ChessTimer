import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'localizations.dart';

class PlayersArea extends StatelessWidget {
  final Function clickedCallback;
  final bool _isActive;
  final num _timeSeconds;
  final int _gameTimeSeconds;
  final int _turnCounter;
  final int _playerTimeSeconds;

  const PlayersArea(
      {Key key,
      this.clickedCallback,
      isActive,
      time,
      gameTime,
      turnCounter,
      playerTimeSeconds})
      : _isActive = isActive,
        _timeSeconds = time,
        _gameTimeSeconds = gameTime,
        _turnCounter = turnCounter,
        _playerTimeSeconds = playerTimeSeconds,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    double avgTurnTime =
        (_turnCounter ?? 0) == 0 || (_playerTimeSeconds ?? 0) == 0
            ? 0
            : _playerTimeSeconds / _turnCounter;
    return Container(
      constraints: BoxConstraints.expand(),
      child: RaisedButton(
        padding: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: _isActive ? Colors.green[300] : Colors.grey[400],
        onPressed: () => clickedCallback(),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                '${NumberFormat('00').format(((_timeSeconds ?? 10) / 60).floor())}:${NumberFormat('00').format(((_timeSeconds ?? 10) % 60))}',
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
                  '${NumberFormat('00').format(((_timeSeconds ?? 10) / 60).floor())}:${NumberFormat('00').format(((_timeSeconds ?? 10) % 60))}',
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
                    '${NumberFormat('00').format(((_gameTimeSeconds ?? 0) / 60).floor())}: ' +
                    '${NumberFormat('00').format(((_gameTimeSeconds ?? 0) % 60))}\n' +
                    '${AppLocalizations.of(context).get('turns')}: ${_turnCounter ?? 0}\n' +
                    '${AppLocalizations.of(context).get('avg_turn')}: ${NumberFormat('0.0').format(avgTurnTime)}s',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
