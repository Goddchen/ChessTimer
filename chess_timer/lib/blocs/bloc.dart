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
    initPlayers();
    return getCurrentState();
  }

  @override
  Stream<ChessTimerState> mapEventToState(ChessTimerEvent event) async* {
    if (event is ResetEvent) {
      _timer?.cancel();
      initPlayers();
      activePlayerID = null;
    } else if (event is PauseEvent) {
      _playerOne.stopTimer();
      _playerTwo.stopTimer();
      if (_timer?.isRunning == true) {
        _timer.cancel();
      }
    } else if (event is ResumeEvent) {
      Player activePlayer = getActivePlayer();
      if (activePlayer == null) {
        return;
      }
      activePlayer.startTimer();

      if (_timer?.isRunning == false) {
        _startTimerForCurrentPlayer(activePlayer);
      }
    } else if (event is StopEvent) {
      activePlayerID = null;
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
      Player activePlayer = getActivePlayer();
      if (activePlayer == null) {
        return;
      }
      activePlayer.turnTimeLeft = _timer.remaining.inSeconds;
    } else if (event is PlayerStoppedEvent) {
      if (activePlayerID != event.triggeringPlayer && activePlayerID != null) {
        return;
      }
      Player activePlayer = getActivePlayer();
      activePlayer?.stopTimer();
      if (activePlayer == null) {
        activePlayerID = event.triggeringPlayer;
      } else {
        activePlayer.turnTimeLeft += getTurnTimeSeconds();
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

  void _startTimerForCurrentPlayer(Player activePlayer) {
    _timer?.cancel();
    _timer = CountdownTimer(
      Duration(seconds: activePlayer.turnTimeLeft, milliseconds: 500),
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
    activePlayer.startTimer();
    activePlayer.numberOfTurns++;
  }

  Player getActivePlayer() {
    if (activePlayerID == PLAYER_ID.ONE) {
      return _playerOne;
    } else if (activePlayerID == PLAYER_ID.TWO) {
      return _playerTwo;
    }
    return null;
  }

  void initPlayers() {
    _playerOne = Player(turnTimeLeft: getTurnTimeSeconds(), id: PLAYER_ID.ONE);
    _playerTwo = Player(turnTimeLeft: getTurnTimeSeconds(), id: PLAYER_ID.TWO);
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
