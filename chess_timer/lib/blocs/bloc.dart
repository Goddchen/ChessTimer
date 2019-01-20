import 'package:bloc/bloc.dart';
import 'package:quiver/async.dart';
import 'package:flutter/material.dart';
import 'package:chess_timer/stats.dart';
import 'dart:async';
import 'package:chess_timer/blocs/bloc.dart';
import 'package:soundpool/soundpool.dart';
import 'package:flutter/services.dart';
import 'package:chess_timer/interfaces.dart';

export 'events.dart';
export 'state.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:bloc/bloc.dart';

class ChessTimerBloc extends Bloc<ChessTimerEvent, ChessTimerState> {
  CountdownTimer _timer;
  StreamController _animationStreamController = StreamController();
  Soundpool _soundpool;
  int _beepSoundId;
  int _alarmSoundId;
  PrefServiceInterface _prefService;
  AssetBundle _assetBundle;
  VibrateInterface _vibrate;

  Stream<dynamic> get animationStream => _animationStreamController.stream;

  ChessTimerBloc(PrefServiceInterface prefService, Soundpool soundpool, AssetBundle assetBundle, VibrateInterface vibrate)
      : _soundpool = soundpool,
        _prefService = prefService,
        _assetBundle = assetBundle,
        _vibrate = vibrate {
    _loadSounds();
  }

  @override
  ChessTimerState get initialState {
    ChessTimerState state = ChessTimerState();
    state.turnTimeSeconds = _prefService.getInt('turn_time') ?? 20;
    state.playerTime = [0, state.turnTimeSeconds, state.turnTimeSeconds];
    state.playerAtTurn = 0;
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
      newState.turnTimeSeconds = _prefService.getInt('turn_time') ?? 20;
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
    _soundpool.release();
    _soundpool.dispose();
    super.dispose();
  }

  void _loadSounds() async {
    _beepSoundId = await _assetBundle
        .load('assets/sound/beep.wav')
        .then((data) => _soundpool.load(data));
    _alarmSoundId = await _assetBundle
        .load('assets/sound/alarm.wav')
        .then((data) => _soundpool.load(data));
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
          if (_prefService.getBool('animate_last_seconds') ?? true) {
            _animationStreamController.sink.add(null);
          }
          if (_prefService.getBool('vibrate_last_seconds') ?? true) {
            _vibrate.feedback(FeedbackType.medium);
          }
          if (_prefService.getBool('sound_last_seconds') ?? true) {
            _soundpool.play(_beepSoundId);
          }
        }
        if (timer.remaining.inSeconds == 0) {
          if (_prefService.getBool('vibrate_on_time_up') ?? true) {
            _vibrate.feedback(FeedbackType.error);
          }
          if (_prefService.getBool('sound_time_up') ?? true) {
            _soundpool.play(_alarmSoundId);
          }
        }
      }
    });
    state.stopwatches[state.playerAtTurn].start();
    state.turnCounter[state.playerAtTurn]++;
  }
}

class LogAllBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    debugPrint("State transition: $transition");
  }
}
