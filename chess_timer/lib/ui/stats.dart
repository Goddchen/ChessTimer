import 'package:chess_timer/common/app_colors.dart';
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
            _buildAppBar(context),
            Expanded(
              child: StatisticsWidget(
                playerOne: _playerOne,
                playerTwo: _playerTwo,
              ),
            ),
          ],
        ),
      );

  Widget _buildHeaderText(context) => Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Text(
          AppLocalizations.of(context).get('statistics'),
          style: Theme.of(context).textTheme.headline6,
        ),
      );

  Widget _buildAppBar(context) => Container(
        color: AppColors.player_area_inactive,
        padding: EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildHeaderText(context),
              _buildCloseButton(context),
              Transform.rotate(
                angle: pi,
                child: _buildHeaderText(context),
              ),
            ],
          ),
        ),
      );

  Widget _buildCloseButton(context) => InkWell(
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.close,
            size: 24,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        onTap: () => Navigator.pop(context),
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

    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildEntry(
              context,
              title: AppLocalizations.of(context).get('stats_total_game_time'),
              subtitle:
                  NumberFormat('00').format((gameTimeSeconds / 60).floor()) +
                      ':' +
                      NumberFormat('00').format(gameTimeSeconds % 60) +
                      's',
            ),
            _buildEntry(
              context,
              title: AppLocalizations.of(context).get('stats_turns'),
              subtitle:
                  '${totalTurns.toString()} (${_playerOne.numberOfTurns} - ${_playerTwo.numberOfTurns})',
            ),
            _buildEntry(
              context,
              title: AppLocalizations.of(context).get('stats_avg_turn_time'),
              subtitle: _avgTimePerMoveString(gameTimeSeconds, totalTurns),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntry(context, {title, subtitle}) => Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          ListTile(
            title: Text(
              title,
            ),
            subtitle: Text(
              subtitle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 18),
            child: Container(
              height: 1,
              color: Colors.black.withOpacity(0.1),
            ),
          ),
        ],
      );

  String _avgTimePerMoveString(gameTimeSeconds, totalTurns) =>
      '${_formatNumber(_getAverageTurnSeconds(gameTimeSeconds, totalTurns))}s' +
      ' (${_formatNumber(_playerOne.averageTurnSeconds)}s - ${_formatNumber(_playerTwo.averageTurnSeconds)}s)';

  String _formatNumber(number) => NumberFormat('0.0').format(number);

  double _getAverageTurnSeconds(gameTimeSeconds, totalTurns) {
    if (totalTurns > 0) {
      return gameTimeSeconds / totalTurns;
    } else {
      return 0;
    }
  }
}
