import 'package:bloc/bloc.dart';
import 'package:quiver/async.dart';
import 'package:preferences/preferences.dart';
import 'package:flutter/material.dart';
import 'package:chess_timer/stats.dart';
import 'dart:async';
import 'package:vibrate/vibrate.dart';

class ChessTimerBloc extends Bloc<ChessTimerEvent, ChessTimerState> {
  CountdownTimer _timer;
  StreamController _animationStreamController = StreamController();

  Stream<dynamic> get animationStream => _animationStreamController.stream;

  @override
  ChessTimerState get initialState {
    ChessTimerState state = ChessTimerState();
    state.turnTimeSeconds = PrefService.getInt('turn_time') ?? 20;
    state.playerTime = [0, state.turnTimeSeconds, state.turnTimeSeconds];
    state.playerAtTurn = 0;
    state.playerScale = [0, 1, 1];
    state.turnCounter = [0, 0, 0];
    state.stopwatches = [Stopwatch(), Stopwatch(), Stopwatch()];
    return state;
  }

  @override
  Stream<ChessTimerState> mapEventToState(
      ChessTimerState currentState, ChessTimerEvent event) async* {
    ChessTimerState newState = currentState.clone();
    if (event is ResetEvent) {
      _timer?.cancel();
      newState.playerAtTurn = 0;
      newState.turnTimeSeconds = PrefService.getInt('turn_time') ?? 20;
      newState.playerTime = [
        0,
        newState.turnTimeSeconds,
        newState.turnTimeSeconds
      ];
      newState.turnCounter = [0, 0, 0];
      newState.stopwatches.forEach((sw) {
        sw.reset();
        sw.stop();
      });
    } else if (event is NewTurnTimeEvent) {
      newState.turnTimeSeconds = event.seconds;
      newState.playerTime = [
        0,
        newState.turnTimeSeconds,
        newState.turnTimeSeconds
      ];
    } else if (event is PauseEvent) {
      newState.stopwatches.forEach((sw) => sw.stop());
      if (_timer?.isRunning == true) {
        _timer.cancel();
      }
    } else if (event is ResumeEvent) {
      newState.stopwatches[newState.playerAtTurn].start();
      if (_timer?.isRunning == false) {
        _startTimerForCurrentPlayer(newState);
      }
    } else if (event is StopEvent) {
      newState.stopwatches.forEach((sw) => sw.stop());
      if (_timer?.isRunning == true) {
        _timer.cancel();
      }
      Navigator.push(
          event.context,
          MaterialPageRoute(
              builder: (context) => StatisticsScreenWidget(
                  newState.stopwatches
                      .map((sw) => sw.elapsed.inSeconds)
                      .reduce((a, b) => a + b),
                  newState.turnCounter,
                  newState.stopwatches)));
    } else if (event is TimerTickEvent) {
      newState.playerTime[newState.playerAtTurn] = _timer.remaining.inSeconds;
    } else if (event is PlayerStoppedEvent) {
      if (newState.playerAtTurn == event.triggeringPlayer ||
          newState.playerAtTurn == 0) {
        newState.stopwatches[newState.playerAtTurn].stop();
        _setPlayerAtTurn(newState, event.triggeringPlayer);
        _startTimerForCurrentPlayer(newState);
      }
    }
    yield newState;
  }

  void dispose() {
    _animationStreamController.close();
  }

  void _setPlayerAtTurn(ChessTimerState state, int triggeringPlayer) {
    if (state.playerAtTurn == 0) {
      state.playerAtTurn = triggeringPlayer;
      state.turnCounter = [0, 0, 0];
      state.stopwatches.forEach((sw) => sw.reset());
    } else {
      state.playerTime[state.playerAtTurn] += state.turnTimeSeconds;
      state.playerAtTurn = triggeringPlayer == 1 ? 2 : 1;
    }
  }

  void _startTimerForCurrentPlayer(ChessTimerState state) {
    _timer?.cancel();
    _timer = CountdownTimer(
      Duration(
          seconds: state.playerTime[state.playerAtTurn], milliseconds: 500),
      Duration(seconds: 1),
    );
    _timer.listen((timer) {
      if (!timer.remaining.isNegative) {
        dispatch(TimerTickEvent());
        if (timer.remaining.inMilliseconds > 0 &&
            timer.remaining.inSeconds < 5) {
          if (PrefService.getBool('animate_last_seconds') ?? true) {
            _animationStreamController.sink.add(null);
          }
          if (PrefService.getBool('vibrate_last_seconds') ?? true) {
            Vibrate.feedback(FeedbackType.medium);
          }
        }
        if (timer.remaining.inSeconds == 0) {
          if (PrefService.getBool('vibrate_on_time_up') ?? true) {
            Vibrate.feedback(FeedbackType.error);
          }
        }
      }
    });
    state.stopwatches[state.playerAtTurn].start();
    state.turnCounter[state.playerAtTurn]++;
  }
}

class ChessTimerState {
  int turnTimeSeconds;
  int playerAtTurn;
  List<int> playerTime;
  List<double> playerScale;
  List<int> turnCounter;
  List<Stopwatch> stopwatches;

  ChessTimerState clone() => ChessTimerState()
    ..turnTimeSeconds = turnTimeSeconds
    ..playerAtTurn = playerAtTurn
    ..playerTime = List.from(playerTime)
    ..playerScale = List.from(playerScale)
    ..turnCounter = List.from(turnCounter)
    ..stopwatches = List.from(stopwatches);
}

abstract class ChessTimerEvent {}

class ResetEvent extends ChessTimerEvent {}

class NewTurnTimeEvent extends ChessTimerEvent {
  final int seconds;
  NewTurnTimeEvent(this.seconds);
}

class PauseEvent extends ChessTimerEvent {}

class ResumeEvent extends ChessTimerEvent {}

class StopEvent extends ChessTimerEvent {
  final BuildContext context;
  StopEvent(this.context);
}

class TimerTickEvent extends ChessTimerEvent {}

class PlayerStoppedEvent extends ChessTimerEvent {
  final int triggeringPlayer;
  PlayerStoppedEvent(this.triggeringPlayer);
}

class LogAllBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    debugPrint("State transition: $transition");
  }
}
