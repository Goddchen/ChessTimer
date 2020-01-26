enum PLAYER_ID { ONE, TWO }

class Player {
  final Stopwatch _stopwatch = Stopwatch();
  final int _stopwatchOffset;

  PLAYER_ID id;
  int turnTimeLeft;
  int numberOfTurns;

  Player(
      {this.id, this.turnTimeLeft, this.numberOfTurns = 0, secondsPlayed = 0})
      : _stopwatchOffset = secondsPlayed;

  void startTimer() {
    _stopwatch.start();
  }

  void stopTimer() {
    _stopwatch.stop();
  }

  int get totalTimeSeconds {
    return _stopwatch.elapsed.inSeconds + _stopwatchOffset;
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
}
