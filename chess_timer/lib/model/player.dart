import 'dart:convert';

enum PLAYER_ID { ONE, TWO }

class Player {
  final Stopwatch _stopwatch = Stopwatch();

  int turnTimeLeft;
  int numberOfTurns = 0;
  PLAYER_ID id;

  Player({int startTimeSeconds, this.id})
      : this.turnTimeLeft = startTimeSeconds;

  void startTimer() {
    _stopwatch.start();
  }

  void stopTimer() {
    _stopwatch.stop();
  }

  void resetTimer() {
    _stopwatch.stop();
    _stopwatch.reset();
  }

  int get totalTimeSeconds {
    return _stopwatch.elapsed.inSeconds;
  }

  bool get timerIsRunning {
    return _stopwatch.isRunning;
  }

  double get averageTurnSeconds {
    if (numberOfTurns == 0) {
      return 0;
    } else {
      return totalTimeSeconds / numberOfTurns;
    }
  }

  void reset() {
    numberOfTurns = 0;
    resetTimer();
  }

  @override
  String toString() => jsonEncode({
        'PlayerID': id,
        'turnTimeLeft': turnTimeLeft,
        'isActivePlayer': timerIsRunning,
        'numberOfTurns': numberOfTurns,
      });
}
