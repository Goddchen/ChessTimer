import 'dart:convert';

class ChessTimerState {
  int turnTimeSeconds;
  int playerAtTurn;
  List<int> playerTime;
  List<int> turnCounter;
  List<Stopwatch> stopwatches;

  ChessTimerState clone() => ChessTimerState()
    ..turnTimeSeconds = turnTimeSeconds
    ..playerAtTurn = playerAtTurn
    ..playerTime = List.from(playerTime)
    ..turnCounter = List.from(turnCounter)
    ..stopwatches = List.from(stopwatches);

  @override
  String toString() => jsonEncode({
        'turnTimeSeconds': turnTimeSeconds,
        'playerAtTurn': playerAtTurn,
        'playerTime': playerTime,
        'turnCounter': turnCounter,
      });
}
