import 'dart:typed_data';
import 'package:chess_timer/blocs/bloc.dart';
import 'package:chess_timer/blocs/events.dart';
import 'package:chess_timer/blocs/state.dart';
import 'package:chess_timer/model/player.dart';
import 'package:flutter/src/services/asset_bundle.dart';
import 'package:chess_timer/common/interfaces.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soundpool/soundpool.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:test/test.dart';

void main() {
  group('Bloc state tests', () {
    test('Test initial state', () {
      var bloc = ChessTimerBloc(
          PrefServiceMock(), SoundpoolMock(), AssetBundleMock(), VibrateMock());
      var currentState = bloc.getCurrentState();
      expect(bloc.activePlayerID, null);
      expect(currentState.playerOne.numberOfTurns, 0);
      expect(currentState.playerTwo.numberOfTurns, 0);
      expect(currentState.playerOne.turnTimeLeft, 20);
      expect(currentState.playerTwo.turnTimeLeft, 20);
      expect(currentState.playerOne.timerIsRunning, false);
      expect(currentState.playerTwo.timerIsRunning, false);
      bloc.close();
    });
    test('Test player stopped events', () async {
      var bloc = ChessTimerBloc(
          PrefServiceMock(), SoundpoolMock(), AssetBundleMock(), VibrateMock());
      bloc.add(PlayerStoppedEvent(PLAYER_ID.ONE)); // player 1 starts game
      bloc.add(PlayerStoppedEvent(
          PLAYER_ID.ONE)); // player 1 stops his turn, player 2's turn
      bloc.add(PlayerStoppedEvent(
          PLAYER_ID.ONE)); // player 1 clicks stop, nothing changes
      bloc.add(PlayerStoppedEvent(
          PLAYER_ID.TWO)); // player 2 stops this turn, player 1's turn
      List<ChessTimerState> states = await bloc.take(5).toList();
      expect(states[0].playerOne.numberOfTurns, 0);
      expect(states[0].playerTwo.numberOfTurns, 0);
      expect(states[1].playerOne.numberOfTurns, 1);
      expect(states[1].playerTwo.numberOfTurns, 0);
      expect(states[2].playerOne.numberOfTurns, 1);
      expect(states[2].playerTwo.numberOfTurns, 1);
      expect(states[3].playerOne.numberOfTurns, 1);
      expect(states[3].playerTwo.numberOfTurns, 1);
      expect(states[4].playerOne.numberOfTurns, 2);
      expect(states[4].playerTwo.numberOfTurns, 1);
      bloc.close();
    });
    test('Test reset event', () async {
      var bloc = ChessTimerBloc(
          PrefServiceMock(), SoundpoolMock(), AssetBundleMock(), VibrateMock());
      bloc.add(PlayerStoppedEvent(PLAYER_ID.ONE));
      bloc.add(ResetEvent());
      List<ChessTimerState> states = await bloc.take(3).toList();
      expect(states[0].playerOne.numberOfTurns, 0);
      expect(states[0].playerTwo.numberOfTurns, 0);
      expect(states[1].playerOne.numberOfTurns, 1);
      expect(states[1].playerTwo.numberOfTurns, 0);
      expect(states[2].playerOne.numberOfTurns, 0);
      expect(states[2].playerTwo.numberOfTurns, 0);
      bloc.close();
    });

    test('Test changing turn time', () async {
      var prefService = PrefServiceMock();
      var bloc = ChessTimerBloc(
          prefService, SoundpoolMock(), AssetBundleMock(), VibrateMock());
      prefService.setInt('turn_time', 30);
      bloc.add(ResetEvent());
      List<ChessTimerState> states = await bloc.take(2).toList();
      expect(states[0].playerOne.turnTimeLeft, 20);
      expect(states[1].playerOne.turnTimeLeft, 30);
      bloc.close();
    });

    test('Test timer ticks', () async {
      var prefService = PrefServiceMock();
      prefService.setInt('turn_time', 5);
      var bloc = ChessTimerBloc(
          prefService, SoundpoolMock(), AssetBundleMock(), VibrateMock());
      bloc.add(PlayerStoppedEvent(PLAYER_ID.ONE));
      List<ChessTimerState> states = await bloc.take(7).toList();
      expect(states[0].playerOne.turnTimeLeft, 5);
      expect(states[1].playerOne.turnTimeLeft, 5);
      expect(states[2].playerOne.turnTimeLeft, 4);
      expect(states[3].playerOne.turnTimeLeft, 3);
      expect(states[4].playerOne.turnTimeLeft, 2);
      expect(states[5].playerOne.turnTimeLeft, 1);
      expect(states[6].playerOne.turnTimeLeft, 0);

      expect(states[0].playerTwo.turnTimeLeft, 5);
      expect(states[1].playerTwo.turnTimeLeft, 5);
      expect(states[2].playerTwo.turnTimeLeft, 5);
      expect(states[3].playerTwo.turnTimeLeft, 5);
      expect(states[4].playerTwo.turnTimeLeft, 5);
      expect(states[5].playerTwo.turnTimeLeft, 5);
      expect(states[6].playerTwo.turnTimeLeft, 5);
      bloc.close();
    });

    test('Test pause event', () async {
      BlocSupervisor.delegate = LogAllBlocDelegate();
      var bloc = ChessTimerBloc(
          PrefServiceMock(), SoundpoolMock(), AssetBundleMock(), VibrateMock());
      bloc.add(PlayerStoppedEvent(PLAYER_ID.ONE));
      await Future.delayed(Duration(seconds: 3, milliseconds: 500));
      bloc.add(PauseEvent());
      await Future.delayed(Duration(seconds: 3));
      expect(bloc.state.playerOne.turnTimeLeft, 17);
      expect(
          bloc.state.playerOne.totalTimeSeconds +
              bloc.state.playerTwo.totalTimeSeconds,
          3);
      bloc.close();
    });

    test('Test total time keeps running after turn time is up', () async {
      BlocSupervisor.delegate = LogAllBlocDelegate();
      var prefService = PrefServiceMock();
      prefService.setInt('turn_time', 2);
      var bloc = ChessTimerBloc(
          prefService, SoundpoolMock(), AssetBundleMock(), VibrateMock());
      bloc.add(PlayerStoppedEvent(PLAYER_ID.ONE));
      await Future.delayed(Duration(milliseconds: 5100));
      bloc.add(PauseEvent());
      await Future.delayed(Duration(milliseconds: 500));
      expect(bloc.state.playerOne.turnTimeLeft, 0);
      expect(
          bloc.state.playerOne.totalTimeSeconds +
              bloc.state.playerTwo.totalTimeSeconds,
          5);
      bloc.close();
    });
  });
}

class PrefServiceMock implements PrefServiceInterface {
  Map<String, dynamic> _map = {'turn_time': 20};

  @override
  bool getBool(String key) => true;

  @override
  int getInt(String key) => _map[key];

  @override
  void init() {}

  @override
  void setBool(String key, bool value) {}

  @override
  void setInt(String key, int value) {
    _map[key] = value;
  }
}

class SoundpoolMock implements Soundpool {
  @override
  void dispose() {}

  @override
  Future release() {
    return null;
  }

  @override
  Future<void> resume(int streamId) {
    return null;
  }

  @override
  Future setVolume(
      {int soundId,
      int streamId,
      double volume,
      double volumeLeft,
      double volumeRight}) {
    return null;
  }

  @override
  Future<void> stop(int streamId) {
    return null;
  }

  @override
  StreamType get streamType => null;

  @override
  Future<int> load(ByteData rawSound, {int priority = 1}) {
    return null;
  }

  @override
  Future<int> loadAndPlay(ByteData rawSound,
      {int priority = 1, int repeat = 0, double rate = 1.0}) {
    return null;
  }

  @override
  Future<int> loadAndPlayUint8List(Uint8List rawSound,
      {int priority = 1, int repeat = 0, double rate = 1.0}) {
    return null;
  }

  @override
  Future<int> loadAndPlayUri(String uri,
      {int priority = 1, int repeat = 0, double rate = 1.0}) {
    return null;
  }

  @override
  Future<int> loadUint8List(Uint8List rawSound, {int priority = 1}) {
    return null;
  }

  @override
  Future<int> loadUri(String uri, {int priority = 1}) {
    return null;
  }

  @override
  Future<void> pause(int streamId) {
    return null;
  }

  @override
  Future<int> play(int soundId, {int repeat = 0, double rate = 1.0}) {
    return null;
  }

  @override
  Future<AudioStreamControl> playWithControls(int soundId,
      {int repeat = 0, double rate = 1.0}) {
    return null;
  }

  @override
  Future setRate({int streamId, double playbackRate}) {
    return null;
  }
}

class AssetBundleMock implements AssetBundle {
  @override
  void evict(String key) {}

  @override
  Future<ByteData> load(String key) {
    return Future.value(null);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) {
    return Future.value(null);
  }

  @override
  Future<T> loadStructuredData<T>(
      String key, Future<T> Function(String value) parser) {
    return null;
  }
}

class VibrateMock implements VibrateInterface {
  @override
  void feedback(FeedbackType feedbackType) {}
}
