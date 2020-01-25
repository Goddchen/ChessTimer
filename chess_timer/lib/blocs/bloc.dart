import 'dart:async';
import 'package:chess_timer/common/interfaces.dart';
import 'package:chess_timer/model/player.dart';
import 'package:chess_timer/ui/stats.dart';
import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import 'package:chess_timer/blocs/events.dart';
import 'package:chess_timer/blocs/state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soundpool/soundpool.dart';

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

  PLAYER_ID activePlayerID;
  Player _playerOne;
  Player _playerTwo;
  List<int> turnCounter = [0, 0, 0];

  ChessTimerBloc(PrefServiceInterface prefService, Soundpool soundpool,
      AssetBundle assetBundle, VibrateInterface vibrate)
      : _soundpool = soundpool,
        _prefService = prefService,
        _assetBundle = assetBundle,
        _vibrate = vibrate {
    _loadSounds();
  }

  @override
  ChessTimerState get initialState {
    _playerOne =
        Player(startTimeSeconds: getTurnTimeSeconds(), id: PLAYER_ID.ONE);
    _playerTwo =
        Player(startTimeSeconds: getTurnTimeSeconds(), id: PLAYER_ID.TWO);
    return getCurrentState();
  }

  @override
  Stream<ChessTimerState> mapEventToState(ChessTimerEvent event) async* {
    if (event is ResetEvent) {
      _timer?.cancel();
      _playerOne.resetTimer();
      _playerTwo.resetTimer();
      yield getCurrentState();
    } else if (event is PauseEvent) {
      _playerOne.stopTimer();
      _playerTwo.stopTimer();
      if (_timer?.isRunning == true) {
        _timer.cancel();
      }
    } else if (event is ResumeEvent) {
      Player aP = getActivePlayer();
      if (aP == null) {
        return;
      }
      aP.startTimer();

      if (_timer?.isRunning == false) {
        _startTimerForCurrentPlayer(aP);
      }
    } else if (event is StopEvent) {
      _playerOne.stopTimer();
      _playerTwo.stopTimer();
      if (_timer?.isRunning == true) {
        _timer.cancel();
      }
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => StatisticsScreenWidget(
              playerOne: _playerOne, playerTwo: _playerTwo),
        ),
      );
    } else if (event is TimerTickEvent) {
      Player aP = getActivePlayer();
      if (aP == null) {
        return;
      }
      aP.turnTimeLeft = _timer.remaining.inSeconds;
    } else if (event is PlayerStoppedEvent) {
      if (activePlayerID != event.triggeringPlayer) {
        return;
      }
      Player aP = getActivePlayer();
      aP?.stopTimer();
      if (aP == null) {
        activePlayerID = event.triggeringPlayer;
        _playerOne.reset();
        _playerTwo.reset();
      } else {
        aP.turnTimeLeft += getTurnTimeSeconds();
        activePlayerID = event.triggeringPlayer == PLAYER_ID.ONE
            ? PLAYER_ID.TWO
            : PLAYER_ID.ONE;
      }
      _startTimerForCurrentPlayer(getActivePlayer());
    }
    yield getCurrentState();
  }

  ChessTimerState getCurrentState() {
    return ChessTimerState(
      playerOne: _playerOne,
      playerTwo: _playerTwo,
    );
  }

  void dispose() {
    _animationStreamController.close();
    _soundpool.release();
    _soundpool.dispose();
  }

  void _loadSounds() async {
    _beepSoundId = await _assetBundle
        .load('assets/sound/beep.wav')
        .then((data) => _soundpool.load(data));
    _alarmSoundId = await _assetBundle
        .load('assets/sound/alarm.wav')
        .then((data) => _soundpool.load(data));
  }

  void _startTimerForCurrentPlayer(Player aP) {
    _timer?.cancel();
    _timer = CountdownTimer(
      Duration(seconds: aP.turnTimeLeft, milliseconds: 500),
      Duration(seconds: 1),
    );
    _timer.listen((timer) {
      if (!timer.remaining.isNegative) {
        add(TimerTickEvent());
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
    aP.startTimer();
    aP.numberOfTurns++;
  }

  Player getActivePlayer() {
    if (activePlayerID == PLAYER_ID.ONE) {
      return _playerOne;
    } else if (activePlayerID == PLAYER_ID.TWO) {
      return _playerTwo;
    }
    return null;
  }

  int getTurnTimeSeconds() {
    return _prefService.getInt('turn_time') ?? 20;
  }
}

class LogAllBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    debugPrint("Bloc-Event: $event");
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint("Bloc-Transition: $transition");
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    debugPrint("Bloc-Error: $error");
  }
}
