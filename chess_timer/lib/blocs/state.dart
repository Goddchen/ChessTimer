import 'dart:convert';

import 'package:chess_timer/model/player.dart';

class ChessTimerState {
  final PlayerState playerOne;
  final PlayerState playerTwo;

  ChessTimerState({this.playerOne, this.playerTwo});

  @override
  String toString() => jsonEncode({
        'playerOne': playerOne,
        'playerTwo': playerTwo,
      });
}

class PlayerState {
  final PLAYER_ID id;
  final int totalTimeSeconds;
  final bool timerIsRunning;
  final int turnTimeLeft;
  final int numberOfTurns;
  final double averageTurnSeconds;
  PlayerState(
      {this.id,
      this.timerIsRunning,
      this.totalTimeSeconds,
      this.turnTimeLeft,
      this.numberOfTurns,
      this.averageTurnSeconds});

  @override
  String toString() => toJson().toString();

  Map toJson() => {
        'player_id': jsonEncode(id.toString()),
        'turnTimeLeft': turnTimeLeft,
        'isActivePlayer': timerIsRunning,
        'numberOfTurns': numberOfTurns,
        'totalTimeSeconds': totalTimeSeconds,
      };

  Player fromJson(json) => Player(
        id: _getPlayerIDFromString(json['player_id']),
        turnTimeLeft: json['turnTimeLeft'],
        numberOfTurns: json['numberOfTurns'],
        secondsPlayed: json['totalTimeSeconds'],
      );

  PLAYER_ID _getPlayerIDFromString(String idAsString) {
    for (PLAYER_ID element in PLAYER_ID.values) {
      if (element.toString() == idAsString) {
        return element;
      }
    }
    return null;
  }
}
