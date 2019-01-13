import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class PlayersArea extends StatelessWidget {
  final Function clickedCallback;
  final bool _isActive;
  final num _timeSeconds;
  final int _gameTimeSeconds;
  final int _turnCounter;

  const PlayersArea(
      {Key key, this.clickedCallback, isActive, time, gameTime, turnCounter})
      : _isActive = isActive,
        _timeSeconds = time,
        _gameTimeSeconds = gameTime,
        _turnCounter = turnCounter,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    double avgTurnTime =
        _turnCounter == 0 ? 0 : _gameTimeSeconds / _turnCounter;
    return Container(
      constraints: BoxConstraints.expand(),
      child: MaterialButton(
        color: _isActive ? Colors.lightBlue : Colors.grey,
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
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Text(
                    '${NumberFormat('00').format(((_timeSeconds ?? 10) / 60).floor())}:${NumberFormat('00').format(((_timeSeconds ?? 10) % 60))}',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  Text('Total time: ${NumberFormat('00').format(((_gameTimeSeconds ?? 0) / 60).floor())}:' +
                      '${NumberFormat('00').format(((_gameTimeSeconds ?? 0) % 60))}' +
                      ' | Turns: $_turnCounter' +
                      ' | Avg turn: ${NumberFormat('0.0').format(avgTurnTime)}s')
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
