import 'package:chess_timer/common/localizations.dart';
import 'package:chess_timer/model/player.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class StatisticsScreenWidget extends StatelessWidget {
  final Player _playerOne;
  final Player _playerTwo;

  StatisticsScreenWidget({playerOne, playerTwo})
      : _playerOne = playerOne,
        _playerTwo = playerTwo;

  @override
  Widget build(BuildContext context) => Material(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Transform.rotate(
                angle: pi,
                child: StatisticsWidget(
                  playerOne: _playerOne,
                  playerTwo: _playerTwo,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              color: Theme.of(context).primaryColor,
              child: Row(
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.arrow_back,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Transform.rotate(
                        angle: pi,
                        child: Text(
                          AppLocalizations.of(context).get('statistics'),
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .apply(color: Colors.white),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).get('statistics'),
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .apply(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: StatisticsWidget(
                playerOne: _playerOne,
                playerTwo: _playerTwo,
              ),
            ),
          ],
        ),
      );
}

class StatisticsWidget extends StatelessWidget {
  final Player _playerOne;
  final Player _playerTwo;

  StatisticsWidget({playerOne, playerTwo})
      : _playerOne = playerOne,
        _playerTwo = playerTwo;

  @override
  Widget build(BuildContext context) {
    int gameTimeSeconds =
        _playerOne.totalTimeSeconds + _playerTwo.totalTimeSeconds;
    int totalTurns = _playerOne.numberOfTurns + _playerTwo.numberOfTurns;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              AppLocalizations.of(context).get('total_time'),
            ),
            subtitle: Text(
              NumberFormat('00').format((gameTimeSeconds / 60).floor()) +
                  ':' +
                  NumberFormat('00').format(gameTimeSeconds % 60),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              AppLocalizations.of(context).get('turns'),
            ),
            subtitle: Text(totalTurns.toString()),
          ),
          Divider(),
          ListTile(
            title: Text(AppLocalizations.of(context).get('avg_turn')),
            subtitle: Text(
              NumberFormat('0.0').format(
                      getAverageTurnSeconds(gameTimeSeconds, totalTurns)) +
                  's',
            ),
          ),
        ],
      ),
    );
  }

  double getAverageTurnSeconds(gameTimeSeconds, totalTurns) {
    if (totalTurns > 0) {
      return gameTimeSeconds / totalTurns;
    } else {
      return 0;
    }
  }
}
