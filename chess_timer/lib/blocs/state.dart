import 'dart:convert';
import 'package:chess_timer/model/player.dart';

class ChessTimerState {
  final Player playerOne;
  final Player playerTwo;

  ChessTimerState({this.playerOne, this.playerTwo});

  @override
  String toString() => jsonEncode({
        'playerOne': playerOne,
        'playerTwo': playerTwo,
      });
}
