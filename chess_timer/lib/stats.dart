import 'package:flutter/material.dart';
import 'package:chess_timer/localizations.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class StatisticsScreenWidget extends StatelessWidget {
  final int _totalTimeSeconds;
  final List<int> _playerTurnCount;
  final List<Stopwatch> _stopwatches;

  StatisticsScreenWidget(int totalTimeSeconds, List<int> playerTurnCount,
      List<Stopwatch> stopwatches)
      : _totalTimeSeconds = totalTimeSeconds,
        _playerTurnCount = playerTurnCount,
        _stopwatches = stopwatches;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Expanded(
            child: Transform.rotate(
              angle: pi,
              child: Scaffold(
                appBar: AppBar(
                    title:
                        Text(AppLocalizations.of(context).get('statistics'))),
                body: StatisticsWidget(
                    _totalTimeSeconds, _playerTurnCount, _stopwatches),
              ),
            ),
          ),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                  title: Text(AppLocalizations.of(context).get('statistics'))),
              body: StatisticsWidget(
                  _totalTimeSeconds, _playerTurnCount, _stopwatches),
            ),
          ),
        ],
      );
}

class StatisticsWidget extends StatelessWidget {
  final int _totalTimeSeconds;
  final List<int> _playerTurnCount;
  final List<Stopwatch> _stopwatches;

  StatisticsWidget(int totalTimeSeconds, List<int> playerTurnCount,
      List<Stopwatch> stopwatches)
      : _totalTimeSeconds = totalTimeSeconds,
        _playerTurnCount = playerTurnCount,
        _stopwatches = stopwatches;
  @override
  Widget build(BuildContext context) {
    int playerTurnsSeconds =
        _stopwatches.map((sw) => sw.elapsed.inSeconds).reduce((a, b) => a + b);
    int turnCount = _playerTurnCount.reduce((a, b) => a + b);
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            AppLocalizations.of(context).get('total_time'),
          ),
          subtitle: Text(
            NumberFormat('00').format((_totalTimeSeconds / 60).floor()) +
                ':' +
                NumberFormat('00').format(_totalTimeSeconds % 60),
          ),
        ),
        Divider(),
        ListTile(
          title: Text(
            AppLocalizations.of(context).get('turns'),
          ),
          subtitle: Text(_playerTurnCount.reduce((a, b) => a + b).toString()),
        ),
        Divider(),
        ListTile(
          title: Text(AppLocalizations.of(context).get('avg_turn')),
          subtitle: Text(
            NumberFormat('0.0').format(
                    turnCount == 0 ? 0 : (playerTurnsSeconds / turnCount)) +
                's',
          ),
        )
      ],
    );
  }
}
